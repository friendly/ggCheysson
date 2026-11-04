# Display the Cheysson swatches

Draws an atlas of the swatches (see
[cheysson_swatches](https://friendly.github.io/ggCheysson/reference/cheysson_swatches.md)):
one row per palette, one column per element, with the rows grouped into
panels by palette type. Each cell is drawn by the registered swatch
itself, so the swatch for a cell is named by its row and column, e.g.
row `1886_28`, column 3 is `"1886_28-3"`.

## Usage

``` r
show_swatches(palettes = NULL)
```

## Arguments

- palettes:

  Character vector of palette names. If NULL (default), shows all
  palettes. Can also be one or more palette types ("sequential",
  "diverging", "grouped", "category") to show all palettes of those
  types.

## Value

A ggplot object, which draws the atlas when printed. Requires the
'ggpattern' package.

## See also

[cheysson_swatches](https://friendly.github.io/ggCheysson/reference/cheysson_swatches.md),
[`scale_cheysson()`](https://friendly.github.io/ggCheysson/reference/scale_cheysson.md),
[`show_palettes()`](https://friendly.github.io/ggCheysson/reference/show_palettes.md)

## Examples

``` r
if (requireNamespace("ggpattern", quietly = TRUE)) {
  show_swatches("sequential")
}

```
