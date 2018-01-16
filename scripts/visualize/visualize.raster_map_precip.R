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
  basemap <- deps[["basemap"]]
  min_precip <- deps[["precip_limits"]][["min"]]
  max_precip <- deps[["precip_limits"]][["max"]]

  # get raster into correct projection
  raster::extent(precip_raster) <- c(west, east, south, north)
  raster::projection(precip_raster) <- sp::CRS(crs)
  
  # convert raster to sp object then re-project
  precip_sp <- as(precip_raster, "SpatialPixelsDataFrame")
  
  #   Bumped up against a warning about warping when using sp::spTransform.
  #   "warning: Grid warping not available, coercing to points"
  #   Looked at a stackoverflow comment and decided to not reproject into the plotting crs.
  #   Stackoverflow: https://stackoverflow.com/questions/15258582/re-project-sgdf-with-5-km5km-resolution-to-0-050-05
  
  if(!is.null(geom_feature)){
    #crop the precip data to the watershed polygon
    precip_sp <- raster::crop(precip_sp, geom_feature)
  }
  
  precip_sp_df <- as.data.frame(precip_sp) # prep sp data
  names(precip_sp_df) <- c("value", "x", "y")
  
  map_plot <- basemap + 
    ggplot2::geom_tile(data = precip_sp_df,
                       ggplot2::aes(x=x, y=y, fill = value), alpha = 0.8) +
    ggplot2::scale_fill_gradientn(colours=blues9, na.value = "transparent",
                         limits = c(min_precip, max_precip), 
                         guide = ggplot2::guide_legend(direction = "vertical",
                                                       title = "Precipitation (in)")) +
    ggplot2::scale_alpha(guide = FALSE) 
  
  if(!is.null(geom_feature)){
    # see comments above for why we are no longer reprojecting.
    geom_feature_sp_df <- ggplot2::fortify(geom_feature) # prep sp data
    map_plot <- map_plot +
      geom_polygon(data = geom_feature_sp_df, 
                   ggplot2::aes(x=long, y=lat, group=group),
                   alpha = 0.8, fill = NA, color = "black", size=1.25)
  }
  
  png(viz[['location']])
  print(map_plot)
  dev.off()
  
}
