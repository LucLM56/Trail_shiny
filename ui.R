# UI - Projet Trail

library(shiny)



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
    tabPanel("Onglet2")
  ))
  
)
