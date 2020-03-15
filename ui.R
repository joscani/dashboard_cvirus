# tags$style('.input-sm {font-size: 40px; } label {font-weight: 500; margin-bottom: 15px; }'),
# In global.R we load libraries and code source for ui.r and server.R
library(shinydashboard)
# library(highcharter)
library(leaflet)
library(leafpop)


ancho_titulo_side = 200
logo_coronavius <- "https://voluntarios.telefonica.com/sites/default/files/brutus_logo.png"
# header
header <- dashboardHeader( title = "Corona virus \n dashboard",
                           titleWidth = ancho_titulo_side
                           )


# sidebar
sidebar <- dashboardSidebar(
    width = ancho_titulo_side,
    sidebarMenu(id = "sidebarmenu",
                style = "position: fixed; overflow: visible;",
                menuItem("Mapa casos",
                         tabName = "Mapa_global", icon = icon("globe")),
                
                menuItem("Indicadores",
                         tabName = "indicadores_estrategicos",
                         icon = icon("handshake-o"),
                         menuSubItem("Comparación paises", icon = icon("list-alt"),
                                     tabName = "compare_countries"),
                         menuSubItem("Pdte", icon = icon("calendar"),
                                     tabName = "pdte"),
                         menuSubItem("Evolutivo", icon = icon("calendar"),
                                     tabName = "Tabla_evolutivo")
                ),
                br(),
                br()
                
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
        tab_mapa,
        tab_evolutivo
        # tabitem3
    )
)


# DashboardPage, all together
dashboardPage(title="Corona Virus Tracker",
              header,
              sidebar,
              body
)