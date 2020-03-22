# Vista estratégicos
library(shinydashboard)

tab_mapa_ccaa <- tabItem(
  tabName = "Mapa_ccaa",
  # h1("Mapa a día"), 
  h2(textOutput("max_fecha_ccaa")),
  br(),
  fluidRow(
    leafletOutput("mapa_ccaa",  width="100%",height="600px")
  )
)
