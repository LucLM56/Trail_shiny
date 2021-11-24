library(tidytuesdayR)
library(shiny)
library(plotly)
library(ggplot2)
library(leaflet)
library(rgdal)
library(sp)
library(sqldf)
library(MASS)


#Importation
#ultra_rankings <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-10-26/ultra_rankings.csv')
#race <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-10-26/race.csv')

#Merge :
data <- merge(ultra_rankings,race,by="race_year_id")

summary(data)
#Voir les runneurs trop jeunes et trop vieux (15 - 90)
#Carte possible
nrow(data[data$age==0,])
nrow(data[data$age<18,]) #On utilise ce seuil minimal
nrow(data[data$age>85,]) #On utilise ce seuil maximal

#Exclusion des atypiques
data <- data[data$age>17 & data$age <86,]
data$nationality <- as.factor(data$nationality)

#Transformation de la base pour carte
a <- 'SELECT nationality, avg(age) as Age_moyen,count(DISTINCT runner) as nb_runner'
b <- 'FROM data'
c <- 'GROUP BY nationality'
query <- paste(a,b,c)
datapays <- sqldf(query)
a <- 'SELECT nationality, count(DISTINCT runner) as nb_homme'
b <- 'FROM data'
c <- 'WHERE gender = "M"'
d <- 'GROUP BY nationality'
query <- paste(a,b,c,d)
df <- sqldf(query)
datapays <- merge(datapays,df,by = "nationality")
head(datapays)

##Données mondiale
##Données spatiale (4fichiers du même nom)

cartemonde <- readOGR(dsn = "C:/Users/Antoi/OneDrive/Documents/Master 2/Rshiny/Projet/Projet_rshiny/TM_WORLD_BORDERS_SIMPL-0.3",
                      layer="TM_WORLD_BORDERS_SIMPL-0.3")


cartemonde <- sp::merge(cartemonde,datapays,all.x=T, by.x = 'ISO3',by.y='nationality')
class(cartemonde)
head(cartemonde)

leaflet()%>%
  addTiles()%>%
  addPolygons(data = cartemonde,weight = 2,fillColor = "yellow")
