# Cheysson pattern scales for ggpattern

Pattern fill scales using Cheysson patterns from the Albums de
Statistique Graphique. These scales work with ggpattern geoms to apply
both colors and hatching patterns.

## Usage

``` r
scale_pattern_fill_cheysson(palette = "1881_03", reverse = FALSE, ...)

scale_pattern_type_cheysson(palette = "1881_03", reverse = FALSE, ...)

scale_pattern_angle_cheysson(palette = "1881_03", reverse = FALSE, ...)

scale_pattern_density_cheysson(palette = "1881_03", reverse = FALSE, ...)
```

## Arguments

- palette:

  Name of palette (e.g., "1881_03") or palette type ("sequential",
  "diverging", "grouped", "category"). Default is "1881_03".

- reverse:

  Whether to reverse the pattern order. Default is FALSE.

- ...:

  Additional arguments passed to ggplot2 scale functions

## Value

A ggplot2 discrete scale object for the specified pattern aesthetic
(pattern_fill, pattern_type, pattern_angle, or pattern_density). These
scales apply the historically accurate Cheysson patterns to ggpattern
geoms.

## Details

These scales require the ggpattern package. Use with ggpattern geoms
like
[`geom_col_pattern()`](https://trevorldavis.com/R/ggpattern/reference/geom-docs.html),
[`geom_bar_pattern()`](https://trevorldavis.com/R/ggpattern/reference/geom-docs.html),
etc.

The scales apply multiple pattern aesthetics simultaneously:

- `fill`: Base fill color

- `pattern_type`: Type of pattern (none, stripe, crosshatch)

- `pattern_fill`: Color of pattern lines

- `pattern_angle`: Angle of stripes

- `pattern_density`: Density of pattern lines

## Examples

``` r
# \donttest{
# Requires ggpattern package
if (requireNamespace("ggpattern", quietly = TRUE)) {
  library(ggplot2)
  library(ggpattern)

  # Basic bar chart with patterns
  data <- data.frame(
    category = LETTERS[1:4],
    value = c(15, 23, 18, 20)
  )

  ggplot(data, aes(category, value, fill = category)) +
    geom_col_pattern(
      aes(
        pattern_type = category,
        pattern_fill = category,
        pattern_angle = category
      ),
      pattern = "stripe",
      pattern_density = 0.3,
      color = "black"
    ) +
    scale_pattern_fill_cheysson("category") +
    scale_pattern_type_cheysson("category") +
    scale_pattern_angle_cheysson("category") +
    theme_minimal()
}

# }
```
