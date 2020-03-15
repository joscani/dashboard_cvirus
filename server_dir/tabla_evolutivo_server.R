library(shinydashboard)
library(plotly)


output$tabla_evolutivo_paises <- renderPlotly({
  data.df <- GenerateCountryEvolutionData(cvirus_longer)
  max.c <- max(data.df$fecha)
  aux.df <- data.df[data.df$fecha == max.c, ]
  aux.df <- aux.df[order(aux.df$casos, decreasing = TRUE), ]
  aux.df <- aux.df[1:10, ]
  data.df <- data.df[data.df$pais %in% aux.df$pais, ]
  #data.df <- data.df[data.df$pais == 'Spain', ]
  fig <- plot_ly(data.df, x = ~dia_since_5, y = ~casos, name = ~pais, type = 'scatter', mode = 'lines', color = ~pais
                 ) 
  
  f <- list(
    family = "Courier New, monospace",
    size = 18,
    color = "#7f7f7f"
  )
  
  x <- list(
    title = "Día desde alcanzar 5 casos",
    titlefont = f
  )
  
  y <- list(
    title = "Número de casos",
    titlefont = f
  )
  
  fig <- fig %>% layout(xaxis = x, yaxis = y)
  fig
})
