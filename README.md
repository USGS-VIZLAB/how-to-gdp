# how-gdp
Explanation of how the Geo Data Portal works.

## Initial Setup:

Clone this repository.

Open the included `how-gdp.Rproj`

If you don't have it, install [`vizlab`](https://github.com/USGS-VIZLAB/vizlab) via `devtools::install_github()`.

then make sure you have the proper packages and versions installed with:
```r
vizlab::checkVizPackages()
```
and use `install.packages()` or `devtools::install_github()` to update.

To build the viz, run

```
vizlab::vizmake()
```

Once you are able to complete the build, run `python -m http.server` in your Git shell, then open a browser to `localhost:8000`. Navigate to `target/index.html` to see the finished product locally.
