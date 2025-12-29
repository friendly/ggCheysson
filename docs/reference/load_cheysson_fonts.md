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

## Examples

``` r
if (FALSE) { # \dontrun{
# Load fonts (default method)
load_cheysson_fonts()

# Use in a plot
library(ggplot2)
ggplot(mtcars, aes(wt, mpg)) +
  geom_point() +
  labs(title = "Using Cheysson Fonts") +
  theme(
    text = element_text(family = "Cheysson"),
    plot.title = element_text(family = "CheyssonTitle")
  )

# For saving plots with showtext
load_cheysson_fonts(method = "showtext")
showtext::showtext_auto()
# ... create plot ...
ggsave("plot.png")
showtext::showtext_auto(FALSE)
} # }
```
