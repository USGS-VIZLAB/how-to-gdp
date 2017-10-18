process.precip_cells_df <- function(viz){
  library(sf)
  
  deps <- readDepends(viz)
  precip_cells_sf <- deps[["storm-cell-poly"]]
  
  precip_cells_sp <- as(precip_cells_sf, "Spatial")
  precip_cells_df <- ggplot2::fortify(precip_cells_sp)

  saveRDS(precip_cells_df, viz[["location"]])
}
