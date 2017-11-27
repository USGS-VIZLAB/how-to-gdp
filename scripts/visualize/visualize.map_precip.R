visualize.map_precip <- function(viz){
  
  library(ggplot2)
  
  deps <- readDepends(viz)
  precip_data <- deps[["precip_data"]]
  precip_orig_data <- deps[["precip_orig_data"]]
  geom_sp <- deps[["geom_sp"]]
  geom_sp_orig <- deps[["geom_sp_orig"]]
  min_precip <- deps[["precip_limits"]][["min"]]
  max_precip <- deps[["precip_limits"]][["max"]]
  
  # prep sp data
  geom_sp_df <- ggplot2::fortify(geom_sp)
  geom_sp_df[["precipVal"]] <- precip_data[["precipVal"]]

    geom_polygon(data = geom_sp_df, aes(x = long, y = lat, group = group, fill = precipVal),
                 alpha = 0.8, col = NA) +
    ggplot2::scale_fill_gradientn(colours=blues9, na.value = "transparent",
                                  limits = c(min_precip, max_precip), 
                                  guide = ggplot2::guide_legend(direction = "vertical",
                                                                title = "Precipitation (in)")) +
    ggplot2::scale_alpha(guide = FALSE)  
  
  is_second_geom <- !is.null(geom_sp_orig) & !is.null(precip_orig_data)
  if(is_second_geom){
    geom_sp_orig_df <- ggplot2::fortify(geom_sp_orig) # prep sp data
    
    geom_combined <- maptools::spRbind(geom_sp, geom_sp_orig)
    geom_center <- rgeos::gCentroid(geom_combined)@coords
    geom_bbox <- sp::bbox(geom_combined)
    
  } else {
    geom_center <- rgeos::gCentroid(geom_sp)@coords
    geom_bbox <- sp::bbox(geom_sp)
  }
  
  # create basemap
  basemap_data <- ggmap::get_map(location = c(lon = geom_center[1], lat = geom_center[2]),
                                 color = "bw", maptype = "toner", zoom = 10)
  
  # expand bbox if needed
  basemap_bbox <- attr(basemap_data, "bb")
  bottom <- ifelse(basemap_bbox[["ll.lat"]] > geom_bbox[2, 1], geom_bbox[2, 1], basemap_bbox[["ll.lat"]])
  top <- ifelse(basemap_bbox[["ur.lat"]] < geom_bbox[2, 2], geom_bbox[2, 2], basemap_bbox[["ur.lat"]])
  left <- ifelse(basemap_bbox[["ll.lon"]] > geom_bbox[1, 1], geom_bbox[1, 1], basemap_bbox[["ll.lon"]])
  right <- ifelse(basemap_bbox[["ur.lon"]] < geom_bbox[1, 2], geom_bbox[1, 2], basemap_bbox[["ur.lon"]])
  attr(basemap_data, "bb") <- data.frame(ll.lat = bottom, ll.lon = left, ur.lat = top, ur.lon = right)
  
  # actually plot map
  basemap <- ggmap::ggmap(basemap_data) + 
    theme(axis.title = element_blank(), axis.text = element_blank(), axis.ticks = element_blank()) 
  
  map_geometry <- basemap + 
  
  if(is_second_geom){
    geom_sp_orig_df[["precipVal"]] <- precip_orig_data[["precipVal"]]
    map_geometry <- map_geometry + 
      geom_polygon(data = geom_sp_orig_df, aes(x = long, y = lat, group = group, fill = precipVal),
                   alpha = 0.8, col = NA)
  }

  png(viz[['location']])
  print(map_geometry)
  dev.off()
  
}