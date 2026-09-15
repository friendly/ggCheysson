## Test environments
* local Windows 11 install, R 4.6.1 (2026-06-24 ucrt), `--as-cran` and `--run-donttest`
* win-builder R Under development (unstable) (2026-09-13 r90534 ucrt)
* R-hub (GitHub Actions), Ubuntu 24.04.5 LTS, R Under development (unstable) (2026-09-14 r90539),
  x86_64 - 0 errors, 0 warnings; found and fixed 1 NOTE ("hidden files and directories: .github",
  from adding the R-hub workflow file itself - `.github` added to `.Rbuildignore`, confirmed
  clean in a subsequent local `--as-cran` run)

## R CMD check results

0 errors | 0 warnings | 1 note

**NOTE 1:** Possibly misspelled words in DESCRIPTION:
  Cheysson (2:32, 14:3)

This is a proper name (Émile Cheysson) and is spelled correctly. I even put it in quotes, but to no effect on triggering a NOTE.

* This is a new submission. An earlier version (1.0.0) was submitted on 2026-01-08 but was never
  accepted, so there is no ggCheysson release currently on CRAN.

## Changes since the 2026-01-08 submission (from NEWS.md)

### ggCheysson 1.0.1

* The Tom Shanley Observable notebook citation (`R/data.R`, `R/palettes.R`, `README.md`) previously
  linked directly to `observablehq.com`, which returns HTTP 429 to automated, non-browser requests
  and was flagged as a possibly-invalid URL. Replaced with a Wayback Machine snapshot of the same
  page, which resolves reliably; no more URL NOTE.

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

### ggCheysson 1.0.0

* Initial version, implementing Cheysson color palettes, patterns and fonts
* Fixed problem with fonts, requiring `showtext::showtext_auto()`
* Added Getting started vignette
* Added Guerry maps vignette
* Added `show_palette()` functions
* Fixed problems from the initial CRAN submission:
  * `@return` tags for all functions
  * `list_cheysson_fonts()` function converted to `cheysson_fonts` data object
  * `\dontrun{}` examples unwrapped, or changed to `\donttest{}` if they depend on system features
