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
          selected = sample(ccaas_choice, 3),
          multiple = TRUE,
          selectize = TRUE
        ),
        selectInput(
          "ccaa_indicador1",
          "Selecciona variable",
          choices = var_ccaa_list,
          selected = var_ccaa_list[3],
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
        )
      )
    ),

    column(
      6,
      tabsetPanel(
        type = "tabs",
        tabPanel("Indicadores", highchartOutput("tabla_evolutivo_ccaa_raw")),
        tabPanel("Indicadores x 100 mil habitante", highchartOutput("tabla_evolutivo_ccaa"))
      )
    )
  )
)

