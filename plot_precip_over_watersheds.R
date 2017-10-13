
##########################
# plotting watersheds w/ precip

library(vizlab)
library(dplyr)
library(maps)
library(sf)

prcp <- readData("precip-cumulative")
last_timestamp <- max(prcp$DateTime)
prcp_total <- prcp %>% filter(DateTime == last_timestamp)

prcp_sf <- readData("storm-cell-poly")

# try without fitting to county lines
prcp_sf <- readData("storm-poly")
prcp_sf <- sf::st_make_grid(prcp_sf, cellsize = 3000, crs = "+init=EPSG:5070")

prcp_sf_transf <- sf::st_transform(prcp_sf, crs="+init=EPSG:5070")
prcp <- st_sf(prcp_sf_transf, col = prcp_total$cols)

baraboo <- sf::st_read("data/watersheds/baraboo.shp")
baraboo_transf <- sf::st_transform(baraboo, crs = "+init=EPSG:5070")

yahara <- sf::st_read("data/watersheds/yahara.shp")
yahara_transf <- sf::st_transform(yahara, crs = "+init=EPSG:5070")

storm_counties <- c("wisconsin,sauk", "wisconsin,columbia", "wisconsin,dodge", "wisconsin,green lake")
storm_sf <- sf::st_as_sf(maps::map("county", region = storm_counties, plot = FALSE, fill=TRUE))
storm_sf_transf <- sf::st_transform(storm_sf, crs = "+init=EPSG:5070")

## sp w/ ggplot2
prcp_sp <- as(prcp_sf_transf, "Spatial")
prcp_df <- fortify(prcp_sp) # Convert polygons to a data frame for plotting

# ids match sp object ids

#### NOT SURE IF THE IDs ARE MATCHING UP APPROPRIATELY
prcp_total$id <- unlist(lapply(prcp_sp@polygons, function(x) x %>% slot("ID")))
row.names(prcp_total) <- prcp_total$id
####

prcp_df <- left_join(prcp_df, prcp_total, by="id")
# prcp_df <- prcp_df %>% mutate(cols = as.factor(cols, levels=precip_breaks))

baraboo_sp <- as(baraboo_transf, "Spatial")
yahara_sp <- as(yahara_transf, "Spatial")
storm_sp <- as(storm_sf_transf, "Spatial")

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

baseplot + 
  geom_polygon(data=prcp_df, aes(x=long, y=lat, group=group, fill=cols), color=NA, alpha=0.9) 

