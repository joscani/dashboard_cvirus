
## global ----
output$contagiados <- renderValueBox({
    casos_total <- cvirus_map_data %>%
        filter(fecha == max(fecha)) %>%
        summarise(casos_total = sum(casos)) %>%
        pull(casos_total)
    
    valueBox(casos_total, subtitle = "Contagiados", color = "black")
})


output$recuperados <- renderValueBox({
    recuperados_total <- cvirus_map_data %>%
        # filter(fecha == max(fecha)) %>%
        summarise(recuperados_total = sum(recuperados)) %>%
        pull(recuperados_total)
    
    valueBox(recuperados_total, subtitle = "Recuperados", color = "green")
})

output$fallecidos <- renderValueBox({
    fallecidos_total <- cvirus_map_data %>%
        # filter(fecha == max(fecha)) %>%
        summarise(fallecidos_total = sum(fallecidos)) %>%
        pull(fallecidos_total)
    
    valueBox(fallecidos_total, subtitle = "Fallecidos", color = "red")
})

output$activos <- renderValueBox({
    activos_total <- cvirus_map_data %>%
        # filter(fecha == max(fecha)) %>%
        summarise(casos_total = sum(casos),
                  fallecidos_total = sum(fallecidos),
                  recuperados_total = sum(recuperados)) %>%
        mutate(activos_total = casos_total -  fallecidos_total - recuperados_total) %>% 
    pull(activos_total)
    
    valueBox(activos_total, subtitle = "Casos activos ", color = "orange")
})


## Spain -----

output$sp_contagiados <- renderValueBox({
    casos_total <- mapa_ccaa %>%
        filter(fecha == max(fecha)) %>%
        summarise(casos_total = sum(casos)) %>%
        pull(casos_total)
    
    valueBox(casos_total, subtitle = "Contagiados", color = "black")
})


# output$sp_recuperados <- renderValueBox({
#     recuperados_total <- mapa_ccaa %>%
#         # filter(fecha == max(fecha)) %>%
#         summarise(recuperados_total = sum(recuperados)) %>%
#         pull(recuperados_total)
#     
#     valueBox(recuperados_total, subtitle = "Recuperados", color = "green")
# })

output$sp_fallecidos <- renderValueBox({
    fallecidos_total <- mapa_ccaa %>%
        # filter(fecha == max(fecha)) %>%
        summarise(fallecidos_total = sum(fallecidos)) %>%
        pull(fallecidos_total)
    
    valueBox(fallecidos_total, subtitle = "Fallecidos", color = "red")
})

# output$sp_activos <- renderValueBox({
#     activos_total <- mapa_ccaa %>%
#         # filter(fecha == max(fecha)) %>%
#         summarise(casos_total = sum(casos),
#                   fallecidos_total = sum(fallecidos),
#                   recuperados_total = sum(recuperados)) %>%
#         mutate(activos_total = casos_total -  fallecidos_total - recuperados_total) %>% 
#         pull(activos_total)
#     
#     valueBox(activos_total, subtitle = "Casos activos ", color = "orange")
# })


