library(tidytuesdayR)
library(shiny)
library(plotly)
library(ggplot2)
library(leaflet)
library(rgdal)
library(sp)
library(sqldf)
library(MASS)

#Préciser le chemin d'accès aux données ci-dessous :
path = "D:/Dossiers/Etudes/M2 EKAP/R shiny/TRAIL"

#Importation de deux bases de données et du fond de carte
data <- read.csv2("data_runner.csv")
data_nation <- read.csv2("data_nation.csv")
cartemonde <- readOGR(dsn = path,
                      layer="TM_WORLD_BORDERS_SIMPL-0.3")
                      
#Récupération des données à l'échelle nationnale pour la carte
cartemonde <- sp::merge(cartemonde,data_nation,all.x=T, by.x = 'ISO3',by.y='nationality')

#Carte
leaflet()%>%
  addTiles()%>%
  addPolygons(data = cartemonde,weight = 2)

