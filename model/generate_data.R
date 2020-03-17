GenerateCountryEvolutionData <- function(cvirus_longer) {
     res <- cvirus_longer %>% 
       # filter(provincia_estado!= 'Diamond Princess') %>% 
       group_by(pais, fecha) %>% 
       arrange(fecha) %>%
       arrange(-casos) %>% 
       summarise(casos = sum(casos),
                 Lat = first(Lat),
                 Long = first(Long)) %>% 
       mutate(casos_prev_day = lag(casos, n = 1,  default = 0),
              casos_nuevos = casos - casos_prev_day) %>% 
       filter(casos >= 5) %>%
       mutate(
         casos_nuevos = if_else(casos_nuevos==0,
                                lag(casos_nuevos,1),
                                casos_nuevos),
         dia_since_5 = row_number()) 

     return(res)
   }

GenerateSummaryCountriesPlot <- function(data.df, limit.c, scale.c, chart.c = 1) {
   
   if (limit.c != 0) {
      max.c <- max(data.df$fecha)
      aux.df <- data.df[data.df$fecha == max.c, ]
      aux.df <- aux.df[order(aux.df$casos, decreasing = TRUE), ]
      aux.df <- aux.df[1:limit.c, ]   
      data.df <- data.df[data.df$pais %in% aux.df$pais, ]
   }
   
   if (chart.c == 1) {
      fig <- plot_ly(data.df, x = ~dia_since_5, y = ~casos, name = ~pais, type = 'scatter', mode = 'lines', color = ~pais)
   } else {
      fig <- plot_ly(data.df, x = ~dia_since_5, y = ~casos_nuevos, name = ~pais, type = 'scatter', mode = 'lines', color = ~pais)
   }
   
   f <- list(
      family = 'Courier New, monospace',
      size = 18,
      color = '#7f7f7f'
   )
   
   x <- list(
      title = 'Día desde alcanzar 5 casos',
      titlefont = f
   )
   
   y <- list(
      title = ifelse(chart.c == 1, 'Número de casos', 'Número de casos nuevos'),
      titlefont = f, 
      type = scale.c
   )
   
   fig <- fig %>% layout(xaxis = x, yaxis = y)
   fig
}
