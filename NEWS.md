# ggCheysson 1.1.0

## Breaking changes

* Fixed a palette-naming collision bug. Palette names were built from
  `Album + Qty` (e.g. `"1880_07"`), but `Qty` is not a unique plate identifier - it's a
  colors/pattern-element count that happened to repeat across genuinely different plates. 4 such
  collisions silently overwrote 5 of the original 25 palettes during data extraction. Names are
  now built from the real, unique plate identifier (`RumseyListNo`'s decimal suffix) instead:
  19 of the 20 previously-shipped palettes have a new name, and all 5 previously-missing palettes
  are now included - `cheysson_palettes`/`cheysson_patterns` now have **25** palettes (was 20),
  with 134 pattern specifications (was 83). See the new `cheysson_labels` dataset (below) to map
  an old name to its new one.

* Migration aids for the rename: an old (1.0.1) palette name that no longer exists now errors
  with the palette's new name, e.g. `"1883_06"` -> `"1883_30"`, instead of just "not found".
  **Watch out for `"1880_07"`**: it is still a valid name, but now refers to a *different*
  palette (grouped, 1880 plate 7). The palette called `"1880_07"` in 1.0.1 is now `"1880_21"`.
  Using `"1880_07"` gives a once-per-session message saying so. (`"1906_06"` is the only old name
  that still means the same palette.)

* Palette order is now consistent: sequential palettes are stored from low to high (light to
  dark) and diverging palettes end to end, so `reverse = TRUE` means the same for every palette.
  Previously palettes kept RJ Andrews' swatch order, so `1891_19`, `1891_25` and `1900_28` ran
  dark to light, and `1883_31` put its hatched patterns at the extremes; these are now
  reordered. Category and grouped palettes are unchanged.

* When a sequential or diverging palette has more elements than needed, `cheysson_pal(n = )`,
  `cheysson_pattern(n = )` and all the `scale_*_cheysson()` scales now pick elements spread
  over the whole palette, keeping both ends, instead of the first `n` - which could drop one
  end of a diverging palette entirely (e.g. `1883_21` with 5 classes).

## New features

* New (experimental) `scale_cheysson()` applies a whole color-and-pattern palette - fill, hatch
  type, line colors and angle - with one `+`, in place of four or five separate
  `scale_*_cheysson()` calls; `aes_cheysson(x)` maps a variable to all of those aesthetics.
  See the new vignette "Combining Colors and Patterns". The individual scales remain.

* Two-color crosshatches: the crosshatches in `1883_30` and `1886_17` draw their two sets of
  lines in different colors (red and blue; orange and blue-grey). These are now stored as
  `pattern_fill2`, returned by `cheysson_pattern_params(param = "pattern_fill2")`, and applied by
  the new `scale_pattern_fill2_cheysson()`; map ggpattern's `pattern_fill2` aesthetic to use them.

* Added `cheysson_labels`, a new dataset mapping every palette's current name to its previous
  (pre-fix) name, RJ Andrews' original Advent-calendar label, Tom Shanley's Observable notebook
  ID, and the underlying David Rumsey catalog number - useful for looking up a palette by
  whichever naming scheme you encountered it in.

* Added `cheysson_name()`, a lookup function that translates a palette label from any of the
  `cheysson_labels` naming schemes (Andrews' label, Shanley's ID, a Rumsey catalog number, the
  old pre-fix name, or an advent day) into the current palette name, for direct use in calls like
  `scale_color_cheysson(cheysson_name("Dec.01-1883.21"))`. When a label is ambiguous (only
  possible via the old naming scheme, which had 4 real collisions), it warns and lists every
  match; pass `advent_day` to disambiguate without a warning, or to assert a specific palette.

## Bug fixes

* Vignettes now render figures with `ragg`. This fixes a segfault on CRAN's Intel macOS check
  machines, where the Quartz `png()` device crashes drawing ggpattern's masks. Also, set
  `fig.showtext = TRUE`, so showtext text is drawn at the device's real dpi and figures look the
  same in the package vignettes and on the pkgdown site.

* Missing values in a mapped pattern aesthetic no longer make ggpattern fail: the pattern
  scales now give missing data no hatching (`pattern = "none"`) by default.

* The 1883 category palette of Advent day 22 is named `1883_30`: the source data's Rumsey
  number for it (`12512.013`) was a typo for `12514.030`, the 1883 album's plate 30, as checked
  against the original plate. `cheysson_labels` keeps RJ Andrews' and Tom Shanley's labels for
  it (`Dec.22-1881.13`, `category12512013`), which were built from the bad number.

* Fixed 15 missing pattern elements across 6 palettes (`1882_04`, `1883_07`, `1886_04`,
  `1886_07`, `1887_06`, `1900_06`, in their old names): an SVG-parsing bug silently dropped
  hatch-line patterns whose coordinates relied on SVG's implicit default of 0 for an omitted
  `x1`/`y1`/`x2`/`y2` attribute.

* Fixed two `scale_pattern_*_cheysson()` bugs: `scale_pattern_type_cheysson()` targeted the
  wrong ggpattern aesthetic (`pattern_type` instead of `pattern`) and so never actually varied
  the rendered pattern shape by category; `scale_pattern_fill_cheysson()` read the wrong
  parameter (`fill` instead of `pattern_fill`) and always returned `"transparent"` regardless of
  palette.

* Fixed `theme_cheysson()`'s/`theme_cheysson_map()`'s `plot.title` (set in `CheyssonTitle`)
  rendering smaller than intended, the same underlying issue as the 1.0.1 axis/legend-title fix
  below but previously missed for the plot title itself. The correction is now generalized
  (`cheysson_font_size_adjust()`) to all four Cheysson display fonts instead of hardcoded to one.

## Other changes

* The help topic for `scale_color_cheysson()`/`scale_fill_cheysson()` is now
  `?scale_color_cheysson` (the name `scale_cheysson` belongs to the new function).

* Added real (rendered) pattern examples to the README's Pattern Support section, which
  previously had none.

* **`theme_cheysson_map()` text sizing redesigned**: `plot.title`, `plot.subtitle`,
  `legend.title`, and `legend.text` now scale from `base_size` using a deliberate poster-style
  hierarchy (a much larger title relative to the rest, in the spirit of Guerry's own maps) instead
  of the modest ratios `theme_cheysson()` uses; `plot.caption` is now styled too (previously
  unstyled and tiny). `base_size` alone now controls this - no need for the
  `theme(plot.title = element_text(size = ...))` overrides the `guerry-maps` vignette previously
  needed on every map. Sizes are calibrated at true scale (a ~40-character title just fits an
  8in-wide figure), and titles are now centered on the whole plot rather than the panel, so a
  side legend no longer pushes a long title off the left edge.

# ggCheysson 1.0.1

* Fixed undersized axis and legend titles in `theme_cheysson()` (inherited by
  `theme_cheysson_minimal()`): `CheyssonSansCaps` renders visibly smaller than other package
  fonts at the same nominal size, so title text is now scaled up to match
  
* Bumped `roxygen2` to 8.1.0 (`Config/roxygen2/version`)

* Removed unnecessary `\dontrun{}`/`\donttest{}` wrapping from examples that run cleanly
  (`show_palette()`, `show_palettes()`, the `scale_*_cheysson()` family); kept `\donttest{}` only
  where custom-font grid text rendering can crash on some devices
  
* Added R-universe badge and installation instructions to README

* Hardened `cheysson_fonts_available()`, `cheysson_pal()`, and `cheysson_pattern()` against
  non-length-1 arguments (`method`, `n`) that could otherwise trigger opaque errors

# ggCheysson 1.0.0

* Initial version, implementing Cheysson color palettes, patterns and fonts
* Fixed problem with fonts, requiring `showtext::showtext_auto()`
* Added Getting started vignette
* Added Guerry maps vignette
* Added `show_palette()` functions
* Fixed problems from the initial CRAN submission: 
  * `@return` tags for all functions
  * `list_cheysson_fonts()` function converted to `cheysson_fonts` data object
  * `\dontrun{}` examples unwrapped, or changed to `\donttest{}` if they depend on system features
