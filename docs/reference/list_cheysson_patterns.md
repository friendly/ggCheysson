# List available Cheysson pattern palettes

Returns information about available Cheysson pattern palettes.

## Usage

``` r
list_cheysson_patterns(type = NULL)
```

## Arguments

- type:

  Optional palette type to filter by: "sequential", "diverging",
  "grouped", or "category". If NULL (default), returns all palettes.

## Value

A data frame with columns: name, type, album, plate, n_patterns

## Examples

``` r
# List all pattern palettes
list_cheysson_patterns()
#>       name       type album plate n_patterns
#> 1  1880_07   category  1880     7          7
#> 2  1881_03 sequential  1881     3          3
#> 3  1881_04   category  1881     4          4
#> 4  1881_08    grouped  1881     8          4
#> 5  1882_04    grouped  1882     4          3
#> 6  1883_04  diverging  1883     4          4
#> 7  1883_06   category  1883     6          5
#> 8  1883_07  diverging  1883     7          7
#> 9  1886_04 sequential  1886     4          3
#> 10 1886_07   category  1886     7          6
#> 11 1886_08    grouped  1886     8          8
#> 12 1887_06    grouped  1887     6          4
#> 13 1888_05 sequential  1888     5          5
#> 14 1891_03    grouped  1891     3          2
#> 15 1891_06 sequential  1891     6          6
#> 16 1891_07 sequential  1891     7          7
#> 17 1895_04 sequential  1895     4          4
#> 18 1900_06 sequential  1900     6          6
#> 19 1906_04   category  1906     4          4
#> 20 1906_06   category  1906     6          6

# List only sequential palettes
list_cheysson_patterns("sequential")
#>      name       type album plate n_patterns
#> 1 1881_03 sequential  1881     3          3
#> 2 1886_04 sequential  1886     4          3
#> 3 1888_05 sequential  1888     5          5
#> 4 1891_06 sequential  1891     6          6
#> 5 1891_07 sequential  1891     7          7
#> 6 1895_04 sequential  1895     4          4
#> 7 1900_06 sequential  1900     6          6
```
