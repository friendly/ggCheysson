# Development Notes for ggCheysson

This folder contains development scripts, tests, and notes for the ggCheysson package.

## Folder Structure

The `dev/` directory is organized into the following subfolders:

### **colorpat/** - Unified Color-Pattern Palettes (ON HOLD)
Experimental work on unified color-pattern palette system. **This feature is too complex for the current release and has been paused.**

- Documentation: `*_SUMMARY.md`, `UNIFIED_COLOR_PATTERN_PLAN.md`, `COLORPAT_ISSUE_SUMMARY.md`
- Code: `prototype_colorpat.R`, `extract_colorpat_pairings.R`
- Tests: `test_*.R` scripts
- Data: `colorpat_extractions.RData`, `colorpat_extraction/` directory
- Images: Test outputs (`test_*.png`)

### **fonts/** - Font Integration
Font-related development for Windows and cross-platform support.

- Documentation: `FONTS.md`, `FONTS_WINDOWS.md`
- Tests: `test_fonts.R`, `test_fonts_available.R`, `test_fonts_themes.R`, `test_font_registry.R`, `test_ragg_fonts.R`, `test_showtext_fonts.R`
- Examples: `font_test*.png` (7 test output images), `ragg_test.png`

### **palettes/** - Color Palette Work
Regular color palette extraction, testing, and visualization.

- Extraction: `extract_palettes.R`, `inspect_palettes.R`
- Visualization: `visualize_palettes.R`, `demo_show_palette.R`
- Tests: `test_palettes.R`, `test_package.R`, `test_show_palette.R`, `check_palettes.R`
- Data: `palette_list.RData`, `palette_summary.csv`
- Documentation: `PALETTE_FIX.md`
- Examples: `all_palettes.png`, `plot*.png` (4 images), `test_show_palette_*.png` (6 images)

### **patterns/** - Pattern Extraction
Pattern and hatching extraction from SVG files.

- Parsing: `parse_patterns.R`, `parse_patterns_v2.R`
- Tests: `test_patterns.R`
- Data: `svg_patterns.RData`
- Documentation: `PATTERNS.md`
- Examples: `pattern_example*.png` (3 images)

### **vignettes/** - Vignette Development
Documentation and fixes for package vignettes.

- Build: `build_vignette.R`
- Tests: `test_guerry_map.R`
- Documentation: `VIGNETTE_INFO.md`, `VIGNETTES_SUMMARY.md`, `GUERRY_VIGNETTE_INFO.md`, `GUERRY_VIGNETTE_FIXES.md`, `GUERRY_PATTERN_ADDITIONS.md`, `REGION_COLUMN_FIX.md`

### **Root dev/ files**
- `README.md` - This file
- `CHECK_FIXES.md` - General package fixes
- `PACKAGE_STATUS.md` - Package status overview
- `simulate_check_examples.R` - R CMD check simulation
- `test_grid_layout.R` - General utility test
- `complete_example.R` + `complete_example*.png` (5 images) - Complete package examples

---

## What Was Implemented

### 1. Color Palette Extraction (`palettes/extract_palettes.R`)

- Parses all 25 SVG pattern files from `data-raw/observable/`
- Extracts hex color codes from `fill` and `stroke` attributes
- Links palettes to album metadata from `albumColors.csv`
- Generated 20 working palettes (5 had mapping issues)

### 2. Package Data Object (`cheysson_palettes.rda`)

Created in `data-raw/cheysson_palettes.R`, contains:

- **20 color palettes** named by album year and plate (e.g., "1880_07")
- Each palette includes:
  - `colors`: Vector of hex color codes
  - `type`: One of "sequential", "diverging", "grouped", "category"
  - `album`: Year (1880-1906)
  - `plate`: Plate number within album
  - `rumsey_no`: Reference to David Rumsey collection
  - `dec_day`: Original advent calendar numbering

**Palette Distribution:**
- Sequential: 7 palettes (1-3 colors each)
- Diverging: 2 palettes (2-3 colors each)
- Grouped: 5 palettes (2-5 colors each)
- Category: 6 palettes (3-7 colors each)

### 3. R Functions (`R/palettes.R`)

**`cheysson_pal(palette, n, type)`**
- Get colors from a specific palette or palette type
- Optionally specify number of colors (interpolates if needed)
- Can select palettes by type (e.g., "sequential")

**`list_cheysson_pals(type)`**
- List all available palettes with metadata
- Optional filtering by type

### 4. ggplot2 Scales (`R/scales.R`)

