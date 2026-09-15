# Bugs in `scale_pattern_fill_cheysson()` and `scale_pattern_type_cheysson()`

Found 2026-09-15 while replacing the `1881_03` palette (1 color) in the README's "Complete
Cheysson Aesthetic" example with `1883_06` (4 colors, real stripe/crosshatch/solid variety) - the
richer palette still rendered as flat, uncolored diagonal stripes on every bar. Root-caused to two
independent bugs in `R/scale_patterns.R`. **Not fixed in `R/` yet** - ggCheysson 1.0.1 was just
submitted to CRAN and the user wants the package left as-is until that's settled. This file tracks
the diagnosis and a working fix for the next release. `test_pattern_scale_bugs.R` in this folder
reproduces both bugs and the fix.

## Bug 1: `scale_pattern_type_cheysson()` targets the wrong ggpattern aesthetic

`R/scale_patterns.R` (~line 94-119):

```r
scale_pattern_type_cheysson <- function(palette = "1881_03", reverse = FALSE, ...) {
  ...
  types <- cheysson_pattern_params(patterns, "pattern_type")
  ggplot2::discrete_scale(
    aesthetics = "pattern_type",   # <-- wrong aesthetic name
    ...
```

`ggpattern`'s `GeomColPattern` (and friends) use the aesthetic **`pattern`** to select which
pattern function draws (stripe/crosshatch/none/circle/...). `pattern_type` is a real but
*different*, mostly-unused aesthetic (`default_aes` shows `pattern_type -> NA`; it's for
sub-variants of certain patterns, e.g. "hexagons" vs "squares" for a grid pattern - irrelevant to
stripe/crosshatch/none). Confirmed via `ggpattern::GeomColPattern$aesthetics()` (lists both
`pattern` and `pattern_type` as distinct, valid aesthetics) and `$default_aes`
(`pattern -> "stripe"`, `pattern_type -> NA`).

Effect: every bar/geom rendered with whatever `pattern = ` was set to as a fixed geom parameter
(e.g. `"stripe"` in the README example), completely ignoring the per-category
`aes(pattern_type = category)` mapping and the values `scale_pattern_type_cheysson()` computed.
The computed values themselves are correct (`cheysson_pattern_params(patterns, "pattern_type")`
correctly returns `"stripe"`/`"crosshatch"`/`"none"` per entry) - only the aesthetic name is wrong.

**Fix:** change `aesthetics = "pattern_type"` to `aesthetics = "pattern"` in
`scale_pattern_type_cheysson()`. Also drop the `pattern = "..."` fixed-parameter argument from any
`geom_*_pattern()` call that maps `pattern_type` (now `pattern`) via `aes()`, since a fixed
parameter for the same underlying aesthetic would still win.

## Bug 2: `scale_pattern_fill_cheysson()` reads the wrong param from `cheysson_pattern_params()`

`R/scale_patterns.R` (~line 67-92):

```r
scale_pattern_fill_cheysson <- function(palette = "1881_03", reverse = FALSE, ...) {
  ...
  fills <- cheysson_pattern_params(patterns, "fill")   # <-- wrong param string
  ggplot2::discrete_scale(
    aesthetics = "pattern_fill",   # aesthetic name is correct
    ...
```

The aesthetic name (`"pattern_fill"`) is right, but the *value* extraction pulls the `"fill"`
param (the geom's base rectangle fill - `"transparent"` for hatch-only pattern entries, a solid
hex for "solid" entries) instead of `"pattern_fill"` (the actual hatch-line/motif color, e.g.
`"#cb3f50"`, `"#366788"`). Confirmed with `ggplot_build()`: every bar's `pattern_fill` column came
out `"transparent"` regardless of palette, instead of the palette's real per-entry hex colors.
Since `pattern_fill` transparent still renders (ggpattern seems to fall back to a default-ish
dark line rather than a truly invisible one), the practical effect was every hatch line rendering
in a uniform dark color regardless of the palette's actual colors - directly undermining "show
more colors" as a goal.

**Fix:** change `cheysson_pattern_params(patterns, "fill")` to
`cheysson_pattern_params(patterns, "pattern_fill")` in `scale_pattern_fill_cheysson()`.

## Confirmed NOT broken

`scale_pattern_angle_cheysson()` - correct aesthetic name (`"pattern_angle"`) and correct param
(`"pattern_angle"`); verified via `ggplot_build()` that angles vary correctly per category.
`scale_fill_cheysson_pattern()` - correct aesthetic (`"fill"`) and correct param (`"fill"`);
this is the base rectangle fill, intentionally `"transparent"` for hatch-only entries and a solid
hex for `"solid"`-type entries (matches the historical style - hatching drawn on bare paper, no
fill, vs. a genuinely solid-filled category).

## Working fix, verified visually

With both bugs fixed (or worked around from calling code without touching `R/`), `1883_06`
renders as intended: bar A red stripes, bar B blue stripes (different angle), bar C red
crosshatch, bar D solid-black stripes - real color and pattern-type variety. See
`test_pattern_scale_bugs.R` for the reproduction (`test_broken.png`) and the fix
(`test_fixed.png`).

## Relationship to the unified color-pattern work in this folder

This is a narrower, concrete bug-fix, not the broader "unified color-pattern palette system"
this `dev/colorpat/` folder was created for (see `UNIFIED_COLOR_PATTERN_PLAN.md` et al., paused
per `dev/README.md`). Worth fixing regardless of whether that larger effort resumes - it's just
two wrong strings in existing, already-shipped functions.
