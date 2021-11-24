# Trail_shiny

Etude de la base de données TRAIL avec Antoine Petiteau

Le lien vers la base : https://github.com/rfordatascience/tidytuesday/blob/master/data/2021/2021-10-26/readme.md

addPolygons(color = "#444444", weight = 1, smoothFactor = 0.5,
    opacity = 1.0, fillOpacity = 0.5,
    fillColor = ~colorQuantile("YlOrRd", ALAND)(ALAND),
    highlightOptions = highlightOptions(color = "white", weight = 2,
      bringToFront = TRUE))
