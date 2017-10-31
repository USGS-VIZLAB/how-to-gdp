visualize.map_geometry <- function(viz){
  
  deps <- readDepends(viz)
  geom_feature <- deps[['geom_feature']]
  geom_context <- deps[['geom_context']]
  
  png(viz[['location']])
  sp::plot(geom_context, col="grey")
  sp::plot(geom_feature, col="lightyellow", add=TRUE)
  dev.off()
}