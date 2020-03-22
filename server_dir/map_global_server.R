
output$mapa_global <- renderLeaflet(mapa_global_leaf)

output$max_fecha <-  renderText({
    fecha_max <- cvirus_longer %>%
        summarise(fecha = max(fecha)) %>%
        pull(fecha)
    as.character(fecha_max)
})
