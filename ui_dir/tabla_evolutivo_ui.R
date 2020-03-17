# Vista estratégicos
library(shinydashboard)

tab_evolutivo <- tabItem(
  tabName = 'Tabla_evolutivo',
  # h1('Evolutivo desde caso 5'), 
  # h2(textOutput('tabla_evolutivo')),
  br(),
  fluidRow(
    
    
    column(4,
           wellPanel(
             selectInput('scale', 'Scale Y-Axis', choices = c('log', 'linear'), selected = 'log', width = 100), 
             selectInput('limit', label = h3('Visualización Top N'), 
                         choices = list('Top 5' = 5, 'Top 10' = 10, 'Todos' = 0), 
                         selected = 1)
           )       
    ),
    
    column(8,
           plotlyOutput('tabla_evolutivo_paises'),
           plotlyOutput('tabla_evolutivo_paises_crecimiento')
    )
  )
)
