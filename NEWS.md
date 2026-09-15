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
