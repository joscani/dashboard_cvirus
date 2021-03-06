## Leer datos de los repositoros

# Librerías ----
# library(tidyverse)
# library(leaflet)
# library(shinydashboard)
# library(htmltools)
# library(leafpop)

source(paste0(getwd(), "/model/generate_data.R"))
# source(paste0(getwd(), "/model/generate_ccaa_data.R"))

## John Hopkins data ----

cvirus_confirmed <-  read_csv("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv")

cvirus_recovered <- read_csv("https://github.com/CSSEGISandData/COVID-19/raw/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_recovered_global.csv")

cvirus_death <- read_csv("https://github.com/CSSEGISandData/COVID-19/raw/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv")

# Pasamos a formato largo 

cvirus_confirmed_longer <- cvirus_confirmed %>%
    pivot_longer(
        cols = 5:ncol(cvirus_confirmed),
        values_to = "casos"
    )
cvirus_confirmed_longer$name <- mdy(cvirus_confirmed_longer$name)


cvirus_recovered_longer <-  cvirus_recovered %>% 
    pivot_longer(
        cols = 5:ncol(cvirus_recovered),
        values_to = "recuperados"
    )
cvirus_recovered_longer$name <- mdy(cvirus_recovered_longer$name)


cvirus_death_longer <-  cvirus_death %>% 
    pivot_longer(
        cols = 5:ncol(cvirus_death),
        values_to = "fallecidos"
    )

cvirus_death_longer$name <- mdy(cvirus_death_longer$name)


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

# cvirus_longer$fecha <- as.Date(as.character(cvirus_longer$fecha), format = "%m/%d/%y")

cvirus_longer <-  cvirus_longer %>% 
    mutate(provincia_estado = if_else(is.na(provincia_estado), pais, provincia_estado)) %>% 
    filter(casos>0)


## Mapa global con el último dato ----

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
        recuperados_i_relativo_x100 = round(100 * recuperados_nuevos/recuperados_prev_day,1),
        casos_i_relativo_x100 = round(100 * casos_nuevos/casos_prev_day,1),
        recuperados_i_relativo_x100 = round(100 * recuperados_nuevos/recuperados_prev_day,1),
        fallecidos_i_relativo_x100 = round(100 * fallecidos_nuevos/fallecidos_prev_day,1)
    ) %>%
    filter(casos >= 100) %>%
    mutate(
        casos_nuevos = if_else(casos_nuevos == 0,
                               lag(casos_nuevos, 1),
                               casos_nuevos),
        
        recuperados = if_else(is.na(recuperados),
                               recuperados_prev_day,
                               recuperados),
        
        recuperados_nuevos = if_else(is.na(recuperados_nuevos),
                               lag(recuperados_nuevos, 1),
                               recuperados_nuevos),
        
        
        dia_since_100 = row_number()
    )


cvirus_map_data <- res %>% 
    group_by(pais) %>% 
    filter(fecha == max(fecha)) %>% 
    mutate(casos = sum(casos),
           recuperados = sum(recuperados, na.rm = TRUE),
           fallecidos = sum(fallecidos, na.rm = TRUE)) %>% 
    ungroup()


## TODO try to change to highcharter and conver to interactive shiny

# 
# p_subs_fallecidos <- map(cvirus_map_data$pais, function(pais_select) {
#     df <- res %>% 
#         filter(pais== pais_select)
#     p_glob <- df %>%
#         ggplot( aes(x = dia_since_100, y = fallecidos_nuevos, group = 1))
#     p_glob <- p_glob  +  
#         geom_point(size = rel(1.5)) + 
#         geom_line() +
#         # geom_smooth() + 
#         # scale_y_continuous(limits = c(0,max(res$casos_nuevos)+100))+
#         theme_bw() +
#         labs(title = "Coronavirus: Nuevos fallecidos por día ",
#              subtitle = pais_select, x = "Días desde el caso 100")
#     return(p_glob)
# })
# 
# names(p_subs_fallecidos) <- cvirus_map_data$pais
# 
# p_subs_casos <- map(cvirus_map_data$pais, function(pais_select) {
#     df_casos <- res %>% 
#         filter(pais== pais_select)
#     p_casos <- df_casos %>%
#         ggplot( aes(x = dia_since_100, y = casos_nuevos, group = 1))
#     p_casos <- p_casos  +  
#         geom_point(size = rel(1.5)) + 
#         geom_line() +
#         # geom_smooth() + 
#         # scale_y_continuous(limits = c(0,max(res$casos_nuevos)+100))+
#         theme_bw() +
#         labs(title = "Coronavirus: Nuevos casos por día ",
#              subtitle = pais_select, x = "Días desde el caso 100")
#     return(p_casos)
# })
# 
# names(p_subs_casos) <- paste0("casos_",cvirus_map_data$pais)

