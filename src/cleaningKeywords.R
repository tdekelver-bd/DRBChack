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
  mutate(new_tags=case_when(grepl("goede ro|beoordeling gro", new_tags)~"gro",
                            grepl("exceptie verworpen", new_tags)~"Exceptie onontvankelijk", 
                            grepl("schorsing verworpen", new_tags) ~ "Vernietiging verworpen",
                            new_tags=="exceptie"~"excepties",
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
