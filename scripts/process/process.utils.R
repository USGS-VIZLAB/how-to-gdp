#' add a column to precip data based on the color bin  the precip
#' value corresponds to
#' 
#' this function assumes column names `DateTime`, 
#' `id` (location of precip summarization), and `precipVal`
#' 
bin_precip <- function(precip_df, breaks){
  `%>%` <- magrittr::`%>%`
  
  precip <- dplyr::mutate(precip_df, cols = cut(precipVal, breaks = breaks, labels = FALSE)) %>%
    dplyr::mutate(cols = ifelse(precipVal > tail(breaks,1), length(breaks), cols)) %>%
    dplyr::mutate(cols = ifelse(is.na(cols), 1, cols)) %>% 
    dplyr::mutate(cols = as.character(cols)) %>% 
    dplyr::select(id, DateTime, cols)
  
  return(precip)
}
