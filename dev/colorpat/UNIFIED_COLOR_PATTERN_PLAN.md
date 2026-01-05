# Plan: Unified Color-Pattern Palettes

## Problem Statement

### The Conceptual Mismatch

**Original Cheysson/Andrews/Shanley Design**:
- Each palette element is a **unified (color, pattern) pair**
- Example: Category A = (red, diagonal stripes), Category B = (blue, solid fill), Category C = (yellow, crosshatch)
- The color and pattern are designed together as a single visual unit

**Current ggCheysson Implementation**:
- Colors and patterns are **completely separate**
- Color palettes: Just hex codes
- Pattern palettes: Just pattern specifications
- Applied independently with different scale functions
- This is "ggplot-thinking": treating color and pattern as independent aesthetics

### Why This Matters

1. **Historical Authenticity**: Cheysson carefully designed color-pattern combinations for maximum visual distinction
2. **Design Intent**: Andrews/Shanley extracted these as unified palettes, not separate dimensions
3. **User Experience**: Currently requires managing two separate scales that should be coordinated
4. **Visual Coherence**: The combinations were chosen specifically to work together

### Reference

Tom Shanley's palettes: https://observablehq.com/@tomshanley/cheysson-color-palettes

Each palette entry should be something like:
```
{
  category: "A",
  fill: "#d18781",
  pattern: "stripe",
  pattern_angle: 45,
  pattern_fill: "#8b4513",
  pattern_density: 0.3
}
```

## Current State Analysis

### File: `data-raw/cheysson_palettes.R`
```r
# Currently stores ONLY colors
cheysson_palettes[["1881_03"]] <- list(
  colors = c("#d18781", "#7c9a77", "#edd493"),
  type = "sequential",
  ...
)
```

### File: `data-raw/cheysson_patterns.R`
```r
# Currently stores patterns separately, disconnected from colors
cheysson_patterns[["1881_03"]] <- list(
  list(type = "solid", fill = "#d18781", ...),
  list(type = "stripe", fill = "#7c9a77", angle = 45, ...),
  ...
)
```

### The Disconnect

When a user wants palette "1881_03" with both colors and patterns:

```r
# Current approach (disconnected)
geom_sf_pattern(aes(fill = category, pattern_type = category)) +
  scale_fill_cheysson("1881_03") +           # Gets colors
  scale_pattern_type_cheysson("1881_03")     # Gets patterns
  # No guarantee these are the intended pairings!
```

The user has to manually ensure they're using the same palette name for both, and even then, the pairing is only by position/order, not by design.

## Proposed Solution Architecture

### Option 1: Unified Palette Objects (Recommended)

#### Data Structure

Create a new unified palette structure:

```r
# New data object: cheysson_colorpat_palettes
cheysson_colorpat_palettes[["1881_03"]] <- list(
  name = "1881_03",
  type = "sequential",
  album = 1881,
  plate = 3,
  elements = list(
    list(
      fill = "#d18781",
      pattern_type = "solid",
      pattern_fill = "#d18781",
      pattern_angle = NA,
      pattern_density = 1.0,
      label = "Low"
    ),
    list(
      fill = "#7c9a77",
      pattern_type = "stripe",
      pattern_fill = "#4a5d44",
      pattern_angle = 45,
      pattern_density = 0.3,
      label = "Medium"
    ),
    list(
      fill = "#edd493",
      pattern_type = "stripe",
      pattern_fill = "#c9a962",
      pattern_angle = 135,
      pattern_density = 0.3,
      label = "High"
    )
  )
)
```

#### New Functions

```r
# Accessor function
cheysson_colorpat(palette = "1881_03", n = NULL)
# Returns list of (fill, pattern_type, pattern_fill, pattern_angle, pattern_density)

# Single unified scale function
scale_fill_pattern_cheysson(palette = "1881_03", ...)
# Applies BOTH fill and pattern aesthetics in one call

# Or more explicit:
scale_colorpat_cheysson(palette = "1881_03", ...)
```

#### Usage

```r
# New unified approach
geom_sf_pattern(aes(fill = category, pattern_type = category)) +
  scale_colorpat_cheysson("1881_03")
  # Single function sets both aesthetics with proper pairings!
```

### Option 2: Extended Palette Metadata

Keep current structure but add pairing information:

