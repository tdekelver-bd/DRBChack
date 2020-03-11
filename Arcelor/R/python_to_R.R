
setwd('C:/Users/rbelhocine/Desktop/BD/Arcelor/R/')

# install.packages("reticulate")
library(reticulate)
source_python("Search_engine_and_topic_prediction.py")


a = Search_engine_and_topic_prediction('Responsibilities Lance car')

