# Vista estratégicos
library(shinydashboard)

tab_mapa_ccaa <- tabItem(
  tabName = "Mapa_ccaa",
  h2("Tarda unos segundos en cargar datos y mapa. Paciencia"),
  h2("Fecha actualización datos: ") , h2(textOutput("max_fecha_ccaa")),
  fluidRow(
    valueBoxOutput("sp_contagiados"),
    valueBoxOutput("sp_recuperados"),
    valueBoxOutput("sp_fallecidos"),
    valueBoxOutput("sp_activos")
  ),
  br(),
  fluidRow(
    
    
    column(3,
           wellPanel(
             selectInput('var_ccaa', 'Elige variables', choices = var_ccaa_list_mapa,
                         selected = var_ccaa_list_mapa[1], width = 280)

           )       
    ),
    
    column(9,
           leafletOutput("mapa_ccaa_base",  width="100%",height="600px")

    )
  )
  # fluidRow(
  #   leafletOutput("mapa_ccaa",  width="100%",height="600px")
  # )
)
