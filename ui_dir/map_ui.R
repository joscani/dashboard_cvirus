# Vista estratégicos
library(shinydashboard)

tab_mapa <- tabItem(
  tabName = "Mapa_global",
  # h1("Mapa a día"), 
  h2(textOutput("max_fecha")),
  br(),
  fluidRow(
    leafletOutput("mapa_global", width="100%",height="1000px")
  )
)