```r
cheysson_palettes[["1881_03"]] <- list(
  colors = c("#d18781", "#7c9a77", "#edd493"),
  type = "sequential",
  # NEW: Add pattern pairing metadata
  patterns = list(
    list(type = "solid", angle = NA, density = 1.0),
    list(type = "stripe", angle = 45, density = 0.3),
    list(type = "stripe", angle = 135, density = 0.3)
  ),
  pattern_fills = c("#d18781", "#4a5d44", "#c9a962")
)
```

#### Wrapper Function

```r
apply_cheysson_palette <- function(palette, ...) {
  # Returns list of scale_* functions to add together
  pal <- cheysson_palettes[[palette]]
  list(
    scale_fill_manual(values = pal$colors),
    scale_pattern_type_manual(values = pal$patterns),
    scale_pattern_fill_manual(values = pal$pattern_fills)
  )
}

# Usage
p + apply_cheysson_palette("1881_03")
```

### Option 3: Composite Scale Function

Create a scale function that sets multiple aesthetics:

```r
scale_cheysson <- function(palette, aesthetics = c("fill", "pattern_type", "pattern_fill"), ...) {
  # Returns a list of scales
  pal_data <- get_unified_palette(palette)

  scales <- list()
  if ("fill" %in% aesthetics) {
    scales <- c(scales, list(scale_fill_manual(values = pal_data$fills)))
  }
  if ("pattern_type" %in% aesthetics) {
    scales <- c(scales, list(scale_pattern_type_manual(values = pal_data$patterns)))
  }
  # etc.

  scales
}

# Usage
p + scale_cheysson("1881_03", aesthetics = c("fill", "pattern_type", "pattern_fill"))
```

## Implementation Plan

### Phase 1: Data Extraction and Reconciliation

**Goal**: Understand the true color-pattern pairings from Andrews/Shanley

1. **Review Shanley's Observable Notebook**
   - Document each palette's color-pattern combinations
   - Extract the designed pairings
   - Identify pattern types, angles, densities for each color

2. **Cross-reference with Andrews' SVG Files**
   - Verify pairings in the original SVG extractions
   - Check if there are documented color-pattern relationships

3. **Create Mapping Document**
   - For each of the 20 palettes, document:
     ```
     Palette: 1881_03
     Element 1: fill=#d18781, pattern=solid
     Element 2: fill=#7c9a77, pattern=stripe/45°, pattern_fill=#darker
     Element 3: fill=#edd493, pattern=stripe/135°, pattern_fill=#darker
     ```

**Output**: `dev/COLORPAT_PAIRINGS.md` documenting the true intended pairings

### Phase 2: Design API

**Goal**: Design the user-facing API before implementation

1. **Decide on Approach** (Option 1, 2, or 3 above, or hybrid)
2. **Design Function Signatures**
   ```r
   # Example for Option 1
   cheysson_colorpat(palette, n = NULL)
   scale_colorpat_cheysson(palette, aesthetics = "auto", discrete = TRUE, ...)
   list_cheysson_colorpat_palettes(type = NULL)
   ```

3. **Design Data Structure**
   - Format for storing unified palettes
   - Backward compatibility with existing palette objects
   - Metadata to include

4. **Mock Up Usage Examples**
   ```r
   # Write example code showing ideal usage
   # Test ergonomics before implementing
   ```

**Output**: `dev/COLORPAT_API_DESIGN.md` with proposed API

### Phase 3: Prototype Implementation

**Goal**: Build proof-of-concept with one palette

1. **Create Test Palette**
   - Implement unified structure for palette "1881_03"
   - Create accessor function
   - Create scale function

2. **Test with Real Data**
   - Use Guerry data to test
   - Verify visual output matches intended design
   - Check ergonomics

3. **Refine Based on Testing**
   - Adjust API based on real usage
   - Identify edge cases
   - Document issues

**Output**: `dev/prototype_colorpat.R` with working prototype

### Phase 4: Full Implementation

**Goal**: Implement for all palettes

1. **Extract All Pairings**
   - Process all 20 palettes
   - Create unified palette data objects
   - Validate against source materials

2. **Implement Core Functions**
   - Accessor functions
   - Scale functions
   - Helper/utility functions

3. **Documentation**
   - Roxygen documentation for all functions
   - Examples showing unified vs separate approaches
   - Vignette section explaining the concept

4. **Testing**
   - Unit tests for palette access
   - Visual tests for scale application
   - Edge case handling

### Phase 5: Backward Compatibility

**Goal**: Maintain existing functionality

