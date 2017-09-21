fetch.precip_data <- function(viz){
  
  precip.data <- mtcars
  
  saveRDS(precip.data, viz[['location']])
  
}

fetchTimestamp.precip_data <- vizlab:::fetchTimestamp.file
