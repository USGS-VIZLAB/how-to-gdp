fetch.geom_shp <- function(viz){
  
  shp_crs <- viz[["shp_crs"]]
  
  deps <- readDepends(viz)
  transform_crs <- deps[["transform_crs"]][["crs_str"]]
  
  # read in the shapefile
  sp_poly <- rgdal::readOGR(dsn = viz[["filepath"]])
  sp_poly@proj4string <- sp::CRS(shp_crs)
  
  # merge multiple polygons into one large polygon
  sp_poly@data <- dplyr::mutate(sp_poly@data, polygon = viz[["id"]])
  sp_poly_dissolve <- maptools::unionSpatialPolygons(sp_poly, IDs = sp_poly@data$polygon)
  
  # reproject the sp object
  sp_poly_transf <- sp::spTransform(sp_poly_dissolve, CRSobj = transform_crs)
  
  saveRDS(sp_poly_transf, viz[['location']])
}

fetchTimestamp.geom_shp <- vizlab:::fetchTimestamp.file
