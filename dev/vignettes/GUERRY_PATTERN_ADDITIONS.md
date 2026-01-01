# Cheysson Pattern Additions to Guerry Vignette

## Overview

Added **3 new pattern-enhanced maps** to the Guerry vignette, showcasing the signature feature of Cheysson's *Albums de Statistique Graphique*: combining hatching patterns with colors.

## New Maps Added

### 1. Literacy with Cheysson Patterns (p3b)

**After**: Map 3 (Literacy quintiles)
**Palette**: `1881_04` (grouped, 4 colors)
**Features**:
- `geom_sf_pattern()` with stripe patterns
- `scale_pattern_type_cheysson()` - varying pattern types by quintile
- `scale_pattern_fill_cheysson()` - pattern fill colors
- `scale_fill_cheysson_pattern()` - background fill colors
- Pattern density: 0.3, spacing: 0.02

**Purpose**: Demonstrate dual encoding (color + pattern) for categorical data on maps.

### 2. Donations with Cheysson Patterns (p4b)

**After**: Map 4 (Charitable donations quartiles)
**Palette**: `1883_04` (diverging, 2 colors)
**Features**:
- Similar pattern approach as literacy map
- Quartile categories with distinct patterns
- Pattern density: 0.35, spacing: 0.025
- Shows authentic *Albums* cartographic style

**Purpose**: Illustrate how patterns enhance visual distinction between donation levels.

### 3. Regions with Patterns (p8b)

**After**: Map 8 (Regions of France)
**Palette**: `category` (auto-select)
**Features**:
- Each region gets distinctive hatching pattern
- Most characteristic of Cheysson's regional maps
- Pattern density: 0.3, spacing: 0.02
- Strong black borders (linewidth: 0.5)

**Purpose**: Show how Cheysson used varied patterns to distinguish administrative regions - a hallmark technique of the *Albums*.

## Technical Implementation

### Code Pattern

All three maps use the same basic structure:

```r
ggplot(france_data) +
  geom_sf_pattern(
    aes(fill = variable,
        pattern_type = variable,
        pattern_fill = variable),
    pattern = "stripe",
    pattern_density = 0.3,
    pattern_spacing = 0.02,
    color = "black",
    linewidth = 0.4
  ) +
  scale_fill_cheysson_pattern("palette_name") +
  scale_pattern_fill_cheysson("palette_name") +
  scale_pattern_type_cheysson("palette_name") +
  labs(...) +
  theme_cheysson_map() +
  guides(
    fill = guide_legend(title = "..."),
    pattern_type = guide_legend(title = "..."),
    pattern_fill = "none"  # Hide redundant legend
  )
```

### Key Elements

1. **Triple aesthetic mapping**:
   - `fill` - Background color
   - `pattern_type` - Type of hatching (stripe, crosshatch, etc.)
   - `pattern_fill` - Color of the pattern lines

2. **Triple scale specification**:
   - `scale_fill_cheysson_pattern()` - Background colors
   - `scale_pattern_fill_cheysson()` - Pattern line colors
   - `scale_pattern_type_cheysson()` - Pattern types

3. **Pattern parameters**:
   - `pattern = "stripe"` - Use line patterns
   - `pattern_density = 0.3` - Spacing between lines
   - `pattern_spacing = 0.02` - Line thickness control

4. **Strong borders**:
   - `color = "black"` - Black department boundaries
   - `linewidth = 0.4-0.5` - Visible borders

## Historical Significance

### Why Patterns Matter

Hatching patterns were **not optional** in Cheysson's work - they were fundamental:

1. **Printing technology**: Color printing was expensive; patterns allowed multi-category distinction in monochrome or limited color
2. **Visual richness**: Patterns created texture and visual interest
3. **Redundant encoding**: Both color and pattern convey the same information, improving readability
4. **Aesthetic tradition**: Followed engraving and cartographic traditions of the 19th century

### Cheysson's Innovation

Cheysson didn't invent hatching, but he perfected its use:
- Systematic pattern vocabularies
- Careful coordination of colors and patterns
- Varied angles (0°, 45°, 90°, 135°) for distinction
- Appropriate pattern density for map scale

## Vignette Impact

### Before (9 maps)
- Focused on color palettes only
- Modern cartographic style
- Missing signature Cheysson technique

### After (12 maps)
- **Showcases complete Cheysson aesthetic**
- Demonstrates dual encoding technique
- Authentically recreates *Albums* cartographic style
- Educational about 19th century visualization methods

## Files Modified

1. **`vignettes/guerry-maps.Rmd`**:
   - Added `library(ggpattern)` to packages
   - Added 3 new pattern-enhanced map chunks
   - Updated summary section to highlight patterns
   - Added explanation of Cheysson's pattern techniques

2. **`dev/GUERRY_VIGNETTE_INFO.md`**:
   - Updated map count (9 → 12)
   - Split maps into color-only vs pattern-enhanced
   - Added "Cheysson Pattern Techniques" section

3. **`dev/VIGNETTES_SUMMARY.md`**:
   - Updated comparison table
   - Added pattern features to technical description
   - Updated map counts

4. **`dev/GUERRY_PATTERN_ADDITIONS.md`**:
   - This documentation file (NEW)

## Usage Example

Users can now see both approaches side-by-side:

```r
# Simple color-only map (modern style)
ggplot(france_data) +
  geom_sf(aes(fill = Literacy_quint), ...) +
  scale_fill_cheysson("1881_04")

# Pattern-enhanced map (Cheysson style)
ggplot(france_data) +
  geom_sf_pattern(
    aes(fill = Literacy_quint,
        pattern_type = Literacy_quint,
        pattern_fill = Literacy_quint), ...) +
  scale_fill_cheysson_pattern("1881_04") +
  scale_pattern_fill_cheysson("1881_04") +
  scale_pattern_type_cheysson("1881_04")
```

## Educational Value

The vignette now teaches:

1. **Historical context**: Why patterns were used in 19th century
2. **Modern implementation**: How to recreate these techniques with ggpattern
3. **Aesthetic appreciation**: The rich visual language of the Golden Age
4. **Dual encoding**: Benefits of redundant visual channels
5. **Package capabilities**: Full range of ggCheysson pattern features

## Comparison: Color vs Patterns

### Color-Only Maps
- ✅ Simpler code
- ✅ Cleaner aesthetic for modern audiences
- ✅ Faster rendering
- ❌ Less historically authentic
- ❌ Single encoding channel

### Pattern-Enhanced Maps
- ✅ **Authentic Cheysson style**
- ✅ Dual encoding (color + pattern)
- ✅ Better for accessibility (redundant encoding)
- ✅ Rich, textured aesthetic
- ❌ More complex code
- ❌ Requires ggpattern package

## Testing

```r
# Build vignette
devtools::build_vignettes()

# Or test individual chunks
# Load packages
library(ggCheysson)
library(ggplot2)
library(Guerry)
library(sf)
library(ggpattern)

# Load data
data(Guerry)
data(gfrance85)
france_sf <- st_as_sf(gfrance85)
# ... follow vignette data prep ...

# Create pattern map
# ... run any of the p3b, p4b, or p8b chunks ...
```

## Result

The Guerry vignette now provides a **complete demonstration** of Cheysson's cartographic style, including his most distinctive innovation: the artful combination of colors and hatching patterns. This makes the vignette more educational, more visually impressive, and more historically authentic.
