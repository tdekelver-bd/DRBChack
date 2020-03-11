library(tidyverse)

tags <- read.csv("C:/Users/rbelhocine/Desktop/BD/Hackathon/DBRC/src/data/arrests_trefwoorden.csv")

tags <- tags%>%
  mutate(new_tags=str_split(trimws(Trefwoorden), "(?<=.)(?=((?<=[a-z])[A-Z]|[A-Z](?=[a-z])))"))%>% 
  unnest(new_tags)%>%
  select(-Trefwoorden)%>%
  mutate(new_tags=trimws(new_tags))
  
write.csv(tags, "C:/Users/rbelhocine/Desktop/BD/Hackathon/DBRC/src/data/arrests_trefwoorden_clean.csv", row.names = F)


hierarchy <- read.csv("C:/Users/rbelhocine/Desktop/BD/Hackathon/DBRC/src/data/Woordenlijst digitalisering - woordenlijst.csv")

hierarchy <- hierarchy%>%
  mutate(Hoofd_tag= gsub("\\(navigator\\)|\\[navigator|navigator\\]|navigator", "", Hoofd_tag),
         Sub_tag=gsub("\\(navigator\\)|\\[navigator|navigator\\]|navigator", "", Sub_tag))%>%
  mutate(Hoofd_tag=gsub("[[:punct:]]", "", Hoofd_tag),
         Sub_tag=gsub("[[:punct:]]", "", Sub_tag))%>%
  mutate(Hoofd_tag=trimws(tolower(Hoofd_tag)), Sub_tag=trimws(tolower(Sub_tag)))

tags_new <- tags%>%
  select(new_tags, Nr_Arrest)%>%
  unique()%>%
  mutate(new_tags=tolower(new_tags))%>%
  filter(!grepl("\\d", new_tags))%>%
  mutate(new_tags= gsub("\\(navigator\\)|\\[navigator|navigator\\]|navigator", "", new_tags))%>%
  filter(grepl("[A-Za-z]", new_tags))%>%
  mutate(new_tags=gsub("[[:punct:]]", "", new_tags))%>%
  mutate(new_tags=case_when(grepl("goede ro | beoordeling gro", new_tags)~"gro",
                            grepl("exceptie verworpen", new_tags)~"Exceptie onontvankelijk", 
                            grepl("schorsing verworpen", new_tags) ~ "Vernietiging verworpen",
                            new_tags=="exceptie"~"excepties",
                            new_tags%in%c("rolrecht niet betaald", "rolrechten niet betaald", "rolrechten niet tijdig betaald", "nietbetaling rolrecht", "rolrecht niet tijdig betaald")~"Rolrechten niet (tijdig) betaald",
                            new_tags=="afstand"~"Afstand van geding",
                            new_tags=="vernietiging omwille van de duidelijkheid in het rechtsverkeer" ~ "Vernietiging",
                            new_tags=="ta"~"Tussenarrest",
                            new_tags%in%c("klaarblijkelijk onontvankelijk", "onontvankelijkheidsbeslissing",
                                          "onontvankelijkheid", "gedeeltelijk onontvankelijk") ~ "Onontvankelijk",
                            new_tags== "tussenkomst onontvankelijk" ~ "Ontvankelijkheid tussenkomst",
                            new_tags%in%c("derdebelanghebbende", "belanghebbende derde", "derdenbelanghebbenden")~"Derdebelanghebbende belanghebbende derde",
                            new_tags=="visuele impact"~"Visuele hinder",
                            new_tags=="raad" ~ "Bevoegdheid Raad",
                            new_tags=="geen ontvankelijk middel"~"Gebrek aan een ontvankelijk middel",
                            new_tags=="gw" ~ "Geen wettigheidskritiek",
                            new_tags=="verzaking" ~ "Verzaking aan de vergunning",
                            new_tags=="vb" ~ "Vertrouwensbeginsel" ,
                            new_tags=="motiveringsplicht"~"Formele motiveringsplicht",
                            new_tags%in%c("niet afdoende gemotiveerd", "geen afdoende motivering")~ "Niet afdoende gemotiveerd",
                            new_tags=="niet onredelijk"~"Niet kennelijk onredelijk",
                            new_tags%in%c("andersluidend psaverslag", "andersluidend verslag van de provinciale stedenbouwkundige ambtenaar",
                                          "andersluidend verslag psa", "ongunstig psaverslag") ~ "Andersluidend PSAverslag",
                            new_tags%in%c("stelplicht verzoekende partij", "stelplicht vzp") ~ "Stelplicht",
                            new_tags%in%c("opportuniteitskritiek")~ "Loutere opportuniteitskritiek",
                            new_tags=="verkavelingsvergunning"~"Verkavelingsvergunningsplicht",
                            new_tags=="relevante in de omgeving bestaande toestand"~"Relevante omgeving",
                            new_tags=="beleidsmatig gewenste ontwikkelingen" ~"Beleidsmatig gewenste ontwikkeling",
                            new_tags%in%c("planaanpassingen", "beperkte planaanpassingen", "beperkte planaanpassing")~"Planaanpassing",
                            new_tags=="projectmerscreeningsnota"~"Merscreening",
                            new_tags=="hoogdringendheid aangetoond"~"Hoogdringendheid",
                            new_tags%in%c("rpv toegekend", "basisbedrag rpv toegekend")~"rpv",
                            TRUE~new_tags))%>%
  mutate(new_tags=trimws(new_tags))%>%
  mutate(new_tags=tolower(new_tags))%>%
  filter(new_tags%in%hierarchy$Sub_tag | new_tags%in%hierarchy$Hoofd_tag)


