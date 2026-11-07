## Update submission (1.2.0)

This is a feature update. The main change is that each element of each color-and-pattern palette
is now registered with 'gridpattern' as a pattern of its own (a *swatch*), so that a whole palette
can be used through the single `pattern` aesthetic of 'ggpattern'; `scale_cheysson()` is now one
scale giving these swatches. Both are marked experimental. A new function, `show_swatches()`,
draws them all. Thanks to Trevor L. Davis for help with this.

'ggpattern' and 'gridpattern' remain in Suggests. The swatches are registered in `.onLoad()`
only when 'gridpattern' is loaded (via `rlang::on_package_load()`, so 'rlang' is added to Imports),
with `gridpattern::register_pattern()` where available and the older `ggpattern_geometry_funcs`
option otherwise. The package works with the current CRAN versions (ggpattern 1.3.1,
gridpattern 1.5.1) and with their development versions, not yet on CRAN
(ggpattern 1.4.0.2, gridpattern 1.6.0.4); it was checked against both.

It also fixes a bug: the palette functions failed with "object 'cheysson_palettes' not found"
unless the package was attached, e.g. when called as `ggCheysson::scale_fill_cheysson()`; and it
no longer uses base R's `%||%`, which needs R >= 4.4.0. The NEWS for this version is reproduced
below.

## Test environments

* local Windows 11, R 4.6.1 (2026-06-24 ucrt), `R CMD check --as-cran`, with both the CRAN
  and the development versions of 'ggpattern' and 'gridpattern'
* win-builder, R 4.6.2 (2026-10-29 ucrt): Status OK
* win-builder, R Under development (unstable) (2026-11-06 r90845 ucrt): Status OK
* R-hub (GitHub Actions), R-devel (2026-11-05 r90840 / 2026-11-06 r90845): linux (x86_64),
  windows, macos (x86_64-apple-darwin20, the platform of the 1.0.1 ERROR), macos-arm64
  (aarch64-apple-darwin23): all Status OK, vignettes re-built

## R CMD check results

0 errors | 0 warnings | 0 notes (all of the above; locally with either version of 'ggpattern')

## Reverse dependencies

There are no reverse dependencies.

## Changes in this version (from NEWS.md)

### ggCheysson 1.2.0

#### New features

* Experimental: each element of each pattern palette is now a ggpattern pattern of its own, a
  *swatch*, named `"<palette>-<element>"` (e.g. `"1886_28-1"`), that draws its fill, hatch type, line
  colors and angle together. A whole color-and-pattern palette then needs only `aes(pattern = x)`
  and a pattern scale, e.g. `scale_pattern_manual(values = paste0("1886_28-", 1:6))`: no
  `aes_cheysson()`, and no `pattern_spacing` / `pattern_density` arguments. The swatches are
  registered when gridpattern loads, with `gridpattern::register_pattern()` where available.
  What setting `pattern_spacing` / `pattern_density` means depends on the ggpattern version; see
  `?cheysson_swatches`.

* The swatches of a palette keep the relative line spacings measured on Cheysson's plates, so
  e.g. the hatching of sequential palette `1888_27` gets denser at each step. `pattern_spacing`
  sets the spacing of a palette's typical swatch, and the others keep their proportions. The
  literacy map in the Guerry maps vignette now uses `scale_cheysson()` instead of mapping
  `pattern_spacing` with `scale_pattern_spacing_manual()`.

* New `show_swatches()` draws an atlas of the swatches: one row per palette and one column per
  element, grouped by palette type, so a swatch's name reads off its row and column. It is shown
  in the README.

* Experimental `scale_cheysson()` is now a single discrete scale for the `pattern` aesthetic that
  gives each level a swatch, so a palette needs only
  `aes(pattern = x) + geom_col_pattern() + scale_cheysson("1886_28")`. It used to return five
  scales, one per pattern aesthetic. Its `aesthetics` argument is ignored, with a warning; to use
  only some of a palette's properties, use the individual `scale_*_cheysson()` scales. `na.value`
  is now a pattern (default `"none"`, which shows the geom's own `fill`) rather than a color.
  `aes_cheysson(x)` is deprecated and now the same as `aes(pattern = x)`, so existing code using
  both keeps working. The "Combining Colors and Patterns" vignette is updated.

* The package's discrete scales no longer pass `scale_name` to `ggplot2::discrete_scale()` with
  ggplot2 3.5.0 or later, where it is deprecated.

#### Bug fixes

* The palette functions and scales (`cheysson_pal()`, `cheysson_pattern()`, `scale_fill_cheysson()`,
  `scale_cheysson()`, etc.) and `cheysson_name()` failed with "object 'cheysson_palettes' not found"
  (or `'cheysson_patterns'`, `'cheysson_labels'`) unless ggCheysson was attached with `library()`, e.g.
  when called as `ggCheysson::scale_fill_cheysson()` or from another package. They now find the
  palette data either way.

* `cheysson_pattern_params()` used `%||%`, which base R has only from 4.4.0, so it failed on the
  earlier R versions the package supports (R >= 3.5). The package now has its own.
