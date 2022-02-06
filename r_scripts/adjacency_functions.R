get_bases_por_periodos <- function(year, inicio, final, path_save){
  añoY <- as.character(year)
  periodos_por_meses <- get_periodos(year, inicio, final)
  mesesillos <- colnames(periodos_por_meses)
  tipo <- ".csv"
  for(i in 1:length(periodos_por_meses)){
    print(paste("Año: ", añoY, "  Mes: ", mesesillos[i]))
    base <- extraer(as.character(periodos_por_meses[1,i]), as.character(periodos_por_meses[2,i]))
    
    valor <- get_var_for_base_retornos(base)
    retornos <- base_retornos(base, valor)
    
    
    matriz <- cor(retornos)
    matriz <- limpiar_pearson(matriz)
    matriz <- sqrt(2*(1-matriz))
    matriz <- limpiar_sqrt(matriz)
    # matriz <- (1-matriz)/2
    
    nombre_archivo <- paste0(añoY, "_", mesesillos[i], tipo)
    setwd(path_save)
    write.csv(matriz, file = nombre_archivo, row.names = FALSE)
    rm(base)
    rm(retornos)
    rm(matriz)
  }
  
}



get_periodos <- function (year, a, b) {
  if((a<1 | a>12) | (b < 1 | b > 12) | (a>=b)){
    return(0)
  } else {
    periodos_8 <- data.frame(ene = c("-12-20", "-01-31"),
                             feb = c("-01-20", "-02-28"),
                             mar = c("-02-20", "-03-31"),
                             abr = c("-03-20", "-04-30"),
                             may = c("-04-20", "-05-31"),
                             jun = c("-05-20", "-06-30"),
                             jul = c("-06-20", "-07-31"),
                             ago = c("-07-20", "-08-31"),
                             sep = c("-08-20", "-09-30"),
                             oct = c("-09-20", "-10-31"),
                             nov = c("-10-20", "-11-30"),
                             dic = c("-11-20", "-12-31"))
    
    periodos_9 <- data.frame(ene = c("-12-20", "-01-31"),
                             feb = c("-01-20", "-02-29"),
                             mar = c("-02-20", "-03-31"),
                             abr = c("-03-20", "-04-30"),
                             may = c("-04-20", "-05-31"),
                             jun = c("-05-20", "-06-30"),
                             jul = c("-06-20", "-07-31"),
                             ago = c("-07-20", "-08-31"),
                             sep = c("-08-20", "-09-30"),
                             oct = c("-09-20", "-10-31"),
                             nov = c("-10-20", "-11-30"),
                             dic = c("-11-20", "-12-31")
    )
    
    meses <- c("01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12")
    ##########
    evaluar <- year - 2000
    if((evaluar%%4) != 0){
      año <- as.numeric(year)
      año_meses<- data.frame(index = c(1,2))
      for(i in a:b){
        if(i ==1){
          temp <- as.numeric(año)
          temp <- temp - 1
          año <- as.character(temp)
          inicio <- paste0(año, periodos_8[1,i])
          temp <- as.numeric(año)
          temp <- temp + 1
          año <- as.character(temp)
          final <- paste0(año, periodos_8[2,i])
          #vector <- c(inicio, final)
          año_meses[, meses[i]] <- c(inicio, final)
          
        } else {
          inicio <- paste0(año, periodos_8[1,i])
          final <- paste0(año, periodos_8[2,i])
          #vector <- c(inicio, final)
          año_meses[, meses[i]] <- c(inicio, final)
        }
      }
      return(año_meses[,-c(1)])
    }
    else{
      año <- as.numeric(year)
      año_meses<- data.frame(index = c(1,2))
      for(i in a:b){
        if(i ==1){
          temp <- as.numeric(año)
          temp <- temp - 1
          año <- as.character(temp)
          inicio <- paste0(año, periodos_9[1,i])
          temp <- as.numeric(año)
          temp <- temp + 1
          año <- as.character(temp)
          final <- paste0(año, periodos_9[2,i])
          #vector <- c(inicio, final)
          año_meses[, meses[i]] <- c(inicio, final)
          
        } else {
          inicio <- paste0(año, periodos_9[1,i])
          final <- paste0(año, periodos_9[2,i])
          #vector <- c(inicio, final)
          año_meses[, meses[i]] <- c(inicio, final)
        }
      }
      return(año_meses[,-c(1)])
    }
  }
}


