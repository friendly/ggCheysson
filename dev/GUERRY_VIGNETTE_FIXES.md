# Guerry Vignette Fixes

## Issues Fixed

### 1. Inappropriate Sequential Palette

**Problem**: The palette `1880_07` was used for continuous sequential data in several maps, but it's actually a **category palette with 7 colors** that lacks coherent sequential ordering of hues.

**Maps Affected**:
- Crime Against Persons (map 1)
- Small Multiples faceted map (map 7)
- Bivariate comparison (map 9)

**Solution**: Changed to `1895_04`, which is a true **sequential palette with 3 colors**, providing proper gradients for continuous ranked data.

### 2. Corrected Variable Description

**Problem**: The `Infants` variable description was incorrect.

**Correct Description**:
- **Simple label**: "Illegitimate births"
- **Complete label**: "Population per illegitimate birth"

**Context**: The `Infants` variable in Guerry's data measures the ratio of population to illegitimate births in each department. This is a standard measure from 19th century French social statistics.

## Changes Made

### Vignette File (`vignettes/guerry-maps.Rmd`)

1. **Line 121**: Crime Against Persons map
   - Changed: `scale_fill_cheysson("1880_07", ...)`
   - To: `scale_fill_cheysson("1895_04", ...)`

2. **Line 230-231**: Map title and subtitle
   - Changed: "Infant Abandonment" / "Abandoned infants per population"
   - To: "Illegitimate Births" / "Population per illegitimate birth"

3. **Line 290**: Small Multiples faceted map
   - Changed: `scale_fill_cheysson("1880_07", ...)`
   - To: `scale_fill_cheysson("1895_04", ...)`

4. **Line 367**: Bivariate comparison map
   - Changed: `scale_fill_cheysson("1880_07", ...)`
   - To: `scale_fill_cheysson("1895_04", ...)`

5. **Line 402**: Variable description
   - Changed: "Abandoned infants (per capita)"
   - To: "Population per illegitimate birth"

### Documentation Files

1. **`dev/GUERRY_VIGNETTE_INFO.md`**:
   - Updated palette list to reflect `1895_04` usage
   - Added note explaining why `1880_07` was inappropriate
   - Updated Infants description
   - Updated map list with new palette information

## Why These Changes Matter

### Sequential vs Category Palettes

**Category palettes** (like `1880_07`):
- Designed for distinct, unordered categories
- Colors are chosen for maximum contrast/distinction
- No inherent ordering or progression
- Example: Red, blue, green, orange, purple...

**Sequential palettes** (like `1895_04`):
- Designed for ordered, continuous data
- Colors progress smoothly from light to dark
- Natural visual hierarchy (low → high)
- Example: Light blue → medium blue → dark blue

**Impact**: Using `1880_07` for ranked continuous data could mislead readers because the color ordering doesn't match the data ordering. `1895_04` provides proper visual progression.

### Historical Accuracy

The term "illegitimate births" accurately represents what Guerry measured:
- Standard measure in 19th century French social statistics
- Population per illegitimate birth ratio
- Part of Guerry's moral statistics framework
- Comparable across departments

## Palette Comparison

### 1880_07 (Category)
- **Colors**: 7 distinct hues
- **Type**: Category
- **Best for**: Discrete categorical data (regions, groups)
- **Problem for continuous data**: No logical color progression

### 1895_04 (Sequential)
- **Colors**: 3 colors in progression
- **Type**: Sequential
- **Best for**: Continuous numerical data (rankings, rates)
- **Advantage**: Creates smooth gradient through interpolation

## Verification

To verify the improvements:

```r
# Load package
library(ggCheysson)

# Compare palettes
cheysson_pal("1880_07")  # Category: diverse hues
cheysson_pal("1895_04")  # Sequential: ordered progression

# Check palette types
cheysson_palettes[["1880_07"]]$type  # "category"
cheysson_palettes[["1895_04"]]$type  # "sequential"
```

## Files Modified

1. `vignettes/guerry-maps.Rmd` - Main vignette
2. `dev/GUERRY_VIGNETTE_INFO.md` - Documentation
3. `dev/GUERRY_VIGNETTE_FIXES.md` - This file (NEW)

## Result

The vignette now:
- ✅ Uses appropriate sequential palettes for continuous data
- ✅ Provides historically accurate variable descriptions
- ✅ Demonstrates proper palette selection for different data types
- ✅ Creates more accurate and readable choropleth maps
