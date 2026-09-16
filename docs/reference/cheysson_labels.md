# Cheysson Palette Naming Crosswalk

A one-row-per-plate lookup table tying together every naming scheme used
for these 25 palettes: the package's own
[`cheysson_palettes`](https://friendly.github.io/ggCheysson/reference/cheysson_palettes.md)/
[`cheysson_patterns`](https://friendly.github.io/ggCheysson/reference/cheysson_patterns.md)
names, RJ Andrews' original Advent calendar labels, and Tom Shanley's
Observable notebook IDs. Useful whenever you have a palette identified
in someone else's terms - an Advent day, a David Rumsey catalog number,
or a label copied from Andrews' or Shanley's own work - and need the
package name to actually use it in
[`scale_color_cheysson()`](https://friendly.github.io/ggCheysson/reference/scale_cheysson.md)
and friends, or vice versa.

## Usage

``` r
cheysson_labels
```

## Format

A data frame with 25 rows and 10 variables:

- name:

  The package's current palette name (e.g. "1881_22") - pass this to
  [`scale_color_cheysson()`](https://friendly.github.io/ggCheysson/reference/scale_cheysson.md),
  [`cheysson_pal()`](https://friendly.github.io/ggCheysson/reference/cheysson_pal.md),
  [`cheysson_pattern()`](https://friendly.github.io/ggCheysson/reference/cheysson_pattern.md),
  etc. Unique; matches `names(cheysson_palettes)` and
  `names(cheysson_patterns)` exactly

- advent_day:

  Advent calendar day (1-25) from RJ Andrews' original digitization
  project, where he released one palette per day during December

- album_year:

  Year of the album (1880-1906)

- plate:

  The plate number within the album, derived from `rumsey_no`'s decimal
  suffix (e.g. "12511.007" -\> 7) - the real unique per-plate identifier
  that `name` is built from

- type:

  Palette type: "Sequential", "Diverging", "Grouped", or "Category"

- qty:

  Number of colors/pattern elements in the palette - despite the name,
  not a plate identifier (see `plate`)

- rumsey_no:

  David Rumsey Map Collection list number

- old_name:

  The name this palette would have received under the package's original
  (Album + `qty`) naming scheme, before a 2026-09-16 fix - kept for
  historical reference. Not unique: 4 pairs of genuinely different
  plates shared an `old_name`, silently overwriting one another during
  data extraction until the fix

- andrews_label:

  RJ Andrews' own label for this palette, in the form "Dec.DD-YYYY.PP"
  (Advent day - album year . plate)

- shanley_id:

  Tom Shanley's Observable notebook ID for this palette: `type` followed
  directly by `rumsey_no`'s digits with the dot removed (e.g.
  "diverging12514021")

## Source

- David Rumsey Map Collection: <https://www.davidrumsey.com/>

- RJ Andrews Album Colors:
  <https://github.com/infowetrust/albumcolors> - see also
  `man/figures/RJ-Andrews-color-palettes.jpg` in the package sources for
  his own reference grid of all 25 labeled palettes

- Tom Shanley Observable:
  <https://web.archive.org/web/20210130125506/https://observablehq.com/@tomshanley/cheysson-color-palettes> -
  see also `man/figures/shanley-palettes.png` in the package sources for
  his own reference grid of all 25 labeled palettes

- `data-raw/observable/albumColors.csv` (this package) - the original
  Advent day / Rumsey number / album / type mapping everything else here
  is derived from

## Details

This table exists because the package's own `name` (Album + plate) is a
convenient but package-internal convention - it isn't what you'll see if
you're reading Andrews' or Shanley's original write-ups, or working from
a Rumsey catalog reference. `andrews_label` and `shanley_id` are derived
programmatically from the verified rule linking all three schemes (album
year + plate, taken from `rumsey_no`'s decimal suffix), not scraped from
either source - both were cross-checked against every legible label/ID
in the reference images below and matched for all 24/24 checked. (Two of
Shanley's own ID *strings* have isolated typos - a digit transposition
and a missing trailing digit; his prose descriptions don't have these
typos, and this table's `shanley_id` gives the corrected form, not the
typo'd one.)

`old_name` also documents a real bug this table helped uncover: before
2026-09-16, palette names were built from `qty` (a color count) instead
of `plate` (the real per-plate identifier), causing 4 collisions between
genuinely different plates and silently dropping 5 of the original 25
palettes from the package. Comparing `name` to `old_name` shows exactly
what changed for each plate.

## See also

[`cheysson_palettes`](https://friendly.github.io/ggCheysson/reference/cheysson_palettes.md),
[`cheysson_patterns`](https://friendly.github.io/ggCheysson/reference/cheysson_patterns.md),
[`albumImages`](https://friendly.github.io/ggCheysson/reference/albumImages.md)

## Examples

``` r
# View the crosswalk
head(cheysson_labels)
#>      name advent_day album_year plate       type qty rumsey_no old_name
#> 1 1883_21          1       1883    21  Diverging   7 12514.021  1883_07
#> 2 1886_24          2       1886    24    Grouped   8 12516.024  1886_08
#> 3 1881_12          3       1881    12 Sequential   3 12512.012  1881_03
#> 4 1886_17          4       1886    17    Grouped   4 12516.017  1886_04
#> 5 1886_28          5       1886    28   Category   7 12516.028  1886_07
#> 6 1880_07          6       1880     7    Grouped   7 12511.007  1880_07
#>    andrews_label         shanley_id
#> 1 Dec.01-1883.21  diverging12514021
#> 2 Dec.02-1886.24    grouped12516024
#> 3 Dec.03-1881.12 sequential12512012
#> 4 Dec.04-1886.17    grouped12516017
#> 5 Dec.05-1886.28   category12516028
#> 6 Dec.06-1880.07    grouped12511007

# Find the package name for a palette described in Andrews' terms
cheysson_labels[cheysson_labels$andrews_label == "Dec.01-1883.21", "name"]
#> [1] "1883_21"

# Find the package name for a palette described in Shanley's terms
cheysson_labels[cheysson_labels$shanley_id == "grouped12511007", "name"]
#> [1] "1880_07"

# See what a palette used to be called before the 2026-09-16 naming fix
subset(cheysson_labels, name != old_name)[, c("name", "old_name")]
#>       name old_name
#> 1  1883_21  1883_07
#> 2  1886_24  1886_08
#> 3  1881_12  1881_03
#> 4  1886_17  1886_04
#> 5  1886_28  1886_07
#> 7  1886_11  1886_08
#> 8  1887_22  1887_06
#> 9  1888_27  1888_05
#> 10 1895_16  1895_04
#> 11 1891_14  1891_03
#> 12 1891_25  1891_07
#> 14 1882_18  1882_04
#> 15 1886_18  1886_04
#> 16 1883_31  1883_04
#> 17 1906_50  1906_04
#> 18 1900_28  1900_06
#> 19 1886_26  1886_04
#> 20 1891_19  1891_06
#> 21 1881_14  1881_04
#> 22 1883_13  1883_06
#> 23 1881_30  1881_08
#> 24 1880_21  1880_07
#> 25 1881_22  1881_04
```