tags_new_add <- tags_new%>%
  inner_join(hierarchy, by=c("new_tags"="Sub_tag"))%>%
  select(Nr_Arrest, Hoofd_tag)%>%
  rename(new_tags=Hoofd_tag)
  
tags_new <- tags_new%>%
  rbind(tags_new_add)%>%
  unique()

tags_old <- tags%>%
  unique()%>%
  mutate(new_tags=tolower(new_tags))%>%
  filter(!grepl("\\d", new_tags))%>%
  mutate(new_tags= gsub("\\(navigator\\)|\\[navigator|navigator\\]|navigator", "", new_tags))%>%
  filter(grepl("[A-Za-z]", new_tags))%>%
  mutate(new_tags=gsub("[[:punct:]]", "", new_tags))%>%
  mutate(new_tags=case_when(grepl("goede ro | beoordeling gro", new_tags)~"gro",
                            grepl("exceptie verworpen", new_tags)~"Exceptie onontvankelijk", 
                            grepl("schorsing verworpen", new_tags) ~ "Vernietiging verworpen",
                            new_tags=="exceptie"~"excepties",
                            new_tags%in%c("rolrecht niet betaald", "rolrechten niet betaald", "rolrechten niet tijdig betaald", "nietbetaling rolrecht", "rolrecht niet tijdig betaald")~"Rolrechten niet (tijdig) betaald",
                            new_tags=="afstand"~"Afstand van geding",
                            new_tags=="vernietiging omwille van de duidelijkheid in het rechtsverkeer" ~ "Vernietiging",
                            new_tags=="ta"~"Tussenarrest",
                            new_tags%in%c("klaarblijkelijk onontvankelijk", "onontvankelijkheidsbeslissing",
                                          "onontvankelijkheid", "gedeeltelijk onontvankelijk") ~ "Onontvankelijk",
                            new_tags== "tussenkomst onontvankelijk" ~ "Ontvankelijkheid tussenkomst",
                            new_tags%in%c("derdebelanghebbende", "belanghebbende derde", "derdenbelanghebbenden")~"Derdebelanghebbende belanghebbende derde",
                            new_tags=="visuele impact"~"Visuele hinder",
                            new_tags=="raad" ~ "Bevoegdheid Raad",
                            new_tags=="geen ontvankelijk middel"~"Gebrek aan een ontvankelijk middel",
                            new_tags=="gw" ~ "Geen wettigheidskritiek",
                            new_tags=="verzaking" ~ "Verzaking aan de vergunning",
                            new_tags=="vb" ~ "Vertrouwensbeginsel" ,
                            new_tags=="motiveringsplicht"~"Formele motiveringsplicht",
                            new_tags%in%c("niet afdoende gemotiveerd", "geen afdoende motivering")~ "Niet afdoende gemotiveerd",
                            new_tags=="niet onredelijk"~"Niet kennelijk onredelijk",
                            new_tags%in%c("andersluidend psaverslag", "andersluidend verslag van de provinciale stedenbouwkundige ambtenaar",
                                          "andersluidend verslag psa", "ongunstig psaverslag") ~ "Andersluidend PSAverslag",
                            new_tags%in%c("stelplicht verzoekende partij", "stelplicht vzp") ~ "Stelplicht",
                            new_tags%in%c("opportuniteitskritiek")~ "Loutere opportuniteitskritiek",
                            new_tags=="verkavelingsvergunning"~"Verkavelingsvergunningsplicht",
                            new_tags=="relevante in de omgeving bestaande toestand"~"Relevante omgeving",
                            new_tags=="beleidsmatig gewenste ontwikkelingen" ~"Beleidsmatig gewenste ontwikkeling",
                            new_tags%in%c("planaanpassingen", "beperkte planaanpassingen", "beperkte planaanpassing")~"Planaanpassing",
                            new_tags=="projectmerscreeningsnota"~"Merscreening",
                            new_tags=="hoogdringendheid aangetoond"~"Hoogdringendheid",
                            new_tags%in%c("rpv toegekend", "basisbedrag rpv toegekend")~"rpv",
                            TRUE~new_tags))%>%
  filter(str_count(new_tags, '\\s+')<5)%>%
  mutate(new_tags=trimws(new_tags))%>%
  mutate(new_tags=tolower(new_tags))%>%
  filter(!(new_tags%in%hierarchy$Sub_tag | new_tags%in%hierarchy$Hoofd_tag))
