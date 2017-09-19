# how-gdp
Explanation of how the Geo Data Portal works.

## Initial Setup:

Clone this repository.

Open the included `how-gdp.Rproj`

If you don't have it, install [`vizlab`](https://github.com/USGS-VIZLAB/vizlab)

do:
```r
library(vizlab)
createProfile()
createMakefiles()
```

then make sure you have the proper packages and versions installed with:
```r
vizlab::checkVizPackages()
```
and use `install.packages()` or `devtools::install_github()` to update

`createProfile()` may not be necessary if you've worked on vizlab before.

Go to the "build" tab in Rstudio. You should see a "Build All" option. Click it!

If there are errors, logs with errors are in `how-gdp/vizlab/make/log`

Once you are able to complete the build, run `python -m http.server` in your Git shell, then open a browser to `localhost:8000`. Navigate to `target/index.html` to see the finished product locally.
