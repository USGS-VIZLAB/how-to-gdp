fetch.precip_data <- function(viz){
  
  library(geoknife)
  
  deps <- readDepends(viz)
  sf_poly <- deps[["sf-poly"]]
  
  sp_poly <- sf_to_sp(sf_poly)
  
  stencil <- geoknife::simplegeom(sp_poly)
  precip <- get_gdp_precip(stencil, viz[['start.date']], viz[['end.date']])
  
  saveRDS(precip, viz[['location']])
}

fetchTimestamp.precip_data <- vizlab:::fetchTimestamp.file
