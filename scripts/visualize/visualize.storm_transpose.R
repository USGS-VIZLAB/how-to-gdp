visualize.storm_transpose <- function(viz){
  
  library(ggplot2)
  
  deps <- readDepends(viz)
  precip_df <- deps[["precip-cumulative"]]
  precip_breaks <- deps[["precip-breaks"]]
  precip_colors <- deps[["precip-colors"]]
  ws_orig <- deps[["watershed-orig"]]
  ws_new <- deps[["watershed-new"]]
  storm_cell_df <- deps[["storm-cell-df"]]
  
  baseplot <- ggplot() +
    geom_polygon(data=ws_orig, aes(x=long,y=lat,group=group), fill="lightpink") +
    geom_polygon(data=ws_new, aes(x=long,y=lat,group=group), fill="lightgreen") +
    coord_fixed() +
    scale_fill_gradientn(colours = blues9) +
    theme_minimal() + 
    theme(axis.title = element_blank(), panel.grid = element_blank(), axis.text = element_blank(),
          legend.position="bottom") 
  
  precip_df_final <- dplyr::filter(precip_df, DateTime == max(precip_df$DateTime))
  
  precip_df_sp_final <- dplyr::left_join(storm_cell_df, precip_df_final, by="id") # merge w/ precip totals
  precip_plot <- baseplot + 
    geom_polygon(data=precip_df_sp_final, aes(x=long, y=lat, group=group, fill=precipVal), color=NA, alpha=0.9)
  
  ggsave(filename = viz[["location"]], plot = precip_plot)
}