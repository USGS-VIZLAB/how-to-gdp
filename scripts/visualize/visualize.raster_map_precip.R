visualize.raster_map_precip <- function(viz = as.viz('yahara_precip_clip')){
  
  library(ggplot2) # need to actually load this or rasterVis::gplot throws an error
  library(sp) # need to use `as(. , "SpatialPixelsDataFrame")` so the whole library loads
  
  deps <- readDepends(viz)
  precip_raster <- deps[['raster_data']]
  crs <- deps[["crs"]][["crs_str"]]
  geom_feature <- deps[['geom_feature']]
  # west <- deps[["bbox"]][["west"]]
  # east <- deps[["bbox"]][["east"]]
  # north <- deps[["bbox"]][["north"]]
  # south <- deps[["bbox"]][["south"]]
  basemap <- deps[["basemap"]]
  min_precip <- deps[["precip_limits"]][["min"]]
  max_precip <- deps[["precip_limits"]][["max"]]

  # convert raster to sp object
  precip_sp <- as(precip_raster, "SpatialPixelsDataFrame") 
  
  if(!is.null(geom_feature)){
    #crop the precip data to the watershed polygon
    precip_sp <- raster::crop(precip_sp, geom_feature)
  }
  
  # setup as data.frame for plotting
  precip_df <- as.data.frame(precip_sp)
  
  map_plot <- basemap + 
    ggplot2::geom_tile(data = precip_df,
                       ggplot2::aes(x=x, y=y, fill = layer), alpha = 0.8) +
    ggplot2::scale_fill_gradientn(colours=blues9, na.value = "transparent",
                         limits = c(min_precip, max_precip), 
                         guide = ggplot2::guide_legend(direction = "vertical",
                                                       title = "Precipitation (in)")) +
    ggplot2::scale_alpha(guide = FALSE) 
  
  if(!is.null(geom_feature)){
    # see comments above for why we are no longer reprojecting.
    geom_feature_sp_df <- ggplot2::fortify(geom_feature) # prep sp data
    map_plot <- map_plot +
      geom_polygon(data = geom_feature_sp_df, 
                   ggplot2::aes(x=long, y=lat, group=group),
                   alpha = 0.8, fill = NA, color = "black", size=1.25)
  }
  
  png(viz[['location']])
  print(map_plot)
  dev.off()
  
}
