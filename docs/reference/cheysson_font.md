# Get Cheysson font family name

Returns the appropriate Cheysson font family name for a given purpose.

## Usage

``` r
cheysson_font(type = c("regular", "italic", "sans", "outline", "title"))
```

## Arguments

- type:

  Font type: "regular", "italic", "sans", "outline", or "title"

## Value

Character string with font family name

## Examples

``` r
cheysson_font("title")  # Returns "CheyssonTitle"
#> [1] "CheyssonTitle"
cheysson_font("regular")  # Returns "Cheysson"
#> [1] "Cheysson"
```
