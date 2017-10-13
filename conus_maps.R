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

  fabric <- webdata(url = 'https://cida.usgs.gov/thredds/dodsC/prism_v2', 
                    variables = "ppt", 
                    times = dates_d)
  job <- geoknife(stencil, fabric, knife, wait=TRUE, OUTPUT_TYPE = "geotiff")
  
  # fn <- paste0("precip", names(dates[d]))
  # fn <- paste0("tmx_rainbow", names(dates[d]))
  fn <- paste0("ppt_rainbow", names(dates[d]))
  
  file <- download(job, destination = file.path(tempdir(), paste0(fn, '_data.zip')), overwrite=TRUE)
  unzip(file, exdir=file.path(tempdir(), fn))
  tiff.dir <- file.path(tempdir(), fn)
  
  crs <- CRS("+proj=laea +lat_0=45 +lon_0=-100 +x_0=0 +y_0=0 +a=6370997 +b=6370997 +units=m +no_defs")
  precip <- raster(file.path(tiff.dir , dir(tiff.dir)), crs = crs)
  
  # col_vector <- c("white", blues9[4:9])
  # col_vector <- c("white", rev(heat.colors(6)))
  col_vector <- c("white", rev(rainbow(10)))
  
  conus <- map_data("usa")
  
  map_plot <- gplot(precip, maxpixels = 5e5) + 
    geom_tile(aes(fill = value), alpha=1) +
    geom_polygon(data=conus, aes(x=long, y=lat, group=group), color="grey", fill='transparent') +
    scale_fill_gradientn("Precipitation, mm", colours=col_vector, 
                         guide = FALSE) +
    coord_equal() + 
    theme_minimal() + 
    theme(axis.text = element_blank(), axis.title = element_blank(), panel.grid = element_blank())
  
  ggsave(paste0(fn, ".png"), map_plot, width = 8, height = 7, units = "in")
}