1. **Keep Current Functions**
   - `scale_fill_cheysson()` - still works for color-only
   - `scale_pattern_type_cheysson()` - still works for pattern-only
   - Existing code doesn't break

2. **Add Deprecation Warnings** (Optional, for future)
   - Suggest using unified approach
   - But don't force migration immediately

3. **Documentation Migration Guide**
   - Show how to migrate from separate to unified
   - Explain benefits of unified approach

### Phase 6: Update Vignettes

**Goal**: Showcase unified approach

1. **Update Guerry Vignette**
   - Rewrite pattern examples using unified scales
   - Show before/after comparison
   - Explain the design philosophy

2. **Update Getting Started Vignette**
   - Add section on unified color-pattern palettes
   - Show both approaches (simple color-only vs full color-pattern)

3. **Create Pattern Design Vignette** (Optional)
   - Deep dive into pattern design
   - How Andrews/Shanley extracted pairings
   - Historical context of color-pattern combinations

## Technical Challenges

### Challenge 1: ggplot2's Aesthetic System

**Issue**: ggplot2 treats `fill` and `pattern_type` as independent aesthetics

**Implications**:
- Can't use a single `aes()` mapping for both
- Need to map the same variable to multiple aesthetics
- Scale functions operate on one aesthetic at a time

**Possible Solutions**:
1. Return multiple scale objects from one function (Option 3)
2. Create a wrapper that adds multiple scales (Option 2)
3. Use non-standard evaluation to modify the plot object directly

**Recommendation**: Option 2/3 - return list of scales, use `+` to add them

### Challenge 2: Pattern Parameter Coordination

**Issue**: Patterns have multiple parameters (type, fill, angle, density)

**Implications**:
- Need to coordinate 4+ aesthetics simultaneously
- Each aesthetic needs its own scale
- User code becomes verbose

**Possible Solutions**:
1. Store all pattern params in the unified palette
2. Create helper that generates all necessary scale_pattern_* functions
3. Use pattern string encoding (e.g., "stripe-45-0.3-#darker")

**Recommendation**: Solution 1 + 2 - store all params, generate scales automatically

### Challenge 3: Palette Size Variation

**Issue**: Different palettes have different numbers of elements (1-7)

