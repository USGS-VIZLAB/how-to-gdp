visualize.precip_timeseries_map <- function(viz){
  
  deps <- readDepends(viz)
  precip.cumulative <- deps[['precip-cumulative']]
  
  png(viz[['location']])
  plot(mtcars)
  dev.off()
  
}