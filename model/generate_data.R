GenerateCountryEvolutionData <- function(cvirus_longer) {
     res <- cvirus_longer %>% 
       # filter(provincia_estado!= "Diamond Princess") %>% 
       group_by(pais, fecha) %>% 
       arrange(fecha) %>%
       arrange(-casos) %>% 
       summarise(casos = sum(casos),
                 Lat = first(Lat),
                 Long = first(Long)) %>% 
       mutate(casos_prev_day = lag(casos, n = 1,  default = 0),
              casos_nuevos = casos - casos_prev_day) %>% 
       filter(casos >= 5) %>%
       mutate(
         casos_nuevos = if_else(casos_nuevos==0,
                                lag(casos_nuevos,1),
                                casos_nuevos),
         dia_since_5 = row_number()) 
     
     return(res)
   }