# p_subs <- p_subs[1:13]

cvirus_map_data$labs <- map_chr(seq(nrow(cvirus_map_data)), function(i) {
    paste0( '<p>', cvirus_map_data[i, "pais"], '<p></p>', 
            "Casos: ",cvirus_map_data[i, "casos"], '<p></p>', 
            "Recuperados: ",cvirus_map_data[i, "recuperados"],'</p><p>', 
            "Fallecidos: ",cvirus_map_data[i, "fallecidos"], '</p><p>', 
            "Fallecidos, inc relativo : ",cvirus_map_data[i, "fallecidos_i_relativo_x100"], '%</p><p>',
            "Recuperados, inc relativo : ",cvirus_map_data[i, "recuperados_i_relativo_x100"], '%</p>'
            
    ) 
})

paleta <- scales::brewer_pal(type = "div", palette = "PiYG", direction = -1)
color_rampa <-  colorRamp(paleta(11))
pal <- colorNumeric(
    palette = color_rampa,
    domain = c(-1, log(1e8))
)



# altura <- scales::rescale(3 * log( cvirus_map_data$fallecidos + 1 ) , to=c(10,100))
# anchura <-  scales::rescale(3 * log( cvirus_map_data$fallecidos + 1 ) , to=c(5,80))
# greenLeafIcon <- makeIcon(
#     iconUrl = "data/statistics.png",
#     iconWidth = anchura, iconHeight = altura,
#     iconAnchorX = 0, iconAnchorY = 0
# )
# 
# leaflet(data = cvirus_map_data) %>% 
#     addProviderTiles("Stamen.Toner") %>%
#     addMarkers(lng = ~Long,
#                lat = ~Lat,
#                icon = greenLeafIcon)


mapa_global_leaf <- leaflet(cvirus_map_data) %>%
    # addProviderTiles('CartoDB.Positron') %>%
    addProviderTiles("Stamen.Toner") %>%
    addCircleMarkers(
        group =  "Casos",
        lng = ~ Long,
        lat = ~ Lat,
        label = lapply(cvirus_map_data$labs, htmltools::HTML),
        radius = ~ 3 * log( casos + 1 ) ,
        color = ~ pal(log( casos + 1 ) )
    ) %>% 
        addCircleMarkers(
        group =  "Casos nuevos hoy",
        lng = ~ Long,
        lat = ~ Lat,
        label = lapply(cvirus_map_data$labs, htmltools::HTML),
        radius = ~ 3 * log( casos_nuevos + 1 ) ,
        color = ~ pal(log( casos_nuevos + 1 ) )
    ) %>% 
    
    addCircleMarkers(
        group =  "Fallecidos",
        # layerId = "capa1",
        lng = ~ Long,
        lat = ~ Lat,
        label = lapply(cvirus_map_data$labs, htmltools::HTML),
        radius = ~ 3 * log( fallecidos + 1 ) ,
        color = ~ pal(log( fallecidos + 1 ) )
    ) %>% 
        
    addCircleMarkers(
        group =  "Fallecidos nuevos hoy",
        # layerId = "capa1",
        lng = ~ Long,
        lat = ~ Lat,
        label = lapply(cvirus_map_data$labs, htmltools::HTML),
        radius = ~ 3 * log( fallecidos_nuevos + 1 ) ,
        color = ~ pal(log( fallecidos_nuevos + 1 ) )
    ) %>% 
    
    addCircleMarkers(
        group =  "Recuperados",
        # layerId = "capa1",
        lng = ~ Long,
        lat = ~ Lat,
        label = lapply(cvirus_map_data$labs, htmltools::HTML),
        radius = ~ 3 * log( recuperados + 1 ) ,
        color = ~ pal(log( recuperados + 1 ) )
    ) %>% 
    addCircleMarkers(
        group =  "Recuperados nuevos hoy",
        # layerId = "capa1",
        lng = ~ Long,
        lat = ~ Lat,
        label = lapply(cvirus_map_data$labs, htmltools::HTML),
        radius = ~ 3 * log( recuperados_nuevos + 1 ) ,
        color = ~ pal(log( recuperados_nuevos + 1 ) )
    ) %>% 
    
    
    # Layers control
    addLayersControl(
        baseGroups = c("Casos", "Casos nuevos hoy", "Fallecidos","Fallecidos nuevos hoy",
                       "Recuperados","Recuperados nuevos hoy"),
        # overlayGroups = c("Quakes", "Outline"),
        options = layersControlOptions(collapsed = FALSE)
    )
    