extraer <- function(inicio, final){
  
  ### Formato para la fecha: "Y-m-d" ; Tanto para el "inicio" como para el "final"
  #  Establece el path en el fichero dond están todas las base de datos (archivos csv) para poder
  #  extraer solo los precios de cierre y la fecha. Juntando todo en un solo archivo Final.csv
  setwd(Sys.getenv("DATA"))
  
  # Vector con el nombre de todos los archivos.
  archivos <- list.files(pattern = "Datos históricos ", all.files = TRUE)
  
  # Usando la función gsub() lo que hago es extraer el nombre del índice para ponerlos como nombre columna
  # en el archivo Final.csv
  indices <- gsub(pattern = "Datos históricos |.csv", replacement = "", x = archivos)
  
  # Sabiendo el nombre de las columnas de antemano, les paso un nombre con un formato "limpio" ya que la descarga
  # original tiene carácteres raros.
  col_names <- c("fecha", "cierre", "apertura", "maximo", "minimo", "volumen", "variacion")
  
  # Creo un vector de fechas: Desde "inicio" hasta "final".
  fechas <- as.Date(inicio, "%Y-%m-%d"):as.Date(final, "%Y-%m-%d")
  fechas <- anydate(fechas)
  # Transformo el vector de fechas en una base de fechas. Nota: Será de utilidad después.
  datos <- data.frame(fecha = fechas)
  datos$fecha <- as.character(datos$fecha)
  
  # Ciclo que se va a ejecutar la cantidad del tamaño del fichero.
  for(i in 1:length(archivos)){
    # Base temporal
    base1 <- read.table(archivos[c(i)], sep=",", header = TRUE)
    
    # Asigna los nombres de las columnas a esa base temporal.
    colnames(base1) <- col_names
    
    # Extrae la columna fecha y cierre.
    base1 <- base1[c(1,2)]
    # Transforma los números que tengan comas en variables tipo numeric.
    base1$cierre <- gsub(pattern=",", replacement = "", x = base1$cierre)
    base1$cierre <- as.numeric(as.character(base1$cierre))
    
    # Da formato de fecha a la columna fecha de la base temporal y crea un vector temporal tipo serie de tiempo.
    base1$fecha <- as.Date(base1$fecha, "%d.%m.%Y")
    temp1 <- zoo(base1$cierre, order.by = base1$fecha)
    base1_xts <- as.xts(temp1)
    
    # Extrae del vector temporal (formato ST) solo el periodo de tiempo que se le paso a la función.
    base_modificar <- base1_xts[paste0(inicio,"/",final), ]
    
    # Si alguna "base" es nula ie El índice no existía en ese periodo de tiempo pasa a la siguiente iteración.
    if(length(base_modificar)<=0){
      datos <- datos
      
    }
    else{
      # Transforma el vector (formato ST) a una base asignado dos columnas fecha y el nombre del índice i.
      base_temporal <- as.data.frame(base_modificar)
      ##  La función se utiliza puesto que venimos de un objeto tipo xts (Serie de tiempo), para que no se presenten
      #   problemas al juntar las bases de datos con full_join().
      base_temporal <- setDT(base_temporal, keep.rownames = TRUE)
      
      colnames(base_temporal) <- c("fecha", indices[c(i)])
      
      # Uno las dos base: La base de fechas y la base temporal; Lo que los va a unir será la columna fecha.
      datos <- full_join(datos, base_temporal, by=c("fecha"))
      
    }
    
    
  }
  
  # Regreso la base Final
  return(datos)
  
}


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
  datos_cifras <- sapply(datos_cifras, to_numeric)
  
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

# Función que transfomra una factor o character a numeric.
to_numeric <- function(x){
  return(as.numeric(as.character(as.factor(x))))
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

#############################################

limpiar_pearson_full <- function(correlaciones){
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

limpiar_pearson <- function(correlaciones){
  for(i in 1:dim(correlaciones)[c(1)]){
    for(j in 1:dim(correlaciones)[c(2)]){
      if(correlaciones[c(i),c(j)]<0.5 & correlaciones[c(i),c(j)] >-0.5){
        correlaciones[c(i),c(j)] <-0
      }
      else{
        correlaciones[c(i),c(j)] <- correlaciones[c(i),c(j)]
      }
    }
  }
  
  return(correlaciones)
}

limpiar_sqrt <- function(datos) {
  for(i in 1:dim(datos)[c(1)]){
    for(j in 1:dim(datos)[c(2)]){
      if(round(datos[c(i),c(j)], 4) == round(sqrt(2), 4)){
        datos[c(i),c(j)] <-0
      }
      else{
        datos[c(i),c(j)] <- datos[c(i),c(j)]
      }
    }
  }
  
  return(datos)
}





