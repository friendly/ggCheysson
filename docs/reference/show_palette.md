# Display a Cheysson palette with color swatches and hex codes

Creates a visual display of a color palette showing color swatches along
with their hex codes. This is useful for documentation, presentations,
and exploring the available palettes.

## Usage

``` r
show_palette(palette = "1880_21", n = NULL, show_info = TRUE, cex = 1)
```

## Arguments

- palette:

  Name of palette (e.g., "1880_21"), or palette type ("sequential",
  "diverging", "grouped", "category").

- n:

  Number of colors to display. If NULL (default), shows all colors in
  the palette. If specified, will interpolate if n \> palette size.

- show_info:

  Logical; if TRUE (default), displays palette metadata (type, album,
  plate) above the swatches.

- cex:

  Text size multiplier for hex codes (default 1).

## Value

Invisibly returns a character vector of the displayed hex codes. The
function is called primarily for its side effect of creating a plot.

## Examples

``` r
# Display a specific palette
show_palette("1880_21")


# Display palette without metadata
show_palette("1881_12", show_info = FALSE)


# Display 10 interpolated colors
show_palette("1895_16", n = 10)


# Display first sequential palette
show_palette("sequential")

```
