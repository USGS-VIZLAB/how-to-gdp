## Create map figures to use in algorithm fig
## Takes approximately 5 minutes to run.
## Saves them in `images/`

library(geoknife)
library(rgdal)
library(rasterVis)
library(maps)
library(ggmap)
library(ggplot2)

stencil <- webgeom(geom = "sample:CONUS_states", attribute = "STATE", values = NA)
knife <- webprocess("subset")

dates <- list(time1 = c("2015-03-01", "2015-03-31"),
              time2 = c("2015-05-01", "2015-05-31"),
              time3 = c("2015-07-01", "2015-07-31"),
              time4 = c("2015-09-01", "2015-09-30"),
              time5 = c("2015-11-01", "2015-11-30"))

for(d in seq_along(dates)){
  
  dates_d <- dates[[d]]

  # execute geoknife job
  fabric <- webdata(url = 'https://cida.usgs.gov/thredds/dodsC/prism_v2', 
                    variables = "tmx", 
                    times = dates_d)
  job <- geoknife(stencil, fabric, knife, wait=TRUE, OUTPUT_TYPE = "geotiff")
  
  # get raster file and location
  fn <- paste0("tmx", names(dates[d]))
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
    geom_tile(aes(fill = value), alpha=1) +
    scale_fill_gradientn(colours=c("white", rev(rainbow(10))), na.value = "transparent", guide = FALSE) +
    coord_equal() + 
    theme_minimal() + 
    theme(axis.text = element_blank(), axis.title = element_blank(), panel.grid = element_blank())
  
  ggsave(paste0("images/", fn, ".png"), map_plot, width = 8, height = 7, units = "in")
}
