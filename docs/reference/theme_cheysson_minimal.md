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

## Examples

``` r
if (FALSE) { # \dontrun{
ggplot(mtcars, aes(wt, mpg)) +
  geom_point() +
  theme_cheysson_minimal()
} # }
```
