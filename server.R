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
            labs(title = "Repartition des runners par classe d'age",y = "Effectif")
        
        ggplotly(histo)
    })
    
    #Seulement les femmes
    output$hist_age_femme <- renderPlotly({
        
        data_f <- data[data$gender=="W",]
        histo <- ggplot(data_f, aes(x = age))+
            geom_histogram(bins = input$bins, color="red", fill = "red")+
            labs(title = "Repartition des runners par classe d'age",y = "Effectif")
        
        ggplotly(histo)
    })
    
    #Seulement les hommes
    output$hist_age_homme<- renderPlotly({
        
        data_h <- data[data$gender=="M",]
        histo <- ggplot(data_h, aes(x = age))+
            geom_histogram(bins = input$bins, color="red", fill = "red")+
            labs(title = "Repartition des runners par classe d'age",y = "Effectif")
            
        
        ggplotly(histo)
    })
    
    
    output$map<- renderLeaflet({
        # Creation de la fonction de palette numérique sur nos densités
        pal <- colorBin(
            palette = "Blues",
            domain = cartemonde$nb_runner
            )
        
        #Carte
        map_regions <- leaflet() %>%
            addTiles() %>%
            # polygone des regions
            addPolygons(
                data = cartemonde, 
                label = ~NAME,
                popup = ~paste0("Nombre de coureurs : ", nb_runner), #Affichage après un clique sur le pays
                fill = TRUE, 
                # Application de la fonction palette
                fillColor = ~pal(nb_runner),
                fillOpacity = 0.8,
                highlightOptions = highlightOptions(color = "white", weight = 2))%>%
            addLegend(
                title = "Nombre de coureurs ",
                pal = pal, values = cartemonde$nb_runner)
        map_regions
    })
    
})