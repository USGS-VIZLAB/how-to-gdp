
##########################
# plotting watersheds w/ precip

library(vizlab)
library(dplyr)
library(maps)
library(sf)

prcp <- readData("precip-cumulative")
# last_timestamp <- median(prcp$DateTime)
# prcp_total <- prcp %>% filter(DateTime == last_timestamp)

prcp_sf <- readData("storm-cell-poly")

baraboo <- sf::st_read("data/watersheds/baraboo.shp")
baraboo_transf <- sf::st_transform(baraboo, crs = "+init=EPSG:5070")

yahara <- sf::st_read("data/watersheds/yahara.shp")
yahara_transf <- sf::st_transform(yahara, crs = "+init=EPSG:5070")

storm_counties <- as.viz("storm-poly")$regions
storm_sf <- sf::st_as_sf(maps::map("county", region = storm_counties, plot = FALSE, fill=TRUE))
storm_sf_transf <- sf::st_transform(storm_sf, crs = "+init=EPSG:5070")

## sp w/ ggplot2
prcp_sp <- as(prcp_sf, "Spatial")
prcp_df <- fortify(prcp_sp) # Convert polygons to a data frame for plotting

baraboo_sp <- as(baraboo_transf, "Spatial")
baraboo2_sp <- as(baraboo2_transf, "Spatial")
yahara_sp <- as(yahara_transf, "Spatial")
storm_sp <- as(storm_sf_transf, "Spatial")

precip_breaks <- readData("precip-breaks")
precip_colors <- readData("precip-colors")

baseplot <- ggplot() +
  geom_polygon(data=yahara_sp, aes(x=long,y=lat,group=group), fill="lightpink") +
  geom_polygon(data=baraboo_sp, aes(x=long,y=lat,group=group), fill="lightgreen") +
  coord_fixed() +
  scale_fill_manual(values = precip_colors, labels = precip_breaks, 
                    name = "Cumulative precip (in)", 
                    guide = guide_legend(direction = "horizontal", title.position = "top",
                                         nrow = 1, label.position = "bottom", label.hjust = 0.5)) +
  theme_minimal() + 
  theme(axis.title = element_blank(), panel.grid = element_blank(), axis.text = element_blank(),
        legend.position="bottom") 

all_timesteps <- unique(as.Date(prcp$DateTime))
for(i in seq_along(all_timesteps)){
  ts <- as.POSIXct(paste(all_timesteps[i], "00:00:00"), tz = "UTC")
  prcp_ts <- prcp %>% filter(DateTime == ts)
  prcp_data_ts <- left_join(prcp_df, prcp_ts, by="id") # merge w/ precip totals
  ts_plot <- baseplot + 
    geom_polygon(data=prcp_data_ts, aes(x=long, y=lat, group=group, fill=cols), color=NA, alpha=0.9) +
    geom_polygon(data=storm_sp, aes(x=long,y=lat,group=group), fill="transparent", color="black")
  
  ggsave(filename = paste0("figures/tmax_", all_timesteps[i], ".png"), plot = ts_plot)
}