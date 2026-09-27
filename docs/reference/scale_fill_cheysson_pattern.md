# Apply Cheysson patterns to fill aesthetic

Convenience function that applies the base fill color from Cheysson
patterns. Use in combination with pattern\_\* scales for full pattern
effect.

## Usage

``` r
scale_fill_cheysson_pattern(palette = "1881_12", reverse = FALSE, ...)
```

## Arguments

- palette:

  Name of palette (e.g., "1881_12") or palette type ("sequential",
  "diverging", "grouped", "category"). Default is "1881_12".

- reverse:

  Whether to reverse the pattern order. Default is FALSE.

- ...:

  Additional arguments passed to ggplot2 scale functions

## Value

A ggplot2 discrete scale object for the fill aesthetic. Applies the base
fill colors from Cheysson patterns.

## Examples

``` r
# \donttest{
# Requires ggpattern package
if (requireNamespace("ggpattern", quietly = TRUE)) {
  library(ggplot2)
  library(ggpattern)

  data <- data.frame(
    category = LETTERS[1:4],
    value = c(15, 23, 18, 20)
  )

  ggplot(data, aes(category, value, fill = category)) +
    geom_col_pattern(aes(pattern = category)) +
    scale_fill_cheysson_pattern("category") +
    scale_pattern_type_cheysson("category") +
    theme_minimal()
}

# }
```
