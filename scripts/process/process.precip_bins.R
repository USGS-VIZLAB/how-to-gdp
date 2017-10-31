process.precip_colors <- function(viz){
  cols <- RColorBrewer::brewer.pal(viz[['bins']], viz[['palette']])
  cat(jsonlite::toJSON(cols), file = viz[['location']])
}

process.precip_breaks <- function(viz){
  deps <- readDepends(viz)
  colSteps <- deps[['precip-colors']] #vector of actual color palette codes
  
  precip_breaks <- seq(from = deps[["precip_color_scale"]][["low_precip"]], 
                       to = deps[["precip_color_scale"]][["high_precip"]], 
                       length.out = viz[['bins']])
  
  saveRDS(object = precip_breaks, file = viz[['location']])
}
