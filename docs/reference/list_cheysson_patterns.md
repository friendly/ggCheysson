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
#> 1  1880_07    grouped  1880     7          7
#> 2  1880_21   category  1880    21          7
#> 3  1881_12 sequential  1881    12          3
#> 4  1881_14    grouped  1881    14          4
#> 5  1881_22   category  1881    22          4
#> 6  1881_30    grouped  1881    30          8
#> 7  1882_18    grouped  1882    18          4
#> 8  1883_13   category  1883    13          5
#> 9  1883_21  diverging  1883    21          7
#> 10 1883_31  diverging  1883    31          4
#> 11 1886_11    grouped  1886    11          8
#> 12 1886_17    grouped  1886    17          4
#> 13 1886_18    grouped  1886    18          4
#> 14 1886_24    grouped  1886    24          8
#> 15 1886_26 sequential  1886    26          4
#> 16 1886_28   category  1886    28          6
#> 17 1887_22    grouped  1887    22          6
#> 18 1888_27 sequential  1888    27          5
#> 19 1891_14    grouped  1891    14          3
#> 20 1891_19 sequential  1891    19          6
#> 21 1891_25 sequential  1891    25          7
#> 22 1895_16 sequential  1895    16          4
#> 23 1900_28 sequential  1900    28          6
#> 24 1906_06   category  1906     6          6
#> 25 1906_50   category  1906    50          4

# List only sequential palettes
list_cheysson_patterns("sequential")
#>      name       type album plate n_patterns
#> 1 1881_12 sequential  1881    12          3
#> 2 1886_26 sequential  1886    26          4
#> 3 1888_27 sequential  1888    27          5
#> 4 1891_19 sequential  1891    19          6
#> 5 1891_25 sequential  1891    25          7
#> 6 1895_16 sequential  1895    16          4
#> 7 1900_28 sequential  1900    28          6
```
