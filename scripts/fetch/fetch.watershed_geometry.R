fetch.watershed_geometry <- function(viz){
  deps <- readDepends(viz)
  region <- viz[['region']]
  
  saveRDS(region, viz[['location']])
  
}

fetchTimestamp.watershed_geometry <- vizlab:::fetchTimestamp.file
