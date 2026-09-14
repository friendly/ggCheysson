# Changelog

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
