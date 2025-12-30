# Cheysson Pattern Data

Pattern specifications (fills and hatching) extracted from the Albums de
Statistique Graphique. These patterns combine solid colors with line
hatching (stripes and crosshatching) as used in Cheysson's maps.

## Usage

``` r
cheysson_patterns
```

## Format

A list of 20 pattern palettes, each containing:

- patterns:

  List of pattern specifications with fill colors and hatching
  parameters

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

- n_patterns:

  Number of patterns in the palette

## Source

Pattern specifications digitized from the David Rumsey Map Collection

## Details

Each pattern specification includes:

- **type**: "solid", "stripe", or "crosshatch"

- **fill**: Base fill color

- **pattern_fill**: Color for pattern lines

- **pattern_angle**: Angle of stripes (in degrees)

- **pattern_density**: Density of pattern lines (0-1)

- **pattern_spacing**: Spacing between pattern lines

- **pattern_linewidth**: Width of pattern lines

## See also

[`cheysson_pattern`](https://friendly.github.io/ggCheysson/reference/cheysson_pattern.md),
[`scale_pattern_fill_cheysson`](https://friendly.github.io/ggCheysson/reference/scale_pattern_cheysson.md)

## Examples

``` r
# List available pattern palettes
names(cheysson_patterns)
#>  [1] "1880_07" "1881_03" "1881_04" "1881_08" "1882_04" "1883_04" "1883_06"
#>  [8] "1883_07" "1886_04" "1886_07" "1886_08" "1887_06" "1888_05" "1891_03"
#> [15] "1891_06" "1891_07" "1895_04" "1900_06" "1906_04" "1906_06"

# Get patterns from a specific palette
cheysson_patterns$`1881_03`
#> $patterns
#> $patterns[[1]]
#> $patterns[[1]]$type
#> [1] "stripe"
#> 
#> $patterns[[1]]$fill
#> [1] "transparent"
#> 
#> $patterns[[1]]$pattern_fill
#> [1] "#1e3e69"
#> 
#> $patterns[[1]]$pattern_color
#> [1] "#1e3e69"
#> 
#> $patterns[[1]]$pattern_angle
#> [1] 135
#> 
#> $patterns[[1]]$pattern_density
#> [1] 0.9795918
#> 
#> $patterns[[1]]$pattern_spacing
#> [1] 0.02040816
#> 
#> $patterns[[1]]$pattern_linewidth
#> [1] 2
#> 
#> $patterns[[1]]$direction
#> [1] "diagonal_left"
#> 
#> 
#> $patterns[[2]]
#> $patterns[[2]]$type
#> [1] "crosshatch"
#> 
#> $patterns[[2]]$fill
#> [1] "transparent"
#> 
#> $patterns[[2]]$pattern_fill
#> [1] "#1e3e69"
#> 
#> $patterns[[2]]$pattern_color
#> [1] "#1e3e69"
#> 
#> $patterns[[2]]$pattern_density
#> [1] 0.9897959
#> 
#> $patterns[[2]]$pattern_spacing
#> [1] 0.01020408
#> 
#> $patterns[[2]]$pattern_linewidth
#> [1] 2
#> 
#> 
#> $patterns[[3]]
#> $patterns[[3]]$type
#> [1] "crosshatch"
#> 
#> $patterns[[3]]$fill
#> [1] "transparent"
#> 
#> $patterns[[3]]$pattern_fill
#> [1] "#1e3e69"
#> 
#> $patterns[[3]]$pattern_color
#> [1] "#1e3e69"
#> 
#> $patterns[[3]]$pattern_density
#> [1] 0.9923077
#> 
#> $patterns[[3]]$pattern_spacing
#> [1] 0.007692308
#> 
#> $patterns[[3]]$pattern_linewidth
#> [1] 3
#> 
#> 
#> 
#> $type
#> [1] "sequential"
#> 
#> $album
#> [1] 1881
#> 
#> $plate
#> [1] 3
#> 
#> $rumsey_no
#> [1] 12512.01
#> 
#> $dec_day
#> [1] 3
#> 
#> $n_patterns
#> [1] 3
#> 
```
