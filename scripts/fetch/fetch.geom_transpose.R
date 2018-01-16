fetch.geom_transpose <- function(viz){
  deps <- readDepends(viz)
  
  sp_poly_transpose <- maptools::elide(deps[["geom_sp"]], shift = c(0, viz[["vertical_trans_va"]]))
  sp::proj4string(sp_poly_transpose) <- sp::proj4string(deps[["geom_sp"]])
  
  # create unique ids for the new transposed polygons
  # there should only be one polygon at this point:
  stopifnot(length(sp_poly_transpose@plotOrder) == 1)
  new_id <- paste0(slot(sp_poly_transpose@polygons[[1]], name = "ID"), "_transposed")
  slot(sp_poly_transpose@polygons[[1]], name = "ID") <- new_id
  
  saveRDS(sp_poly_transpose, viz[['location']])
}

fetchTimestamp.geom_transpose <- vizlab::alwaysCurrent