**Implications**:
- Need to handle n > palette size (interpolation)
- For patterns, interpolation is complex (can't interpolate angles linearly)
- Color interpolation easy, pattern interpolation hard

**Possible Solutions**:
1. Only allow exact palette size (no interpolation for unified palettes)
2. Repeat/recycle pattern assignments when n > size
3. Define interpolation rules for patterns (challenging)

**Recommendation**: Solution 2 - recycle patterns, but warn user

### Challenge 4: Backward Compatibility

**Issue**: Existing code uses separate color and pattern scales

**Implications**:
- Can't break existing functionality
- Need to maintain two parallel systems
- Documentation complexity

**Possible Solutions**:
1. Keep old functions, add new unified functions alongside
2. Old functions become wrappers around new unified system
3. Gradual deprecation path

**Recommendation**: Solution 1 - parallel systems with clear documentation

## Open Questions

### Q1: How to Handle Color-Only Use Cases?

When users want just colors (no patterns), should they:
- Use old `scale_fill_cheysson()` (maintain parallel systems)
- Use new `scale_colorpat_cheysson(aesthetics = "fill")` (unified system)
- Either approach allowed?

**Recommendation**: Allow both, document trade-offs

### Q2: Pattern-Only Palettes?

Some palettes might be designed for patterns-only (monochrome with pattern variation). How to represent these?

**Options**:
- Separate pattern-only palette objects
- Include in unified structure with same fill color for all
- Special flag in unified palette

**Recommendation**: Include in unified structure, flag as monochrome

### Q3: Naming Convention?

What to call the new functions/objects?
- `colorpat` (concise but unclear)
- `color_pattern` (clear but verbose)
- `unified` (generic)
- `combo` (informal)
- `integrated` (technical)

**Recommendation**: `colorpat` for objects/internals, `color_pattern` for user-facing docs

### Q4: How to Extract True Pairings?

Where is the authoritative source for color-pattern pairings?
- Shanley's Observable notebook (computational source)
- Andrews' original SVGs (visual source)
- Original Album plates (historical source)

**Recommendation**: Primary = Shanley's Observable, verify against original Albums

## Migration Path for Users

### Current Approach (Separate)

```r
library(ggplot2)
library(ggpattern)
library(ggCheysson)

# User must manage two separate scales
ggplot(data, aes(x, y, fill = category, pattern_type = category)) +
  geom_col_pattern() +
  scale_fill_cheysson("1881_03") +              # Colors
  scale_pattern_type_cheysson("1881_03") +      # Patterns
  scale_pattern_fill_cheysson("1881_03")        # Pattern fills
  # Must remember to use same palette name for all!
  # No guarantee of proper pairing
```

### Proposed Approach (Unified)

```r
library(ggplot2)
library(ggpattern)
library(ggCheysson)

# Single function handles coordinated aesthetics
ggplot(data, aes(x, y, fill = category, pattern_type = category)) +
  geom_col_pattern() +
  scale_colorpat_cheysson("1881_03")
  # Automatically sets fill, pattern_type, pattern_fill, etc.
  # Guarantees proper color-pattern pairings as designed
```

### Hybrid Approach (Backward Compatible)

```r
# Old code still works
scale_fill_cheysson("1881_03")  # Color only

# New code uses unified approach
scale_colorpat_cheysson("1881_03")  # Color + pattern

# Can mix if needed
scale_fill_cheysson("1881_03") +      # Use Cheysson colors
  scale_pattern_type_manual(...)       # But custom patterns
```

## Success Criteria

A successful implementation should:

1. ✅ **Historically Accurate**: Reproduce Andrews/Shanley's intended color-pattern pairings
2. ✅ **Ergonomic**: Simpler than current separate-scale approach
3. ✅ **Backward Compatible**: Existing code continues to work
4. ✅ **Well Documented**: Clear explanation of unified vs separate approaches
5. ✅ **Flexible**: Support color-only, pattern-only, and unified use cases
6. ✅ **Extensible**: Easy to add new unified palettes in future

## Priority Assessment

### High Priority (Core Issue)
- Phase 1: Extract true color-pattern pairings from source
- Phase 2: Design unified API
- Phase 3: Prototype with one palette

### Medium Priority (Implementation)
- Phase 4: Implement for all palettes
- Phase 5: Ensure backward compatibility

### Lower Priority (Enhancement)
- Phase 6: Update vignettes
- Additional pattern-focused vignette
- Advanced pattern interpolation

## Next Steps

### Immediate Actions

1. **Review Shanley's Observable Notebook** thoroughly
   - Document color-pattern pairings for all 20 palettes
   - Understand his design methodology
   - Capture any notes about why certain pairings were chosen

2. **Create COLORPAT_PAIRINGS.md**
   - Systematic documentation of all pairings
   - Include visual references (screenshots from Observable)
   - Note any ambiguities or questions

3. **Prototype One Palette**
   - Choose representative palette (e.g., 1881_03 with 3-4 elements)
   - Implement basic unified structure
   - Test with simple example
   - Validate approach before full implementation

### Timeline Estimate

- **Phase 1** (Data extraction): 2-4 hours
- **Phase 2** (API design): 2-3 hours
- **Phase 3** (Prototype): 3-4 hours
- **Phase 4** (Full implementation): 8-12 hours
- **Phase 5** (Backward compat): 2-3 hours
- **Phase 6** (Vignettes): 4-6 hours

**Total**: 21-32 hours of development work

### Dependencies

- Access to Shanley's Observable notebook
- Access to original Album plates (for verification)
- Andrews' SVG files (already have)
- ggpattern package understanding
- ggplot2 scale system knowledge

## References

- **Tom Shanley's Palettes**: https://observablehq.com/@tomshanley/cheysson-color-palettes
- **RJ Andrews' Work**: https://infowetrust.com/project/album-colors
- **Andrews GitHub**: https://github.com/infowetrust/albumcolors
- **ggpattern Documentation**: https://coolbutuseless.github.io/package/ggpattern/
- **Original Albums**: David Rumsey Collection

## Conclusion

This is a fundamental conceptual issue that affects the historical authenticity and usability of the package. The current separation of colors and patterns is a mismatch with how Cheysson actually designed these palettes.

Implementing unified color-pattern palettes will:
- Better honor the original design intent
- Improve user experience (simpler code)
- Increase historical accuracy
- Showcase the package's unique value proposition

The recommended approach is Option 1 (Unified Palette Objects) with backward compatibility maintained through parallel systems. This provides the best balance of authenticity, usability, and migration path.

**Status**: Planning phase - no code changes yet
**Next Action**: Review Shanley's Observable notebook and document color-pattern pairings
