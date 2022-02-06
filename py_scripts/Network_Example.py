import networkx as nx
import matplotlib.pyplot as plt
g = nx.DiGraph()

g.add_edge('1', '2', capacity = 5)
g.add_edge('2', '6', capacity = 5)
g.add_edge('6', '7', capacity = 1)
g.add_edge('7', '9', capacity = 8)
g.add_edge('1', '3', capacity = 7)
g.add_edge('3', '5', capacity = 2)
g.add_edge('5', '8', capacity = 5)
g.add_edge('8', '9', capacity = 1)
g.add_edge('2', '3', capacity = 6)
g.add_edge('2', '4', capacity = 6)
g.add_edge('3', '4', capacity = 4)
g.add_edge('4', '6', capacity = 4)
g.add_edge('5', '4', capacity = 6)
g.add_edge('6', '5', capacity = 4)
g.add_edge('7', '5', capacity = 3)
g.add_edge('8', '7', capacity = 6)

flow = nx.maximum_flow_value(g, '1', '9')
corte = nx.minimum_cut(g, '1', '9')
print(flow)
print(corte)

nx.draw(g, with_labels=1)
plt.show()






