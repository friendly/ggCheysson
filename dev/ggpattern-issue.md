**Title:** Question: a better way to apply color + pattern "swatches" across several pattern aesthetics?

Hi Trevor,

Thanks for ggpattern - it's what makes [ggCheysson](https://friendly.github.io/ggCheysson/)
possible. ggCheysson (on CRAN, 1.1.0) brings the graphic style of Émile Cheysson's
*Albums de Statistique Graphique* (1880s) to ggplot2: color palettes, hatching patterns and fonts.
I'd value your opinion on how I've handled one recurring problem, and whether there is a better way.

## The problem

In Cheysson's maps and charts, a class is rarely shown by color alone. Each element of one of his
palettes is a small bundle of properties - a "swatch": a paper or fill color, a hatch type, the
color of the hatch lines (in some crosshatches, a different color for each set of lines), and the
angle. For example, the six elements of palette `1886_28`:

```r
library(ggCheysson)   # install.packages("ggCheysson")
pats <- cheysson_pattern("1886_28")
data.frame(
  pattern       = cheysson_pattern_params(pats, "pattern_type"),
  fill          = cheysson_pattern_params(pats, "fill"),
  pattern_fill  = cheysson_pattern_params(pats, "pattern_fill"),
  pattern_fill2 = cheysson_pattern_params(pats, "pattern_fill2"),
  pattern_angle = cheysson_pattern_params(pats, "pattern_angle")
)
#>   pattern        fill pattern_fill pattern_fill2 pattern_angle
#> 1  stripe transparent      #d61d21       #d61d21            90
#> 2  stripe transparent      #53679b       #53679b             0
#> 3  stripe transparent      #060304       #060304             0
#> 4    none     #53679b      #53679b       #53679b            45
#> 5    none     #d61d21      #d61d21       #d61d21            45
#> 6    none     #060304      #060304       #060304            45
```

With ggpattern, each property is a separate aesthetic, so applying one palette to one variable
takes a mapping *and* a scale for each of them.

## Before: one mapping and one scale per aesthetic

ggCheysson has a discrete scale for each aesthetic, each taking its values from the same palette:

```r
library(ggplot2)
library(ggpattern)

trade <- data.frame(
  country = c("France", "England", "Germany", "Italy"),
  exports = c(2350, 3120, 2680, 1890)
)

ggplot(trade, aes(country, exports)) +
  geom_col_pattern(
    aes(fill = country, pattern = country, pattern_fill = country,
        pattern_fill2 = country, pattern_angle = country),
    pattern_colour = NA, pattern_density = 0.3, pattern_spacing = 0.025,
    colour = "black"
  ) +
  scale_fill_cheysson_pattern("1886_28") +
  scale_pattern_type_cheysson("1886_28") +
  scale_pattern_fill_cheysson("1886_28") +
  scale_pattern_fill2_cheysson("1886_28") +
  scale_pattern_angle_cheysson("1886_28")
```

## After: two helpers (experimental, in 1.1.0)

```r
ggplot(trade, aes(country, exports)) +
  geom_col_pattern(
    aes_cheysson(country),
    pattern_colour = NA, pattern_density = 0.3, pattern_spacing = 0.025,
    colour = "black"
  ) +
  scale_cheysson("1886_28")
```

![Exports by nation, drawn with aes_cheysson() and scale_cheysson()](https://friendly.github.io/ggCheysson/articles/combining-colors-patterns_files/figure-html/short-form-1.png)

Both versions produce byte-identical images. The implementation is small:

- [`scale_cheysson()`](https://github.com/friendly/ggCheysson/blob/v1.1.0/R/scale_cheysson.R#L69-L89)
  returns a **list** of the five discrete scales, which `+` adds in one step. Each is built by
  [`cheysson_pattern_scale()`](https://github.com/friendly/ggCheysson/blob/v1.1.0/R/scale_patterns.R#L147-L158),
  a `ggplot2::discrete_scale()` whose `palette` function picks values for one parameter from the
  same palette elements, so each level gets one complete swatch. Arguments in `...` (e.g. `name`)
  go to every scale, which keeps the legends merged into one.
- [`aes_cheysson(x, ...)`](https://github.com/friendly/ggCheysson/blob/v1.1.0/R/scale_cheysson.R#L98-L101)
  is just `aes(fill = {{ x }}, pattern = {{ x }}, pattern_fill = {{ x }}, pattern_fill2 = {{ x }}, pattern_angle = {{ x }}, ...)`.

The helper for the mappings turned out to be necessary: a scale for an aesthetic that isn't mapped
does nothing. With only `fill` and `pattern` mapped, the three striped bars all get ggpattern's
default grey lines at its default angle, and can't be told apart.

For missing values, I followed your convention from #117: the pattern scale defaults to
`na.value = "none"` (and the angle scale to 0), since an `NA` pattern fails as in #107 / #133.

The vignette [Combining Colors and Patterns](https://friendly.github.io/ggCheysson/articles/combining-colors-patterns.html)
describes all this, including legends, ordered (sequential/diverging) palettes, `NA`s and using
only some of the aesthetics.

## Questions

1. **Is a list of scales plus an `aes()` helper a reasonable design**, or is there a more direct
   mechanism in ggpattern (or one you'd recommend) for mapping one variable to a bundle of pattern
   aesthetics?
2. **The mapping half.** Is there a way to avoid mapping the same variable five times - e.g. with
   `after_scale()` or `stage()`, deriving `pattern_fill`, `pattern_angle`, etc. from one scaled
   aesthetic? I haven't found a clean one.
3. **Anything that would fit better upstream?** The idea isn't specific to Cheysson: any "swatch"
   palette - a data frame with one row per level and one column per pattern aesthetic - could
   be applied this way, e.g. something like `scale_pattern_swatches(values = <data frame>)` with a
   matching mapping helper. Would something like that belong in ggpattern? I'm happy to
   contribute.
4. Smaller: the name `aes_cheysson()` echoes ggplot2's deprecated `aes_()` / `aes_string()`.
   Would you avoid that pattern of name?

Since these functions are marked experimental, I can still change the interface, so any advice is
welcome.

Michael Friendly
