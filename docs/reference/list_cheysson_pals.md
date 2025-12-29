# List available Cheysson palettes

Returns information about available Cheysson color palettes, optionally
filtered by type.

## Usage

``` r
list_cheysson_pals(type = NULL)
```

## Arguments

- type:

  Optional palette type to filter by: "sequential", "diverging",
  "grouped", or "category". If NULL (default), returns all palettes.

## Value

A data frame with columns: name, type, album, plate, n_colors

## Examples

``` r
# List all palettes
list_cheysson_pals()
#>       name       type album plate n_colors
#> 1  1880_07   category  1880     7        7
#> 2  1881_03 sequential  1881     3        1
#> 3  1881_04   category  1881     4        4
#> 4  1881_08    grouped  1881     8        5
#> 5  1882_04    grouped  1882     4        2
#> 6  1883_04  diverging  1883     4        2
#> 7  1883_06   category  1883     6        4
#> 8  1883_07  diverging  1883     7        3
#> 9  1886_04 sequential  1886     4        2
#> 10 1886_07   category  1886     7        3
#> 11 1886_08    grouped  1886     8        4
#> 12 1887_06    grouped  1887     6        2
#> 13 1888_05 sequential  1888     5        1
#> 14 1891_03    grouped  1891     3        2
#> 15 1891_06 sequential  1891     6        1
#> 16 1891_07 sequential  1891     7        2
#> 17 1895_04 sequential  1895     4        3
#> 18 1900_06 sequential  1900     6        2
#> 19 1906_04   category  1906     4        4
#> 20 1906_06   category  1906     6        6

# List only sequential palettes
list_cheysson_pals("sequential")
#>      name       type album plate n_colors
#> 1 1881_03 sequential  1881     3        1
#> 2 1886_04 sequential  1886     4        2
#> 3 1888_05 sequential  1888     5        1
#> 4 1891_06 sequential  1891     6        1
#> 5 1891_07 sequential  1891     7        2
#> 6 1895_04 sequential  1895     4        3
#> 7 1900_06 sequential  1900     6        2

# List only category palettes
list_cheysson_pals("category")
#>      name     type album plate n_colors
#> 1 1880_07 category  1880     7        7
#> 2 1881_04 category  1881     4        4
#> 3 1883_06 category  1883     6        4
#> 4 1886_07 category  1886     7        3
#> 5 1906_04 category  1906     4        4
#> 6 1906_06 category  1906     6        6
```
