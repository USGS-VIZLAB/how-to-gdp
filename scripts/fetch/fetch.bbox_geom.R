fetch.bbox_geom <- function(viz){
  
  library(sf) # needed to use `as` to convert
  
  deps <- readDepends(viz)
  crs <- deps[["crs"]][["crs_str"]]
  west <- viz[["west"]]
  east <- viz[["east"]]
  north <- viz[["north"]]
  south <- viz[["south"]]
  
  bbox_coords <- rbind(c(west, south), c(west, north), 
                       c(east, north), c(east, south), 
                       c(west, south))
  
  bbox_poly <- sp::Polygons(list(sp::Polygon(bbox_coords)), "poly1")
  bbox_sp <- sp::SpatialPolygons(list(bbox_poly), proj4string = sp::CRS(crs))
  bbox_sp_transf <- sp::spTransform(bbox_sp, CRSobj = crs)
  
  saveRDS(bbox_sp_transf, viz[["location"]])
}

fetchTimestamp.bbox_geom <- vizlab::alwaysCurrent
