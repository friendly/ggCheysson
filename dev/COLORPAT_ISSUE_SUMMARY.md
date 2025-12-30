# Color-Pattern Palette Issue: Quick Summary

## The Problem

**What Cheysson/Andrews/Shanley Designed**:
- Each palette is a set of **(color, pattern) pairs**
- Example: `[(red, stripe/45°), (blue, solid), (yellow, stripe/135°)]`
- The combinations are carefully designed together

**What ggCheysson Currently Does**:
- Separates colors from patterns
- `cheysson_palettes`: Just colors `[red, blue, yellow]`
- `cheysson_patterns`: Just patterns `[stripe/45°, solid, stripe/135°]`
- User applies them separately, hoping they match up correctly

## Why This Matters

This is like storing RGB colors as three separate grayscale palettes - technically possible but fundamentally wrong.

### Historical Authenticity
Cheysson designed color-pattern combinations specifically to maximize visual distinction. Separating them loses this design intent.

### User Experience
Current approach:
```r
# Must coordinate 3+ separate scales manually
scale_fill_cheysson("1881_03") +
scale_pattern_type_cheysson("1881_03") +
scale_pattern_fill_cheysson("1881_03")
```

Should be:
```r
# One function, guaranteed proper pairings
scale_colorpat_cheysson("1881_03")
```

## Root Cause

This happened because we approached the problem from a ggplot2 perspective:
- ggplot2 treats `fill` and `pattern_type` as separate aesthetics
- Natural to create separate palette systems
- But this doesn't match how the palettes were originally designed

## The Solution

Create **unified color-pattern palette objects** that store the designed pairings:

```r
cheysson_colorpat_palettes[["1881_03"]] <- list(
  elements = list(
    list(fill = "#d18781", pattern_type = "solid", ...),
    list(fill = "#7c9a77", pattern_type = "stripe", pattern_angle = 45, ...),
    list(fill = "#edd493", pattern_type = "stripe", pattern_angle = 135, ...)
  )
)
```

With a unified scale function:
```r
scale_colorpat_cheysson("1881_03")
# Applies all coordinated aesthetics automatically
```

## What's Needed

1. **Extract true pairings** from Shanley's Observable notebook
2. **Design unified API** (function names, parameters)
3. **Implement unified palette objects** for all 20 palettes
4. **Create scale functions** that apply multiple aesthetics
5. **Maintain backward compatibility** with current approach
6. **Update documentation** explaining the difference

## See Also

- **Full Plan**: `dev/UNIFIED_COLOR_PATTERN_PLAN.md` (detailed implementation plan)
- **Shanley's Work**: https://observablehq.com/@tomshanley/cheysson-color-palettes
- **Andrews' GitHub**: https://github.com/infowetrust/albumcolors

## Status

**Current**: Planning phase - identified the issue, designed solution architecture
**Next**: Extract color-pattern pairings from source materials
**Timeline**: ~20-30 hours of development work