# 
# clean <- tags_old%>%
#   filter(!grepl("\\d", new_tags))%>%
#   mutate(new_tags= gsub("\\(navigator\\)|\\[navigator|navigator\\]|navigator", "", new_tags))%>%
#   filter(grepl("[A-Za-z]", new_tags))%>%
#   mutate(new_tags=gsub("[[:punct:]]", "", new_tags))%>%
#   mutate(new_tags=case_when(grepl("goede ro", new_tags)~"gro",
#                             grepl("exceptie verworpen", new_tags)~"Exceptie onontvankelijk", 
#                             grepl("schorsing verworpen", new_tags) ~ "Vernietiging verworpen",
#                             TRUE~new_tags))%>%
#   mutate(new_tags=trimws(new_tags))
# 
# out <- tags_old%>%
#   filter(grepl("\\d", new_tags))
# 
# 
# 
# length(unique(tags_new$Nr_Arrest))
# length(unique(tags$Nr_Arrest))

tags_new_count <- tags_new%>%
  select(new_tags, Nr_Arrest)%>%
  unique()%>%
  group_by(new_tags)%>%
  summarise(ntext=n())

tags_old_count <- tags_old%>%
  select(new_tags, Nr_Arrest)%>%
  unique()%>%
  group_by(new_tags)%>%
  summarise(ntext=n())


write.csv(tags_new, "C:/Users/rbelhocine/Desktop/BD/Hackathon/DBRC/src/data/arrests_trefwoorden_new.csv", row.names = F)


write.csv(tags_new_count, "C:/Users/rbelhocine/Desktop/BD/Hackathon/DBRC/src/data/Common_tags_new.csv", row.names = F)
