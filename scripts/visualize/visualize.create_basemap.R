visualize.create_basemap <- function(viz){
  
  library(ggplot2)
  
  deps <- readDepends(viz)
  geom_sp <- deps[["geom_sp"]]
  
  # prep sp data
  geom_sp_df <- ggplot2::fortify(geom_sp)
  geom_bbox <- sp::bbox(geom_sp)
  
  # create basemap
  basemap_data <- ggmap::get_map(location = geom_bbox, color = "bw", maptype = "toner")
  
  # actually plot map
  basemap <- ggmap::ggmap(basemap_data) + 
    theme(axis.title = element_blank(), 
          axis.text = element_blank(), 
          axis.ticks = element_blank(), 
          panel.grid = ggplot2::element_blank()) 

  saveRDS(basemap, viz[['location']])
}