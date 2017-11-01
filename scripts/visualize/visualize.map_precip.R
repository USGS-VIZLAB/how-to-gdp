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
    sp::plot(geom_sp_orig, col="lightgrey")
    add_to_map <- TRUE
  } else {
    add_to_map <- FALSE
  }
  
  sp::plot(geom_sp, col="darkgrey", add=add_to_map)
  sp::plot(geom_sp, col = precip_col, border = NA, add=add_to_map)
  
  dev.off()
  
}