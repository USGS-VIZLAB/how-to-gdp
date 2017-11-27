visualize.create_basemap <- function(viz){
  
  library(ggplot2)
  
  deps <- readDepends(viz)
  geom_sp <- deps[["geom_sp"]]
  
  # prep sp data
  geom_sp_df <- ggplot2::fortify(geom_sp)
  geom_bbox <- sp::bbox(geom_sp)
  
  # create basemap
  basemap_data <- ggmap::get_map(location = geom_bbox, color = "bw", maptype = "toner")
  
  # expand bbox if needed
  # basemap_bbox <- attr(basemap_data, "bb")
  # bottom <- ifelse(basemap_bbox[["ll.lat"]] > geom_bbox[2, 1], geom_bbox[2, 1], basemap_bbox[["ll.lat"]])
  # top <- ifelse(basemap_bbox[["ur.lat"]] < geom_bbox[2, 2], geom_bbox[2, 2], basemap_bbox[["ur.lat"]])
  # left <- ifelse(basemap_bbox[["ll.lon"]] > geom_bbox[1, 1], geom_bbox[1, 1], basemap_bbox[["ll.lon"]])
  # right <- ifelse(basemap_bbox[["ur.lon"]] < geom_bbox[1, 2], geom_bbox[1, 2], basemap_bbox[["ur.lon"]])
  # attr(basemap_data, "bb") <- data.frame(ll.lat = bottom, ll.lon = left, ur.lat = top, ur.lon = right)
  
  # actually plot map
  basemap <- ggmap::ggmap(basemap_data) + 
    theme(axis.title = element_blank(), 
          axis.text = element_blank(), 
          axis.ticks = element_blank(), 
          panel.grid = ggplot2::element_blank()) 

  saveRDS(basemap, viz[['location']])
}