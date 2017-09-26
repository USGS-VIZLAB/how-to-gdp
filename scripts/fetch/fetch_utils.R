# Fetch utility functions

#' Convert a vector of counties into sf polygons
#' 
#' counties must be strings of "[state]:[county]". See ?maps::county.fips
#' 
county_to_sf <- function(counties, crs = 3086){
  library(sf)
  library(maps)
  
  sf_poly <- sf::st_as_sf(map("county", region = counties, plot = FALSE, fill=TRUE))
  sf_poly_transf <- st_transform(sf_poly, crs)
  
  return(sf_poly_transf)
}

#' Convert an sf object into an sp object
#' 
sf_to_sp <- function(sf_poly, crs = "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"){
  library(sf)
  library(sp)
  
  sp_poly <- as(sf_poly, "Spatial")
  sp_poly_transf <- sp::spTransform(sp_poly, sp::CRS(crs))
  
  return(sp_poly_transf)
}

#' take an sf object polygon and make a grid out of it
#' 
#' This really belongs in process, but having fetch depend
#' on process is not a feature yet.
#' 
poly_to_grid <- function(sf_poly, cell_size = 15000, crs = 3086){
  library(sf)
  
  cell_grid <- st_make_grid(sf_poly, cellsize = cell_size, crs = crs)
  cell_poly <- st_difference(st_union(sf_poly), cell_grid)
  
  return(cell_poly)
}

#' get GDP precipitation data for given a stencil and dates
#' 
get_gdp_precip <- function(stencil, start_date, end_date){
  library(geoknife)
  library(dplyr)
  library(tidyr)
  
  fabric <- geoknife::webdata(url = 'https://cida.usgs.gov/thredds/dodsC/stageiv_combined', 
                              variables = "Total_precipitation_surface_1_Hour_Accumulation", 
                              times = c(start_date, end_date))
  
  job <- geoknife::geoknife(stencil, fabric, wait = TRUE, REQUIRE_FULL_COVERAGE=FALSE)
  
  precip <- geoknife::result(job, with.units=TRUE) %>% 
    dplyr::select(-variable, -statistic, -units) %>% 
    tidyr::gather(key = id, value = precipVal, -DateTime) 
  
  return(precip)
}

