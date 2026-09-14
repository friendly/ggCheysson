# Cheysson Font Families

Metadata about the five Cheysson font families included in the package,
describing their characteristics and recommended uses.

## Usage

``` r
cheysson_fonts
```

## Format

A data frame with 5 rows and 4 variables:

- family:

  Font family name (e.g., "Cheysson", "CheyssonTitle")

- description:

  Brief description of the font style

- use:

  Recommended use cases for the font

- file:

  TrueType font filename in the inst/fonts/ directory

## Source

Font families created by Kenneth Fields (ESRI) based on the lettering
style of Émile Cheysson's Albums de Statistique Graphique.

## Details

The package includes five hand-drawn font families created by Kenneth
Fields (ESRI) to match the lettering style of the original Albums de
Statistique Graphique:

- **Cheysson**: Regular serif font suitable for body text, axis labels,
  and legends

- **CheyssonItalic**: Italic variant for emphasis and annotations

- **CheyssonSansCaps**: Sans-serif capitals for axis labels and category
  names

- **CheyssonOutlineCaps**: Outlined capitals for decorative plot titles
  and headings

- **CheyssonTitle**: Decorative font for main plot titles

These fonts must be loaded before use with
[`load_cheysson_fonts`](https://friendly.github.io/ggCheysson/reference/load_cheysson_fonts.md).
The Cheysson themes
([`theme_cheysson`](https://friendly.github.io/ggCheysson/reference/theme_cheysson.md),
etc.) automatically select appropriate fonts for different plot
elements.

## See also

[`load_cheysson_fonts`](https://friendly.github.io/ggCheysson/reference/load_cheysson_fonts.md),
[`cheysson_fonts_available`](https://friendly.github.io/ggCheysson/reference/cheysson_fonts_available.md),
[`theme_cheysson`](https://friendly.github.io/ggCheysson/reference/theme_cheysson.md)

## Examples

``` r
# View font metadata
cheysson_fonts
#>                family                             description
#> 1            Cheysson        Regular serif font for body text
#> 2      CheyssonItalic             Italic variant for emphasis
#> 3    CheyssonSansCaps          Sans-serif capitals for labels
#> 4 CheyssonOutlineCaps Outlined capitals for decorative titles
#> 5       CheyssonTitle         Decorative font for main titles
#>                                  use                            file
#> 1 General text, axis labels, legends     CheyssonRegular-Regular.ttf
#> 2              Emphasis, annotations       CheyssonItalic-Italic.ttf
#> 3        Axis labels, category names    CheyssonSansCaps-Regular.ttf
#> 4              Plot titles, headings CheyssonOutlineCaps-Regular.ttf
#> 5                   Main plot titles       CheyssonTitle-Regular.ttf

# Get recommended uses
cheysson_fonts[, c("family", "use")]
#>                family                                use
#> 1            Cheysson General text, axis labels, legends
#> 2      CheyssonItalic              Emphasis, annotations
#> 3    CheyssonSansCaps        Axis labels, category names
#> 4 CheyssonOutlineCaps              Plot titles, headings
#> 5       CheyssonTitle                   Main plot titles

# Find the title font
subset(cheysson_fonts, grepl("title", use, ignore.case = TRUE))
#>                family                             description
#> 4 CheyssonOutlineCaps Outlined capitals for decorative titles
#> 5       CheyssonTitle         Decorative font for main titles
#>                     use                            file
#> 4 Plot titles, headings CheyssonOutlineCaps-Regular.ttf
#> 5      Main plot titles       CheyssonTitle-Regular.ttf
```
