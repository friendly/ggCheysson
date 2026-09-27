# Correction factor for a Cheysson display font's undersized metrics

The four non-body Cheysson font families (`CheyssonSansCaps`,
`CheyssonTitle`, `CheyssonItalic`, `CheyssonOutlineCaps`) each measure
smaller than a typical sans font (Arial) at the same nominal point
size - a common trait of hand-drawn/all-caps/decorative designs, which
have less ascender/descender space filling out the type's em box. Sizes
for text set in one of these families are scaled up by this factor so
they read at roughly the intended visual size, rather than shrinking
further on top of an already-undersized glyph. Factors were derived from
[`systemfonts::font_info()`](https://systemfonts.r-lib.org/reference/font_info.html)
(`max_ascend`, `lineheight` vs Arial at size 11), landing between the
ascent-ratio-implied and lineheight-ratio-implied corrections for each
family; `CheyssonSansCaps` and `CheyssonTitle` were additionally checked
against rendered comparisons (see `dev/fonts/test_title_size_fix.R`).

## Usage

``` r
cheysson_font_size_adjust(family)
```

## Arguments

- family:

  A font family name.

## Value

A numeric scaling factor (1 if `family` isn't one of the four known
undersized display fonts).
