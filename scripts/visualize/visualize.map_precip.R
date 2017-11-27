visualize.map_precip <- function(viz){
  
  library(ggplot2)
  
  deps <- readDepends(viz)
  precip_data <- deps[["precip_data"]]
  precip_orig_data <- deps[["precip_orig_data"]]
  geom_sp <- deps[["geom_sp"]]
  geom_sp_orig <- deps[["geom_sp_orig"]]
  basemap <- deps[["basemap"]]
  min_precip <- deps[["precip_limits"]][["min"]]
  max_precip <- deps[["precip_limits"]][["max"]]
  
  # prep sp data
  geom_sp_df <- ggplot2::fortify(geom_sp)
  geom_sp_df[["precipVal"]] <- precip_data[["precipVal"]]

  map_geometry <- basemap + 
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
    geom_sp_orig_df[["precipVal"]] <- precip_orig_data[["precipVal"]]
    map_geometry <- map_geometry + 
      geom_polygon(data = geom_sp_orig_df, aes(x = long, y = lat, group = group, fill = precipVal),
                   alpha = 0.8, col = NA)
  }

  png(viz[['location']])
  print(map_geometry)
  dev.off()
  
}