library(shinydashboard)


output$mapa_ccaa <- renderLeaflet({
    mapa_ccaa_leaflet
})

output$max_fecha_ccaa <-  renderText({
    fecha_max <- ccaa_longer %>%
        summarise(fecha = max(fecha)) %>%
        pull(fecha)
    as.character(fecha_max)
})
