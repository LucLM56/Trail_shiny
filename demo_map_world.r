library(rgdal)
library(leaflet)
library(shiny)

world_spdf <- readOGR( 
  dsn = paste0(getwd(),"/world_shape_file") , 
  layer ="TM_WORLD_BORDERS_SIMPL-0.3",
  verbose=FALSE
)



# Clean the data object
library(dplyr)
world_spdf@data$POP2005[ which(world_spdf@data$POP2005 == 0)] = NA
world_spdf@data$POP2005 <- as.numeric(as.character(world_spdf@data$POP2005)) / 1000000 %>% round(2)
library(RColorBrewer)
mybins <- c(0,10,20,50,100,500,Inf)
mypalette <- colorBin( palette="YlOrBr", domain=world_spdf@data$POP2005, na.color="transparent", bins=mybins)

# Prepare the text for tooltips:
mytext <- paste(
  "Country: ", world_spdf@data$NAME,"<br/>", 
  "Area: ", world_spdf@data$AREA, "<br/>", 
  "Population: ", round(world_spdf@data$POP2005, 2), 
  sep="") %>%
  lapply(htmltools::HTML)



ui <- fluidPage(
  h2("Map"),
  leafletOutput("map")
  
)

server <- function(input, output) {
  
  observeEvent(input$map_shape_click, { # update the location selectInput on map clicks
    p <- input$map_shape_click
    country <- maps::map.where(database = "world", p$lng, p$lat)
    print(country)
  })
  
  output$map <- renderLeaflet({
    
    leaflet(world_spdf) %>% 
      addTiles()  %>% 
      setView( lat=10, lng=0 , zoom=2) %>%
      addPolygons( 
        fillColor = ~mypalette(POP2005), 
        #fillColor = "red",
        color = "black",
        stroke=TRUE, 
        fillOpacity = 0.9, 
        #color="white", 
        weight=0.3,
        label = mytext,
        labelOptions = labelOptions( 
          style = list("font-weight" = "normal", padding = "3px 8px"), 
          textsize = "13px", 
          direction = "auto"
        )
      ) %>%
      addLegend( pal=mypalette, values=~POP2005, opacity=0.9, title = "Population (M)", position = "bottomleft" )
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)