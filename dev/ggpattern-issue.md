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

---

# Replies from Trevor (updated 2026-11-01)

The text above is the question as posted in
[trevorld/ggpattern#154](https://github.com/trevorld/ggpattern/issues/154). My follow-up questions are
in `dev/ggpattern-reply.md` (commit
[1337f53](https://github.com/friendly/ggCheysson/commit/1337f5388f289f80d1fdbaac72a71882841f3a0b)), and
Trevor answered them in comments on that commit. The current plan is in `dev/TASKS.md`, "1.2.0: a custom
`cheysson` ggpattern pattern"; the proof of concept is `dev/custom-pattern/poc_simplified.R`.

## In the issue (2026-10-01)

- [Define our own patterns](https://github.com/trevorld/ggpattern/issues/154#issuecomment-5933995708) that
  reuse existing patterns and hard-code several attributes at once
  ([developing patterns](https://trevorldavis.com/R/ggpattern/dev/articles/developing-patterns.html)).
  This is what the proof of concept does.
- Perhaps a `geom_cheysson()` that takes the Cheysson data frame and a `geom` argument, and sets up the
  ggpattern geom and scale calls. The proof of concept makes this unnecessary.
- [Model to follow](https://github.com/trevorld/ggpattern/issues/154#issuecomment-5934119493): gridpattern's
  [`hatching` pattern](https://trevorldavis.com/R/gridpattern/dev/articles/hatching.html).

## On my three follow-up questions

**Q1. Is registering about 130 names in `options(ggpattern_geometry_funcs = ...)` reasonable, or is there
a better way?** ([2026-10-10](https://github.com/friendly/ggCheysson/commit/1337f5388f289f80d1fdbaac72a71882841f3a0b#commitcomment-204381902))
Use gridpattern's new `register_pattern()`, still "a bit experimental (and open for feedback)", in
`.onLoad()`, falling back to the option for older versions:

```r
.onLoad <- function(libname, pkgname) {
  rlang::on_package_load("gridpattern", {
    if (exists("register_pattern", envir = asNamespace("gridpattern"), inherits = FALSE)) {
      gridpattern::register_pattern("brick", create_pattern_brick)
    } else {
      funcs <- getOption("ggpattern_geometry_funcs", list())
      funcs[["brick"]] <- create_pattern_brick
      options(ggpattern_geometry_funcs = funcs)
    }
  })
}
```

**Q2. Can I rely on `params$pattern` being the pattern's name inside a geometry pattern function?**
"This appears to be true."

**Q3. Can I tell whether the user actually set `pattern_spacing` / `pattern_density`, as opposed to getting
the defaults?** First answer: no straightforward way, as ggplot2 aesthetics can't be `NULL`, `NA` often means
"transparent", and patterns may also be called from `patternGrob()` / `patternFill()` without ggplot2.

[Newer answer (2026-11-01)](https://github.com/friendly/ggCheysson/commit/1337f5388f289f80d1fdbaac72a71882841f3a0b#commitcomment-207580653):
**the development versions now solve this, so there's no need to detect it.** Set the defaults in
`register_pattern()`; they can be functions of other pattern aesthetics. ggpattern's aesthetics now default to
"unset", so a value the user doesn't set comes from the pattern's registered default, and failing that from
gridpattern's fallback default. If working with `pattern_spacing` and `pattern_density`, also be aware of
`pattern_units`.

## Versions

| Package | Installed here | CRAN | Development |
|---|---|---|---|
| gridpattern | 1.4.2 (no `register_pattern()`) | 1.5.1, 2026-10-28 (has `register_pattern()`) | 1.6.0-4 (`NaN` = unset) |
| ggpattern | 1.3.1 | 1.3.1, 2026-03-07 | 1.4.0-2 (aesthetics unset by default) |

Trevor expects the development versions on CRAN no sooner than about a month after 2026-11-01. To try them:

```r
remotes::install_github("trevorld/gridpattern")
remotes::install_github("trevorld/ggpattern")
```

## Notes from the gridpattern and ggpattern sources (development versions, 2026-11-01)

Not from Trevor directly, so check these against the current docs.

- **Our swatch names won't work as they are.** `register_pattern()` documents that `name` "must not contain
  `":"`", and the code aborts if it does, because `"owner::name"` is the qualified form. The proof of concept uses `"<palette>:<element>"`, so
  use another separator, e.g. `"1886_28-1"` (which doesn't start with a letter either; I haven't checked
  whether that matters).
- **Signature:** `register_pattern(name, fn, kind = "geometry", defaults, unprefixed, env)`. A geometry
  `fn` is `function(params, boundary_df, aspect_ratio, legend)`.
- **`defaults`** is a named list of `pattern_`-prefixed values, or functions `function(params, gp)`, e.g.
  `list(pattern_amplitude = function(params, gp) 0.5 * params$pattern_spacing)`. They're applied in order, so
  one can use an earlier one. `unprefixed` allows others, e.g.
  `defaults = list(fill = "black"), unprefixed = "fill"`.
- **Unset is `NaN` internally:** a length-one `NaN` means unset. `NA` keeps its meaning (e.g. transparent).
- **Name conflicts:** a bare name is an error if two owners have it, unless `prefer_pattern()` resolves it.
  Packages should refer to patterns by qualified name, e.g. `"gridpattern::stripe"`, including when the
  drawing function delegates lines to `stripe` / `crosshatch`.
- **Legend keys:** in ggpattern 1.4.0 these are scaled by gridpattern, so relative lengths scale together.
  Re-check the swatch legend keys.

## Tried with the development versions (2026-11-03)

gridpattern 1.6.0.4 and ggpattern 1.4.0.2, installed from GitHub. The script is `dev/custom-pattern/poc_register.R`.

- **The old proof of concept still works.** `poc_simplified.R` (registered through `options(ggpattern_geometry_funcs = ...)`)
  runs unchanged, and its PNGs are byte-identical to the committed ones.
- **`register_pattern()` works for all 134 swatches**, each registered with `defaults = list(pattern_spacing = 0.025,
  pattern_density = 0.30)`. Names like `"1886_28-1"` are accepted, so a leading digit and `-` are fine.
- **Registered defaults do apply through ggpattern.** The pattern function recorded what it received:

  | Case | Received spacing / density |
  |---|---|
  | `geom_col_pattern()`, no arguments | 0.025 / 0.30 (the swatch defaults) |
  | `geom_col_pattern(pattern_spacing = 0.06, pattern_density = 0.6)` | 0.06 / 0.6 (the user's values) |
  | `geom_sf_pattern()`, no arguments | 0.025 / 0.30 |
  | `gridpattern::grid.pattern("1883_30-3", ...)`, without ggpattern | 0.025 / 0.30 |

  The `register_pattern()` help still says ggpattern "supplies its own (generic) defaults ... so these will mainly be
  used with `grid.pattern()`". That's out of date as of these versions, which is worth telling Trevor.
- **No relative scaling is needed**, so the `0.025 * pattern_spacing / 0.05` arithmetic is gone.
- **Delegating to `"gridpattern::stripe"` / `"gridpattern::crosshatch"` by qualified name works.**
- **The output matches the old proof of concept:** the bars and map look the same apart from the titles.
- **Legend keys with large overrides:** with `pattern_spacing = 0.06, pattern_density = 0.6`, the England and Germany keys
  draw as almost solid colour and the France key nearly so, while the bars are clearly striped
  (`poc_register_bars_override.png`). The default keys look right. This is probably ggpattern 1.4.0's legend-key scaling;
  ask Trevor.

## What this means for 1.2.0 (my reading)

1. Register each swatch with `register_pattern()`, using the `.onLoad()` code above, under a name without `":"`.
2. Give each swatch its spacing and density as registered `defaults`, and use those values directly in place
   of today's relative scaling against ggpattern's 0.05 and 0.2. A user's `pattern_spacing` then overrides the
   swatch, rather than adjusting it, which is a behaviour change to decide on and document.
3. Until the development versions reach CRAN, ggpattern 1.3.1 still supplies its own values, so the registered
   defaults won't apply through it. Either wait to release 1.2.0, or keep the relative scaling as a fallback
   and require newer versions in `DESCRIPTION` once they're out.
4. Check how `pattern_units` affects the built-in spacing.
5. Tell Trevor how `register_pattern()` works for a family of 134 patterns, since he asked for feedback.
