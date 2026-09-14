# Cheysson map theme

A theme specifically designed for maps, with no grid and minimal
elements, in the style of Cheysson's cartographic works.

## Usage

``` r
theme_cheysson_map(
  base_size = 11,
  base_family = "auto",
  title_family = "auto",
  load_fonts = TRUE
)
```

## Arguments

- base_size:

  Base font size (default: 11)

- base_family:

  Base font family. If "auto" (default), uses Cheysson if available,
  otherwise falls back to sans-serif

- title_family:

  Font family for titles (default: "auto")

- load_fonts:

  Automatically load Cheysson fonts if not already loaded (default:
  TRUE)

## Value

A ggplot2 theme object that can be added to a plot with `+`.

## Examples

``` r
if (FALSE) { # \dontrun{
# Not run automatically: see theme_cheysson() for why (same font/grid crash)
# once a plot with this theme is actually rendered/printed.
# For use with spatial data/maps
library(ggplot2)

# Load fonts first
load_cheysson_fonts()

# Example with spatial data (requires sf package)
if (requireNamespace("sf", quietly = TRUE)) {
  # ggplot(map_data) + geom_sf() + theme_cheysson_map()
}
} # }
```
