process.precip_timestep <- function(viz){
  
  deps <- readDepends(viz)
  precip_data <- deps[['precip_data']]
  timestep <- deps[["timestep"]][["date"]]
  timezone <- deps[["timestep"]][["tz"]]
  
  precip_data_ts <- dplyr::filter(precip_data, DateTime == as.POSIXct(timestep, tz=timezone))
  
  saveRDS(precip_data_ts, viz[['location']])
}