**`scale_color_cheysson(palette, discrete, reverse, ...)`**
- Color scale using Cheysson palettes
- Works for both discrete and continuous data
- British spelling variant `scale_colour_cheysson()` also available

**`scale_fill_cheysson(palette, discrete, reverse, ...)`**
- Fill scale using Cheysson palettes
- Same features as color scale

### 5. Pattern Support (`R/patterns.R`)

**`scale_pattern_*_cheysson()`** family of functions
- Pattern type, fill, angle, density, spacing scales
- Integration with ggpattern package
- Historically accurate pattern specifications

### 6. Font Integration

- Automated font installation for Windows
- Support for Playfair Display font family
- Cross-platform font handling
- Integration with ragg and showtext packages

### 7. Documentation

- All functions fully documented with roxygen2
- Data objects documented with examples
- NAMESPACE automatically generated
- Man pages in `man/` directory
- Vignettes for Guerry data and pattern usage

## Usage Examples

```r
library(ggCheysson)
library(ggplot2)

# List all palettes
list_cheysson_pals()

# List sequential palettes only
list_cheysson_pals("sequential")

# Get colors from a palette
cheysson_pal("1880_07")

# Use in ggplot2 - discrete color
ggplot(iris, aes(Sepal.Length, Sepal.Width, color = Species)) +
  geom_point() +
  scale_color_cheysson()

# Use specific palette
ggplot(iris, aes(Sepal.Length, Sepal.Width, color = Species)) +
  geom_point() +
  scale_color_cheysson(palette = "1881_04")

# Fill scale
ggplot(iris, aes(Species, Sepal.Width, fill = Species)) +
  geom_boxplot() +
  scale_fill_cheysson(palette = "category")

# Continuous scale
ggplot(iris, aes(Sepal.Length, Sepal.Width, color = Petal.Length)) +
  geom_point() +
  scale_color_cheysson(palette = "sequential", discrete = FALSE)

# Pattern scales (with ggpattern)
library(ggpattern)
ggplot(data, aes(x, y, pattern_type = category)) +
  geom_col_pattern() +
  scale_pattern_type_cheysson()
```

## Key Files by Topic

### Palette Development
- **Extraction**: `palettes/extract_palettes.R`
- **Inspection**: `palettes/inspect_palettes.R`
- **Visualization**: `palettes/visualize_palettes.R`
- **Tests**: `palettes/test_palettes.R`, `palettes/test_package.R`
- **Data**: `palettes/palette_list.RData`, `palettes/palette_summary.csv`

### Pattern Development
- **Parsing**: `patterns/parse_patterns.R`, `patterns/parse_patterns_v2.R`
- **Tests**: `patterns/test_patterns.R`
- **Data**: `patterns/svg_patterns.RData`
- **Documentation**: `patterns/PATTERNS.md`

### Font Development
- **Documentation**: `fonts/FONTS.md`, `fonts/FONTS_WINDOWS.md`
- **Tests**: `fonts/test_fonts.R`, `fonts/test_fonts_themes.R`, etc.

### Vignette Development
- **Build**: `vignettes/build_vignette.R`
- **Documentation**: `vignettes/VIGNETTES_SUMMARY.md`, `vignettes/GUERRY_VIGNETTE_INFO.md`
- **Fixes**: `vignettes/GUERRY_VIGNETTE_FIXES.md`, `vignettes/REGION_COLUMN_FIX.md`

### Color-Pattern Work (ON HOLD)
- **Prototype**: `colorpat/prototype_colorpat.R`
- **Extraction**: `colorpat/extract_colorpat_pairings.R`
- **Documentation**: `colorpat/UNIFIED_COLOR_PATTERN_PLAN.md`
- **Status**: Too complex for current release

## Package Status

See `PACKAGE_STATUS.md` for overall package development status.

## Notes

- Some palettes have only 1-2 colors because they rely on patterns/hatching for differentiation
- The original SVG files contain both colors and line patterns
- Pattern information has been extracted and is available through pattern scales
- Palette names use the album year and plate number for clarity
  - Original "dec01" through "dec25" naming from Advent calendar is preserved in metadata
- **Unified color-pattern palette system** is on hold - too complex for this release

## Completed Features

✅ Color palette extraction and integration
✅ Pattern extraction and ggpattern integration
✅ Font installation and integration (Windows)
✅ ggplot2 scale functions for colors and patterns
✅ Comprehensive documentation and vignettes
✅ Package structure and organization

## Features On Hold

⏸️ Unified color-pattern palette system (`colorpat/`) - deferred to future release
