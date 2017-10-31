visualize.raster_map_precip <- function(viz){
  
  deps <- readDepends(viz)
  precip_data <- deps[['precip_data']]
  
  png(viz[['location']])
  plot(mtcars)
  dev.off()
  
}