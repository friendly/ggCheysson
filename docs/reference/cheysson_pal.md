# Get a Cheysson color palette

Returns colors from a specified Cheysson palette. Palettes can be
referenced by name (e.g., "1880_07") or by selecting a palette of a
particular type.

## Usage

``` r
cheysson_pal(palette = "1880_07", n = NULL, type = 1)
```

## Arguments

- palette:

  Name of palette (e.g., "1880_07"), or palette type ("sequential",
  "diverging", "grouped", "category"). If a type is specified, the first
  palette of that type is returned.

- n:

  Number of colors to return. If NULL, returns all colors in the
  palette. If n is greater than the number of colors in the palette,
  colors will be interpolated.

- type:

  If palette is a type name, optionally specify which palette of that
  type to use (default is 1 for the first).

## Value

A character vector of hex color codes

## Examples

``` r
# Get all colors from a specific palette
cheysson_pal("1880_07")
#> [1] "#d9636c" "#869e80" "#dec367" "#85aab1" "#aea9a4" "#ed8238" "#ab90a4"

# Get 5 colors from a palette
cheysson_pal("1880_07", n = 5)
#> [1] "#d9636c" "#869e80" "#dec367" "#85aab1" "#aea9a4"

# Get colors from first sequential palette
cheysson_pal("sequential")
#> [1] "#1e3e69"

# Get colors from second category palette
cheysson_pal("category", type = 2)
#> [1] "#d18781" "#edd493" "#7c9a77" "#6a8782"
```
