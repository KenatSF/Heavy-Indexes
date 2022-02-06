import networkx as nx
import pandas as pd
import re
from os import listdir

####  Nota: Para que la función pueda funcionar la base de datos debe tener el formato
#          Unnamed: 0  AEX  ATX
#      0          AEX    0  151
#      1          ATX  151    0

#    El ínidce en las filas empieza en i = 0  &  El índice en las columnas empieza en j + 1    donde j = 0

# Vector con los nombres de los índices.
def crear_red(base):
    # Aquí cuidado con el elmento en el lugar 0
    columnas = list(base.columns)
    #columnas.pop(0)

    # Definimos el grafo:
    g = nx.Graph()

    # Creamos los nodos a partir de los nombres de las columnas.
    g.add_nodes_from(columnas)

    for i in range(base.shape[0]):
        for j in range(base.shape[1]-1):
            if(base.iloc[i, j+1] != 0):
                g.add_edge(list(g.nodes())[i], list(g.nodes())[j], weight = base.iloc[i, j+1])
                print("Nodo i,j  Ent: ", list(g.nodes())[i], " vs ", list(g.nodes())[j], " Pesos: ", base.iloc[i, j+1])

    return g

def get_fechas(x):
    fechas = []
    for i in range(len(x)):
        fechas.append(re.sub('\.csv', '', x[i]))
    return fechas

def get_indices(ruta):
    x = listdir(ruta)
    nombres_indices = []
    for i in range(len(x)):
        temp = re.sub('\.csv', '', x[i])
        nombres_indices.append(re.sub('Datos históricos ', '', temp))
    return nombres_indices

def limpiar_indices(x):
    indices = []
    for i in range(len(x)):
        temp = re.sub('&', '.', x[i])
        temp = re.sub('-', '.', temp)
        indices.append(re.sub(" ", ".", temp))
    return indices

def llenar_entradas(nodos, centrallidad, base, id):
    for i in range(len(nodos)):
        base.at[id, nodos[i]] = centrallidad[nodos[i]]
        #base.set_value(id, nodos[i], centrallidad[nodos[i]])
    return base


