# Check if Cheysson fonts are loaded

Checks whether Cheysson fonts have been registered and are available for
use.

## Usage

``` r
cheysson_fonts_available(method = NULL)
```

## Arguments

- method:

  Check for "systemfonts" or "showtext". If NULL (default), checks both
  methods.

## Value

Logical indicating whether fonts are available

## Examples

``` r
if (cheysson_fonts_available()) {
  message("Cheysson fonts are ready to use!")
}
```
