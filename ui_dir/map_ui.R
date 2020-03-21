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
  fluidRow(
    leafletOutput("mapa_global", width="100%",height="600px")
  )
)
