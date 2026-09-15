# Changelog

## ggCheysson 1.0.1

- Fixed undersized axis and legend titles in
  [`theme_cheysson()`](https://friendly.github.io/ggCheysson/reference/theme_cheysson.md)
  (inherited by
  [`theme_cheysson_minimal()`](https://friendly.github.io/ggCheysson/reference/theme_cheysson_minimal.md)):
  `CheyssonSansCaps` renders visibly smaller than other package fonts at
  the same nominal size, so title text is now scaled up to match

- Bumped `roxygen2` to 8.1.0 (`Config/roxygen2/version`)

- Removed unnecessary `\dontrun{}`/`\donttest{}` wrapping from examples
  that run cleanly
  ([`show_palette()`](https://friendly.github.io/ggCheysson/reference/show_palette.md),
  [`show_palettes()`](https://friendly.github.io/ggCheysson/reference/show_palettes.md),
  the `scale_*_cheysson()` family); kept `\donttest{}` only where
  custom-font grid text rendering can crash on some devices

- Added R-universe badge and installation instructions to README

- Hardened
  [`cheysson_fonts_available()`](https://friendly.github.io/ggCheysson/reference/cheysson_fonts_available.md),
  [`cheysson_pal()`](https://friendly.github.io/ggCheysson/reference/cheysson_pal.md),
  and
  [`cheysson_pattern()`](https://friendly.github.io/ggCheysson/reference/cheysson_pattern.md)
  against non-length-1 arguments (`method`, `n`) that could otherwise
  trigger opaque errors

## ggCheysson 1.0.0

- Initial version, implementing Cheysson color palettes, patterns and
  fonts
- Fixed problem with fonts, requiring
  [`showtext::showtext_auto()`](https://rdrr.io/pkg/showtext/man/showtext_auto.html)
- Added Getting started vignette
- Added Guerry maps vignette
- Added
  [`show_palette()`](https://friendly.github.io/ggCheysson/reference/show_palette.md)
  functions
- Fixed problems from the initial CRAN submission:
  - `@return` tags for all functions
  - `list_cheysson_fonts()` function converted to `cheysson_fonts` data
    object
  - `\dontrun{}` examples unwrapped, or changed to `\donttest{}` if they
    depend on system features
