# Extract pattern parameters for ggpattern

Helper function to extract specific pattern parameters from a pattern
spec.

## Usage

``` r
get_pattern_param(pattern_spec, param, default = NA)
```

## Arguments

- pattern_spec:

  A pattern specification from cheysson_pattern()

- param:

  Parameter name to extract (e.g., "pattern_fill", "pattern_angle")

- default:

  Default value if parameter not found

## Value

The parameter value or default
