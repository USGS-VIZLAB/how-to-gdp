fetch.precip_data <- function(viz){
  `%>%` <- magrittr::`%>%`
  
  deps <- readDepends(viz)
  geom_sp <- deps[["geom_sp"]]
  date_range <- deps[["date_range"]]
  
  stencil <- geoknife::simplegeom(geom_sp)
  fabric <- geoknife::webdata(url = 'https://cida.usgs.gov/thredds/dodsC/stageiv_combined', 
                              variables = "Total_precipitation_surface_1_Hour_Accumulation", 
                              times = c(date_range$start_date, date_range$end_date))
  knife <- geoknife::webprocess(viz[["algorithm"]])
  
  if(viz[["algorithm"]] == "subset"){
    job <- geoknife::geoknife(stencil, fabric, knife, wait = TRUE, 
                              REQUIRE_FULL_COVERAGE=FALSE, OUTPUT_TYPE = "geotiff")
  } else {
    job <- geoknife::geoknife(stencil, fabric, knife, wait = TRUE, REQUIRE_FULL_COVERAGE=FALSE)
  }
  
  precip <- geoknife::result(job, with.units=TRUE)
  precip_clean <- precip %>% 
    dplyr::select(-variable, -statistic, -units) %>% 
    tidyr::gather(key = id, value = precipVal, -DateTime) %>% 
    dplyr::mutate(precipVal = precipVal/25.4) #convert mm to inches
  
  saveRDS(precip_clean, viz[['location']])
}

fetchTimestamp.precip_data <- vizlab:::fetchTimestamp.file
