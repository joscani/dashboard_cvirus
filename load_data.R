## Leer datos de los repositoros

# Librerías ----
library(tidyverse)
library(leaflet)
library(shinydashboard)
library(htmltools)


source(paste0(getwd(), "/model/generate_data.R"))


## John Hopkins data ----

cvirus_confirmed <-  read_csv("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Confirmed.csv")

cvirus_recovered <- read_csv("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Recovered.csv")

cvirus_death <- read_csv("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Deaths.csv")

# Pasamos a formato largo 

cvirus_confirmed_longer <- cvirus_confirmed %>%
    pivot_longer(
        cols = 5:ncol(cvirus_confirmed),
        values_to = "casos"
    )

cvirus_recovered_longer <-  cvirus_recovered %>% 
    pivot_longer(
        cols = 5:ncol(cvirus_recovered),
        values_to = "recuperados"
    )

cvirus_death_longer <-  cvirus_death %>% 
    pivot_longer(
        cols = 5:ncol(cvirus_death),
        values_to = "fallecidos"
    )



cvirus_longer <-  cvirus_confirmed_longer %>%
    left_join(
        cvirus_recovered_longer,
        by =  c("Province/State", "Country/Region", "Lat", "Long", "name")
    ) %>% 
    left_join(
        cvirus_death_longer,
        by =  c("Province/State", "Country/Region", "Lat", "Long", "name")
    )



colnames(cvirus_longer) <- c("provincia_estado","pais", "Lat", "Long", "fecha", "casos", "recuperados", "fallecidos")

cvirus_longer$fecha <- as.Date(as.character(cvirus_longer$fecha), format = "%m/%d/%y")

cvirus_longer <-  cvirus_longer %>% 
    mutate(provincia_estado = if_else(is.na(provincia_estado), pais, provincia_estado)) %>% 
    filter(casos>0)


# Mapa con el último dato ----

## TODO Create interaactive with days since filter(casos >= input$ncasos)
res  <- cvirus_longer %>%
    # filter(provincia_estado!= "Diamond Princess") %>%
    group_by(pais, fecha) %>%
    arrange(fecha) %>%
    arrange(-casos) %>%
    summarise(
        casos = sum(casos),
        recuperados = sum(recuperados),
        fallecidos = sum(fallecidos),
        Lat = first(Lat),
        Long = first(Long)
    ) %>%
    mutate(
        casos_prev_day = lag(casos, n = 1,  default = 0),
        casos_nuevos = casos - casos_prev_day,
        recuperados_prev_day = lag(recuperados, n = 1, default = 0),
        recuperados_nuevos = recuperados - recuperados_prev_day,
        fallecidos_prev_day = lag(fallecidos, n = 1, default = 0),
       fallecidos_nuevos = fallecidos - fallecidos_prev_day,
        
    ) %>%
    filter(casos >= 100) %>%
    mutate(
        casos_nuevos = if_else(casos_nuevos == 0,
                               lag(casos_nuevos, 1),
                               casos_nuevos),
        dia_since_100 = row_number()
    )


cvirus_map_data <- res %>% 
    group_by(pais) %>% 
    filter(fecha == max(fecha)) %>% 
    mutate(casos = sum(casos),
           recuperados = sum(recuperados),
           fallecidos = sum(fallecidos)) %>% 
    ungroup()

## TODO try to change to highcharter and conver to interactive shiny


p_subs <- map(cvirus_map_data$pais, function(pais_select) {
    df <- res %>% 
        filter(pais== pais_select)
    p <- df %>%
        ggplot( aes(x = dia_since_100, y = casos_nuevos, group = 1))
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
    domain = c(-1, log(max(cvirus_map_data$fallecidos + 1)))
)

cvirus_map_data$labs <- map_chr(seq(nrow(cvirus_map_data)), function(i) {
    paste0( '<p>', cvirus_map_data[i, "pais"], '<p></p>', 
            "Casos: ",cvirus_map_data[i, "casos"], '<p></p>', 
            "Recuperados: ",cvirus_map_data[i, "recuperados"],'</p><p>', 
            "Fallecidos: ",cvirus_map_data[i, "fallecidos"], '</p>' ) 
})

# cvirus_map_data$labs <- map(seq(nrow(cvirus_map_data)),
#                             function(i){
#                                 HTML(cvirus_map_data[i, "labs"])
#                             })

mapa <- 
    leaflet(cvirus_map_data) %>%
    # addProviderTiles('CartoDB.Positron') %>%
    addProviderTiles("Stamen.Toner") %>%
    addCircleMarkers(
        group =  "pais",
        lng = ~ Long,
        lat = ~ Lat,
        label = lapply(cvirus_map_data$labs, htmltools::HTML),
        radius = ~ 3 * log( fallecidos + 1 ) ,
        color = ~ pal(log( fallecidos + 1 ) )
    ) %>% 
    addPopupGraphs(p_subs , group = "pais")
