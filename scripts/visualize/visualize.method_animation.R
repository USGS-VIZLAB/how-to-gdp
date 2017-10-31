visualize.map_precip_data <- function(viz){
  
  deps <- readDepends(viz)
  precip_data <- deps[["precip_data"]]
  geom_sp <- deps[["geom_sp"]]
  geom_sp_orig <- deps[["geom_sp_orig"]]
  
  if(is.null(geom_sp_orig)){
    # don't plot it!
  }
  
  png(viz[['location']])
  map('state', 'wisconsin', fill=TRUE, col="darkred")
  dev.off()
  
}