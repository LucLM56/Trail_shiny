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
                                     max = 50,
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
                         radioButtons("var", "Indicateur : ", choiceValues = c("Age_moyen", "nb_runner", "classement_moyen"),choiceNames = c("Age moyen", "Nombre de runners", "Classement moyen"))
                     ),
                     mainPanel(
                         h3("Carte"),
                         leafletOutput("map")
                     )
                 )
        )
    ))
    
)

#Voir choicenames et choicevalues : https://shiny.rstudio.com/reference/shiny/1.6.0/radioButtons.html