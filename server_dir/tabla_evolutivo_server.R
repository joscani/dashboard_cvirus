library(shinydashboard)
library(plotly)


output$tabla_evolutivo_paises <- renderPlotly({
  data.df <- GenerateCountryEvolutionData(cvirus_longer)
  fig <- GenerateSummaryCountriesPlot(data.df, limit.c = input$limit, scale.c = input$scale, chart.c = 1)
  fig
})


output$tabla_evolutivo_paises_crecimiento <- renderPlotly({
  data.df <- GenerateCountryEvolutionData(cvirus_longer)
  fig <- GenerateSummaryCountriesPlot(data.df, limit.c = input$limit, scale.c = input$scale, chart.c = 2)
  fig
})
