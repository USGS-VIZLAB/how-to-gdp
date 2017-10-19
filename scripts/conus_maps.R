## Create map figures to use in algorithm fig
## Takes approximately 10 minutes to run.
## Saves them in `images/`

library(geoknife)
library(lubridate)
library(rgdal)
library(rasterVis)
library(sf)
library(maps)
library(ggmap)
library(ggplot2)

# setup stencil and knife
stencil <- webgeom(geom = "sample:CONUS_states", attribute = "STATE", values = NA)
knife <- webprocess("subset")

# create timesteps
starts <- seq(as.Date("2015-01-01"), as.Date("2015-08-01"), by="month")
ends <- seq(as.Date("2015-02-01"), as.Date("2015-09-01"), by="month") - lubridate::days(1)
dates_df <- data.frame(start_date = starts, end_date = ends, stringsAsFactors = FALSE)

for(r in seq(nrow(dates_df))){
  
  start <- as.character(dates_df$start_date[r])
  end <- as.character(dates_df$end_date[r])

  # execute geoknife job
  fabric <- webdata(url = 'https://cida.usgs.gov/thredds/dodsC/prism_v2', 
                    variables = "tmx", 
                    times = c(start, end))
  job <- geoknife(stencil, fabric, knife, wait=TRUE, OUTPUT_TYPE = "geotiff")
  
  # get raster file and location
  fn <- paste0("tmx", r, lubridate::month(start, label=TRUE))
  file <- download(job, destination = file.path(tempdir(), paste0(fn, '_data.zip')), overwrite=TRUE)
  unzip(file, exdir=file.path(tempdir(), fn))
  tiff.dir <- file.path(tempdir(), fn)
  
  # reproject the raster
  crs <- "+init=EPSG:5070"
  temp <- raster(file.path(tiff.dir , dir(tiff.dir)))
  temp_projected <- projectRaster(temp, crs=crs)
  
  # create conus sp object to clip precip raster to just conus & not ocean
  conus_sf <- st_as_sf(maps::map("state", plot = FALSE, fill=TRUE))
  conus_sf_transf <- st_transform(conus_sf, crs = crs)
  conus_sp <- as(conus_sf_transf, "Spatial")
  
  # actually subset data to conus
  temp_crop <- crop(temp_projected, extent(conus_sp))
  temp_mask <- mask(temp_crop, conus_sp)
  
  map_plot <- gplot(temp_mask, maxpixels = 5e5) + 
    geom_tile(aes(fill = value, alpha=ifelse(is.na(value), 0, 1))) +
    scale_fill_gradientn(colours=rev(rainbow(15)), na.value = "transparent",
                         limits = c(-15, 50), guide = FALSE) +
    scale_alpha(guide = FALSE) +
    coord_equal() + 
    theme_minimal() + 
    theme(axis.text = element_blank(), axis.title = element_blank(), panel.grid = element_blank())
  
  ggsave(paste0("images/", fn, ".png"), map_plot, width = 8, height = 7, units = "in", bg="transparent")
}
