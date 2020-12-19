library(readxl)
library(factoextra)
#Loading required library
kmeansmale <- read_excel("kmeansmale.xlsx")
kmeansfemale <- read_excel("kmeansfemale.xlsx")
#Loading required dataset
stmale<-scale(kmeansmale) #Standardize the dataset
fviz_nbclust(stmale,kmeans,method = "wss")+geom_vline(xintercept = 3, linetype = 2)
set.seed(123) #Find the optimal number of clusters for male
km_res_stmale<-kmeans(stmale,3) #Use the K-means method for the dataset
km_res_stmale[["centers"]] #Show the centroids of K-means
plot_male<-fviz_cluster(km_res_stmale,stmale,main="K-means of Urgency on Males") #Plot K-means result 
plot_male

stfemale<-scale(kmeansfemale) #Standardize the dataset
fviz_nbclust(stfemale,kmeans,method = "wss")+geom_vline(xintercept = 3, linetype = 2)
#Find the optimal number of clusters for female

set.seed(1234)
km_res_stfemale<-kmeans(stfemale,3) #Use the K-means method for the dataset
km_res_stfemale[["centers"]] #Show the centroids of K-means
plot_female<-fviz_cluster(km_res_stfemale,stfemale,main="K-means of Urgency on Females") #Plot K-means result
plot_female