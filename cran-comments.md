## Resubmission

This is a resubmission in response to CRAN feedback received 2026-01-12.

### Changes made in response to CRAN review:

1. **Added missing `@returns` tags** to the following functions:
   - `scale_color_cheysson()`, `scale_fill_cheysson()`
   - `scale_pattern_fill_cheysson()`, `scale_pattern_type_cheysson()`,
     `scale_pattern_angle_cheysson()`, `scale_pattern_density_cheysson()`
   - `scale_fill_cheysson_pattern()`
   - `theme_cheysson_minimal()`, `theme_cheysson_map()`

   All `@returns` tags now document the structure and class of output objects.

2. **Converted `list_cheysson_fonts()` function to `cheysson_fonts` data object**:
   - Removed the function that had no parameters (which caused missing `\arguments` issue)
   - Created a properly documented data frame in `data/cheysson_fonts.rda`
   - Added complete documentation with `@format`, `@details`, `@source`, and `@examples`
   - Updated all references in README and pkgdown configuration

3. **Examples properly tagged with `\dontrun{}` or `\donttest{}`**:

   **`\dontrun{}`** (require user interaction or special setup):
   - `theme_cheysson()`, `theme_cheysson_minimal()`, `theme_cheysson_map()` - require
     `load_cheysson_fonts()` to be called first for proper font rendering
   - `load_cheysson_fonts()` - modifies system font registry

   **`\donttest{}`** (work automatically but need graphics/suggested packages):
   - `show_palette()`, `show_palettes()` - require graphics device
   - `scale_*_cheysson()` functions - create ggplot2 graphics
   - `scale_pattern_*_cheysson()` - require suggested package (ggpattern)

   **Unwrapped** (run during R CMD check):
   - `cheysson_pal()`, `list_cheysson_pals()` - simple data access
   - `cheysson_pattern()`, `cheysson_pattern_params()`, `list_cheysson_patterns()` - data operations
   - `cheysson_font()`, `cheysson_fonts_available()` - utility functions

   All examples are fully functional for end users.

## Test environments
* local Windows 10 install, 4.5.1 (2025-06-13 ucrt)
* win-builder (to be tested)

## R CMD check results

0 errors | 0 warnings | 2 notes

**NOTE 1:** Possibly misspelled words in DESCRIPTION:
  Cheysson (2:32, 14:3)
  Emile (13:34)

These are proper names (Émile Cheysson) and are spelled correctly.

**NOTE 2:** Installed package size (if this appears)

Large demonstration images for README are hosted on GitHub and excluded from
the CRAN tarball via .Rbuildignore. The package includes five custom TrueType
font files (1.2Mb) essential for authentic historical styling, which is typical
for graphics packages with embedded fonts.

* This is a new package release.

## ggCheysson 1.0.0

* Initial version, implementing Cheysson color palettes, patterns and fonts
* Fixed problem with fonts, requiring `showtext::showtext_auto()`
* Added Getting started vignette
* Added Guerry maps vignette
* Added `show_palette()` functions

