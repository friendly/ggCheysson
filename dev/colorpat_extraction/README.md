# Color-Pattern Extraction Directory

This directory contains the extracted color-pattern pairings from Tom Shanley's Observable notebook and RJ Andrews' albumcolors data.

## Purpose

Document the TRUE color-pattern pairs as designed by Émile Cheysson, extracted from:
- Tom Shanley's Observable notebook: https://observablehq.com/@tomshanley/cheysson-color-palettes
- RJ Andrews' albumcolors: https://github.com/infowetrust/albumcolors
- Original Album plates: David Rumsey Map Collection

## Files in This Directory

### Overview Documents

- **README.md** (this file) - Directory index
- **EXTRACTION_SUMMARY.md** - Quick summary of all 20 palettes
- **MASTER_EXTRACTION_REPORT.md** - Comprehensive report with findings, patterns, and recommendations

### Detailed Palette Documentation

Individual palette documentation following the extraction template:

- **1881_03.md** - Sequential, 3 elements (monochrome with patterns)
- **1881_04.md** - Grouped, 4 elements (solid colors only)
- **1883_04.md** - Diverging, 4 elements (dual encoding with patterns)
- **1891_07.md** - Sequential, 7 elements (hybrid color + pattern)

**Status**: 4/20 palettes documented in detail. Remaining 16 need detailed write-ups.

### Data Files

Located in parent directory (`dev/`):
- **colorpat_extractions.RData** - R data object with all extracted palette information

### Source Data

Located in `data-raw/observable/`:
- **albumColors.csv** - Metadata for all 25 palettes
- **dec01.txt** through **dec25.txt** - SVG pattern definitions

### Extraction Tools

Located in parent directory (`dev/`):
- **extract_colorpat_pairings.R** - Automated extraction script

## Palette Index

### Sequential Palettes (7)

| Palette | Elements | Colors | Patterns | Status |
|---------|----------|--------|----------|--------|
| 1881_03 | 3 | 1 (monochrome) | Varied | ✅ Documented |
| 1886_04 | 4 | 2 | Mixed | ⚠️ Needs review |
| 1888_05 | 5 | 1 (monochrome) | All stripe | ⚠️ Needs review |
| 1891_07 | 7 | 2 | Varied | ✅ Documented |
| 1895_04 | 4 | 3 | Mixed | ✅ Complete |
| 1900_06 | 6 | 2 | Mostly solid | ⚠️ Needs review |
| 1891_06 | 6 | 1 (monochrome) | All stripe | ✅ Complete |

### Diverging Palettes (2)

| Palette | Elements | Colors | Patterns | Status |
|---------|----------|--------|----------|--------|
| 1883_07 | 7 | 3 | Mostly solid | ⚠️ Missing colors |
| 1883_04 | 4 | 2 | Symmetric | ✅ Documented |

### Grouped Palettes (5)

| Palette | Elements | Colors | Patterns | Status |
|---------|----------|--------|----------|--------|
| 1881_04 | 4 | 4 | All solid | ✅ Documented |
| 1881_08 | 8 | 4 | Mixed | ✅ Complete |
| 1882_04 | 4 | 2 | Mixed | ⚠️ Needs review |
| 1886_08 | 8 | 4 | Alternating | ✅ Complete |
| 1887_06 | 6 | 2 | Mixed | ⚠️ Needs review |
| 1891_03 | 3 | 2 | Mixed | ✅ Complete |

### Category Palettes (6)

| Palette | Elements | Colors | Patterns | Status |
|---------|----------|--------|----------|--------|
| 1880_07 | 7 | 7 | All solid | ✅ Complete |
| 1883_06 | 6 | 4 | Mixed | ✅ Complete |
| 1886_07 | 7 | 3 | Mostly solid | ⚠️ Missing colors |
| 1906_04 | 4 | 4 | All solid | ✅ Complete |
| 1906_06 | 6 | 6 | Mostly solid | ✅ Complete |

