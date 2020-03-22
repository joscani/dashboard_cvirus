

output$contagiados <- renderValueBox({
    casos_total <- cvirus_map_data %>%
        filter(fecha == max(fecha)) %>%
        summarise(casos_total = sum(casos)) %>%
        pull(casos_total)
    
    valueBox(casos_total, subtitle = "Contagiados", color = "black")
})


output$recuperados <- renderValueBox({
    recuperados_total <- cvirus_map_data %>%
        filter(fecha == max(fecha)) %>%
        summarise(recuperados_total = sum(recuperados)) %>%
        pull(recuperados_total)
    
    valueBox(recuperados_total, subtitle = "Recuperados", color = "green")
})

output$fallecidos <- renderValueBox({
    fallecidos_total <- cvirus_map_data %>%
        filter(fecha == max(fecha)) %>%
        summarise(fallecidos_total = sum(fallecidos)) %>%
        pull(fallecidos_total)
    
    valueBox(fallecidos_total, subtitle = "Fallecidos", color = "red")
})