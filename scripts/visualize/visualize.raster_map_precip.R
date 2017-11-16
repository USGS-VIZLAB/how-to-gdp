visualize.raster_map_precip <- function(viz = as.viz('yahara_precip_clip')){
  
  library(ggplot2) # need to actually load this or rasterVis::gplot throws an error
  library(sp) # need to use `as(. , "SpatialPixelsDataFrame")` so the whole library loads
  
  deps <- readDepends(viz)
  precip_raster <- deps[['raster_data']]
  plot_crs <- deps[["plot_crs"]][["crs_str"]]
  data_crs <- deps[["data_crs"]][["crs_str"]]
  geom_feature <- deps[['geom_feature']]
  west <- deps[["bbox"]][["west"]]
  east <- deps[["bbox"]][["east"]]
  north <- deps[["bbox"]][["north"]]
  south <- deps[["bbox"]][["south"]]
  
  min_precip <- floor(precip_raster@data@min)
  max_precip <- ceiling(precip_raster@data@max)
  
  png(viz[['location']])
  precip_sp <- as(precip_raster_data, "SpatialPixelsDataFrame")
  precip_sp_projected <- sp::spTransform(precip_sp, crs)
  precip_sp_df <- as.data.frame(precip_sp_projected) # prep sp data
  names(precip_sp_df) <- c("value", "x", "y")
  
  map_plot <- ggplot() + 
    ggplot2::geom_tile(data = precip_sp_df,
                       ggplot2::aes(x=x, y=y, fill = value, alpha=ifelse(is.na(value), 0, 1))) +
    ggplot2::scale_fill_gradientn(colours=blues9, na.value = "transparent",
                         limits = c(min_precip, max_precip), 
                         guide = ggplot2::guide_legend(direction = "vertical",
                                                       title = "Precipitation (in)")) +
    ggplot2::scale_alpha(guide = FALSE) +
    ggplot2::coord_equal() + 
    ggplot2::theme_minimal() + 
    ggplot2::theme(axis.text = ggplot2::element_blank(), 
                   axis.title = ggplot2::element_blank(), 
                   panel.grid = ggplot2::element_blank())
  
  if(!is.null(geom_feature)){
    projected_sp <- sp::spTransform(geom_feature, crs)
    projected_sp_df <- ggplot2::fortify(projected_sp) # prep sp data
    map_plot <- map_plot +
      geom_polygon(data = projected_sp_df, 
                   ggplot2::aes(x=long, y=lat, group=group),
                   fill = NA, color = "black", size=1.5)
  }
  
  print(map_plot)
  dev.off()
  
}