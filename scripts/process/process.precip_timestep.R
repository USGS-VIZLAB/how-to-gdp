process.precip_timestep <- function(viz){
  
  deps <- readDepends(viz)
  precip_data <- deps[['precip_data']]
  timestep <- deps[["timestep"]][["date"]]
  
  precip_data_ts <- dplyr::filter(precip_data, DateTime == timestep)
  
  saveRDS(precip_data_ts, viz[['location']])
}
