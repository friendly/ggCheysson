# Cheysson Color Palettes

Color palettes extracted from the Albums de Statistique Graphique
produced under the direction of Émile Cheysson. These palettes are
organized by album year and plate number.

## Usage

``` r
cheysson_palettes
```

## Format

A list of 25 color palettes, each containing:

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
<https://web.archive.org/web/20210130125506/https://observablehq.com/@tomshanley/cheysson-color-palettes>

## Details

The palettes are named using the convention `YYYY_PP` where YYYY is the
album year and PP is the zero-padded plate number. For example,
"1880_07" refers to plate 7 from the 1880 album.

Palette types:

- **Sequential** (7 palettes): Ordered colors for quantitative data

- **Diverging** (2 palettes): Two contrasting colors with neutral
  midpoint

- **Grouped** (10 palettes): Related colors for comparing groups

- **Category** (6 palettes): Distinct colors for categorical data

## See also

[`cheysson_pal`](https://friendly.github.io/ggCheysson/reference/cheysson_pal.md),
[`scale_color_cheysson`](https://friendly.github.io/ggCheysson/reference/scale_cheysson.md)

## Examples

``` r
# List available palettes
names(cheysson_palettes)
#>  [1] "1880_07" "1880_21" "1881_12" "1881_14" "1881_22" "1881_30" "1882_18"
#>  [8] "1883_13" "1883_21" "1883_31" "1886_11" "1886_17" "1886_18" "1886_24"
#> [15] "1886_26" "1886_28" "1887_22" "1888_27" "1891_14" "1891_19" "1891_25"
#> [22] "1895_16" "1900_28" "1906_06" "1906_50"

# Get colors from a specific palette
cheysson_palettes$`1880_07`$colors
#> [1] "#655564" "#c5602a" "#d8af4a" "#4e6c76" "#cc575e"

# Find palettes by type
sequential_pals <- Filter(function(x) x$type == "sequential", cheysson_palettes)
names(sequential_pals)
#> [1] "1881_12" "1886_26" "1888_27" "1891_19" "1891_25" "1895_16" "1900_28"
```