## Load  ccaa data from datadista github ----


# ccaa_casos <- read_csv("https://raw.githubusercontent.com/datadista/datasets/master/COVID%2019/ccaa_covid19_casos_long.csv")

# ccaa_altas <- read_csv("https://raw.githubusercontent.com/datadista/datasets/master/COVID%2019/ccaa_covid19_altas_long.csv")

# ccaa_fallecidos <- read_csv("https://raw.githubusercontent.com/datadista/datasets/master/COVID%2019/ccaa_covid19_fallecidos.csv")

# ccaa_uci <- read_csv("https://raw.githubusercontent.com/datadista/datasets/master/COVID%2019/ccaa_covid19_uci.csv")

iscii <-  read_csv("https://github.com/datadista/datasets/raw/master/COVID%2019/ccaa_covid19_datos_isciii_nueva_serie.csv")  %>% 
    rename("CCAA"="ccaa")

ccaa_fallecidos_longer <-  read_csv("https://github.com/datadista/datasets/raw/master/COVID%2019/ccaa_covid19_fallecidos_por_fecha_defuncion_nueva_serie_long.csv") %>% 
    rename("fallecidos"= "Fallecidos",
           "fecha" = "Fecha",
           "cod_ine" = "cod_ccaa")

ccaa_casos_longer <-  iscii %>% 
    select(cod_ine, CCAA, fecha, num_casos) %>% 
    rename(casos = num_casos)

# ccaa_altas_longer <-  ccaa_altas %>% 
#     pivot_longer(
#         cols = 3:ncol(ccaa_altas),
#         values_to = "altas"
#     ) %>% 
#     rename("fecha" = "name")

# ccaa_fallecidos_longer <-  ccaa_fallecidos %>% 
#     pivot_longer(
#         cols = 3:ncol(ccaa_fallecidos),
#         values_to = "fallecidos"
#     ) %>% 
#     rename("fecha" = "name")

# ccaa_uci_longer <-  ccaa_uci %>% 
#     pivot_longer(
#         cols = 3:ncol(ccaa_uci),
#         values_to = "ingresos_uci"
#     ) %>% 
#     rename("fecha" = "name")


ccaa_longer <- ccaa_casos_longer %>% 
    # left_join(ccaa_altas_longer %>% 
    #               select(-CCAA),
    #           by = c("cod_ine", "fecha")) %>% 
    left_join(ccaa_fallecidos_longer %>% 
                  select(-CCAA),
              by = c("cod_ine", "fecha")) # %>% 
    # left_join(ccaa_uci_longer %>% 
    #               select(-CCAA),
    #           by = c("cod_ine", "fecha"))
ccaa_longer$fecha <- lubridate::ymd(ccaa_longer$fecha)

pob_ccaa <- readRDS("data/pob_ccaa.rds")

ccaa_longer <- ccaa_longer %>% 
    left_join(pob_ccaa, by = c("cod_ine" = "Codigo")) %>% 
    group_by(CCAA) %>% 
    arrange(fecha) %>% 
    mutate(
        casos = cumsum(coalesce(casos,0)),
        fallecidos = cumsum(coalesce(fallecidos, 0))
           ) %>% 
    ungroup()

## Mapa ccaa ----

mapa_ccaa <- readRDS("data/mapa_ccaa.rds")


ccaa_data_subplots <-  ccaa_longer %>% 
    group_by(cod_ine, CCAA, fecha) %>% 
    arrange(fecha) %>% 
    summarise(
        casos = sum(casos),
        # recuperados = sum(altas),
        fallecidos = sum(fallecidos),
        # ingresos_uci = sum(ingresos_uci),
        pob2019 = first(pob2019)
    ) %>% 
    mutate(
        casos_prev_day = lag(casos, n = 1,  default = 0),
        casos_nuevos = casos - casos_prev_day,
        # recuperados_prev_day = lag(recuperados, n = 1, default = 0),
        # recuperados_nuevos = recuperados - recuperados_prev_day,
        fallecidos_prev_day = lag(fallecidos, n = 1, default = 0),
        fallecidos_nuevos = fallecidos - fallecidos_prev_day,
        # ingresos_uci_prev_day = lag(ingresos_uci, n = 1, default = 0),
        # ingresos_uci_nuevos = ingresos_uci - ingresos_uci_prev_day
    ) %>% 
    filter(casos >= 1) %>%
    mutate(
        casos_nuevos = if_else(casos_nuevos == 0,
                               lag(casos_nuevos, 1),
                               casos_nuevos),
        dia_since_1 = row_number()
    )

