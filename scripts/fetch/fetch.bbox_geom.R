fetch.bbox_geom <- function(viz){
  
  library(sf) # needed to use `as` to convert
  
  deps <- readDepends(viz)
  crs <- deps[["crs"]][["crs_str"]]
  west <- viz[["west"]]
  east <- viz[["east"]]
  north <- viz[["north"]]
  south <- viz[["south"]]
  
  bbox_coords <- list(rbind(c(west, south), c(west, north), 
                            c(east, north), c(east, south), 
                            c(west, south)))
  
  bbox_sf <- sf::st_sfc(sf::st_polygon(bbox_coords), crs = crs)
  bbox_sp <- as(bbox_sf, "Spatial")
  bbox_sp_transf <- sp::spTransform(bbox_sp, CRSobj = crs)
  
  saveRDS(bbox_sp_transf, viz[["location"]])
}

fetchTimestamp.bbox_geom <- vizlab:::fetchTimestamp.file
