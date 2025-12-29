# Get Cheysson pattern specifications

Returns pattern specifications from a Cheysson palette for use with
ggpattern.

## Usage

``` r
cheysson_pattern(palette = "1881_03", n = NULL, type = 1)
```

## Arguments

- palette:

  Name of palette (e.g., "1881_03") or palette type ("sequential",
  "diverging", "grouped", "category").

- n:

  Number of patterns to return. If NULL, returns all patterns.

- type:

  If palette is a type name, which palette of that type to use (default
  1).

## Value

A list of pattern specifications suitable for ggpattern

## Examples

``` r
# Get all patterns from a palette
cheysson_pattern("1881_03")
#> [[1]]
#> [[1]]$type
#> [1] "stripe"
#> 
#> [[1]]$fill
#> [1] "transparent"
#> 
#> [[1]]$pattern_fill
#> [1] "#1e3e69"
#> 
#> [[1]]$pattern_color
#> [1] "#1e3e69"
#> 
#> [[1]]$pattern_angle
#> [1] 135
#> 
#> [[1]]$pattern_density
#> [1] 0.9795918
#> 
#> [[1]]$pattern_spacing
#> [1] 0.02040816
#> 
#> [[1]]$pattern_linewidth
#> [1] 2
#> 
#> [[1]]$direction
#> [1] "diagonal_left"
#> 
#> 
#> [[2]]
#> [[2]]$type
#> [1] "crosshatch"
#> 
#> [[2]]$fill
#> [1] "transparent"
#> 
#> [[2]]$pattern_fill
#> [1] "#1e3e69"
#> 
#> [[2]]$pattern_color
#> [1] "#1e3e69"
#> 
#> [[2]]$pattern_density
#> [1] 0.9897959
#> 
#> [[2]]$pattern_spacing
#> [1] 0.01020408
#> 
#> [[2]]$pattern_linewidth
#> [1] 2
#> 
#> 
#> [[3]]
#> [[3]]$type
#> [1] "crosshatch"
#> 
#> [[3]]$fill
#> [1] "transparent"
#> 
#> [[3]]$pattern_fill
#> [1] "#1e3e69"
#> 
#> [[3]]$pattern_color
#> [1] "#1e3e69"
#> 
#> [[3]]$pattern_density
#> [1] 0.9923077
#> 
#> [[3]]$pattern_spacing
#> [1] 0.007692308
#> 
#> [[3]]$pattern_linewidth
#> [1] 3
#> 
#> 

# Get first 3 patterns
cheysson_pattern("1881_03", n = 3)
#> [[1]]
#> [[1]]$type
#> [1] "stripe"
#> 
#> [[1]]$fill
#> [1] "transparent"
#> 
#> [[1]]$pattern_fill
#> [1] "#1e3e69"
#> 
#> [[1]]$pattern_color
#> [1] "#1e3e69"
#> 
#> [[1]]$pattern_angle
#> [1] 135
#> 
#> [[1]]$pattern_density
#> [1] 0.9795918
#> 
#> [[1]]$pattern_spacing
#> [1] 0.02040816
#> 
#> [[1]]$pattern_linewidth
#> [1] 2
#> 
#> [[1]]$direction
#> [1] "diagonal_left"
#> 
#> 
#> [[2]]
#> [[2]]$type
#> [1] "crosshatch"
#> 
#> [[2]]$fill
#> [1] "transparent"
#> 
#> [[2]]$pattern_fill
#> [1] "#1e3e69"
#> 
#> [[2]]$pattern_color
#> [1] "#1e3e69"
#> 
#> [[2]]$pattern_density
#> [1] 0.9897959
#> 
#> [[2]]$pattern_spacing
#> [1] 0.01020408
#> 
#> [[2]]$pattern_linewidth
#> [1] 2
#> 
#> 
#> [[3]]
#> [[3]]$type
#> [1] "crosshatch"
#> 
#> [[3]]$fill
#> [1] "transparent"
#> 
#> [[3]]$pattern_fill
#> [1] "#1e3e69"
#> 
#> [[3]]$pattern_color
#> [1] "#1e3e69"
#> 
#> [[3]]$pattern_density
#> [1] 0.9923077
#> 
#> [[3]]$pattern_spacing
#> [1] 0.007692308
#> 
#> [[3]]$pattern_linewidth
#> [1] 3
#> 
#> 

# Get patterns from a sequential palette
cheysson_pattern("sequential")
#> [[1]]
#> [[1]]$type
#> [1] "stripe"
#> 
#> [[1]]$fill
#> [1] "transparent"
#> 
#> [[1]]$pattern_fill
#> [1] "#1e3e69"
#> 
#> [[1]]$pattern_color
#> [1] "#1e3e69"
#> 
#> [[1]]$pattern_angle
#> [1] 135
#> 
#> [[1]]$pattern_density
#> [1] 0.9795918
#> 
#> [[1]]$pattern_spacing
#> [1] 0.02040816
#> 
#> [[1]]$pattern_linewidth
#> [1] 2
#> 
#> [[1]]$direction
#> [1] "diagonal_left"
#> 
#> 
#> [[2]]
#> [[2]]$type
#> [1] "crosshatch"
#> 
#> [[2]]$fill
#> [1] "transparent"
#> 
#> [[2]]$pattern_fill
#> [1] "#1e3e69"
#> 
#> [[2]]$pattern_color
#> [1] "#1e3e69"
#> 
#> [[2]]$pattern_density
#> [1] 0.9897959
#> 
#> [[2]]$pattern_spacing
#> [1] 0.01020408
#> 
#> [[2]]$pattern_linewidth
#> [1] 2
#> 
#> 
#> [[3]]
#> [[3]]$type
#> [1] "crosshatch"
#> 
#> [[3]]$fill
#> [1] "transparent"
#> 
#> [[3]]$pattern_fill
#> [1] "#1e3e69"
#> 
#> [[3]]$pattern_color
#> [1] "#1e3e69"
#> 
#> [[3]]$pattern_density
#> [1] 0.9923077
#> 
#> [[3]]$pattern_spacing
#> [1] 0.007692308
#> 
#> [[3]]$pattern_linewidth
#> [1] 3
#> 
#> 
```
