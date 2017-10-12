process.precip_cumulative <- function(viz){
  
  deps <- readDepends(viz)
  precip_data <- deps[['precip-data']]
  precip_breaks <- deps[['precip-breaks']]
  
  precip_data <- calc_cumulative_precip(precip_data)
  precip_data <- bin_precip(precip_data, precip_breaks)
  
  saveRDS(precip_data, viz[['location']])
}
