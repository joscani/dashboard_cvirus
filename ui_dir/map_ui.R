# Vista estratégicos
library(shinydashboard)

  
  tab_mapa <- tabItem(
    tabName = "Mapa_global",
    # h1("Mapa a día"), 
    h2("Fecha actualización datos: ") , h2(textOutput("max_fecha")),
    fluidRow(
      valueBoxOutput("contagiados"),
      valueBoxOutput("recuperados")
    ),
    br(),
    h5("Radio círculos =  3 * log( fallecidos + 1 )"),
    fluidRow(
      leafletOutput("mapa_global", width="100%",height="600px")
    )
  )
  
  # h2("Fecha actualización datos: ") , h2(textOutput("max_fecha")),
  # fluidRow(
  #   valueBoxOutput("contagiados"),
  #   valueBoxOutput("recuperados")
  # ),
  # br(),
  # # h5("Radio círculos =  3 * log( fallecidos + 1 )"),
  # fluidRow(
  #   leafletOutput("mapa_global", width="100%",height="600px")
  # )

