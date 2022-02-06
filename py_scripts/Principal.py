import networkx as nx
import matplotlib.pyplot as plt
import pandas as pd

## Mis propias funciones:
from network_functions import crear_red
from network_functions import get_fechas
from network_functions import get_indices
from network_functions import llenar_entradas

import os
from dotenv import load_dotenv
os.chdir("..")
load_dotenv()


# Rutas
my_root = os.getenv("MY_ROOT")
data = os.getenv("DATA")
networks = os.getenv('NETWORKS')
centralities = os.getenv("CENTRALITIES")


fechas_archivos = os.listdir(networks)
fechas = get_fechas(fechas_archivos)
#print(fechas)

data = pd.DataFrame(columns=get_indices(data))
#print(data)
redes = {}

data_degree = data_betweenness = data_eigenvector = data_pagerank = data_clustering = data




# Se crean las distintas redes:
os.chdir(networks)
for i in range(len(fechas_archivos)):
    base = pd.read_csv(fechas_archivos[i])
    redes[fechas[i]] = crear_red(base)
    nodos = list(nx.nodes(redes[fechas[i]]))
    centralidad_grado = nx.degree_centrality(redes[fechas[i]])               #*
    #centralidad_intermedia = nx.betweenness_centrality(redes[fechas[i]])          #*
    #centralidad = nx.closeness_centrality(redes[fechas[i]])
    # centralidad = nx.katz_centrality(redes[fechas[i]], alpha=0.01)
    #centralidad_eigenvector = nx.eigenvector_centrality(redes[fechas[i]])           #*
    #centralidad_pagerank = nx.pagerank(redes[fechas[i]])                        #*
    #centralidad_clustering = nx.clustering(redes[fechas[i]])                      #*

    data_degree = llenar_entradas(nodos, centralidad_grado, data_degree, i)
    #data_betweenness = llenar_entradas(nodos, centralidad_intermedia, data_betweenness, i)
    #data_eigenvector = llenar_entradas(nodos, centralidad_eigenvector, data_eigenvector, i)
    #data_pagerank = llenar_entradas(nodos, centralidad_pagerank, data_pagerank, i)
    #data_clustering = llenar_entradas(nodos, centralidad_clustering, data_clustering, i)



os.chdir(centralities)
data_degree.to_csv("centralidad grado.csv", index=False)
#data_betweenness.to_csv("centralidad intermedia.csv", index=False)
#data_eigenvector.to_csv("centralidad eigenvector.csv", index=False)
#data_pagerank.to_csv("centralidad pagerank.csv", index=False)
#data_clustering.to_csv("centralidad clustering.csv", index=False)







