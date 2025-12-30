# Color-Pattern Pairing Extraction Template

## Purpose

This template provides a structured format for documenting the color-pattern pairings from Tom Shanley's Observable notebook and RJ Andrews' original work.

## Source

**Primary**: https://observablehq.com/@tomshanley/cheysson-color-palettes
**Secondary**: Andrews' SVG files in `albumcolors/` directory
**Verification**: Original Album plates from David Rumsey collection

## Extraction Checklist

For each palette:
- [ ] Record palette identifier (year_plate)
- [ ] Note palette type (sequential, diverging, grouped, category)
- [ ] Document number of elements
- [ ] Extract each color-pattern pair
- [ ] Note pattern parameters (angle, density, type)
- [ ] Include visual screenshot or reference
- [ ] Verify against original Album if possible

## Template Format

Copy this template for each palette:

---

### Palette: [YEAR_PLATE]

**Source**: Album [YEAR], Plate [NUMBER]
**Type**: [sequential|diverging|grouped|category]
**Elements**: [N]
**Observable Link**: [specific URL if available]
**SVG File**: [filename if exists]

#### Element 1
- **Fill Color**: `#rrggbb`
- **Pattern Type**: [solid|stripe|crosshatch|none]
- **Pattern Angle**: [0|45|90|135|NA] degrees
- **Pattern Fill**: `#rrggbb` (color of pattern lines)
- **Pattern Density**: [0.0-1.0]
- **Pattern Spacing**: [0.0-1.0]
- **Visual Description**: [e.g., "light blue with fine diagonal stripes"]
- **Label/Name**: [if provided]

#### Element 2
- **Fill Color**: `#rrggbb`
- **Pattern Type**: [solid|stripe|crosshatch|none]
- **Pattern Angle**: [0|45|90|135|NA] degrees
- **Pattern Fill**: `#rrggbb`
- **Pattern Density**: [0.0-1.0]
- **Pattern Spacing**: [0.0-1.0]
- **Visual Description**: [description]
- **Label/Name**: [if provided]

[Repeat for each element...]

#### Notes
- [Any special observations about this palette]
- [Design intent if documented]
- [Variations or alternatives]
- [Questions or uncertainties]

#### Visual Reference
- Screenshot: `dev/palette_screenshots/[YEAR_PLATE].png`
- Original Album: `[URL to David Rumsey if available]`

---

## Example: Completed Template

### Palette: 1881_03

**Source**: Album 1881, Plate 3
**Type**: Sequential
**Elements**: 3
**Observable Link**: https://observablehq.com/@tomshanley/cheysson-color-palettes#palette_1881_03
**SVG File**: `albumcolors/1881/plate_03.svg`

#### Element 1 (Low)
- **Fill Color**: `#d18781` (salmon/coral red)
- **Pattern Type**: solid
- **Pattern Angle**: NA
- **Pattern Fill**: `#d18781` (same as fill)
- **Pattern Density**: 1.0
- **Pattern Spacing**: NA
- **Visual Description**: Solid salmon/coral fill, no pattern
- **Label/Name**: "Low" / "Faible"

#### Element 2 (Medium)
- **Fill Color**: `#7c9a77` (sage green)
- **Pattern Type**: stripe
- **Pattern Angle**: 45 degrees (diagonal NE-SW)
- **Pattern Fill**: `#4a5d44` (darker green)
- **Pattern Density**: 0.3
- **Pattern Spacing**: 0.02
- **Visual Description**: Sage green background with dark green diagonal stripes
- **Label/Name**: "Medium" / "Moyen"

#### Element 3 (High)
- **Fill Color**: `#edd493` (light yellow/cream)
- **Pattern Type**: stripe
- **Pattern Angle**: 135 degrees (diagonal NW-SE)
- **Pattern Fill**: `#c9a962` (darker yellow/gold)
- **Pattern Density**: 0.3
- **Pattern Spacing**: 0.02
- **Visual Description**: Cream background with gold diagonal stripes (opposite angle from Element 2)
- **Label/Name**: "High" / "Élevé"

