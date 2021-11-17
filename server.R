#Server - Projet Trail

library(shiny)
library(plotly)
library(ggplot2)


# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  output$hist_age_full <- renderPlotly({
    
    histo <- ggplot(data, aes(x = age))+
      geom_histogram(bins = input$bins, color="red", fill = "red")
    
    ggplotly(histo)
  })
  
  #Seulement les femmes
  output$hist_age_femme <- renderPlotly({
    
    data_f <- data[data$gender=="W",]
    histo <- ggplot(data_f, aes(x = age))+
      geom_histogram(bins = input$bins, color="red", fill = "red")
    
    ggplotly(histo)
  })
  
  #Seulement les hommes
  output$hist_age_homme<- renderPlotly({
    
    data_h <- data[data$gender=="M",]
    histo <- ggplot(data_h, aes(x = age))+
      geom_histogram(bins = input$bins, color="red", fill = "red")
    
    ggplotly(histo)
  })

})
