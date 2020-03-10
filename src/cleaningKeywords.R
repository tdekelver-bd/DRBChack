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
  mutate(Hoofd_tag=trimws(tolower(Hoofd_tag)), Sub_tag=trimws(tolower(Sub_tag)))

tags_new <- tags%>%
  select(new_tags, Nr_Arrest)%>%
  unique()%>%
  mutate(new_tags=tolower(new_tags))%>%
  filter(new_tags%in%hierarchy$Sub_tag | new_tags%in%hierarchy$Hoofd_tag)

tags_old <- tags%>%
  select(new_tags, Nr_Arrest)%>%
  unique()%>%
  mutate(new_tags=tolower(new_tags))%>%
  filter(!(new_tags%in%hierarchy$Sub_tag | new_tags%in%hierarchy$Hoofd_tag))

clean <- tags_old%>%
  filter(!grepl("\\d", new_tags))%>%
  mutate(new_tags= gsub("\\(navigator\\)|\\[navigator|navigator\\]|navigator", "", new_tags))

out <- tags_old%>%
  filter(grepl("\\d", new_tags))



length(unique(tags_new$Nr_Arrest))
length(unique(tags$Nr_Arrest))

tags_new_count <- tags_new%>%
  select(new_tags, Nr_Arrest)%>%
  unique()%>%
  group_by(new_tags)%>%
  summarise(ntext=n())

tags_old_count <- clean%>%
  select(new_tags, Nr_Arrest)%>%
  unique()%>%
  group_by(new_tags)%>%
  summarise(ntext=n())
