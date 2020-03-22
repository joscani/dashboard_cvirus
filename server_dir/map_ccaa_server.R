library(shinydashboard)



# paleta reactiva
colorpal <- reactive({
    colorNumeric("Reds", mapa_ccaa[[input$var_ccaa]])
})

# mapa base con
output$mapa_ccaa_base <- renderLeaflet({
    mapa_ccaa_leaflet
})


# Mapa reactiva
observe({
    pal <- colorpal()

   leafletProxy("mapa_ccaa_base", data = mapa_ccaa) %>%
        # clearShapes() %>%
        addPolygons(
            color = "#444444",
            weight = 1,
            smoothFactor = 0.5,
            # group = "Ingresos UCI",
            opacity = 1.0,
            fillOpacity = 0.5,
            fillColor = ~ pal( mapa_ccaa[[input$var_ccaa]]),
            label = lapply(mapa_ccaa$labs, htmltools::HTML),
            highlightOptions = highlightOptions(
                color = "white",
                weight = 2,
                bringToFront = TRUE
            )
        )

})

# Leynda reactivos
observe({
    proxy <-   leafletProxy("mapa_ccaa_base", data = mapa_ccaa)
    
    # Remove any existing legend, and only if the legend is
    # enabled, create a new one.
    proxy %>% clearControls()
        pal <- colorpal()
        proxy %>% addLegend(position = "topleft",
                            pal = pal, values = ~mapa_ccaa[[input$var_ccaa]],
                            title = input$var_ccaa
        )
})

# Fecha máxima
output$max_fecha_ccaa <-  renderText({
    fecha_max <- ccaa_longer %>%
        summarise(fecha = max(fecha)) %>%
        pull(fecha)
    as.character(fecha_max)
})
