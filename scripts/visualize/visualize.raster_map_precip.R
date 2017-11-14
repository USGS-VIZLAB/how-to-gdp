visualize.raster_map_precip <- function(viz = as.viz('yahara_precip_clip')){
  
  library(ggplot2) # need to actually load this or rasterVis::gplot throws an error
  
  deps <- readDepends(viz)
  precip_data <- deps[['raster_data']]
  
  png(viz[['location']])
  map_plot <- rasterVis::gplot(precip_data, maxpixels = 5e5) + 
    ggplot2::geom_tile(ggplot2::aes(fill = value, alpha=ifelse(is.na(value), 0, 1))) +
    ggplot2::scale_fill_gradientn(colours=rev(rainbow(15)), na.value = "transparent",
                         limits = c(-15, 50), 
                         guide = ggplot2::guide_legend(direction = "vertical",
                                                       title = "Precipitation (in)")) +
    ggplot2::scale_alpha(guide = FALSE) +
    ggplot2::coord_equal() + 
    ggplot2::theme_minimal() + 
    ggplot2::theme(axis.text = ggplot2::element_blank(), 
                   axis.title = ggplot2::element_blank(), 
                   panel.grid = ggplot2::element_blank())
  print(map_plot)
  dev.off()
  
}