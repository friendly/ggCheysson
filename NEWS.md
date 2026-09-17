# ggCheysson 1.1.0

* **Breaking change**: fixed a palette-naming collision bug. Palette names were built from
  `Album + Qty` (e.g. `"1880_07"`), but `Qty` is not a unique plate identifier - it's a
  colors/pattern-element count that happened to repeat across genuinely different plates. 4 such
  collisions silently overwrote 5 of the original 25 palettes during data extraction. Names are
  now built from the real, unique plate identifier (`RumseyListNo`'s decimal suffix) instead:
  19 of the 20 previously-shipped palettes have a new name, and all 5 previously-missing palettes
  are now included - `cheysson_palettes`/`cheysson_patterns` now have **25** palettes (was 20),
  with 134 pattern specifications (was 83). See the new `cheysson_labels` dataset (below) to map
  an old name to its new one

* Fixed 15 missing pattern elements across 6 palettes (`1882_04`, `1883_07`, `1886_04`,
  `1886_07`, `1887_06`, `1900_06`, in their old names): an SVG-parsing bug silently dropped
  hatch-line patterns whose coordinates relied on SVG's implicit default of 0 for an omitted
  `x1`/`y1`/`x2`/`y2` attribute

* Fixed two `scale_pattern_*_cheysson()` bugs: `scale_pattern_type_cheysson()` targeted the
  wrong ggpattern aesthetic (`pattern_type` instead of `pattern`) and so never actually varied
  the rendered pattern shape by category; `scale_pattern_fill_cheysson()` read the wrong
  parameter (`fill` instead of `pattern_fill`) and always returned `"transparent"` regardless of
  palette

* Added `cheysson_labels`, a new dataset mapping every palette's current name to its previous
  (pre-fix) name, RJ Andrews' original Advent-calendar label, Tom Shanley's Observable notebook
  ID, and the underlying David Rumsey catalog number - useful for looking up a palette by
  whichever naming scheme you encountered it in

* Added real (rendered) pattern examples to the README's Pattern Support section, which
  previously had none

* Added `cheysson_name()`, a lookup function that translates a palette label from any of the
  `cheysson_labels` naming schemes (Andrews' label, Shanley's ID, a Rumsey catalog number, the
  old pre-fix name, or an advent day) into the current palette name, for direct use in calls like
  `scale_color_cheysson(cheysson_name("Dec.01-1883.21"))`. When a label is ambiguous (only
  possible via the old naming scheme, which had 4 real collisions), it warns and lists every
  match; pass `advent_day` to disambiguate without a warning, or to assert a specific palette

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
