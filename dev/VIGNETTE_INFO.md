# ggCheysson Vignette Information

## Vignette Created: Getting Started

**File**: `vignettes/getting-started.Rmd`

### Content Overview

The "Getting Started" vignette provides a comprehensive introduction to the ggCheysson package with practical examples covering:

#### 1. **Setup & Installation**
- Package installation instructions
- Loading fonts (using showtext method for vignettes)

#### 2. **Color Palettes** (Examples: 3 plots)
- Sequential palette: Iris scatterplot with continuous color scale
- Categorical palette: Iris scatterplot with discrete colors by species
- Diverging palette: Temperature anomaly visualization

#### 3. **Bar Charts** (Examples: 2 plots)
- Simple bar chart with solid colors
- Bar chart with hatching patterns using ggpattern

#### 4. **Line Graphs** (Examples: 1 plot)
- Time series showing railway traffic development (1880-1900)
- Multiple series with different line types

#### 5. **Area Charts** (Examples: 1 plot)
- Stacked area chart showing industrial production by sector

#### 6. **Faceted Plots** (Examples: 1 plot)
- Small multiples comparing population growth across 4 cities

#### 7. **Grouped Charts** (Examples: 1 plot)
- Grouped bar chart with patterns showing infrastructure by region

#### 8. **Map-Style Visualization** (Examples: 1 plot)
- Tile-based map using theme_cheysson_map()

### Total Examples: 10 plots

### Graph Types Covered
- ✅ Scatterplots (2 variants)
- ✅ Bar charts (simple + patterned)
- ✅ Grouped bar charts with patterns
- ✅ Line graphs (time series)
- ✅ Area charts (stacked)
- ✅ Faceted plots (small multiples)
- ✅ Map-style visualizations

### Palettes Demonstrated
- Sequential: `1880_07`
- Categorical: `1881_04`, `1883_04`, `1881_03`
- Diverging: First diverging palette
- Pattern palettes: `1881_03`, `1881_03`

### Themes Used
- `theme_cheysson()` - Primary theme (most examples)
- `theme_cheysson_minimal()` - For line graph
- `theme_cheysson_map()` - For map visualization

### Font Usage
All examples use Cheysson fonts when available (loaded via showtext).

## Building the Vignette

### During Development
```r
# Build vignettes locally
devtools::build_vignettes()

# Or use the helper script
source("dev/build_vignette.R")
```

### For Users
```r
# Install with vignettes
devtools::install_github("friendly/ggCheysson", build_vignettes = TRUE)

# View the vignette
vignette("getting-started", package = "ggCheysson")
```

### For pkgdown Site
```r
# Build articles section
pkgdown::build_articles()

# Or full site
pkgdown::build_site()
```

## Files Modified

1. **`vignettes/getting-started.Rmd`** - Main vignette file (NEW)
2. **`DESCRIPTION`** - Added knitr, rmarkdown to Suggests; added VignetteBuilder
3. **`_pkgdown.yml`** - Added articles section
4. **`dev/build_vignette.R`** - Helper script to build vignette (NEW)

## Notes

- The vignette uses `showtext` method for font loading (works better in documents)
- All code chunks set to execute (`eval=TRUE`) except installation chunks
- Includes error handling for optional dependencies (ggpattern, showtext)
- Figure dimensions optimized for viewing (7" × 5" typical)
- Uses real datasets (iris, mtcars) and simulated historical data

## Next Steps

If you want to add more vignettes in the future:

1. **Advanced Patterns** - Deep dive into pattern specifications
2. **Historical Context** - Story of the Albums de Statistique Graphique
3. **Color Theory** - How Cheysson used color for data communication
4. **Recreating Classic Charts** - Step-by-step reproductions of specific Album plates
