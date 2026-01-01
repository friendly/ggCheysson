# ggCheysson Package Vignettes

## Overview

The ggCheysson package includes two comprehensive vignettes demonstrating the package's capabilities with different types of visualizations.

---

## Vignette 1: Getting Started

**File**: `vignettes/getting-started.Rmd`
**Title**: "Getting Started with ggCheysson"

### Purpose
Comprehensive introduction to all package features with varied plot types.

### Content (10 examples)

#### Graph Types
1. **Scatterplots** (2) - Sequential and categorical palettes
2. **Bar Charts** (2) - Solid colors and hatching patterns
3. **Line Graph** - Multi-series time series
4. **Stacked Area Chart** - Composition over time
5. **Faceted Plot** - Small multiples comparison
6. **Grouped Bar Chart** - With patterns
7. **Map-style Tile Visualization** - Grid-based map
8. **Diverging Palette** - Temperature anomalies

#### Features Demonstrated
- All 4 palette types (sequential, diverging, grouped, category)
- Pattern integration with ggpattern
- All 3 themes (standard, minimal, map)
- Font loading and usage
- Various ggplot2 geoms

#### Data Used
- Built-in R datasets (iris, mtcars)
- Simulated historical data

---

## Vignette 2: Mapping Guerry's Moral Statistics

**File**: `vignettes/guerry-maps.Rmd`
**Title**: "Mapping Guerry's Moral Statistics with Cheysson Palettes"

### Purpose
Specialized demonstration of choropleth mapping with historical social statistics, showcasing Cheysson's signature hatching patterns combined with colors.

### Content (12 maps: 9 color-only + 3 with patterns)

#### Color-Only Thematic Maps (9)
1. **Crime Against Persons** - Sequential palette
2. **Property Crime** - Different sequential palette
3. **Literacy Rates** (quintiles) - Grouped palette
4. **Charitable Donations** (quartiles) - Category palette
5. **Illegitimate Births** - Sequential palette
6. **Suicides** - Sequential palette
7. **Small Multiples** - Faceted comparison of 4 variables
8. **Regions** - Administrative divisions
9. **Bivariate Map** - Crime with literacy overlay

#### Pattern-Enhanced Maps (3) - Signature Cheysson Style
10. **Literacy with Patterns** - Colors + hatching patterns (quintiles)
11. **Donations with Patterns** - Authentic Albums-style dual encoding
12. **Regions with Patterns** - Distinctive patterns for each region

#### Historical Significance
- **André-Michel Guerry** (1833): Pioneer of statistical cartography
- **Émile Cheysson** (1879-1897): Perfected statistical graphics
- Combines historical data with historical visual style
- Demonstrates 40-50 year evolution in statistical graphics

#### Technical Features
- Spatial data handling (SpatialPolygonsDataFrame → sf)
- Modern ggplot2 mapping with `geom_sf()` and `geom_sf_pattern()`
- **Cheysson hatching patterns** using ggpattern integration
- **Pattern scales** (scale_pattern_type_cheysson, scale_pattern_fill_cheysson)
- Dual encoding with colors and patterns
- Data joining and transformation
- Ranking continuous variables
- Categorical binning (quintiles, quartiles)
- Faceted spatial layouts
- `theme_cheysson_map()` usage

#### Data Used
- **Guerry::Guerry** - Historical social statistics of France (1830s)
- **Guerry::gfrance85** - Map of French departments
- Variables: Crime, literacy, donations, abandonment, suicides

---

## Comparison

| Feature | Getting Started | Guerry Maps |
|---------|----------------|-------------|
| **Focus** | General introduction | Specialized cartography |
| **Plot Types** | 8 diverse types | Choropleth maps |
| **Examples** | 10 plots | 12 maps |
| **Data** | Built-in/simulated | Historical (Guerry) |
| **Themes** | All 3 themes | theme_cheysson_map() |
| **Palettes** | All types | Sequential & category |
| **Patterns** | Yes (bar charts) | **Yes (3 maps with patterns)** |
| **Spatial** | Tile grid only | Full sf integration |
| **Historical Context** | Cheysson Albums | Guerry + Cheysson |

---

## Dependencies

### Common to Both
- ggplot2
- ggCheysson
- showtext, sysfonts (for fonts)
- knitr, rmarkdown (for building)

### Getting Started
- ggpattern (for pattern examples)
- tidyr (for data reshaping)

### Guerry Maps
- **Guerry** (historical data)
- **sf** (spatial data)
- tidyr (for faceted maps)

---

## Building Vignettes

### Build All Vignettes
```r
devtools::build_vignettes()
```

### Build for pkgdown Site
```r
pkgdown::build_articles()
# or
pkgdown::build_site()
```

### Install Package with Vignettes
```r
devtools::install_github("friendly/ggCheysson", build_vignettes = TRUE)
```

### View Vignettes After Installation
```r
vignette("getting-started", package = "ggCheysson")
vignette("guerry-maps", package = "ggCheysson")
```

---

## Test Scripts

Quick tests for functionality:

```r
# Test general features
source("dev/test_ragg_fonts.R")
source("dev/test_showtext_fonts.R")

# Test Guerry maps
source("dev/test_guerry_map.R")

# Build vignettes
source("dev/build_vignette.R")
```

---

## Files Structure

```
ggCheysson/
├── vignettes/
│   ├── getting-started.Rmd    # General introduction
│   └── guerry-maps.Rmd        # Choropleth maps
├── dev/
│   ├── VIGNETTE_INFO.md       # Getting started docs
│   ├── GUERRY_VIGNETTE_INFO.md # Guerry maps docs
│   ├── VIGNETTES_SUMMARY.md   # This file
│   ├── build_vignette.R       # Build helper
│   └── test_guerry_map.R      # Test Guerry functionality
├── DESCRIPTION                # Updated with dependencies
└── _pkgdown.yml              # Articles section configured
```

---

## Future Vignette Ideas

Potential additional vignettes:

1. **Pattern Deep Dive**
   - Detailed exploration of all 83 patterns
   - Pattern creation and customization
   - Advanced ggpattern techniques

2. **Historical Recreation**
   - Step-by-step recreation of specific Album plates
   - Matching original designs
   - Historical accuracy discussion

3. **Color Theory**
   - Cheysson's use of color for data
   - Palette selection guidelines
   - Accessibility considerations

4. **Advanced Cartography**
   - Modern French data with Cheysson style
   - Multi-layer maps
   - Animation and interactivity

5. **Typography and Design**
   - Font selection for different contexts
   - Layout principles from the Albums
   - Complete design workflow

---

## References

### Guerry
- Guerry, A.-M. (1833). *Essai sur la statistique morale de la France*
- Friendly, M. (2007). A.-M. Guerry's Moral Statistics of France. *Statistical Science*, **22**(3), 368-399

### Cheysson
- France. Ministère des travaux publics. *Album de statistique graphique de [year]*. Paris: Imprimerie nationale, [1879-1897]
- Friendly, M. (2008). The Golden Age of Statistical Graphics. *Statistical Science*, **23**(4), 502-535

### Visualization History
- Friendly, M. & Wainer, H. (2021). *A History of Data Visualization and Graphic Communication*. Harvard University Press
