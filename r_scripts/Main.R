# You must be at your root file
#load_dot_env(file = ".env")
data_path <- Sys.getenv("DATA")
setwd(data_path)


get_bases_por_periodos(2009, 1, 4)



# Nota: Yo debo examinar los ficheros.
setwd(Sys.getenv("PATH_1"))
archivos <- list.files(all.files = TRUE)
nombres_files <- gsub(pattern = "\\W", replacement = "", x = archivos)
nombres_files <- gsub(pattern = "csv", replacement = "", x = nombres_files)
el_indice <- grep(pattern = "_02", x = nombres_files)
nombres_files <- nombres_files[el_indice:length(nombres_files)]
print(nombres_files)


generar_bases_retornos_periods(nombres_files)


# archivos <- list.files(all.files = TRUE)
# nombres_files <- gsub(pattern = "\\W", replacement = "", x = archivos)
# nombres_files <- gsub(pattern = "csv", replacement = "", x = nombres_files)
# el_indice <- grep(pattern = "_02", x = nombres_files)
# nombres_files <- nombres_files[el_indice:length(nombres_files)]
# print(nombres_files)


crear_adyacencias(nombres_files)









