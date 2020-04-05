# tags$style('.input-sm {font-size: 40px; } label {font-weight: 500; margin-bottom: 15px; }'),
# In global.R we load libraries and code source for ui.r and server.R
library(shinydashboard)
require(highcharter)
library(leaflet)
library(leafpop)


ancho_titulo_side = 200
logo_coronavius <- "buscar logo" 
# header
header <- dashboardHeader( title = "Corona virus \n dashboard",
                           titleWidth = ancho_titulo_side
                           )

# sidebar
sidebar <- dashboardSidebar(
    width = ancho_titulo_side,
    sidebarMenu(id = "sidebarmenu",
                style = "position: fixed; overflow: visible;",
                
                menuItem("Mapa Global",
                         tabName = "Mapa_global", icon = icon("globe")),
                menuItem("Evolutivo",
                         tabName = "Tabla_evolutivo", icon = icon("calendar")),
                
                menuItem("Mapa España",
                         tabName = "Mapa_ccaa", icon = icon("globe")),
                menuItem("Evolutivo CCAA",
                         tabName = "Tabla_evolutivo_ccaa", icon = icon("calendar")),
            

                
                
                menuItem("Indicadores (por definir)",
                         tabName = "indicadores_estrategicos",
                         icon = icon("handshake-o"),
                         menuSubItem("Ind1", icon = icon("list-alt"),
                                     tabName = "compare_countries"),
                         menuSubItem("Ind2", icon = icon("calendar"),
                                     tabName = "pdte")

                ),
                br(),
                br(),
                p("  Datos España: "),
                p(tags$a(href="https://github.com/datadista/datasets/tree/master/COVID%2019", " Datadista")),
                br(),
                
                p("  Datos Globales: "),
    p(tags$a(href="https://github.com/CSSEGISandData/COVID-19", " CSSE at Johns Hopkins University"))
                
    )
)


body <- dashboardBody(
    # tags$script(inactivity),
    # tags$head(
    #     tags$link(rel = "stylesheet", type = "text/css", href = "custom.css"),
    #     tags$style(HTML("
    #   .shiny-output-error-validation {
    #                     font-size: 150%;
    #                     color: #0072B7;
    #                     }
    #                     "))
    # ),
    tabItems(
        tab_mapa_ccaa,
        tab_mapa,
        tab_evolutivo,
        tab_evolutivo_ccaa 
        # tabitem3
    )
)


# DashboardPage, all together
dashboardPage(title="Corona Virus Tracker",
              header,
              sidebar,
              body,
              skin = "purple"
)