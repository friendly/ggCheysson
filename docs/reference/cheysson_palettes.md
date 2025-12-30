# Cheysson Color Palettes

Color palettes extracted from the Albums de Statistique Graphique
produced under the direction of Émile Cheysson. These palettes are
organized by album year and plate number.

## Usage

``` r
cheysson_palettes
```

## Format

A list of 20 color palettes, each containing:

- colors:

  Character vector of hex color codes

- type:

  Palette type: "sequential", "diverging", "grouped", or "category"

- album:

  Year of the album

- plate:

  Plate number within the album

- rumsey_no:

  David Rumsey collection reference number

- dec_day:

  Advent calendar day from original source

## Source

Color patterns digitized by RJ Andrews from the David Rumsey Map
Collection <https://github.com/infowetrust/albumcolors>

Observable implementation by Tom Shanley
<https://observablehq.com/@tomshanley/cheysson-color-palettes>

## Details

The palettes are named using the convention `YYYY_PP` where YYYY is the
album year and PP is the zero-padded plate number. For example,
"1880_07" refers to plate 7 from the 1880 album.

Palette types:

- **Sequential** (7 palettes): Ordered colors for quantitative data

- **Diverging** (2 palettes): Two contrasting colors with neutral
  midpoint

- **Grouped** (5 palettes): Related colors for comparing groups

- **Category** (6 palettes): Distinct colors for categorical data

## See also

[`cheysson_pal`](https://friendly.github.io/ggCheysson/reference/cheysson_pal.md),
[`scale_color_cheysson`](https://friendly.github.io/ggCheysson/reference/scale_cheysson.md)

## Examples

``` r
# List available palettes
names(cheysson_palettes)
#>  [1] "1880_07" "1881_03" "1881_04" "1881_08" "1882_04" "1883_04" "1883_06"
#>  [8] "1883_07" "1886_04" "1886_07" "1886_08" "1887_06" "1888_05" "1891_03"
#> [15] "1891_06" "1891_07" "1895_04" "1900_06" "1906_04" "1906_06"

# Get colors from a specific palette
cheysson_palettes$`1880_07`$colors
#> [1] "#d9636c" "#869e80" "#dec367" "#85aab1" "#aea9a4" "#ed8238" "#ab90a4"

# Find palettes by type
sequential_pals <- Filter(function(x) x$type == "sequential", cheysson_palettes)
names(sequential_pals)
#> [1] "1881_03" "1886_04" "1888_05" "1891_06" "1891_07" "1895_04" "1900_06"
```
