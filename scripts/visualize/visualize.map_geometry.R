visualize.map_geometry <- function(viz){
  
  library(ggplot2)
  
  deps <- readDepends(viz)
  geom_feature <- deps[['geom_feature']]
  basemap <- deps[["basemap"]]
  
  # prep sp data for ggplot mapping
  geom_feature_sp_df <- ggplot2::fortify(geom_feature) 
  
  map_plot <- basemap +
    geom_polygon(data = geom_feature_sp_df, 
                 ggplot2::aes(x=long, y=lat, group=group),
                 fill = "forestgreen", alpha = 0.2,
                 color = "forestgreen") +
    ggplot2::theme(axis.text = ggplot2::element_blank(), 
                   axis.title = ggplot2::element_blank(), 
                   panel.grid = ggplot2::element_blank())
  
  png(viz[['location']])
  print(map_plot)
  dev.off()
}