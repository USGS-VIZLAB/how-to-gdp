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
  
  precip_grp <- dplyr::group_by(precip_df, id)
  precip_english <- dplyr::mutate(precip_grp, precipVal = precipVal/25.4) #convert mm to inches
  precip_cumulative <- dplyr::mutate(precip_english, summ = cumsum(precipVal))
  precip_data <- dplyr::select(precip_cumulative, DateTime, id, precipVal = summ)
  
  return(precip_data)
}

#' add a column to precip data based on the color bin  the precip
#' value corresponds to
#' 
#' this function assumes column names `DateTime`, 
#' `id` (location of precip summarization), and `precipVal`
#' 
bin_precip <- function(precip_df, breaks){
  
  precip_df <- dplyr::mutate(precip_df, cols = cut(precipVal, breaks = breaks, labels = FALSE)) 
  precip_df <- dplyr::mutate(precip_df, cols = ifelse(precipVal > tail(breaks,1), 
                                                      length(breaks), 
                                                      cols))
  precip_df <- dplyr::mutate(precip_df, cols = ifelse(is.na(cols), 1, cols)) 
  precip_df <- dplyr::mutate(precip_df, cols = as.character(cols)) 
  precip_df <- dplyr::select(precip_df, id, DateTime, cols)
  
  return(precip_df)
}
