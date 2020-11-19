library(tidyverse)
library(rgeos)
library(rgdal)
library(maptools)
library(spatstat)

#removes scientific notation on plots- useful later
options(scipen=3)


#import employment sheet
socval.employment.data=read.csv("employmentdata.csv", header=TRUE,sep=',')

#subset to complete cases, remove 0 values
targetvsactual.socval.employment.data <- subset(socval.employment.data, select= c("Target_LEV", "Delivered_LEV"))
targetvsactual.socval.employment.data[targetvsactual.socval.employment.data==0] <- NA
targetvsactual.socval.employment.data <- targetvsactual.socval.employment.data[complete.cases(targetvsactual.socval.employment.data), ]


#plot scatterplot and export to pdf
pdf(file = "NT1_target_vs_actual_LEV.pdf")
plot(targetvsactual.socval.employment.data$Target_LEV, targetvsactual.socval.employment.data$Delivered_LEV, 
main="Target LEV vs Delivered LEV, NT1",
xlab="Target LEV (£)", ylab="Delivered LEV  (£)"
)
abline(lm(targetvsactual.socval.employment.data$Target_LEV ~ targetvsactual.socval.employment.data$Delivered_LEV))
dev.off()
lm(targetvsactual.socval.employment.data$Target_LEV ~ targetvsactual.socval.employment.data$Delivered_LEV)

#plot box+whisker plots and export to pdf
pdf(file ="NT1_target_vs_actual_LEV_boxplots.pdf")
par(mfrow=c(1,2))
boxplot(targetvsactual.socval.employment.data$Target_LEV, main ="NT1 Target LEV")
boxplot(targetvsactual.socval.employment.data$Delivered_LEV, main ="NT1 Delivered LEV")
dev.off()

summary(targetvsactual.socval.employment.data$Target_LEV)
summary(targetvsactual.socval.employment.data$Delivered_LEV)

#select above 25% quantile and below 75% quantile
quartile.targetvs.actual.employment <- subset(targetvsactual.socval.employment.data, Target_LEV < 595344)
quartile.targetvs.actual.employment <- subset(quartile.targetvs.actual.employment,Target_LEV > 54246) 
quartile.targetvs.actual.employment <- subset(quartile.targetvs.actual.employment, Delivered_LEV < 408566) 
quartile.targetvs.actual.employment <- subset(quartile.targetvs.actual.employment, Delivered_LEV > 51644) 


#plot with outliers taken away
pdf(file ="NT1_target_vs_actual_LEV_outliers_scatter.pdf")
plot(targetvsactual.socval.employment.data$Target_LEV, targetvsactual.socval.employment.data$Delivered_LEV, col= "3",
main="Target LEV vs Delivered LEV, NT1",
xlab="Target LEV (£)", ylab="Delivered LEV  (£)"
)
points(quartile.targetvs.actual.employment$Target_LEV, quartile.targetvs.actual.employment$Delivered_LEV, col = "black" )
abline(col = "3",lm(targetvsactual.socval.employment.data$Target_LEV ~ targetvsactual.socval.employment.data$Delivered_LEV))
abline(lm(quartile.targetvs.actual.employment$Target_LEV ~ quartile.targetvs.actual.employment$Delivered_LEV))
dev.off()

lm(quartile.targetvs.actual.employment$Target_LEV ~ quartile.targetvs.actual.employment$Delivered_LEV)

#import the nt19 data
nt19.data=read.csv("nt19.csv", header=TRUE,sep=',')

#subset to complete cases, remove 0 values
targetvsactual.nt19.data <- subset(nt19.data, select= c("Target_LEV", "Delivered_LEV"))
targetvsactual.nt19.data[targetvsactual.nt19.data==0] <- NA
targetvsactual.nt19.data <- targetvsactual.nt19.data[complete.cases(targetvsactual.nt19.data), ]

summary(targetvsactual.nt19.data$Target_LEV)
summary(targetvsactual.nt19.data$Delivered_LEV)

#select above 25% quantile and below 75% quantile
quartile.targetvsactual.nt19.data <- subset(targetvsactual.nt19.data, Target_LEV < 2184676)
quartile.targetvsactual.nt19.data <- subset(quartile.targetvsactual.nt19.data,Target_LEV > 81403) 
quartile.targetvsactual.nt19.data <- subset(quartile.targetvsactual.nt19.data, Delivered_LEV < 1927600) 
quartile.targetvsactual.nt19.data <- subset(quartile.targetvsactual.nt19.data, Delivered_LEV > 54131) 

pdf(file = "NT19_target_vs_actual_LEV.pdf")
plot(targetvsactual.nt19.data$Target_LEV, targetvsactual.nt19.data$Delivered_LEV, col= "3",
main="Target LEV vs Delivered LEV, NT19",
xlab="Target LEV (£)", ylab="Delivered LEV (£)"
)
points(quartile.targetvsactual.nt19.data$Target_LEV, quartile.targetvsactual.nt19.data$Delivered_LEV, col = "black" )
abline(col = "3",lm(targetvsactual.nt19.data$Target_LEV ~ targetvsactual.nt19.data$Delivered_LEV))
abline(lm(quartile.targetvsactual.nt19.data$Target_LEV ~ quartile.targetvsactual.nt19.data$Delivered_LEV))
dev.off()
lm(targetvsactual.nt19.data$Target_LEV ~ targetvsactual.nt19.data$Delivered_LEV)
lm(quartile.targetvsactual.nt19.data$Target_LEV ~ quartile.targetvsactual.nt19.data$Delivered_LEV)



#mapping

#importing the base map to work from
#this is data containing postcode areas, districts and sectors
bng <- CRS("+init=epsg:27700")
basemap <- readOGR(dsn="postcodes", layer="Districts")
basemap <- spTransform(basemap, bng)
pdf(file = "basemap.pdf")
plot(basemap)
dev.off()
