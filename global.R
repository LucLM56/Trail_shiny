library(tidytuesdayR)

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
