# Apply a Cheysson color-and-pattern palette in one step

**Experimental.** The interface of `scale_cheysson()` and
`aes_cheysson()` may change in a future version.

## Usage

``` r
scale_cheysson(
  palette = "1881_12",
  reverse = FALSE,
  aesthetics = c("fill", "pattern", "pattern_fill", "pattern_fill2", "pattern_angle"),
  na.value = "grey80",
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

- aesthetics:

  Which aesthetics to provide scales for: any of `"fill"`, `"pattern"`,
  `"pattern_fill"`, `"pattern_fill2"`, `"pattern_angle"`. Default is all
  of them. A scale for an aesthetic that the plot does not map has no
  effect.

- na.value:

  Color for missing values, used for the fill and line colors; missing
  values get no hatching (`pattern = "none"`).

- ...:

  For `scale_cheysson()`: additional arguments passed to every scale,
  e.g. `name` or `labels`; since all the scales get the same `name`,
  their legends stay merged into one. For `aes_cheysson()`: other
  aesthetic mappings to include, e.g. `x` and `y`.

- x:

  The variable to map, as in
  [`ggplot2::aes()`](https://ggplot2.tidyverse.org/reference/aes.html).

## Value

`scale_cheysson()` returns a list of ggplot2 discrete scales, which can
be added to a plot with `+` like a single scale.

`aes_cheysson()` returns an aesthetic mapping of `x` to `fill`,
`pattern`, `pattern_fill`, `pattern_fill2` and `pattern_angle`, plus any
mappings in `...`.

## Details

Cheysson's palettes combine colors with hatching: each element of a
palette has a paper or fill color, a hatch type (solid, stripe or
crosshatch), a line color and an angle. Drawing them with 'ggpattern'
takes one scale per aesthetic
([`scale_fill_cheysson_pattern()`](https://friendly.github.io/ggCheysson/reference/scale_fill_cheysson_pattern.md),
[`scale_pattern_type_cheysson()`](https://friendly.github.io/ggCheysson/reference/scale_pattern_cheysson.md),
[`scale_pattern_fill_cheysson()`](https://friendly.github.io/ggCheysson/reference/scale_pattern_cheysson.md),
...). `scale_cheysson()` adds all of them with a single `+`, and
`aes_cheysson()` maps one variable to all of the matching aesthetics.

All the scales take their values from the same elements of the palette,
so each level of the mapped variable gets one complete historical
swatch. The aesthetics must be mapped for the scales to apply: a scale
for `pattern_fill` does nothing unless `pattern_fill` is mapped, and
'ggpattern' then draws grey hatching. `aes_cheysson()` maps them all.

Parameters that are better set to fixed values in the geom are not
included: `pattern_density` and `pattern_spacing` (the palettes'
spacings were measured on small swatches, see the Guerry maps vignette),
`pattern_colour` (`NA` avoids outlines around the hatch lines) and the
outline `colour`.

## See also

[scale_pattern_cheysson](https://friendly.github.io/ggCheysson/reference/scale_pattern_cheysson.md)
for the individual scales,
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

  ggplot(data, aes(category, value)) +
    geom_col_pattern(aes_cheysson(category),
                     pattern_colour = NA, pattern_density = 0.35,
                     colour = "black") +
    scale_cheysson("1883_30") +
    theme_minimal()
}

# }
```
