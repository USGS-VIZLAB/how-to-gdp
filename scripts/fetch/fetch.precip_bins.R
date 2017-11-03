fetch.precip_colors <- function(viz){
  deps <- readDepends(viz)
  cols <- RColorBrewer::brewer.pal(deps[['bins']][['bins']], viz[['palette']])
  saveRDS(cols, file = viz[['location']])
}

fetchTimestamp.precip_colors <- vizlab::alwaysCurrent

fetch.precip_breaks <- function(viz){
  deps <- readDepends(viz)
  
  precip_breaks <- seq(from = viz[["low_precip"]], 
                       to = viz[["high_precip"]], 
                       length.out = deps[['bins']][['bins']])
  
  saveRDS(object = precip_breaks, file = viz[['location']])
}

fetchTimestamp.precip_breaks <- vizlab::alwaysCurrent
