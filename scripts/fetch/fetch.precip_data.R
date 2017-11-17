fetch.precip_data <- function(viz = as.viz('context_precip')){
  `%>%` <- magrittr::`%>%`
  
  deps <- readDepends(viz)
  geom_sp <- deps[["geom_sp"]] #yahara watershed
  date_range <- deps[["date_range"]]
  date <- deps[["date"]]
  crs <- deps[['crs']]$crs_str 
    
  start_date <- ifelse(is.null(date_range), date$date, date_range$start_date)
  end_date <- ifelse(is.null(date_range), date$date, date_range$end_date)
  
  stencil <- geoknife::simplegeom(geom_sp)
  fabric <- geoknife::webdata(url = 'https://cida.usgs.gov/thredds/dodsC/stageiv_combined', 
                              variables = "Total_precipitation_surface_1_Hour_Accumulation", 
                              times = c(start_date, end_date))
  knife <- geoknife::webprocess(viz[["algorithm"]])
  
  if(viz[["algorithm"]] == "subset"){
    job <- geoknife::geoknife(stencil, fabric, knife, wait = TRUE, 
                              REQUIRE_FULL_COVERAGE=FALSE, 
                              OUTPUT_TYPE="netcdf")
    #need to download manually since no netcdf parser
    download.file(url = geoknife::check(job)$URL, 
                  destfile = viz[['raw_netcdf']], 
                  mode="wb")
    precip_raster <- raster::raster(viz[['raw_netcdf']], band = 1,
                            crs = crs)/25.4
    saveRDS(precip_raster, file = viz[['location']])
  } else {
    job <- geoknife::geoknife(stencil, fabric, knife, wait = TRUE, REQUIRE_FULL_COVERAGE=FALSE)
    precip <- geoknife::result(job, with.units=TRUE)
    precip_clean <- precip %>% 
      dplyr::select(-variable, -statistic, -units) %>% 
      tidyr::gather(key = id, value = precipVal, -DateTime) %>% 
      dplyr::mutate(precipVal = precipVal/25.4) #convert mm to inches
    
    saveRDS(precip_clean, viz[['location']])
  }
}

fetchTimestamp.precip_data <- vizlab:::fetchTimestamp.file
