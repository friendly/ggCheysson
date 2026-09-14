# Minimal Cheysson theme

A more minimal version of theme_cheysson with fewer grid lines, suitable
for maps and diagrams.

## Usage

``` r
theme_cheysson_minimal(
  base_size = 11,
  base_family = "auto",
  title_family = "auto",
  axis_title_family = "auto",
  load_fonts = TRUE
)
```

## Arguments

- base_size:

  Base font size (default: 11)

- base_family:

  Base font family. If "auto" (default), uses Cheysson if available,
  otherwise falls back to sans-serif

- title_family:

  Font family for titles (default: "auto")

- axis_title_family:

  Font family for axis titles (default: "auto")

- load_fonts:

  Automatically load Cheysson fonts if not already loaded (default:
  TRUE)

## Value

A ggplot2 theme object that can be added to a plot with `+`.

## Examples

``` r
if (FALSE) { # \dontrun{
# Not run automatically: see theme_cheysson() for why (same font/grid crash).
library(ggplot2)

# Load fonts first
load_cheysson_fonts()

ggplot(mtcars, aes(wt, mpg)) +
  geom_point() +
  theme_cheysson_minimal()
} # }
```
