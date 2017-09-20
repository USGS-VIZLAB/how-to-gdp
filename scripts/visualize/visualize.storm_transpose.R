visualize.storm_transpose <- function(viz){
  deps <- readDepends(viz)
  
  library(maps)
  
  png(viz[['location']])
  map('state', fill=TRUE, col="cornflowerblue")
  dev.off()
  
}