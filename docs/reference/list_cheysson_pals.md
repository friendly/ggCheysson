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
#> 1  1880_07    grouped  1880     7        5
#> 2  1880_21   category  1880    21        7
#> 3  1881_12 sequential  1881    12        1
#> 4  1881_14    grouped  1881    14        2
#> 5  1881_22   category  1881    22        4
#> 6  1881_30    grouped  1881    30        5
#> 7  1882_18    grouped  1882    18        2
#> 8  1883_13   category  1883    13        4
#> 9  1883_21  diverging  1883    21        3
#> 10 1883_31  diverging  1883    31        2
#> 11 1886_11    grouped  1886    11        4
#> 12 1886_17    grouped  1886    17        3
#> 13 1886_18    grouped  1886    18        3
#> 14 1886_24    grouped  1886    24        3
#> 15 1886_26 sequential  1886    26        2
#> 16 1886_28   category  1886    28        3
#> 17 1887_22    grouped  1887    22        2
#> 18 1888_27 sequential  1888    27        1
#> 19 1891_14    grouped  1891    14        2
#> 20 1891_19 sequential  1891    19        1
#> 21 1891_25 sequential  1891    25        2
#> 22 1895_16 sequential  1895    16        3
#> 23 1900_28 sequential  1900    28        2
#> 24 1906_06   category  1906     6        6
#> 25 1906_50   category  1906    50        4

# List only sequential palettes
list_cheysson_pals("sequential")
#>      name       type album plate n_colors
#> 1 1881_12 sequential  1881    12        1
#> 2 1886_26 sequential  1886    26        2
#> 3 1888_27 sequential  1888    27        1
#> 4 1891_19 sequential  1891    19        1
#> 5 1891_25 sequential  1891    25        2
#> 6 1895_16 sequential  1895    16        3
#> 7 1900_28 sequential  1900    28        2

# List only category palettes
list_cheysson_pals("category")
#>      name     type album plate n_colors
#> 1 1880_21 category  1880    21        7
#> 2 1881_22 category  1881    22        4
#> 3 1883_13 category  1883    13        4
#> 4 1886_28 category  1886    28        3
#> 5 1906_06 category  1906     6        6
#> 6 1906_50 category  1906    50        4
```
