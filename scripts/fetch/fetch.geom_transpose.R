fetch.geom_transpose <- function(viz){
  deps <- readDepends(viz)
  
  sp_poly_transpose <- maptools::elide(deps[["geom_sp"]], shift = c(0, viz[["vertical_trans_va"]]))
  
  saveRDS(sp_poly_transpose, viz[['location']])
}

fetchTimestamp.geom_transpose <- vizlab:::fetchTimestamp.file
