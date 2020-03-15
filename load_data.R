## Leer datos de los repositoros

# Librerías ----
library(tidyverse)
library(leaflet)
library(shinydashboard)

source('model/generate_data.R')

# nos bajamos  los datos, actualizados a día de ayer ----

url <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Confirmed.csv"

cvirus <-  read_csv(url)

# cvirus$`Province/State`<- NULL


# Pasamos a formato largo ----

cvirus_longer <- cvirus %>%
    pivot_longer(
        cols = 5:ncol(cvirus),
        values_to = "casos"
    )

colnames(cvirus_longer) <- c("provincia_estado","pais", "Lat", "Long", "fecha", "casos")

cvirus_longer$fecha <- as.Date(as.character(cvirus_longer$fecha), format = "%m/%d/%y")

cvirus_longer <-  cvirus_longer %>% 
    mutate(provincia_estado = if_else(is.na(provincia_estado), pais, provincia_estado)) %>% 
    filter(casos>0)

# mapa con el último dato -----

# mapa con el último dato -----
## sub graphs 

res <- GenerateCountryEvolutionData(cvirus_longer)


cvirus_map_data <- res %>% 
    group_by(pais) %>% 
    filter(fecha == max(fecha)) %>% 
    mutate(casos = sum(casos)) %>% 
    ungroup()


p_subs <- map(cvirus_map_data$pais, function(pais_select) {
    df <- res %>% 
        filter(pais== pais_select)
    p <- df %>%
        ggplot( aes(x = dia_since_5, y = casos_nuevos, group = 1))
    p +  
        geom_point(size = rel(1.5)) + 
        geom_line() +
        # geom_smooth() + 
        # scale_y_continuous(limits = c(0,max(res$casos_nuevos)+100))+
        ggtitle("Coronavirus: new daily cases") +
        theme_bw() +
        labs(title = paste0("Coronavirus: new daily cases in ", pais_select ))
})

names(p_subs) <- cvirus_map_data$pais

# p_subs <- p_subs[1:13]

pal <- colorNumeric(
    palette = "Reds",
    domain = c(-1, log(max(cvirus_map_data$casos + 1)))
)
#
#
mapa <- 
    leaflet(cvirus_map_data) %>%
    # addProviderTiles('CartoDB.Positron') %>%
    addProviderTiles("Stamen.Toner") %>%
    addCircleMarkers(
        group =  "pais",
        lng = ~ Long,
        lat = ~ Lat,
        label = ~ paste0(pais, ": ", casos ),
        radius = ~ 3 * log( casos + 1 ) ,
        color = ~ pal(log( casos + 1 ) )
    ) %>% 
    addPopupGraphs(p_subs , group = "pais")
