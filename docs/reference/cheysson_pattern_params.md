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
  "pattern_angle", "pattern_density", "pattern_spacing", or
  "pattern_type"

## Value

Vector of parameter values

## Examples

``` r
if (FALSE) { # \dontrun{
patterns <- cheysson_pattern("1881_03")
cheysson_pattern_params(patterns, "fill")
cheysson_pattern_params(patterns, "pattern_angle")
} # }
```
