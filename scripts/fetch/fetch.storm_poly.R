fetch.storm_poly <- function(viz){
  
  sf_poly <- county_to_sf(viz[["regions"]])
  sf_poly <- sf::st_transform(sf_poly, viz[["crs"]])
  
  saveRDS(sf_poly, viz[["location"]])
}

fetchTimestamp.storm_poly <- vizlab:::fetchTimestamp.file
