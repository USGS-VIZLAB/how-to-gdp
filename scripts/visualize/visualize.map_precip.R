visualize.map_precip <- function(viz){
  
  deps <- readDepends(viz)
  precip_colors <- deps[["precip_colors"]]
  precip_breaks <- deps[["precip_breaks"]]
  precip_data <- deps[["precip_data"]]
  geom_sp <- deps[["geom_sp"]]
  geom_sp_orig <- deps[["geom_sp_orig"]]
  
  precip_col <- precip_colors[cut(precip_data[["precipVal"]], 
                                  breaks = precip_breaks, 
                                  labels = FALSE)]
  
  png(viz[['location']])
  
  if(!is.null(geom_sp_orig)){
    
    # calculate the center of both polygons (combine them first)
    # so that appropriate limits can be used for the plot
    geom_sp_combined <- maptools::spRbind(geom_sp, geom_sp_orig)
    geom_sp_bbox <- sp::bbox(geom_sp_combined)
    
    sp::plot(geom_sp_orig, col="lightgrey", border = NA, 
             xlim = geom_sp_bbox["x",], ylim = geom_sp_bbox["y",])
    
    add_to_map <- TRUE
  } else {
    add_to_map <- FALSE
  }
  

  sp::plot(geom_sp, col = precip_col, border = NA, add=add_to_map)
  legend("bottom", legend = paste("<", round(precip_breaks[-1], 2)),
         fill = precip_colors, border = NA, ncol = 5, box.col = NA,
         cex = 0.8, x.intersp = 0.5, bg = "lightgrey", inset = -0.3, xpd = TRUE)
  
  dev.off()
  
}