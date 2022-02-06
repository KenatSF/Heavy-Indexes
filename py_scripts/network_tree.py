import networkx as nx
import matplotlib.pyplot as plt
import pandas as pd

## Mi funcion:
from network_functions import crear_red

import os
from dotenv import load_dotenv
os.chdir("..")
load_dotenv()

# Ruta
networks = os.getenv('NETWORKS')

os.chdir(networks)
base = pd.read_csv("2019_10.csv")
red = crear_red(base)

t = nx.minimum_spanning_tree(red)
nx.draw(t, with_labels=1)
plt.show()

