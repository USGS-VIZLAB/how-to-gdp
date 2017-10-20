fetch.shapefile <- function(viz){
  library(sf)
  
  deps <- readDepends(viz)
  shp_filepath <- viz[["filepath"]]
  crs <- viz[["crs"]]
  
  sf_poly <- sf::st_read(shp_filepath)
  sf_poly_transf <- sf::st_transform(sf_poly, crs = crs)
  sp_poly <- as(sf_poly_transf, "Spatial")
  
  saveRDS(sp_poly, viz[['location']])
  
}

fetchTimestamp.shapefile <- vizlab:::fetchTimestamp.file
