
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
  
  # Regreso la base Final.csv
  return(datos)
  
}


get_bases_por_periodos <- function(year, inicio, final){
  añoY <- as.character(year)
  periodos_por_meses <- get_periodos(year, inicio, final)
  mesesillos <- colnames(periodos_por_meses)
  tipo <- ".csv"
  for(i in 1:length(periodos_por_meses)){
    base <- extraer(as.character(periodos_por_meses[1,i]), as.character(periodos_por_meses[2,i]))
    ruta_archivo <- paste0(añoY, "_", mesesillos[i], tipo)
    data_path <- Sys.getenv("PATH_1")
    setwd(data_path)
    write.csv(base, file = ruta_archivo, row.names = FALSE)
    rm(base)
  }
  
}

#############################################################
#######  LAS FUNCIONES DE ARRIBA SON PARA FRAGMENTAR LOS PERIODOS (_1_base_datos)


