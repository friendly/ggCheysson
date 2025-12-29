# Development Notes for ggCheysson

This folder contains development scripts, tests, and notes for the ggCheysson package.

## What Was Implemented

### 1. Color Palette Extraction (`extract_palettes.R`)

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

### 5. Documentation

- All functions fully documented with roxygen2
- Data object documented with examples
- NAMESPACE automatically generated
- Man pages in `man/` directory

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
```

## Test Files

- **`test_palettes.R`**: Basic tests of data structure
- **`inspect_palettes.R`**: Detailed inspection of palette contents
- **`test_package.R`**: Full package test with plot generation
  - Creates 4 example plots demonstrating different scale types
  - Saves plots to `dev/plot*.png`

## Files Generated

- `palette_list.RData`: Raw extraction results
- `palette_summary.csv`: Summary table of all palettes
- `plot1_discrete.png`: Discrete color scale example
- `plot2_palette.png`: Different palette example
- `plot3_fill.png`: Fill scale example
- `plot4_continuous.png`: Continuous scale example

## Next Steps

Potential enhancements:
1. **Patterns/hatching**: Implement fill patterns using ggpattern
2. **Themes**: Create `theme_cheysson()` for overall plot styling
3. **Fonts**: Integrate the Cheysson fonts
4. **More palettes**: Fix the 5 palettes that didn't import correctly
5. **Palette visualization**: Create a function to display all palettes
6. **Interpolation**: Better color interpolation for continuous scales
7. **Documentation**: Add vignette with historical context and examples

## Notes

- Some palettes have only 1-2 colors because they rely on patterns/hatching for differentiation
- The original SVG files contain both colors and line patterns
- Pattern information is not yet extracted (future enhancement)
- Palette names use the album year and plate number for clarity
  - Original "dec01" through "dec25" naming from Advent calendar is preserved in metadata