ccaa_data_subplots$pob2019[ccaa_data_subplots$CCAA == "Total"] <-
    sum( unique( ccaa_data_subplots$pob2019[ ccaa_data_subplots$CCAA != "Total"] ),
        na.rm = TRUE)

ccaas_choice <- unique(ccaa_data_subplots$CCAA)
var_ccaa_list <- c("casos",
                   # "recuperados",
                   # "ingresos_uci",
                   "fallecidos",
                   "casos_nuevos",
                   # "recuperados_nuevos",
                   "fallecidos_nuevos"
                   # ,
                   # "ingresos_uci_nuevos"
                   )

var_ccaa_list_mapa <- c("casos_por_100_mil_habitantes",
                        # "recuperados_por_100_mil_habitantes",
                        "fallecidos_por_100_mil_habitantes")


   
ccaa_map_data <- ccaa_data_subplots %>% 
    filter(CCAA != "Total" & fecha == max(fecha)) %>% 
    mutate (
        casos_por_100_mil_habitantes = 1e5 * casos / pob2019,
        # recuperados_por_100_mil_habitantes = 1e5 * recuperados / pob2019,
        fallecidos_por_100_mil_habitantes = 1e5 * fallecidos / pob2019,
        casos_nuevos_por_100_mil_habitantes = 1e5 * casos_nuevos / pob2019,
        # recuperados_diarios_por_100_mil_habitantes = 1e5 * recuperados_nuevos / pob2019,
        fallecidos_diarios_por_100_mil_habitantes = 1e5 * fallecidos_nuevos / pob2019
        
    ) %>% 
    ungroup()




## subplots in two leaflet is problematic

# p_ccaa_subs <- map(ccaa_map_data$CCAA, function(cod_select) {
#     df_spain <- ccaa_data_subplots %>%
#         filter(CCAA == cod_select)
#     p_spain <- df_spain %>%
#         ggplot( aes(x = dia_since_1, y = casos_nuevos, group = 1))
#     p_spain <-  p_spain +
#         geom_point(size = rel(1.5)) +
#         geom_line() +
#         # geom_smooth() +
#         # scale_y_continuous(limits = c(0,max(res$casos_nuevos)+100))+
#         ggtitle("Coronavirus: new daily cases in ") +
#         theme_bw() +
#         labs(title = paste0("Coronavirus: new daily cases in ", cod_select ))
#     return(p_spain)
# })
# 
# names(p_ccaa_subs) <- ccaa_map_data$CCAA

# p_subs <- p_subs[1:13]



ccaa_map_data$labs <- map_chr(seq(nrow(ccaa_map_data)), function(i) {
    paste0( '<p>', ccaa_map_data[i, "CCAA"], '<p></p>', 
            "Casos: ", ccaa_map_data[i, "casos"], '<p></p>', 
            # "Recuperados: ",ccaa_map_data[i, "recuperados"],'</p><p>', 
            "Fallecidos: ",ccaa_map_data[i, "fallecidos"], # '</p><p>'
            # ,"Ingresos UCI: ",ccaa_map_data[i, "ingresos_uci"],
            '</p>') 
})


## TODO . interactive to select input 



mapa_ccaa  <-  mapa_ccaa %>% 
    inner_join(ccaa_map_data, by = c("Codigo" = "cod_ine") )


pal1 <- colorNumeric(
    palette = "Reds",
    domain = mapa_ccaa$casos_por_100_mil_habitantes)

mapa_ccaa_leaflet <-
    leaflet(mapa_ccaa) %>%
    addProviderTiles("Stamen.Toner")  %>%
    addPolygons(
        color = "#444444",
        weight = 1,
        smoothFactor = 0.5,
        # group = "Ingresos UCI",
        opacity = 1.0,
        fillOpacity = 0.5,
        fillColor = ~ pal1(casos_por_100_mil_habitantes),
        label = lapply(mapa_ccaa$labs, htmltools::HTML),
        highlightOptions = highlightOptions(
            color = "white",
            weight = 2,
            bringToFront = TRUE
        )) %>% 
    addLegend(position = "topleft",
                     pal = pal1,
              values = ~casos_por_100_mil_habitantes,
                     title = "casos_por_100_mil_habitantes")
