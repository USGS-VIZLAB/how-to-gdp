visualize.storm_transpose <- function(viz){
  deps <- readDepends(viz)
  
  library(sp)
  
  png(viz[['location']])
  plot(deps[["geom_sp_orig"]], col="lightgrey")
  plot(deps[["geom_sp"]], col="darkgrey", add=TRUE)
  dev.off()
  
}