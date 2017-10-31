visualize.watershed_map <- function(viz){
  
  deps <- readDepends(viz)
  geom_feature <- deps[['geom_feature']]
  geom_context <- deps[['geom_context']]
  
  library(sp)
  
  png(viz[['location']])
  plot(geom_context, col="grey")
  plot(geom_feature, col="lightyellow")
  dev.off()
}