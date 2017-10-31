fetch.geom_transpose <- function(viz){
  deps <- readDepends(viz)
  
  sp_poly_transpose <- raster::shift(deps[["geom_sp"]], y = viz[["vertical_trans_va"]])
  
  saveRDS(sp_poly_transpose, viz[['location']])
}

fetchTimestamp.geom_transpose <- vizlab:::fetchTimestamp.file
