visualize.raster_map_precip <- function(viz = as.viz('yahara_precip_clip')){
  
  library(ggplot2) # need to actually load this or rasterVis::gplot throws an error
  library(sp) # need to use `as(. , "SpatialPixelsDataFrame")` so the whole library loads
  
  deps <- readDepends(viz)
  precip_raster <- deps[['raster_data']]
  crs <- deps[["crs"]][["crs_str"]]
  geom_feature <- deps[['geom_feature']]
  west <- deps[["bbox"]][["west"]]
  east <- deps[["bbox"]][["east"]]
  north <- deps[["bbox"]][["north"]]
  south <- deps[["bbox"]][["south"]]
  
  min_precip <- floor(precip_raster@data@min)
  max_precip <- ceiling(precip_raster@data@max)
  
  png(viz[['location']])
  
  # get raster into correct projection
  raster::extent(precip_raster) <- c(west, east, south, north)
  raster::projection(precip_raster) <- sp::CRS(crs)
  
  # convert raster to sp object then re-project
  precip_sp <- as(precip_raster, "SpatialPixelsDataFrame")
  
  # precip_sp_projected <- sp::spTransform(precip_sp, plot_crs)
  #   bumped up against a warning about warping, looked at a stackoverflow comment
  #   and decided to just not reproject into the plotting crs
  #   warning: Grid warping not available, coercing to points
  #   stackoverflow: https://stackoverflow.com/questions/15258582/re-project-sgdf-with-5-km5km-resolution-to-0-050-05
  
  precip_sp_df <- as.data.frame(precip_sp) # prep sp data
  names(precip_sp_df) <- c("value", "x", "y")
  
  map_plot <- ggplot() + 
    ggplot2::geom_tile(data = precip_sp_df,
                       ggplot2::aes(x=x, y=y, fill = value, alpha=ifelse(is.na(value), 0, 1))) +
    ggplot2::scale_fill_gradientn(colours=blues9, na.value = "transparent",
                         limits = c(min_precip, max_precip), 
                         guide = ggplot2::guide_legend(direction = "vertical",
                                                       title = "Precipitation (in)")) +
    ggplot2::scale_alpha(guide = FALSE) +
    ggplot2::coord_equal() + 
    ggplot2::theme_minimal() + 
    ggplot2::theme(axis.text = ggplot2::element_blank(), 
                   axis.title = ggplot2::element_blank(), 
                   panel.grid = ggplot2::element_blank())
  
  if(!is.null(geom_feature)){
    # see comments about for why we are no longer reprojecting.
    # projected_sp <- sp::spTransform(geom_feature, data_crs)
    geom_feature_sp_df <- ggplot2::fortify(geom_feature) # prep sp data
    map_plot <- map_plot +
      geom_polygon(data = geom_feature_sp_df, 
                   ggplot2::aes(x=long, y=lat, group=group),
                   fill = NA, color = "black", size=1.5)
  }
  
  print(map_plot)
  dev.off()
  
}