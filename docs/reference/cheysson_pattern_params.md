# Create ggpattern-compatible pattern parameters

Converts Cheysson pattern specifications to parameters suitable for
ggpattern geoms.

## Usage

``` r
cheysson_pattern_params(patterns, param = "fill")
```

## Arguments

- patterns:

  List of pattern specifications from cheysson_pattern()

- param:

  Which parameter to extract: "type", "fill", "pattern_fill",
  "pattern_fill2", "pattern_angle", "pattern_density",
  "pattern_spacing", or "pattern_type". `"pattern_fill2"` is the color
  of a crosshatch's second set of lines; it equals `"pattern_fill"`
  except for the two-color crosshatches in `1883_30` and `1886_17`.

## Value

Vector of parameter values

## Examples

``` r
patterns <- cheysson_pattern("1881_12")
cheysson_pattern_params(patterns, "fill")
#> [1] "transparent" "transparent" "transparent"
cheysson_pattern_params(patterns, "pattern_angle")
#> [1] 135  45  45
```
