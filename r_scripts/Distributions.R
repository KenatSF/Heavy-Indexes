
replace_outliers <- function(x, removeNA = TRUE){
  qrts <- quantile(x, probs = c(0.25, 0.75), na.rm = removeNA)
  caps <- quantile(x, probs = c(.05, .95), na.rm = removeNA)
  iqr <- qrts[2]-qrts[1]
  h <- 1.5 * iqr
  x[x<qrts[1]-h] <- caps[1]
  x[x>qrts[2]+h] <- caps[2]
  x
}



setwd(Sys.getenv("CENTRALITIES"))

######   Grado
base <- read.table("centralidad grado.csv", sep=",", header = TRUE)


nombres <- 1:47
colnames(base) <- nombres


par(mar=c(3,3,3,3))
boxplot(base, col="#69b3a2", ylab = "Centralidad", main = "Centralidad de grado.")
abline(h = 0.5, col="red")
abline(h = 0.55, col="red")
abline(h = 0.6, col="red")

######   Intermedia 
base <- read.table("centralidad intermedia.csv", sep=",", header = TRUE)

nombres <- 1:47
colnames(base) <- nombres
#base <- replace_outliers(base)


par(mar=c(3,3,3,3))
boxplot(base, col="#69b3a2", ylab = "Centralidad", main="Centralidad Intermedia")
abline(h = 0.01, col="red")
abline(h = 0.016, col="red")
abline(h = 0.02, col="red")


######   eigenvector
base <- read.table("centralidad eigenvector.csv", sep=",", header = TRUE)


nombres <- 1:47
colnames(base) <- nombres

par(mar=c(3,3,3,3))
boxplot(base, col="#69b3a2", ylab = "Centralidad", main = "Eigenvector.")
abline(h = 0.1, col="red")
abline(h = 0.16, col="red")
abline(h = 0.2, col="red")

######   pageRank
base <- read.table("centralidad pagerank.csv", sep=",", header = TRUE)

nombres <- 1:47
colnames(base) <- nombres


par(mar=c(3,3,3,3))
boxplot(base, col="#69b3a2", ylab = "Centralidad", main = "PageRank")
abline(h = 0.015, col="red")
abline(h = 0.026, col="red")
abline(h = 0.035, col="red")


######   clustering
base <- read.table("centralidad clustering.csv", sep=",", header = TRUE)


nombres <- 1:47
colnames(base) <- nombres

par(mar=c(3,3,3,3))
boxplot(base, col="#69b3a2", ylab = "Centralidad", main = "Clustering.")
abline(h = 0.5, col="red")
abline(h = 0.59, col="red")
abline(h = 0.7, col="red")


















