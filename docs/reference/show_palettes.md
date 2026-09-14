# Display multiple Cheysson palettes

Creates a visual display of multiple color palettes, useful for
comparing palettes or showing all palettes of a certain type.

## Usage

``` r
show_palettes(palettes = NULL, ncol = 1, cex = 0.8)
```

## Arguments

- palettes:

  Character vector of palette names. If NULL (default), shows all
  palettes. Can also be a palette type ("sequential", "diverging",
  "grouped", "category") to show all palettes of that type.

- ncol:

  Number of columns for layout (default 1).

- cex:

  Text size multiplier (default 0.8).

## Value

Invisibly returns NULL. The function is called for its side effect of
creating a plot.

## Examples

``` r
# Show all sequential palettes (use ncol > 1 to keep panels legible with
# several palettes; a tall single-column layout can also fail to render
# when captured for the pkgdown reference site)
show_palettes("sequential", ncol = 2)


# Show specific palettes
show_palettes(c("1880_07", "1881_03", "1895_04"))

```
