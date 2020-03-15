

load_pkg <- rlang::quos(shiny,tidyverse, shinydashboard, ggplot2, lubridate, grid, sp,leafpop,leaflet, RColorBrewer, plotly)

invisible(lapply(lapply(load_pkg, rlang::quo_name),
                 library,
                 character.only = TRUE
))


Sys.setlocale(locale = "es_US.UTF-8")
# load data
source("load_data.R")

# Cargar ficheros que haya en el directorio ui_dir----

dir_files_ui <- paste0(getwd(), "/ui_dir")
ficheros_ui <- dir(dir_files_ui, full.names = T )

lapply(ficheros_ui, function(x)
    source(x))