**Note**: "1881_04" appears twice in source data with different types (Grouped and Category).

## Extraction Status

### Completed ✅ (7/20)
- All colors extracted
- All patterns identified
- Ready for implementation

### Needs Review ⚠️ (13/20)
- Missing color data (NA values)
- Ambiguous pattern densities
- Manual verification needed

### Critical Issues ❌ (0/20)
- None!

## Data Quality Issues

### Missing Colors (Needs Manual Extraction)

Palettes with NA color values that need manual color picking from Rumsey plates:

1. **1883_07** - Elements 4-7 missing colors
2. **1886_04** - Element 3 missing color
3. **1886_07** - Elements 4-7 missing colors
4. **1887_06** - Element 4 missing color
5. **1888_05** - Element 5 missing color
6. **1891_07** - Element 3 missing color
7. **1900_06** - Element 6 missing color

### Ambiguous Patterns (Needs Verification)

Palettes where elements appear identical but shouldn't:

1. **1891_07** - Elements 5, 6, 7 (all 135° stripes with same density)
2. **1881_03** - Elements 2, 3 (both crosshatch, possibly identical)
3. **1888_05** - Elements 1-4 (all 45° stripes, likely varying density)

## Key Findings

### Design Patterns Identified

1. **Monochrome Sequential**: Single color + pattern density progression
2. **Multi-Color Sequential**: Color + pattern variation
3. **Solid Categorical**: Distinct colors, no patterns
4. **Diverging Dual-Encoded**: Color = direction, Pattern = magnitude
5. **Grouped Alternating**: Color groups with pattern variations

### Most Common Patterns

- **Stripe 135°**: 60% of patterned elements
- **Stripe 90°**: 25% of patterned elements
- **Crosshatch**: 10% of patterned elements
- **Stripe 45°**: 5% of patterned elements

### Color Usage

- **Solid fills**: ~65% of all elements
- **Patterned fills**: ~35% of all elements
- **Typical palette size**: 4-7 elements
- **Color economy**: Many palettes use only 1-2 base colors

## Next Steps

### Immediate (High Priority)

1. ✅ **Automated Extraction** - COMPLETED
2. ⏳ **Manual Color Extraction** - Fill NA values from Rumsey plates
3. ⏳ **Pattern Verification** - Verify ambiguous density values

### Near Term (Implementation)

4. Create unified `cheysson_colorpat_palettes` data object
5. Implement `cheysson_colorpat()` accessor function
6. Create `scale_colorpat_cheysson()` unified scale function

### Long Term (Documentation)

7. Document all 20 palettes in detail
8. Create pattern design vignette
9. Update Guerry vignette with unified scales

## Usage

### Load Extracted Data

```r
library(here)
load(here("dev/colorpat_extractions.RData"))

# View palette
all_extractions[["1881_03"]]
```

### Access Elements

```r
# Get all elements for palette 1883_04
pal <- all_extractions[["1883_04"]]

# Access individual element
elem1 <- pal$elements[[1]]
elem1$fill          # "#5d6a9a"
elem1$pattern_type  # "stripe"
elem1$pattern_angle # 135
```

### Generate Implementation Code

```r
# The detailed .md files contain ready-to-use R code
# for implementing each palette in the package
```

## Related Planning Documents

Located in parent directory (`dev/`):

- **UNIFIED_COLOR_PATTERN_PLAN.md** - Comprehensive implementation plan (20-30 hour effort)
- **COLORPAT_ISSUE_SUMMARY.md** - Quick summary of the fundamental issue
- **COLORPAT_EXTRACTION_TEMPLATE.md** - Template used for detailed documentation

## Contact

For questions about extraction methodology or data quality:
- See: `MASTER_EXTRACTION_REPORT.md` for technical details
- Review: Original sources (Shanley's Observable, Rumsey Collection)

---

**Last Updated**: 2025-12-30
**Extraction Tool**: extract_colorpat_pairings.R
**Total Palettes**: 20
**Completion**: 35% fully verified, 65% needs manual review
