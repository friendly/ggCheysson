# Load Cheysson fonts

Registers the Cheysson font families for use in plots. This function
should be called before using Cheysson fonts in ggplot2.

## Usage

``` r
load_cheysson_fonts(method = c("systemfonts", "showtext"))
```

## Arguments

- method:

  Font loading method: "systemfonts" (default) or "showtext".
  systemfonts is recommended for most uses. showtext is useful for
  saving plots to files.

## Value

Invisibly returns a character vector of loaded font family names

## Details

The package includes five Cheysson font families:

- **Cheysson**: Regular serif font for body text

- **CheyssonItalic**: Italic variant

- **CheyssonSansCaps**: Sans-serif capitals

- **CheyssonOutlineCaps**: Outlined capitals for titles

- **CheyssonTitle**: Decorative font for titles

When using showtext, you must call
[`showtext::showtext_auto()`](https://rdrr.io/pkg/showtext/man/showtext_auto.html)
before creating plots, and `showtext::showtext_auto(FALSE)` when done.

**Windows users**: The systemfonts method works for saved plots (with
ragg) but custom fonts won't appear in the on-screen plot window. For
on-screen preview with fonts:

- Use `method = "showtext"` instead, or

- In RStudio: Tools \> Global Options \> General \> Graphics \> Backend:
  "AGG"

For saving plots with systemfonts, use
`ggsave(..., device = ragg::agg_png)`.

## Examples

``` r
# \donttest{
# Load fonts (default method)
load_cheysson_fonts()
#> Loaded 5 Cheysson font families using systemfonts
#> 
#> Windows users - Important notes:
#>   * Fonts work in SAVED plots: use ggsave(..., device = ragg::agg_png)
#>   * Fonts DON'T appear in on-screen plot window with systemfonts
#>   * For on-screen preview: use load_cheysson_fonts(method = 'showtext')
#>   * Or in RStudio: Tools > Global Options > Graphics > Backend: 'AGG'

# Use in a plot
library(ggplot2)
p <- ggplot(mtcars, aes(wt, mpg)) +
  geom_point() +
  labs(title = "Using Cheysson Fonts") +
  theme(
    text = element_text(family = "Cheysson"),
    plot.title = element_text(family = "CheyssonTitle")
  )

# Save to temporary file
tmp <- tempfile(fileext = ".png")
if (requireNamespace("ragg", quietly = TRUE)) {
  ggsave(tmp, p, device = ragg::agg_png)
} else {
  ggsave(tmp, p)
}
#> Saving 6.67 x 6.67 in image
unlink(tmp)
# }
```
