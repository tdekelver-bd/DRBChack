## SETUP -----
# data <- setDT(feather::read_feather("D:/Projects/20180706_MultiStatePostProcessing/feather_storage/small_contingency.feather"))

# data <- setDT(feather::read_feather("C:/OneDrive - Business & Decision Benelux S.A/BandD/_Domains/Analytics_BigData/Customers/Elia/Projects/20180706_MultiStatePostProcessing/ExploreR/small_contingency.feather"))
data <- study.contingency
data$max_loading_perc <- round(data$max_loading_perc,1)

byvars <- c("network_object","contingency1","contingency2")

removeExtraSpaces <- function(x){
  x <- gsub("^ *|(?<= ) | *$", "", x, perl = TRUE)  ## remove extra spaces
  x[is.na(x)] <- ""
  return(x)
  
}

data$contingency=removeExtraSpaces(data$contingency)
data$contingency1=removeExtraSpaces(data$contingency1)
data$contingency2=removeExtraSpaces(data$contingency2)

data$datakeys <-  apply(data[,byvars,with=FALSE],1,paste, collapse= " ; ")


