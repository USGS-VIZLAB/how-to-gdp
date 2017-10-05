visualize.watershed_map <- function(viz){
  deps <- readDepends(viz)
  region_sf <- deps[['region_sf']]
  
  library(sf)
  
  png(viz[['location']])
  plot(region_sf, col="white")
  dev.off()
}