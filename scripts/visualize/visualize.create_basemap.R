visualize.create_basemap <- function(viz){
  
  library(ggplot2)
  
  deps <- readDepends(viz)
  bbox <- deps[["bbox"]]
  bbox_vector <- c(bbox$west, bbox$south, bbox$east, bbox$north)
  
  # create basemap
  basemap_data <- ggmap::get_map(location = bbox_vector, color = "bw", maptype = "toner")
  
  # actually plot map
  basemap <- ggmap::ggmap(basemap_data) + 
    theme(axis.title = element_blank(), 
          axis.text = element_blank(), 
          axis.ticks = element_blank(), 
          panel.grid = ggplot2::element_blank()) 

  saveRDS(basemap, viz[['location']])
}