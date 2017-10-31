visualize.map_precip <- function(viz){
  
  deps <- readDepends(viz)
  precip_data <- deps[["precip_data"]]
  geom_sp <- deps[["geom_sp"]]
  geom_sp_orig <- deps[["geom_sp_orig"]]
  
  png(viz[['location']])
  
  if(!is.null(geom_sp_orig)){
    sp::plot(geom_sp_orig, col="lightgrey")
    add_to_map <- TRUE
  } else {
    add_to_map <- FALSE
  }
  
  sp::plot(geom_sp, col="darkgrey", add=add_to_map)
  
  dev.off()
  
}