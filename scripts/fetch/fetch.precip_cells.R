fetch.precip_cells <- function(viz){
  library(sf)
  library(sp)
  
  deps <- readDepends(viz)
  storm_poly <- deps[["storm-poly"]]
  cell_size <- viz[["cell-size"]]
  crs <- viz[["crs"]]
  
  # create cells
  storm_cell_poly <- poly_to_grid(storm_poly, cell_size, crs)
  
  saveRDS(storm_cell_poly, viz[["location"]])
}

fetchTimestamp.precip_cells <- vizlab:::fetchTimestamp.file
