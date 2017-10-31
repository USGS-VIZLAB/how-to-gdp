fetch.geom_shp <- function(viz){
  library(sf)
  
  deps <- readDepends(viz)
  crs <- deps[["crs"]][["crs_str"]]
  
  sf_poly <- sf::st_read(viz[["filepath"]])
  sf_poly <- sf::st_union(sf_poly) # merge hucs into one large polygon
  sp_poly <- as(sf_poly, "Spatial")
  sp_poly_transf <- sp::spTransform(sp_poly, CRSobj = crs)
  
  saveRDS(sp_poly_transf, viz[['location']])
}

fetchTimestamp.geom_shp <- vizlab:::fetchTimestamp.file
