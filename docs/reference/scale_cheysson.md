# Apply a Cheysson color-and-pattern palette in one step

**Experimental.** The interface of `scale_cheysson()` may change in a
future version.

## Usage

``` r
scale_cheysson(
  palette = "1881_12",
  reverse = FALSE,
  na.value = "none",
  aesthetics = NULL,
  ...
)

aes_cheysson(x, ...)
```

## Arguments

- palette:

  Name of palette (e.g., "1883_30") or palette type ("sequential",
  "diverging", "grouped", "category"). See
  [cheysson_patterns](https://friendly.github.io/ggCheysson/reference/cheysson_patterns.md).

- reverse:

  Whether to reverse the palette order. Default is FALSE.

- na.value:

  Pattern for missing values. The default, `"none"`, draws the geom's
  own `fill`, which no swatch shows, so e.g.
  `geom_col_pattern(fill = "grey80")` sets the color for missing values.

- aesthetics:

  Deprecated and ignored: `scale_cheysson()` used to return one scale
  per aesthetic. To use only some of a palette's properties, use the
  individual scales (see
  [scale_pattern_cheysson](https://friendly.github.io/ggCheysson/reference/scale_pattern_cheysson.md)).

- ...:

  Additional arguments passed to
  [`ggplot2::discrete_scale()`](https://ggplot2.tidyverse.org/reference/discrete_scale.html),
  e.g. `name`, `labels` or `guide`. For `aes_cheysson()`: other
  aesthetic mappings to include, e.g. `x` and `y`.

- x:

  The variable to map, as in
  [`ggplot2::aes()`](https://ggplot2.tidyverse.org/reference/aes.html).

## Value

`scale_cheysson()` returns a ggplot2 discrete scale for the `pattern`
aesthetic.

`aes_cheysson()` returns an aesthetic mapping of `x` to `pattern`, plus
any mappings in `...`.

## Details

Cheysson's palettes combine colors with hatching: each element of a
palette has a paper or fill color, a hatch type (solid, stripe or
crosshatch), line colors and an angle. ggCheysson registers each element
as a 'ggpattern' pattern of its own, a *swatch* (see
[cheysson_swatches](https://friendly.github.io/ggCheysson/reference/cheysson_swatches.md)),
and `scale_cheysson()` is a discrete scale for the `pattern` aesthetic
that gives each level of the mapped variable one swatch. So a palette
needs only `aes(pattern = x)` and this one scale.

For a sequential or diverging palette with more elements than the data
has levels, the scale uses elements spread over the whole palette
(keeping both ends), not the first ones. See
[cheysson_patterns](https://friendly.github.io/ggCheysson/reference/cheysson_patterns.md)
for the stored order.

The swatches set their own colors, angles, line spacing and density, so
no other pattern aesthetics need to be mapped or set, and those that are
(e.g. `pattern_fill`) are ignored, apart from `pattern_spacing`,
`pattern_density` and `pattern_units`. What these mean depends on the
installed version of 'ggpattern'; see
[cheysson_swatches](https://friendly.github.io/ggCheysson/reference/cheysson_swatches.md).

`aes_cheysson(x)` is deprecated: it is now the same as
`aes(pattern = x)`, since the other aesthetics it used to map aren't
needed.

## See also

[cheysson_swatches](https://friendly.github.io/ggCheysson/reference/cheysson_swatches.md)
for the swatches;
[scale_pattern_cheysson](https://friendly.github.io/ggCheysson/reference/scale_pattern_cheysson.md)
for the individual scales, one per pattern aesthetic;
[`cheysson_pattern()`](https://friendly.github.io/ggCheysson/reference/cheysson_pattern.md)
for the underlying pattern specifications.

## Examples

``` r
# \donttest{
if (requireNamespace("ggpattern", quietly = TRUE)) {
  library(ggplot2)
  library(ggpattern)

  data <- data.frame(
    category = LETTERS[1:5],
    value = c(15, 23, 18, 20, 12)
  )

  ggplot(data, aes(category, value, pattern = category)) +
    geom_col_pattern(colour = "black") +
    scale_cheysson("1883_30") +
    theme_minimal()
}

# }
```
