# Antoine PETITEAU & Luc LE MEE - M2 EKAP
# UI - Projet Trail

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    titlePanel("Ultra running events"),
    tabsetPanel(
        tabPanel("Presentation",
                 sidebarLayout(
                     sidebarPanel(
                         sliderInput("bins",
                                     "Nombre de classe de l'histogramme : ",
                                     min = 4,
                                     max = 40,
                                     value = 15)
                         
                     ), 
                     mainPanel(
                         tabsetPanel(
                             tabPanel("TOUS", 
                                      plotlyOutput("hist_age_full"),
                                      br(),
                                      br(),
                                      plotlyOutput("piechart")), 
                             tabPanel("FEMME", 
                                      plotlyOutput("hist_age_femme")), 
                             tabPanel("HOMME", 
                                      plotlyOutput("hist_age_homme"))
                         )
                     )
                 )
        ),
        tabPanel("Carte",
                 sidebarLayout(
                     sidebarPanel(
                         radioButtons("var",
                                      "Indicateur : ",
                                      choiceValues = c("Age_moyen", "nb_runner", "classement_moyen"),
                                      choiceNames = c("Age moyen", "Nombre de runners", "Classement moyen")),
                         radioButtons("col", 
                                      "Palette de couleur : ", 
                                      choiceValues = c( "viridis","Oranges","Greens"),
                                      choiceNames = c("Viridis", "Orange", "Vert"))
                     ),
                     mainPanel(
                         h3("Carte"),
                         leafletOutput("map")
                     )
                 )
        ),
        tabPanel("Vainqueurs",
                 sidebarLayout(
                     sidebarPanel(
                         selectInput("pays", "Choisir le pays de la course : ", 
                                     choices = levels(as.factor(data$country)),
                                     selected = NULL, 
                                     multiple = FALSE,
                                     width="450px"),
                         selectInput("event", "Choisir l'Evenement : ", 
                                     choices = NULL,
                                     selected = NULL, 
                                     multiple = FALSE,
                                     width="450px")
                     ),
                     mainPanel(
                         h3("Liste des vainqueurs"),
                         tableOutput("table_event")
                         
                     )
                 )
        ),
        
        tabPanel("Evolution",
                 sidebarLayout(
                     sidebarPanel(
                         radioButtons("indic_evol", "Indicateur : ", 
                                      choiceValues = c("age_moyen","distance_moyenne","time_moyen"),
                                      choiceNames = c("Age Moyen (an)", "Distance (km)" , "Temps de course (seconde)")),
                         dateRangeInput('dateRange',
                                        label = 'Selectionnez une periode : ',
                                        start = "2012-01-14", 
                                        end = "2021-09-03",
                                        min = "2012-01-14",
                                        max = "2021-09-03")
                     ),
                     mainPanel(
                         plotlyOutput("evol")
                     )
                 )
                 
        )
    ))
    
)

