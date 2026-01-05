# Palette Name Fixes for Guerry Vignette

## Issue

The guerry-maps vignette used invalid palette names that don't exist in the package:
- `1885_11` - does not exist
- `1882_03` - does not exist

## Available Palettes

The ggCheysson package has **20 palettes total**:

### Sequential (7 palettes)
- `1881_03` (1 color)
- `1886_04` (2 colors)
- `1888_05` (1 color)
- `1891_06` (1 color)
- `1891_07` (2 colors) ⭐ **USED IN VIGNETTE**
- `1895_04` (3 colors) ⭐ **USED IN VIGNETTE**
- `1900_06` (2 colors)

### Diverging (2 palettes)
- `1883_04` (2 colors) ⭐ **USED IN VIGNETTE**
- `1883_07` (3 colors)

### Grouped (5 palettes)
- `1881_08` (5 colors)
- `1882_04` (2 colors)
- `1886_08` (4 colors)
- `1887_06` (2 colors) ⭐ **USED IN VIGNETTE**
- `1891_03` (2 colors)

### Category (6 palettes)
- `1880_07` (7 colors) ⭐ **USED IN VIGNETTE**
- `1881_04` (4 colors) ⭐ **USED IN VIGNETTE**
- `1883_06` (4 colors)
- `1886_07` (3 colors)
- `1906_04` (4 colors)
- `1906_06` (6 colors)

## Fixes Applied

### Map 1: Crime Against Persons
- Palette: `1880_07` (category, 7 colors)
- **No change** - this was already correct
- Works well with `discrete = FALSE` for continuous gradient

### Map 2: Property Crime
- **Before**: `1885_11` ❌ (invalid)
- **After**: `1895_04` ✅ (sequential, 3 colors)
- Sequential palette with 3 colors, good for continuous scale

### Map 3: Literacy
- Palette: `1881_04` (category, 4 colors)
- **No change** - this was already correct
- Used for discrete quintiles

### Map 4: Donations
- Palette: `1883_04` (diverging, 2 colors)
- **No change** - this was already correct
- Used for discrete quartiles

### Map 5: Infant Abandonment
- **Before**: `1882_03` ❌ (invalid)
- **After**: `1891_07` ✅ (sequential, 2 colors)
- Sequential palette, suitable for continuous scale

### Map 6: Suicides
- Palette: `1887_06` (grouped, 2 colors)
- **No change** - this was already correct
- Works for continuous scale

### Map 7: Small Multiples
- Palette: `1880_07` (category, 7 colors)
- **No change** - this was already correct

### Map 8: Regions
- Uses `"category"` type selector
- **No change** - this was already correct

### Map 9: Bivariate
- Palette: `1880_07` (category, 7 colors)
- **No change** - this was already correct

## Key Insight

Many of the "sequential" palettes only have 1-2 colors, which limits their usefulness for continuous scales. However:

1. **Category palettes with many colors** (like `1880_07` with 7 colors) work excellently for continuous scales when using `discrete = FALSE`
2. **ColorRampPalette** interpolates between the provided colors, so even 2-3 color palettes can create smooth gradients
3. The package design allows flexible use of any palette type for different visualization needs

## Files Modified

1. `vignettes/guerry-maps.Rmd` - Fixed palette names
2. `dev/GUERRY_VIGNETTE_INFO.md` - Updated documentation
3. `dev/check_palettes.R` - Added palette checking script
4. `dev/PALETTE_FIX.md` - This documentation

## Testing

Run these to verify the fixes:

```r
# Check all available palettes
source("dev/check_palettes.R")

# Test the Guerry map
source("dev/test_guerry_map.R")

# Build the vignette
devtools::build_vignettes()
```

The vignette should now build without errors!
