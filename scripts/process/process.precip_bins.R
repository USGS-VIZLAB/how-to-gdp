process.precip_colors <- function(viz){
  cols <- create_colors(viz[['bins']], viz[['palette']])
  cat(jsonlite::toJSON(cols), file = viz[['location']])
}

process.precip_breaks <- function(viz){
  deps <- readDepends(viz)
  colSteps <- deps[['precip-colors']] #vector of actual color palette codes
  precip_breaks <- create_breaks(length(colSteps), viz[["step-size"]])
  saveRDS(object = precip_breaks, file = viz[['location']])
}
