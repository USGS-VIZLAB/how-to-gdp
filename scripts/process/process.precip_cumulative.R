process.precip_cumulative <- function(viz){
  `%>%` <- magrittr::`%>%`
  
  deps <- readDepends(viz)
  precip_data <- deps[['precip-data']]
  
  precip_data <- dplyr::group_by(precip_data, id) %>% #convert mm to inches
    dplyr::mutate(summ = cumsum(precipVal)) %>% 
    dplyr::select(DateTime, id, precipVal = summ) %>% 
    dplyr::filter(DateTime == max(precip_data$DateTime)) #keep only the final cumulative values
  
  saveRDS(precip_data, viz[['location']])
}
