# Heavy indexes

## Dependencies

* R version 3.6.2
* Python version 3.8.2
* Gephi version 10.21

## Resources

* Datos: [www.investing.com](https://www.investing.com/)
* [Applications of Graph Theory In Finance](http://jonathankinlay.com/2019/09/applications-graph-theory-finance)
* [Estructura Topológica del Mercado Bursátil de Chile, período 2009-2013](https://www.researchgate.net/publication/303721192_Estructura_Topologica_del_Mercado_Bursatil_de_Chile_periodo_2009-2013)
* [Topology of the correlation networks among major currencies using hierarchical structure methods](https://arxiv.org/ftp/arxiv/papers/1010/1010.5653.pdf)

## Project

¿Cúales son los índices bursátil más importantes del mundo? Tratando de responder está pregunta, realicé un estudio, recolentando la información del movimiento de los índices a lo 
largo de varios años. Posteriormente separé la información en periodos mensuales. Una vez estructurado de esta forma, obtuve las correlaciones entre los diferentes índices y con base
en esto poder crear las distintas redes de estudio. Finalmente, obtuve las centralidades de las mismas.


* Centralidad de grado
![](https://github.com/KenatSF/Heavy-Indexes/blob/main/img/1_degree.png)
* Centralidad de cercanía
![](https://github.com/KenatSF/Heavy-Indexes/blob/main/img/2_betweenness.png)
* Eigenvector
![](https://github.com/KenatSF/Heavy-Indexes/blob/main/img/3_eigenvector.png)
* Pagerank
![](https://github.com/KenatSF/Heavy-Indexes/blob/main/img/5_clustering.png)

Los índices "más" importantes que el estudio mostró son:

* AEX - Amsterdam Exchange Index
* ATX - Austrian Traded Index
* DAX - Deutscher Aktien IndeX
* DJI - Dow Jones Industrial Average (NY)
* Euro Stoxx 50 - Stock index of Eurozone 
* FTSE MIB - Stock market index for the Borsa Italiana
* RTSI - Russia Trading System

Note: Aunque dentro del estudio no destacó, todo inversor sabe que es muy importante mantener un ojo sobre este índice:
* S&P500 - Standard & Poor's 500 Index









