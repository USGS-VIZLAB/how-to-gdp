visualize.map_precip <- function(viz){
  
  library(ggplot2)
  
  deps <- readDepends(viz)
  precip_colors <- deps[["precip_colors"]]
  precip_breaks <- deps[["precip_breaks"]]
  precip_data <- deps[["precip_data"]]
  precip_orig_data <- deps[["precip_orig_data"]]
  geom_sp <- deps[["geom_sp"]]
  geom_sp_orig <- deps[["geom_sp_orig"]]
  
  precip_col <- precip_colors[cut(precip_data[["precipVal"]], 
                                  breaks = precip_breaks, 
                                  labels = FALSE)]
  
  # prep sp data
  geom_sp_df <- ggplot2::fortify(geom_sp)
  
  is_second_geom <- !is.null(geom_sp_orig) & !is.null(precip_orig_data)
  if(is_second_geom){
    precip_orig_col <- precip_colors[cut(precip_orig_data[["precipVal"]], 
                                         breaks = precip_breaks, 
                                         labels = FALSE)]
    
    geom_sp_orig_df <- ggplot2::fortify(geom_sp_orig) # prep sp data
    
    geom_combined <- maptools::spRbind(geom_sp, geom_sp_orig)
    geom_center <- rgeos::gCentroid(geom_combined)@coords
    
  } else {
    geom_center <- rgeos::gCentroid(geom_sp)@coords
  }
 
  # create basemap
  basemap_data <- ggmap::get_map(location = c(lon = geom_center[1], lat = geom_center[2]),
                                 color = "bw", maptype = "toner", zoom = 10)
  basemap <- ggmap::ggmap(basemap_data) + 
    theme(axis.title = element_blank(), axis.text = element_blank(), axis.ticks = element_blank())
  
  map_geometry <- basemap + 
    geom_polygon(data = geom_sp_df, aes(x = long, y = lat, group = group),
                 alpha = 0.7, fill = precip_col, col = NA) 
  
  if(is_second_geom){
    map_geometry <- map_geometry + 
      geom_polygon(data = geom_sp_orig_df, aes(x = long, y = lat, group = group),
                   alpha = 0.5, fill = precip_orig_col, col = NA)
  }

  png(viz[['location']])
  print(map_geometry)
  dev.off()
  
}