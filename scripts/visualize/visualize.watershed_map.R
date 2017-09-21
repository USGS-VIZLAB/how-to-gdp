visualize.watershed_map <- function(viz){
  deps <- readDepends(viz)
  region <- deps[['region']]
  
  library(maps)
  
  png(viz[['location']])
  map("state", "wisconsin")
  map("county", region="wisconsin", add=TRUE)
  map("county", region = region, fill=TRUE, col="cornflowerblue", add=TRUE)
  dev.off()
}