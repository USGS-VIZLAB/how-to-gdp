process.precip_cumulative <- function(viz){
  
  deps <- readDepends(viz)
  precip.data <- deps[['precip-data']]
  
  precip.cumulative <- precip.data
  
  saveRDS(precip.cumulative, viz[['location']])
}
