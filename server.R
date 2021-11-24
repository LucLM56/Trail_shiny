#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

#Server - Projet Trail

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    output$hist_age_full <- renderPlotly({
        
        histo <- ggplot(data, aes(x = age))+
            geom_histogram(bins = input$bins, color="red", fill = "red")+
            labs(title = "Répartition des runners par classe d'âge",y = "Effectif")
        
        ggplotly(histo)
    })
    
    #Seulement les femmes
    output$hist_age_femme <- renderPlotly({
        
        data_f <- data[data$gender=="W",]
        histo <- ggplot(data_f, aes(x = age))+
            geom_histogram(bins = input$bins, color="red", fill = "red")+
            labs(title = "Répartition des runners par classe d'âge",y = "Effectif")
        
        ggplotly(histo)
    })
    
    #Seulement les hommes
    output$hist_age_homme<- renderPlotly({
        
        data_h <- data[data$gender=="M",]
        histo <- ggplot(data_h, aes(x = age))+
            geom_histogram(bins = input$bins, color="red", fill = "red")+
            labs(title = "Répartition des runners par classe d'âge",y = "Effectif")
            
        
        ggplotly(histo)
    })
    
})