#### Notes
- Sequential progression: solid → striped/45° → striped/135°
- Color progression: warm (red) → cool (green) → warm (yellow)
- Pattern angles differ to distinguish Medium vs High
- All three highly distinguishable both in color and pattern

#### Visual Reference
- Screenshot: `dev/palette_screenshots/1881_03.png`
- Original Album: https://www.davidrumsey.com/luna/servlet/detail/RUMSEY~8~1~308683~90077848

---

## Data Structure Design

Based on extraction, the unified palette object should look like:

```r
cheysson_colorpat_palettes[["1881_03"]] <- list(
  name = "1881_03",
  type = "sequential",
  album = 1881,
  plate = 3,
  n_elements = 3,
  elements = list(
    list(
      position = 1,
      label = "Low",
      fill = "#d18781",
      pattern_type = "solid",
      pattern_fill = "#d18781",
      pattern_angle = NA,
      pattern_density = 1.0,
      pattern_spacing = NA
    ),
    list(
      position = 2,
      label = "Medium",
      fill = "#7c9a77",
      pattern_type = "stripe",
      pattern_fill = "#4a5d44",
      pattern_angle = 45,
      pattern_density = 0.3,
      pattern_spacing = 0.02
    ),
    list(
      position = 3,
      label = "High",
      fill = "#edd493",
      pattern_type = "stripe",
      pattern_fill = "#c9a962",
      pattern_angle = 135,
      pattern_density = 0.3,
      pattern_spacing = 0.02
    )
  ),
  metadata = list(
    source_url = "https://observablehq.com/@tomshanley/cheysson-color-palettes",
    album_url = "https://www.davidrumsey.com/...",
    extracted_by = "...",
    extraction_date = "...",
    notes = "Sequential palette with solid→striped pattern progression"
  )
)
```

## Common Patterns to Look For

### Pattern Types
- **solid**: No pattern, just solid fill color
- **stripe**: Parallel lines at specific angle
- **crosshatch**: Two sets of parallel lines (multiple angles)
- **dots**: Dotted pattern (less common)
- **none**: Unfilled/white (for outline-only areas)

### Pattern Angles
- **0°**: Horizontal lines
- **45°**: Diagonal NE-SW
- **90°**: Vertical lines
- **135°**: Diagonal NW-SE
- **NA**: Not applicable (for solid fills)

### Pattern Density/Spacing
- Higher density (0.5-0.7) = lines closer together
- Lower density (0.2-0.3) = lines farther apart
- Solid fill = 1.0
- Should be consistent within a palette for similar pattern types

### Color Relationships
- Pattern fill often darker shade of background fill
- Sometimes contrasting color for maximum distinction
- Shanley may have specific rules documented

## Validation Questions

For each palette, verify:

1. **Completeness**: Did you capture all elements?
2. **Accuracy**: Do colors match Observable exactly?
3. **Patterns**: Are pattern parameters correct?
4. **Ordering**: Is sequential/ordinal order preserved?
5. **Labels**: Are category names captured if provided?
6. **Consistency**: Do similar palettes use similar conventions?

## Next Steps After Extraction

1. **Review all extractions** for consistency
2. **Create R data structure** from template
3. **Generate test visualizations** to verify
4. **Compare with original Albums** for authenticity
5. **Document any ambiguities** or decisions made

## File Organization

Create directory structure:
```
dev/
  colorpat_extraction/
    1880_07.md
    1881_03.md
    1881_04.md
    ...
    palette_screenshots/
      1880_07.png
      1881_03.png
      ...
```

## Timeline

Estimated time per palette: 10-15 minutes
Total for 20 palettes: 3-5 hours

Focus on accuracy over speed - these become the canonical reference.
