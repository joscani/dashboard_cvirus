# Vista estratégicos
library(shinydashboard)

tab_evolutivo <- tabItem(
  tabName = "Tabla_evolutivo",
  # h1("Evolutivo desde caso 5"), 
  # h2(textOutput("tabla_evolutivo")),
  br(),
  fluidRow(
    plotlyOutput("tabla_evolutivo_paises")
  )
)
