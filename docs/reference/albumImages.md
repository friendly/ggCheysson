# Album Images Metadata

Metadata linking the 25 color palettes from the Albums de Statistique
Graphique to their corresponding album years, plate numbers, and David
Rumsey collection reference numbers.

## Usage

``` r
albumImages
```

## Format

A data frame with 25 rows and 6 variables:

- adventDay:

  Advent calendar day number (1-25) from original digitization

- RumseyListNo:

  David Rumsey Map Collection list number

- Album:

  Year of the album (1880-1906)

- Qty:

  Plate number within the album

- Type:

  Palette type: "Sequential", "Diverging", "Grouped", or "Category"

- link:

  URL to the digitized image in the David Rumsey Map Collection

## Source

- David Rumsey Map Collection: <https://www.davidrumsey.com/>

- RJ Andrews Album Colors: <https://github.com/infowetrust/albumcolors>

- Tom Shanley Observable:
  <https://observablehq.com/@tomshanley/cheysson-color-palettes>

## Details

This dataset provides the mapping between the original SVG pattern files
(named by Advent calendar days by RJ Andrews) and the actual album years
and plate numbers from the *Albums de Statistique Graphique*.

The naming convention "adventDay" comes from RJ Andrews' original
digitization project where he released one palette per day during
December as an Advent calendar. The package uses the Album year and
plate number for more intuitive palette naming (e.g., "1880_07" instead
of "dec06").

## See also

[`cheysson_palettes`](https://friendly.github.io/ggCheysson/reference/cheysson_palettes.md),
[`cheysson_patterns`](https://friendly.github.io/ggCheysson/reference/cheysson_patterns.md)

## Examples

``` r
# View the dataset
head(albumImages)
#> # A tibble: 6 × 6
#>   adventDay RumseyListNo Album   Qty Type       link                            
#>       <dbl>        <dbl> <dbl> <dbl> <chr>      <chr>                           
#> 1         1       12514.  1883     7 Diverging  https://www.davidrumsey.com/lun…
#> 2         2       12516.  1886     8 Grouped    https://www.davidrumsey.com/lun…
#> 3         3       12512.  1881     3 Sequential https://www.davidrumsey.com/lun…
#> 4         4       12516.  1886     4 Grouped    https://www.davidrumsey.com/lun…
#> 5         5       12516.  1886     7 Category   https://www.davidrumsey.com/lun…
#> 6         6       12511.  1880     7 Grouped    https://www.davidrumsey.com/lun…

# Find information about a specific album
subset(albumImages, Album == 1880)
#> # A tibble: 2 × 6
#>   adventDay RumseyListNo Album   Qty Type     link                              
#>       <dbl>        <dbl> <dbl> <dbl> <chr>    <chr>                             
#> 1         6       12511.  1880     7 Grouped  https://www.davidrumsey.com/luna/…
#> 2        24       12511.  1880     7 Category https://www.davidrumsey.com/luna/…

# Count palettes by type
table(albumImages$Type)
#> 
#>   Category  Diverging    Grouped Sequential 
#>          6          2         10          7 

# Get the Rumsey link for a specific palette
albumImages[albumImages$Album == 1881 & albumImages$Qty == 3, "link"]
#> # A tibble: 1 × 1
#>   link                                                                          
#>   <chr>                                                                         
#> 1 https://www.davidrumsey.com/luna/servlet/detail/RUMSEY~8~1~309110~90078973:Ca…
```
