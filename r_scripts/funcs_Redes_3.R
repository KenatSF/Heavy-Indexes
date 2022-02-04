crear_adyacencias <- function(ficheros){
  tipo <- ".csv"
  for(i in 1:length(ficheros)){
    setwd(Sys.getenv("PATH_2"))
    nombre_archivo <- paste0(ficheros[i], tipo)
    base1 <- read.table(nombre_archivo, sep=",", header = TRUE)
    matriz <- limpiar_pearson(cor(base1))
    matriz <- (1-matriz)/2
    matriz <- limpiar_tranformacion(matriz)
    setwd(Sys.getenv("WEB"))
    write.csv(matriz, file = nombre_archivo, row.names = FALSE)
    rm(base1)
    #print("kkkkkkkkkkkkkkkkkkkkkk")
  }
}




limpiar_pearson <- function(correlaciones){
  for(i in 1:dim(correlaciones)[c(1)]){
    for(j in 1:dim(correlaciones)[c(2)]){
      if(correlaciones[c(i),c(j)]<0.5 & correlaciones[c(i),c(j)] >-0.5){
        correlaciones[c(i),c(j)] <-0
      }
      else{
        
        if(correlaciones[c(i),c(j)]==1 | correlaciones[c(i),c(j)] ==-1){
          correlaciones[c(i),c(j)] <-0
        }
        else{
          correlaciones[c(i),c(j)] <- correlaciones[c(i),c(j)]
        }
      }
    }
  }
  
  return(correlaciones)
}



limpiar_tranformacion <- function(correlaciones){
  for(i in 1:dim(correlaciones)[c(1)]){
    for(j in 1:dim(correlaciones)[c(2)]){
      if(correlaciones[c(i),c(j)] == 0.5){
        correlaciones[c(i),c(j)] <-0
      }
      else{
        correlaciones[c(i),c(j)] <- correlaciones[c(i),c(j)]
      }
    }
  }
  
  return(correlaciones)
}
