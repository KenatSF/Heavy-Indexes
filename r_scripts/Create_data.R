# Debes de estar en el archivo inicial
load_dot_env(file = ".env")

save_files = Sys.getenv("NETWORKS")

get_bases_por_periodos(2008, 2, 12, save_files)
for(i in 2009:2018)
{
  get_bases_por_periodos(i, 1, 12, save_files)
}
get_bases_por_periodos(2019, 1, 10, save_files)




