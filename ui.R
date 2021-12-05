#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

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
                             tabPanel("TOUS", plotlyOutput("hist_age_full")), 
                             tabPanel("FEMME", plotlyOutput("hist_age_femme")), 
                             tabPanel("HOMME", plotlyOutput("hist_age_homme"))
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
                 )
    ))
    
)

