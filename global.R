library(tidytuesdayR)
library(shiny)
library(plotly)
library(ggplot2)
library(leaflet)
library(rgdal)
library(sp)
library(sqldf)
library(MASS)
library(stringr)
library(maps)
library(dplyr)
library(stringr)

#Préciser le chemin d'accès aux données ci-dessous :
#path = "C:/Users/Antoi/OneDrive/Documents/Master 2/Rshiny/Projet/Projet_rshiny/"
path = "D:/Dossiers/Etudes/M2 EKAP/R shiny/TRAIL"
setwd(path)
#Importation de deux bases de données et du fond de carte
data <- read.csv2("data_runner.csv")
data_nation <- read.csv2("data_nation.csv", sep=",")
data_nation$Age_moyen <- as.numeric(data_nation$Age_moyen)

cartemonde <- readOGR(dsn = path,
                      layer="TM_WORLD_BORDERS_SIMPL-0.3")
                      
#Récupération des données à l'échelle nationnale pour la carte
cartemonde <- sp::merge(cartemonde,data_nation,all.x=T, by.x = 'ISO3',by.y='nationality')

cartemonde@data$POP2005[ which(cartemonde@data$POP2005 == 0)] = NA
cartemonde@data$POP2005 <- as.numeric(as.character(cartemonde@data$POP2005)) / 1000000 %>% round(2)

mytext <- paste(
  "Pays: ", cartemonde@data$NAME, "<br/>", 
  "Superficie: ", cartemonde@data$AREA, " km2" , "<br/>", 
  "Population: ", round(cartemonde@data$POP2005,2), " millions d'habitants", 
  sep="") %>%
  lapply(htmltools::HTML)

