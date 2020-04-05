# Vista estratégicos
library(shinydashboard)
require(highcharter)

tab_evolutivo_ccaa <- tabItem(
  tabName = "Tabla_evolutivo_ccaa",
  # h1('Evolutivo desde caso 5'),
  # h2(textOutput('tabla_evolutivo')),
  br(),
  fluidRow(
    column(
      4,
      wellPanel(
        selectInput(
          "ccaa_selected",
          "Selecciona Comunidad autónoma",
          choices = ccaas_choice,
          selected = "Total",
          multiple = TRUE,
          selectize = TRUE
        ),
        selectInput(
          "ccaa_indicador1",
          "Selecciona variable",
          choices = var_ccaa_list,
          selected = var_ccaa_list[4],
          multiple = FALSE,
          selectize = TRUE
        ),
        selectInput(
          "y_scale_ccaa",
          "Selecciona scala",
          choices = c("Lineal", "Log"),
          selected = "Lineal",
          multiple = FALSE,
          selectize = TRUE
        ),

        sliderInput(
          "contagiado_n",
          "Minimo contagiados confirmados",
          min = 1,
          max = 100,
          value = 20,
          step = 1
        ),
                sliderInput(
          "dias_back",
          "Dias atrás para comparar incremento",
          min = 1,
          max = 14,
          value = 2,
          step = 1
        ),
        
      )
    ),

    column(
      6,
      tabsetPanel(
        type = "tabs",
        tabPanel("Indicadores", highchartOutput("tabla_evolutivo_ccaa_raw")),
        tabPanel("Indicadores x 100 mil habitante", highchartOutput("tabla_evolutivo_ccaa"))
      ),
     
      tabsetPanel(
        tabPanel("Incrementos relativos", highchartOutput("tabla_evolutivo_ccaa_inc_relativo")),
        p(" Ejemplo: Eligiendo como indicador el número de fallecidos, y 7 días atrás nos muestra
          el incremento relativo. Si es 1 significa que 7 días sería el tiempo de duplicación del número de fallecidos. El objetivo final sería llegar a valor -1 que implicaría que en ese período (7 días ) no se ha producido  ningún fallecido más ")
      )
    )
  )
)
