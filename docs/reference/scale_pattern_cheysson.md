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

## Details

These scales require the ggpattern package. Use with ggpattern geoms
like `geom_col_pattern()`, `geom_bar_pattern()`, etc.

The scales apply multiple pattern aesthetics simultaneously:

- `fill`: Base fill color

- `pattern_type`: Type of pattern (none, stripe, crosshatch)

- `pattern_fill`: Color of pattern lines

- `pattern_angle`: Angle of stripes

- `pattern_density`: Density of pattern lines

## Examples

``` r
if (FALSE) { # \dontrun{
library(ggplot2)
library(ggpattern)

# Basic bar chart with patterns
ggplot(mpg, aes(class, fill = class)) +
  geom_bar_pattern(
    aes(
      pattern_type = class,
      pattern_fill = class,
      pattern_angle = class
    ),
    pattern = "stripe",
    pattern_density = 0.3,
    pattern_spacing = 0.025,
    color = "black"
  ) +
  scale_pattern_fill_cheysson("category") +
  scale_pattern_type_cheysson("category") +
  theme_minimal()

# Use specific palette
ggplot(iris, aes(Species, Sepal.Width, fill = Species)) +
  geom_col_pattern(
    aes(pattern_type = Species, pattern_fill = Species),
    position = "dodge"
  ) +
  scale_pattern_fill_cheysson("1881_03")
} # }
```
