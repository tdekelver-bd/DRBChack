install.packages("XML")
library(XML)
install.packages("RJSONIO")
library(RJSONIO)
library(tidyr)
library(dplyr)
install.packages("docxtractr")
library(docxtractr)
# 
# txt2 <- docxtractr::read_docx("C:/Users/rbelhocine/Desktop/BD/Arcelor/Data/WorkInstructions/WID_78382.docx")
# docx_tbl_count(txt2)
# # get all the tables
# tbls <- docx_extract_all_tbls(txt2, preserve=T, guess_header = T)
# tbls2 <- lapply(tbls, as.data.frame)


title <- function(x){
  tryCatch({
    
  if(ncol(x)==1 & nrow(x)==1){
    x <- remove_n(x=x)
    if(nrow(as.data.frame(x))==1){
      x <- list(as.character(x[1,]))
    }else{
      x <- list(as.character(x[1,]),as.vector(x[-1,]))
    }
    
    
  }else if(ncol(x)==1 & nrow(x)>1){
    x <- list(x[1,1], x[-1,])
    x <- remove_n(x=x[[2]])

  } else if(ncol(x)>1 & nrow(x>1)){
    i <<- 1
    while(i !=0){
      if(sum(!is.na(x[i,])) < ncol(x)){
        tmp <- list()
        tmp[[i]] <- as.character(x[i,1])
        i <<- i+1
      } else{
      colnames(x) <- as.character(x[i,])
      x <- x[-c(1:i),]
      if(nrow(as.data.frame(x))<10){
        x <- remove_n(x=x)
      } else{
        x <- x
      }
      
      tmp[[i]] <- x
      i <<- 0
    }
    }
    x <- tmp
  }
    }, error=function(e){cat("ERROR :",conditionMessage(e), "\n")})
  return(x)
}

remove_n <- function(x){
    lst_names <- c()
    keys <- c()
    if(is.null(nrow(x))){
      for(j in seq(length(x))) {
        
        assign(paste("lst",j,sep=""),sapply(x[j], str_split, "[\\n]"))
        keys <- unlist(unique(c(keys,unique(names(get(paste("lst",j,sep="")))))))
        lst_names <- c(lst_names,paste("lst",j,sep=""))
        
        if(j==1){
          conc <- setNames(get(paste("lst",j,sep="")), keys)
        } else{
          conc <- setNames(mapply(c, conc, get(lst_names[j])[keys]), keys)
        }
        
      }  
      
    } else {
      for(j in seq(nrow(x))) {
        
        assign(paste("lst",j,sep=""),sapply(x[j,], str_split, "[\\n]"))
        keys <- unlist(unique(c(keys,unique(names(get(paste("lst",j,sep="")))))))
        lst_names <- c(lst_names,paste("lst",j,sep=""))
        
        if(j==1){
          conc <- setNames(get(paste("lst",j,sep="")), keys)
        } else{
          conc <- setNames(mapply(c, conc, get(lst_names[j])[keys]), keys)
        }
        
      }  
    }
    
    conc <- lapply(conc, `length<-`, max(lengths(conc)))  
    return(as.data.frame(conc))
}

# t <- remove_n(x=tbls2[[4]])

tmpy <- list()

structure <- function(doc){
  
  for(q in seq(length(doc))) {
    
    tmpy[[q]] <- title(x=doc[[q]])
  }
  return(tmpy)
}

# test <- structure(tbls2)

structure_all <- function(file){
  
  txt <- docxtractr::read_docx(file) 
  
  tbls <- docx_extract_all_tbls(txt, preserve=T, guess_header = T)
  tbls2 <- lapply(tbls, as.data.frame)
  struct <- structure(tbls2)
  struct <- list(as.character(basename(file)),struct)
  return(struct)
  
}


# structure_all("C:/Users/rbelhocine/Desktop/BD/Arcelor/Data/WorkInstructions/WID_78382.docx")

list_files <- list.files("C:/Users/rbelhocine/Desktop/BD/Arcelor/Data/WorkInstructions/",pattern = ".docx$", recursive = TRUE)
list_files_ent <- paste("C:/Users/rbelhocine/Desktop/BD/Arcelor/Data/WorkInstructions/", list_files, sep="")

entire_list <- lapply(list_files_ent[1:10], structure_all)

entire_list[[2]]


# verify valve
# responsibilities lance car

