## Dashboard cvirus

Está pensado para ir añadiendo visualizaciones de forma modular.

## Cómo colaborar

### Nuevos datos, otras fuentes

Lectura de nuevas fuentes y cálculos que no dependan de un input que introduzcamos
en shiny, se pueden poner en `load_data.R`

### Añadir visualización. 

Para crear nuevo UI. 

Crear en la carpeta server_dir y ui_dir los correspondientes ficheros con la lógica del ui y del server. Todos los ficheros de la carpeta server_dir se leen con la función que hay en el server.R. Los ficheros que hay n ui_dir así como la lectura de datos los carga el fichero `global.R`

Las diferentes **tabs** de las visualización se van poniendo en el fichero `ui.R` en las secciones correspondientes a `dashboardSidebar` y `dashboardBody`. 

Hay que ser cuidados con los nombres, por ejemplo, en la parte del `dashboardBody` en tabItems pongo objeto `tab_mapa` que se crea en el fichero `map_ui.R` del directorio *ui_dir* , el tabName que pongo en tab_mapa es "Mapa_global" y debe ser el mismo que aparece en el sidebar, para que al pinchar en Mapa casos se vincule. 

```
sidebar <- dashboardSidebar(
    width = ancho_titulo_side,
    sidebarMenu(id = "sidebarmenu",
                style = "position: fixed; overflow: visible;",
                menuItem("Mapa casos",
                         tabName = "Mapa_global", icon = icon("globe")),
``` 

En `ui.R` añadir en la parte de `dashboardSidebar` los diferentes menús y en la parte de `dashboardBody` añadir el tabItems 




