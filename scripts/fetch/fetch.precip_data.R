
fetchTimestamp.precip_data <- vizlab::alwaysCurrent

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
    
    geoknife::download(job, destination = viz[['raw_netcdf']], overwrite =TRUE)
    precip_grid_df <- netcdf_to_sp(viz[['raw_netcdf']], crs)
    
    saveRDS(precip_grid_df, file = viz[['location']])
    
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
