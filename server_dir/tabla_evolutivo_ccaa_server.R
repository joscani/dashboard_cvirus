library(shinydashboard)
library(plotly)
require(highcharter)

reactive_ccaas_selected <- reactive({
  
  tmp <- ccaa_data_subplots %>%
    filter( casos >= input$contagiado_n) %>%
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
  
  if(input$y_scale_ccaa == "Log"){
    return(chart %>% 
             hc_yAxis(type = "logarithmic") %>% 
             hc_subtitle(text = "Escala Logaritmica"))
  } else{
    return(chart %>%  hc_subtitle(text = "Escala Lineal"))
  }
  
  
})

output$tabla_evolutivo_ccaa_raw <- renderHighchart({
  
  validate(
    need(nrow(reactive_ccaas_selected()) != 0, "Selecciona al menos una CCAA")
  ) 
  tmp <- reactive_ccaas_selected()
  chart <- tmp %>% 
    mutate(indicador =  variable) %>% 
    hchart("spline", hcaes(x = dias, y = indicador, group = CCAA)) %>% 
    hc_xAxis( title = list( text = paste0("Dias desde que se confirmaron ", input$contagiado_n, " casos")),
              labels = list(style=list(fonSize = "16px")) ) %>%
    hc_yAxis( title = list( text = paste0(input$ccaa_indicador1, " ")), labels = list(style=list(fonSize = "16px")) ) %>%
    hc_legend(enabled = FALSE) %>%
    
    # hc_add_theme(hc_theme_smpl()) %>%
    hc_title(text = paste0(input$ccaa_indicador1)) %>%
    # hc_plotOptions(series = list(dataLabels = list(enabled = TRUE))) %>%
    hc_tooltip(enabled = TRUE)
  
  if(input$y_scale_ccaa == "Log"){
    return(chart %>% 
             hc_yAxis(type = "logarithmic") %>% 
             hc_subtitle(text = "Escala Logaritmica"))
  } else{
    return(chart %>%  hc_subtitle(text = "Escala Lineal"))
  }
  
  
  
})

output$tabla_evolutivo_ccaa_inc_relativo <- renderHighchart({
  
  validate(
    need(nrow(reactive_ccaas_selected()) != 0, "Selecciona al menos una CCAA")
  ) 
  tmp <- reactive_ccaas_selected()
  tmp <- tmp %>% 
    arrange(fecha) %>% 
    mutate(indicador_actual = variable,
           indicador_prev = lag(variable, input$dias_back),
           indicador = (indicador_actual - indicador_prev)/ indicador_prev )
  
  chart <- tmp %>% 
    hchart("spline", hcaes(x = dias, y = indicador, group = CCAA)) %>% 
    hc_xAxis( title = list( text = paste0("Dias desde que se confirmaron ", input$contagiado_n, " casos")),
              labels = list(style=list(fonSize = "16px")) ) %>%
    hc_yAxis( title = list( text = paste0(input$ccaa_indicador1, " Incremento relativo ")), labels = list(style=list(fonSize = "16px")) ) %>%
    hc_legend(enabled = FALSE) %>%
    hc_title(text = paste0("Incremento relativo de ",input$ccaa_indicador1, " respecto a hace ",input$dias_back, " días")) %>%
    hc_tooltip(enabled = TRUE)
  
  if(input$y_scale_ccaa == "Log"){
    return(chart %>% 
             hc_yAxis(type = "logarithmic") %>% 
             hc_subtitle(text = "Escala Logaritmica"))
  } else{
    return(chart %>%  hc_subtitle(text = "Escala Lineal"))
  }
  
  
  
})


