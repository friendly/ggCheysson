# Apply Cheysson patterns to fill aesthetic

Convenience function that applies the base fill color from Cheysson
patterns. Use in combination with pattern\_\* scales for full pattern
effect.

## Usage

``` r
scale_fill_cheysson_pattern(palette = "1881_03", reverse = FALSE, ...)
```

## Arguments

- palette:

  Name of palette (e.g., "1881_03") or palette type ("sequential",
  "diverging", "grouped", "category"). Default is "1881_03".

- reverse:

  Whether to reverse the pattern order. Default is FALSE.

- ...:

  Additional arguments passed to ggplot2 scale functions

## Examples

``` r
if (FALSE) { # \dontrun{
ggplot(mpg, aes(class, fill = class)) +
  geom_bar_pattern(aes(pattern_type = class)) +
  scale_fill_cheysson_pattern("category") +
  scale_pattern_type_cheysson("category")
} # }
```
