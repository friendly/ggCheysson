# Cheysson Patterns Implementation

## Overview

The ggCheysson package now includes full support for the hatching and fill patterns used in the Albums de Statistique Graphique. These patterns combine solid colors with line-based hatching (stripes and crosshatching) that were characteristic of Cheysson's visualization style.

## Pattern Types

Patterns are extracted from the original SVG files and classified into three types:

1. **Solid** (50 patterns): Pure color fills with no hatching
2. **Stripe** (24 patterns): Single-direction line hatching
3. **Crosshatch** (9 patterns): Bidirectional line hatching

Total: **83 pattern specifications** across 20 palettes

## Data Structure

### `cheysson_patterns` Data Object

Located in `data/cheysson_patterns.rda`, this object contains pattern specifications for all 20 album/plate combinations:

```r
cheysson_patterns$`1881_03`
# $patterns - List of pattern specs
# $type - "sequential", "diverging", "grouped", or "category"
# $album - 1881
# $plate - 3
# $n_patterns - 3
```

### Pattern Specifications

Each pattern spec includes:

- **type**: "solid", "stripe", or "crosshatch"
- **fill**: Base fill color (hex code or "transparent")
- **pattern_fill**: Color of pattern lines
- **pattern_color**: Line stroke color
- **pattern_angle**: Angle in degrees (0-180)
- **pattern_density**: Line density (0-1)
- **pattern_spacing**: Spacing between lines
- **pattern_linewidth**: Width of pattern lines
- **direction**: "horizontal", "vertical", "diagonal_left", "diagonal_right"

## Functions

### Pattern Retrieval

**`cheysson_pattern(palette, n, type)`**
- Get pattern specifications from a palette
- Works with palette names ("1881_03") or types ("sequential")
- Returns list of pattern specs

**`list_cheysson_patterns(type)`**
- List all available pattern palettes
- Optional filtering by type

### Pattern Parameters

**`cheysson_pattern_params(patterns, param)`**
- Extract specific parameters from pattern specs
- Parameters: "fill", "pattern_fill", "pattern_angle", "pattern_density", "pattern_type", etc.
- Returns vector of values

### ggpattern Scales

**`scale_pattern_fill_cheysson(palette, reverse, ...)`**
- Sets pattern line colors

**`scale_pattern_type_cheysson(palette, reverse, ...)`**
- Sets pattern types (none, stripe, crosshatch)

**`scale_pattern_angle_cheysson(palette, reverse, ...)`**
- Sets stripe angles

**`scale_pattern_density_cheysson(palette, reverse, ...)`**
- Sets line densities

**`scale_fill_cheysson_pattern(palette, reverse, ...)`**
- Sets base fill colors

## Usage Example

```r
library(ggplot2)
library(ggpattern)
library(ggCheysson)

# Sample data
data <- data.frame(
  category = c("A", "B", "C"),
  value = c(10, 15, 12)
)

# Create plot with Cheysson patterns
ggplot(data, aes(category, value, fill = category)) +
  geom_col_pattern(
    aes(
      pattern_fill = category,
      pattern_type = category,
      pattern_angle = category
    ),
    pattern = "stripe",
    pattern_density = 0.4,
    pattern_spacing = 0.02,
    color = "black"
  ) +
  scale_fill_cheysson_pattern("1881_03") +
  scale_pattern_fill_cheysson("1881_03") +
  scale_pattern_type_cheysson("1881_03") +
  scale_pattern_angle_cheysson("1881_03") +
  theme_minimal()
```

## Pattern Extraction Process

### 1. SVG Parsing (`parse_patterns_v2.R`)

The script reads each SVG file line-by-line:
- Detects `<pattern>` blocks
- Extracts `<rect>` elements for solid fills
- Extracts `<line>` elements for hatching
- Analyzes line coordinates to determine angles
- Classifies patterns as solid, stripe, or crosshatch

### 2. Pattern Classification

Line angles are classified:
- **Horizontal** (0°): Lines parallel to x-axis
- **Vertical** (90°): Lines parallel to y-axis
- **Diagonal right** (45°): Lines going from lower-left to upper-right
- **Diagonal left** (135°): Lines going from upper-left to lower-right

Crosshatch is detected when multiple distinct angles are present.

### 3. Parameter Extraction

From the SVG attributes:
- `stroke:#XXXXXX` → pattern_fill, pattern_color
- `stroke-width:Npx` → pattern_linewidth
- Line count → pattern_density (inverse relationship)
- Line coordinates → pattern_angle

### 4. Data Object Creation (`cheysson_patterns.R`)

The raw pattern data is converted to ggpattern-compatible specifications:
- Maps "none" fills to "transparent"
- Calculates density from line spacing
- Organizes by album/plate naming
- Links to palette metadata

## Pattern Examples

### Sequential Palette (1881_03)
3 patterns, all using `#1e3e69`:
- Diagonal stripes (135°)
- Crosshatch (orthogonal lines)
- Crosshatch (orthogonal lines)

### Category Palette (1880_07)
7 solid color patterns:
- Red, green, yellow, blue, gray, orange, purple tones
- No hatching, pure fills

### Grouped Palette (1886_08)
8 patterns mixing solids and hatching:
- 4 solid colors
- 4 patterned variations

## Technical Notes

### Color Handling

Original SVG files sometimes use `fill="none"` which is not a valid R color. The implementation converts these to `"transparent"` to avoid errors in ggpattern.

### Pattern Density

The SVG line spacing is inversely related to density:
- More lines = higher density
- `pattern_density = 1 - (spacing / 100)`

### ggpattern Integration

The package provides discrete scales for all pattern aesthetics. Users must:
1. Use ggpattern geoms (`geom_*_pattern`)
2. Map aesthetics in `aes()` (e.g., `pattern_type = category`)
3. Apply Cheysson scales to each aesthetic

### Angle Normalization

All angles are normalized to 0-180 range for consistency with ggpattern.

## Files Generated

- **`data/cheysson_patterns.rda`**: Package data (1.5 KB)
- **`dev/svg_patterns.RData`**: Raw parsed patterns
- **`dev/pattern_example1.png`**: Basic pattern demo
- **`dev/pattern_example2.png`**: Category palette demo
- **`dev/pattern_example3.png`**: Stacked bars demo

## Limitations & Future Work

### Current Limitations

1. Some patterns with very fine details may not render perfectly
2. Pattern line widths are approximate conversions from SVG
3. Some palettes have only 1-2 unique colors (rely on patterns for differentiation)

### Potential Enhancements

1. **Custom pattern generator**: Create new Cheysson-style patterns
2. **Pattern preview function**: Visualize all patterns in a palette
3. **Automatic pattern selection**: Smart defaults based on data
4. **Theme integration**: Combine with `theme_cheysson()` when implemented
5. **Export to other formats**: Save patterns for use outside R

## References

- Original SVG patterns by RJ Andrews: https://github.com/infowetrust/albumcolors
- ggpattern package: https://coolbutuseless.github.io/package/ggpattern/
- David Rumsey Map Collection: https://www.davidrumsey.com/
