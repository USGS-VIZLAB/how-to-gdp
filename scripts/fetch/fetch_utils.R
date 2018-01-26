## utils for fetch functions

netcdf_to_sp <- function(filepath, crs_str) {
  
  nc <- ncdf4::nc_open(filepath)
  
  cell_size <- .06 # degrees
  
  # generate point sp
  x <- ncdf4::ncvar_get(nc, nc$var$lon)
  y <- ncdf4::ncvar_get(nc, nc$var$lat)
  coords <- data.frame(x=matrix(x, ncol = 1), y=matrix(y, ncol = 1))
  geo_point_data <- sp::SpatialPoints(coords, proj4string = sp::CRS(crs_str))
  geo_point_data <- sp::spTransform(geo_point_data, sp::CRS(crs_str))
  
  # add precip data (need it to be in inches, not mm)
  prcp_data <- matrix(t(ncdf4::ncvar_get(nc, nc$var$Total_precipitation_surface_1_Hour_Accumulation)), ncol=1) # switch axis order with t()
  prcp_data_inches <- prcp_data/25.4
  geo_p_data <- sp::SpatialPointsDataFrame(geo_point_data, data.frame(prcp=prcp_data_inches))
  
  # generate grid sp
  bbox <- sp::bbox(geo_point_data)
  x_range <- (bbox[3] - bbox[1])/cell_size
  y_range <- (bbox[4] - bbox[2])/cell_size
  grid_topology <- sp::GridTopology(bbox[c(1:2)], cellsize = c(cell_size,cell_size), 
                                    cells.dim = c(x_range, y_range))
  sp_grid <- raster::raster(sp::SpatialGrid(grid_topology, sp::CRS(crs_str)))
  
  # combine points and grid
  sp_grid_data <- raster::rasterize(geo_p_data, sp_grid, "prcp", fun=mean)
  
  return(sp_grid_data)
}
