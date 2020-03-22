library(shinydashboard)
library(plotly)
library(highcharter)

reactive_ccaas_selected <- reactive({
  
  tmp <- ccaa_data_subplots %>%
    filter(CCAA != "Total" & casos >= input$contagiado_n) %>%
    mutate(dias = row_number()) %>% 
    select_at(c("CCAA","fecha", input$ccaa_indicador1, "pob2019", "dias")) %>% 
    filter(CCAA %in% input$ccaa_selected)
    
    colnames(tmp)[4] <-  "variable"
  return(tmp)
  
})




output$tabla_evolutivo_ccaa <- renderHighchart({
  
  validate(
    need(nrow(reactive_ccaas_selected()) != 0, "Selecciona al menos una CCAA")
  ) 
  tmp <- reactive_ccaas_selected()
  chart <- tmp %>% 
    mutate(indicador_100k =  round(1e5*variable / pob2019,2)) %>% 
    hchart("spline", hcaes(x = dias, y = indicador_100k, group = CCAA)) %>% 
    hc_xAxis( title = list( text = paste0("Dias desde que se confirmaron ", input$contagiado_n, " casos")),
              labels = list(style=list(fonSize = "16px")) ) %>%
    hc_yAxis( title = list( text = paste0(input$ccaa_indicador1, " x 100 mil hab")), labels = list(style=list(fonSize = "16px")) ) %>%
    hc_legend(enabled = FALSE) %>%
    
    # hc_add_theme(hc_theme_smpl()) %>%
    hc_title(text = paste0(input$ccaa_indicador1, " por 100 mil habitantes")) %>%
    # hc_plotOptions(series = list(dataLabels = list(enabled = TRUE))) %>%
    hc_tooltip(enabled = TRUE)
  
  
  
  chart
  
})


