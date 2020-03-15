library(shinydashboard)


output$mapa_global <- renderLeaflet({
mapa
})

output$max_fecha <-  renderText({
    fecha_max <- cvirus_longer %>%
        summarise(fecha = max(fecha)) %>% 
        pull(fecha)
    as.character(fecha_max)
    }
)
