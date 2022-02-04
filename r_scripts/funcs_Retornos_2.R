



get_var_for_base_retornos <- function(basesota){
  mi_año <- year(as.Date(basesota$fecha[dim(basesota)[1]]))
  a <- month(as.Date(basesota$fecha[dim(basesota)[1]]))
  if((mi_año-2000)%%4 != 0){
    if( (a==1)|(a==2)|(a==4)|(a==6)|(a==8)|(a==9)|(a==11)){
      return(12)
    } else if((a==5)|(a==7)|(a==10)|(a==12)){
      return(11)
    } else{
      return(9)
    }
  } else{
    if( (a==1)|(a==2)|(a==4)|(a==6)|(a==8)|(a==9)|(a==11)){
      return(12)
    } else if((a==5)|(a==7)|(a==10)|(a==12)){
      return(11)
    } else{
      return(10)
    }
  }
}


# Función que transfomra una factor o character a numeric.
pendejadas <- function(x){
  return(as.numeric(as.character(as.factor(x))))
}

# Función para obtener los retornos de una base; Sin la columna fecha y sin necesidad de limpiar antes los datos
# es decir quitarle los NA's.
base_retornos <- function(x, diferencia){
  #### Nota: El argumento diferencia debe ser del tamaño de los días desde la fecha pre-inicial hasta la fecha
  #####      que realmente quieres usar. ie fecha inicial
  #####  Ejemplo:  En la función extraer, colocaste: incial = "2019-09-21" pero lo quieres es desde "2019-10-01"
  #####             por lo que estarás agregando 10 días hacía atrás [21 sep, 30 sep],  los cúales serán
  #####             eliminados dentro de la función.
  #####             Sin embargo, supondrías que hay que dejar ese número (10), pero no, porque el rango [:,]
  #####             va a empezar desde [21: , ] pero queremos que empiece desde el [20: ,] ya que vas a calcular
  ####              los retornos y la primer fila tendrá NA's, aunque con está función al final le quito esa fila.
  
  # Quito los NA's de todas las columnas y los reemplazo con su precio anterior.
  #datos <- sapply(x, remover_na)
  #datos <- as.data.frame(datos)
  datos <- frame_sin_na(x, diferencia)
  
  # Creo una base temporal a partir de la fecha incial (la que realmente quiero).
  #datos <- datos[diferencia:dim(datos)[1],]
  
  # Quito la columna fecha para poder calcular los retornos de la columna con los índices.
  datos_cifras <- datos[, -c(1)]
  
  # Transormo todas las columnas a numeric en caso de que no lo sea.
  datos_cifras <- sapply(datos_cifras, pendejadas)
  
  datos_cifras <- as.data.frame(datos_cifras)
  
  # Obtengo los retornos a partir de una base que solo contiene los precios de los ídices (creo que no tiene
  # ni el nombre de las columnas más allá de algo tipo {v1, v2, vn})
  retornos <- sapply(datos_cifras, mis_retornos)
  
  retornos <- as.data.frame(retornos)
  
  # Quito la primer fila que contine puros NA's.
  retornos <- retornos[-1,]
  
  return(as.data.frame(retornos))
}

# Está función te regresa la base que vas a usar; Desde la fecha inicial hasta la fecha final
#                                                 Sin la fecha pre-inicial.
frame_sin_na <- function(x, diferencia){
  # Removerá todos los NA's usando la función anterior y regresará una base lista para obtener los retornos sin
  # importar los días que no operen los índice ya que esos días tendrán el ultimpo precio del mismo.
  datos <- sapply(x, remover_na)
  datos <- as.data.frame(datos)
  
  # El argumento "diferencia" es para esos desfases entre ídices por aquello de que algunos solo operan tres o
  # o dos días. Lo recomendable es que diferencia = 10 ie diez días.
  datos <- datos[(diferencia-1):dim(datos)[1],]
  return(datos)
}

remover_na <- function(x){
  # La idea con está función es que en teoría el argumento x provendrá de una columna de una base
  # ie cada x será una columna a la que se reemplazarán los NA's con el precio anterior a un NA.
  # (El día que un índice no opere por ejemplo los sabados, ese día tendrá el precio del viernes).
  # Puse este if solo para arreglar el primer caso (primer lugar) ya que no tendré acceso a la posición 
  # anterior de la columna.
  if(is.na(x[c(1)])){
    x[c(1)] <- 0
  }
  else{
    x[c(1)] <- x[c(1)]
  }
  
  for(i in 1:length(x)){
    if(is.na(x[c(i)])){
      x[c(i)] <- x[c(i-1)]
    }
    else{
      x[c(i)] <- x[c(i)]
    }
  }
  return(x)
}

mis_retornos <- function(x){
  # Incializas la variable "a".
  a <- NULL
  # Cada "x" esta pensado para recibir un vector (recibirá cada columna de la base)
  for(i in 2:length(x)){
    a[i] <- (x[i]-x[i-1])/x[i-1]
    if(is.infinite(a[i]) | is.nan(a[i])){
      a[i] <- 0
    } else{
      a[i] <- a[i]
    }
  }
  return(a)
}



generar_bases_retornos_periods <- function(ficheros){
  tipo <- ".csv"
  for(i in 1:length(ficheros)){
    setwd(Sys.getenv("PATH_1"))
    nombre_archivo <- paste0(ficheros[i], tipo)
    base1 <- read.table(nombre_archivo, sep=",", header = TRUE)
    #print(tail(base1, 5))
    valor <- get_var_for_base_retornos(base1)
    #print(valor)
    retornos <- base_retornos(base1, valor)
    #print(tail(retornos, 5))
    setwd(Sys.getenv("PATH_2"))
    write.csv(retornos, file = nombre_archivo, row.names = FALSE)
    rm(base1)
    #print("kkkkkkkkkkkkkkkkkkkkkk")
  }
}
