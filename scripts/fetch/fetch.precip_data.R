fetch.precip_data <- function(viz){
  
  library(sf)
  
  deps <- readDepends(viz)
  sf_poly <- deps[["sf-poly"]]
  crs <- viz[["crs"]]
  
  sp_poly <- as(sf_poly, "Spatial")
  sp_poly <- sp::spTransform(sp_poly, sp::CRS(crs))
  
  stencil <- geoknife::simplegeom(sp_poly)
  precip <- get_gdp_precip(stencil, viz[['start.date']], viz[['end.date']])
  
  saveRDS(precip, viz[['location']])
}

fetchTimestamp.precip_data <- vizlab:::fetchTimestamp.file
