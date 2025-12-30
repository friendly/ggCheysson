# Guerry Maps Vignette

## Overview

**File**: `vignettes/guerry-maps.Rmd`
**Title**: "Mapping Guerry's Moral Statistics with Cheysson Palettes"

This vignette creates a beautiful connection between two pioneers of statistical graphics:
- **André-Michel Guerry** (1802-1866): First to use choropleth maps for social statistics (1833)
- **Émile Cheysson** (1836-1910): Perfected statistical visualization in the Albums (1879-1897)

## Content

### Historical Data: Guerry::Guerry
- Crime against persons (`Crime_pers`)
- Crime against property (`Crime_prop`)
- Literacy rates (`Literacy`)
- Charitable donations (`Donations`)
- Illegitimate births (`Infants` - population per illegitimate birth)
- Suicides (`Suicides`)

All variables converted to **ranks** to handle different scales.

### Maps Created (12 total)

#### Color-Only Maps (9)
1. **Crime Against Persons** - Sequential palette `1895_04`
2. **Property Crime** - Sequential palette `1895_04`
3. **Literacy** (quintiles) - Grouped palette `1881_04`
4. **Charitable Donations** (quartiles) - Category palette `1883_04`
5. **Illegitimate Births** - Sequential palette `1891_07`
6. **Suicides** - Grouped palette `1887_06`
7. **Small Multiples** - Faceted map showing 4 variables with palette `1895_04`
8. **Regions of France** - Category palette
9. **Bivariate Map** - Crime with literacy overlay using `1895_04`

#### Pattern-Enhanced Maps (3) - **NEW!**
10. **Literacy with Patterns** - Combines colors and hatching (palette `1881_04`)
11. **Donations with Patterns** - Cheysson-style patterns and colors (palette `1883_04`)
12. **Regions with Patterns** - Distinctive hatching for each region (category palette)

### Technical Approach

**Spatial Data Handling:**
- Converts `Guerry::gfrance85` (SpatialPolygonsDataFrame) to sf object using `sf::st_as_sf()`
- Uses modern `geom_sf()` for ggplot2 mapping
- Joins spatial data with tabular data via `Department` variable

**Data Transformation:**
- Ranks continuous variables (handles different scales)
- Creates quintiles/quartiles for discrete display
- Uses `tidyr::pivot_longer()` for faceted maps

**Visualization:**
- All maps use `theme_cheysson_map()`
- Demonstrates 6 different Cheysson palettes
- Shows both continuous and discrete color scales
- Includes faceted (small multiples) layout
- Demonstrates bivariate visualization

### Palettes Used

- **Sequential**: `1895_04` (sequential, 3 colors) - primary palette used for most continuous scales, `1891_07` (sequential, 2 colors)
- **Grouped**: `1881_04` (category, 4 colors), `1887_06` (grouped, 2 colors)
- **Category**: `1883_04` (diverging, 2 colors), `category` (auto-select)

**Note**: `1895_04` is the best true sequential palette in the package with 3 colors, providing good color gradients for continuous data. Previously used `1880_07` (category, 7 colors) was replaced as it lacks coherent sequential ordering.

### Key Features Demonstrated

1. **Choropleth mapping** with sf and geom_sf
2. **Cheysson hatching patterns** combined with colors using geom_sf_pattern
3. **Pattern scales** (scale_pattern_type_cheysson, scale_pattern_fill_cheysson)
4. **Converting rankings** for comparable scales
5. **Discrete categorization** (quintiles, quartiles)
6. **Faceted maps** for multiple variables
7. **Bivariate display** techniques
8. **Historical context** and references
9. **theme_cheysson_map()** usage

### Cheysson Pattern Techniques

The vignette showcases the **signature feature** of Cheysson's Albums: combining hatching patterns with colors. This provides:
- Visual distinction through dual encoding (color + pattern)
- Authentic 19th century cartographic style
- Enhanced readability and accessibility
- Rich, textured aesthetic characteristic of the Golden Age

## Historical Significance

### Guerry's Contribution (1833)
- First systematic use of choropleth maps for social data
- Pioneered spatial analysis of crime and moral statistics
- Examined relationships between education, poverty, and crime

### The Connection
Combining Guerry's data (1833) with Cheysson's visual style (1879-1897) creates a 40-50 year bridge in the history of statistical graphics, showing how visualization techniques evolved during the "Golden Age."

## Dependencies

New packages added to `Suggests`:
- **Guerry** - Contains the historical data and maps
- **sf** - Modern spatial data handling
- **tidyr** - Data reshaping for faceted plots

## Building the Vignette

```r
# Build all vignettes
devtools::build_vignettes()

# Or with pkgdown
pkgdown::build_articles()

# Install with vignettes
devtools::install(build_vignettes = TRUE)
```

## Viewing

```r
# After installation
vignette("guerry-maps", package = "ggCheysson")

# Or view on pkgdown site
pkgdown::build_site()
# Then navigate to Articles > Mapping Guerry's Moral Statistics
```

## Files Modified

1. **`vignettes/guerry-maps.Rmd`** - Main vignette file (NEW)
2. **`DESCRIPTION`** - Added Guerry, sf, tidyr to Suggests
3. **`_pkgdown.yml`** - Added guerry-maps to articles section
4. **`dev/GUERRY_VIGNETTE_INFO.md`** - This documentation file (NEW)

## Potential Extensions

Future enhancements could include:
- Pattern overlays using ggpattern
- Animation showing temporal changes (if multi-year data available)
- Interactive maps using plotly or leaflet
- Comparison with modern French statistics
- More sophisticated bivariate techniques (e.g., 3×3 color matrix)

## References

- Guerry, A.-M. (1833). *Essai sur la statistique morale de la France*
- Friendly, M. (2007). A.-M. Guerry's Moral Statistics of France. *Statistical Science*, **22**(3), 368-399
- Friendly, M. (2008). The Golden Age of Statistical Graphics. *Statistical Science*, **23**(4), 502-535
