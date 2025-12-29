# List available Cheysson fonts

Returns information about the Cheysson font families included in the
package.

## Usage

``` r
list_cheysson_fonts()
```

## Value

A data frame with font family names and descriptions

## Examples

``` r
list_cheysson_fonts()
#>                family                             description
#> 1            Cheysson        Regular serif font for body text
#> 2      CheyssonItalic             Italic variant for emphasis
#> 3    CheyssonSansCaps          Sans-serif capitals for labels
#> 4 CheyssonOutlineCaps Outlined capitals for decorative titles
#> 5       CheyssonTitle         Decorative font for main titles
#>                                  use
#> 1 General text, axis labels, legends
#> 2              Emphasis, annotations
#> 3        Axis labels, category names
#> 4              Plot titles, headings
#> 5                   Main plot titles
```
