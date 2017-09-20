visualize.method_animation <- function(viz){
  deps <- readDepends(viz)
  
  library(maps)
  
  png(viz[['location']])
  map('state', 'wisconsin', fill=TRUE, col="darkred")
  dev.off()
  
}