# Fetch utility functions

#' Convert a vector of counties into sf polygons
#' 
#' counties must be strings of "[state]:[county]". See ?maps::county.fips
#' 
county_to_sf <- function(counties){
  
  sf_poly <- sf::st_as_sf(maps::map("county", region = counties, plot = FALSE, fill=TRUE))
  
  return(sf_poly)
}

#' take an sf object polygon and make a grid out of it
#' 
#' This really belongs in process, but having fetch depend
#' on process is not a feature yet.
#' 
poly_to_grid <- function(sf_poly, cell_size, crs){
  
  cell_grid <- sf::st_make_grid(sf_poly, cellsize = cell_size, crs = crs)
  cell_poly <- sf::st_difference(sf::st_union(sf_poly), cell_grid)
  
  return(cell_poly)
}

#' get GDP precipitation data for given a stencil and dates
#' 
#' by default (`fabric = NULL`) precip data will be used, pass in a
#' geoknife "webdata" object to use different data.
#' 
get_gdp_precip <- function(stencil, start_date, end_date, fabric = NULL){
  
  if(is.null(fabric)){
    fabric <- geoknife::webdata(url = 'https://cida.usgs.gov/thredds/dodsC/stageiv_combined', 
                                variables = "Total_precipitation_surface_1_Hour_Accumulation", 
                                times = c(start_date, end_date))
  }
  
  stopifnot(class(fabric) == "webdata")
  
  job <- geoknife::geoknife(stencil, fabric, wait = TRUE, REQUIRE_FULL_COVERAGE=FALSE)
  
  precip <- geoknife::result(job, with.units=TRUE) %>% 
    dplyr::select(-variable, -statistic, -units) %>% 
    tidyr::gather(key = id, value = precipVal, -DateTime) 
  
  return(precip)
}

