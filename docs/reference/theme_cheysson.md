# Cheysson theme for ggplot2

A ggplot2 theme inspired by the visual style of the Albums de
Statistique Graphique, using Cheysson fonts and appropriate styling.

## Usage

``` r
theme_cheysson(
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

A ggplot2 theme object

## Details

This theme applies the following styling:

- Cheysson fonts for all text elements

- Minimal grid lines

- Classic axis styling

- Subtle colors matching historical aesthetics

Font selection:

- Plot title: CheyssonTitle (decorative)

- Axis titles: CheyssonSansCaps (capitals)

- Body text: Cheysson (regular)

## Examples

``` r
if (FALSE) { # \dontrun{
library(ggplot2)

# Basic usage
ggplot(mtcars, aes(wt, mpg)) +
  geom_point() +
  labs(title = "Automobile Statistics") +
  theme_cheysson()

# With Cheysson color palette
ggplot(iris, aes(Sepal.Length, Sepal.Width, color = Species)) +
  geom_point(size = 3) +
  scale_color_cheysson("1881_04") +
  theme_cheysson()
} # }
```
