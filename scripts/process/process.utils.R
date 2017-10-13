create_colors <- function(n, palette = "Blues"){
  RColorBrewer::brewer.pal(n, palette)
}

create_breaks <- function(nbins, stepsize){
  seq(from = 0, to = stepsize * (nbins - 1), length.out = nbins)
}

#' calculate cumulative precipitation and store as `precipVal`
#' 
#' this function assumes column names `DateTime`, 
#' `id` (location of precip summarization), and `precipVal`
#' 
calc_cumulative_precip <- function(precip_df){
  `%>%` <- magrittr::`%>%`
  
  precip <- dplyr::group_by(precip_df, id) %>% 
    dplyr::mutate(precipVal = precipVal/25.4) %>% #convert mm to inches
    dplyr::mutate(summ = cumsum(precipVal)) %>% 
    dplyr::select(DateTime, id, precipVal = summ)
  
  return(precip)
}

#' add a column to precip data based on the color bin  the precip
#' value corresponds to
#' 
#' this function assumes column names `DateTime`, 
#' `id` (location of precip summarization), and `precipVal`
#' 
bin_precip <- function(precip_df, breaks, colors){
  `%>%` <- magrittr::`%>%`
  
  precip <- dplyr::mutate(precip_df, cols_i = cut(precipVal, breaks = breaks, labels = FALSE)) %>%
    dplyr::mutate(cols_i = ifelse(precipVal > tail(breaks,1), length(breaks), cols_i)) %>%
    dplyr::mutate(cols_i = ifelse(is.na(cols_i), 1, cols_i)) %>% 
    dplyr::mutate(cols = colors[cols_i]) %>% 
    dplyr::select(id, DateTime, precipVal, cols)
  
  return(precip)
}
