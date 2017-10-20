visualize.watershed_map <- function(viz){
  library(ggplot2)
  
  deps <- readDepends(viz)
  sp_poly <- deps[['sp_poly']]
  
  watershed_map <- ggplot() + 
    geom_polygon(data=sp_poly, aes(x=long, y=lat, group=group), fill="grey90", color="black") +
    coord_fixed() +
    theme_minimal() + 
    theme(axis.title = element_blank(), panel.grid = element_blank(), axis.text = element_blank()) 
  
  ggsave(filename = viz[["location"]], plot = watershed_map)
}