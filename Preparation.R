# Script pour préparer les données avant l'intégration à l'application

#Importation
ultra_rankings <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-10-26/ultra_rankings.csv')
race <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-10-26/race.csv')

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

#Création d'une base de données avec les informations par pays
a <- 'SELECT nationality, avg(age) as Age_moyen,count(DISTINCT runner) as nb_runner,
        round(avg(rank),0) as classement_moyen, count(DISTINCT race) as nb_event,
        round(avg(distance),2) as distance_moyenne'
b <- 'FROM data'
c <- 'GROUP BY nationality'
query <- paste(a,b,c)
datapays <- sqldf(query)
a <- 'SELECT nationality, count(DISTINCT runner) as nb_homme'
b <- 'FROM data'
c <- 'WHERE gender = "M"'
d <- 'GROUP BY nationality'
query <- paste(a,b,c,d)
df <- sqldf(query) #Base temporaire
datapays <- merge(datapays,df,by = "nationality")
datapays$prop_homme = round((datapays$nb_homme/datapays$nb_runner)*100,2)
datapays$prop_femme = 100 - datapays$prop_homme
head(datapays)

#Exportation
write.csv2(data,"data_runner.csv")
write.csv2(datapays,"data_nation.csv")