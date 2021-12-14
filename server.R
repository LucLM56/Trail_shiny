# Antoine PETITEAU & Luc LE MEE - M2 EKAP
#Server - Projet Trail

# Define server logic required to draw a histogram
shinyServer(function(input, output,session) {
    
    output$hist_age_full <- renderPlotly({
        
        histo <- ggplot(data, aes(x = age))+
            geom_histogram(bins = input$bins, color="white", fill = "blue")+
            labs(title = "Repartition des runners par classe d'age",y = "Effectif")
        
        ggplotly(histo)
    })
    
    #Seulement les femmes
    output$hist_age_femme <- renderPlotly({
        
        data_f <- data[data$gender=="W",]
        histo <- ggplot(data_f, aes(x = age))+
            geom_histogram(bins = input$bins, color="white", fill = "blue")+
            labs(title = "Repartition des runners par classe d'age",y = "Effectif")
        
        ggplotly(histo)
    })
    
    #Seulement les hommes
    output$hist_age_homme<- renderPlotly({
        
        data_h <- data[data$gender=="M",]
        histo <- ggplot(data_h, aes(x = age))+
            geom_histogram(bins = input$bins, color="white", fill = "blue")+
            labs(title = "Repartition des runners par classe d'age",y = "Effectif")
        
        
        ggplotly(histo)
    })
    
    
    
    output$map<- renderLeaflet({
        indicateur = input$var
        base <- eval(parse(text=paste("cartemonde$", indicateur, sep = "")))
        col = input$col
        # Creation de la fonction de palette numérique sur nos densités
        pal <- colorBin(
            palette = col,
            reverse=T,
            domain = base
        )
        
        observeEvent(input$map_shape_click, { # update the location selectInput on map clicks
            p <- input$map_shape_click
            country <- maps::map.where(database = "world", p$lng, p$lat)
            print(country)
        })
        
        #Carte
        map_regions <- leaflet() %>%
            addTiles() %>%
            # polygone des regions
            addPolygons(
                data = cartemonde, 
                weight = 0.25,
                label = ~mytext,
                popup = ~paste0(indicateur, " : ", round(base,2)), #Affichage après un clique sur le pays
                fill = TRUE, 
                # Application de la fonction palette
                fillColor = ~pal(base),
                fillOpacity = 2,
                highlightOptions = highlightOptions(color = "white", weight = 3))%>%
            addLegend(
                title = indicateur,
                position = "bottomleft",
                pal = pal, values = base)%>%
            setView(lng = -1.638606, lat = 27.453093, zoom = 1)#Bout-de-bois au centre (47 au lieu de 27...)
    })
    
    observeEvent(input$pays, {
        pays = input$pays
        df_winner <- data %>% 
            select(rank, runner, time, age, nationality, event, country, date) %>%
            filter(country == pays) %>%
            group_by(date)
        
        EVENT = levels(as.factor(df_winner$event))
        updateSelectInput(session = session, inputId = "event", choices = EVENT)
    })
    
    observe({
        input$pays
        vars <- all.vars(parse(text=as.character(input$inBody)))
        vars <- as.list(vars)
        updateSelectInput(session = session, inputId = "inVar", choices = vars)
    })
    
    observeEvent(input$event, {
        Event = input$event
        df_winner <- data %>% 
            select(date, runner, gender, nationality, age, time, rank , event) %>% 
            filter( event == Event & rank == 1) %>%
            arrange(substring(date, 1,4)) %>%
            rename(Coureur = runner, Genre = gender, Temps =time, Age = age, Nationnalite = nationality, Date = date)
        
        output$table_event<- renderTable(df_winner[,-c(7,8)]) 
    })
    
    output$piechart <- renderPlotly({
        data_h <- data[data$gender=="M",]
        data_f <- data[data$gender=="W",]
        df <- data.frame(
            gender = c("Hommes", "Femmes"),
            nb_gender = c(nrow(data_h),nrow(data_f)))
        
        fig <- plot_ly(df, labels = ~gender, 
                       values = ~nb_gender, 
                       type = 'pie',
                       textposition = 'inside',
                       textinfo = 'label+percent',
                       marker = list(colors = c("blue","red"),
                                     line = list(color = '#FFFFFF', width = 1)),
                       showlegend = FALSE) %>% 
            layout(title = 'Repartition des participants selon le genre',
                   xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                   yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
        
        fig
    })
    
    observeEvent(c(input$dateRange,input$indic_evol),{   
        
        date_start = format(input$dateRange[1])
        date_end = format(input$dateRange[2])
        data$distance <- as.numeric(data$distance)
        if (date_end<=date_start){
            sendSweetAlert(session, 
                           "Erreur",
                           "La date de fin doit etre superieure a la date de depart.",
                           type="error")
        }
        else {
            data$date_clean <- as.POSIXct(data$date, 
                                          tz = "UTC", 
                                          format = "%Y-%m-%d")
            data$gender[data$gender=="M"] <-"Homme"
            data$gender[data$gender=="W"] <-"Femme"
            
            evol <- data %>%
                select(date_clean, gender, age, distance, time_in_seconds) %>%
                group_by(date_clean, gender) %>%
                summarise(age_moyen = round(mean(age, na.rm = TRUE),2),
                          distance_moyenne = round(mean(distance, na.rm = TRUE),2),
                          time_moyen = round(mean(time_in_seconds, na.rm = TRUE),2)) %>%
                filter(distance_moyenne > 0 & date_clean >= date_start & date_clean<= date_end) %>% 
                drop_na 
            
            tempo <- ggplot(data = evol, aes_string(x = "date_clean", y = input$indic_evol, color = "gender"))+
                geom_line( size = 1) +
                labs(title = "", x = "Date", y = "", color = "Genre\n") +
                scale_color_manual(values = c("red", "blue"))
            
            
            output$evol <- renderPlotly({tempo})
        }
    })
    
    
})


