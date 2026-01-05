# Prototype: Unified Color-Pattern Palettes
#
# This prototype demonstrates the unified approach where color and pattern
# are stored together as designed pairs, not as separate dimensions.
#
# Example: 1883_04 (Diverging palette with dual encoding)

library(here)
library(tidyverse)

# ============================================================================
# PART 1: UNIFIED PALETTE DATA STRUCTURE
# ============================================================================

# Create prototype unified palette object for 1883_04
# This palette demonstrates dual encoding:
#   - COLOR encodes direction (blue = negative, orange = positive)
#   - PATTERN encodes magnitude (solid = low, stripe = high)

cheysson_colorpat_palettes <- list()

cheysson_colorpat_palettes[["1883_04"]] <- list(
  name = "1883_04",
  type = "diverging",
  album = 1883,
  plate = 31,
  n_elements = 4,

  # The key innovation: elements store UNIFIED color-pattern pairs
  elements = list(
    # Element 1: High negative (blue + pattern)
    list(
      position = 1,
      label = "High negative",
      fill = "#5d6a9a",              # Slate blue background
      pattern_type = "stripe",        # Hatching pattern
      pattern_fill = "#3d4a6a",       # Darker blue for lines
      pattern_color = "#3d4a6a",      # Same (ggpattern uses pattern_color)
      pattern_angle = 135,            # Diagonal NW-SE
      pattern_density = 0.3,          # Moderate density
      pattern_spacing = 0.02,         # Line spacing
      pattern_linewidth = 0.5         # Line width
    ),

    # Element 2: Low negative (orange, solid)
    list(
      position = 2,
      label = "Low negative",
      fill = "#ea5716",              # Bright orange
      pattern_type = "none",          # No pattern (solid fill only)
      pattern_fill = "#ea5716",       # Same as fill
      pattern_color = "#ea5716",
      pattern_angle = NA,
      pattern_density = 1.0,          # Solid = density 1.0
      pattern_spacing = NA,
      pattern_linewidth = NA
    ),

    # Element 3: Neutral (white/light)
    list(
      position = 3,
      label = "Neutral",
      fill = "#f5f5f5",              # Very light gray (neutral)
      pattern_type = "none",
      pattern_fill = "#f5f5f5",
      pattern_color = "#f5f5f5",
      pattern_angle = NA,
      pattern_density = 1.0,
      pattern_spacing = NA,
      pattern_linewidth = NA
    ),

    # Element 4: High positive (orange + pattern) - SYMMETRIC with Element 1
    list(
      position = 4,
      label = "High positive",
      fill = "#ea5716",              # Bright orange background
      pattern_type = "stripe",        # Same pattern as Element 1
      pattern_fill = "#ba3716",       # Darker orange for lines
      pattern_color = "#ba3716",
      pattern_angle = 135,            # Same angle as Element 1 (symmetric)
      pattern_density = 0.3,          # Same density
      pattern_spacing = 0.02,         # Same spacing
      pattern_linewidth = 0.5         # Same line width
    )
  ),

  # Metadata
  metadata = list(
    source_url = "https://observablehq.com/@tomshanley/cheysson-color-palettes",
    rumsey_url = "https://www.davidrumsey.com/luna/servlet/detail/RUMSEY~8~1~309192~90079066",
    rumsey_no = "12514.031",
    title = "Carte Figurative des Chomages des Voies Navigables en 1882",
    extracted_date = "2025-12-30",
    notes = "Diverging palette with dual encoding: color = direction, pattern = magnitude. Symmetric design."
  )
)

# ----------------------------------------------------------------------------
# Palette 2: 1881_03 (Monochrome Sequential)
# ----------------------------------------------------------------------------

# This palette demonstrates monochrome sequential encoding:
#   - SINGLE COLOR (#1e3e69 navy blue)
#   - PATTERN DENSITY encodes value (stripe → crosshatch → dense crosshatch)
#   - Extremely economical (one ink color, three visual levels)

cheysson_colorpat_palettes[["1881_03"]] <- list(
  name = "1881_03",
  type = "sequential",
  album = 1881,
  plate = 12,
  n_elements = 3,

  elements = list(
    # Element 1: Low (diagonal stripes)
    list(
      position = 1,
      label = "Low",
      fill = "#1e3e69",              # Dark navy blue
      pattern_type = "stripe",        # Diagonal stripes
      pattern_fill = "#1e3e69",       # Same color (monochrome)
      pattern_color = "#1e3e69",
      pattern_angle = 135,            # Diagonal NW-SE
      pattern_density = 0.25,         # Sparse (lowest density)
      pattern_spacing = 0.04,
      pattern_linewidth = 0.5
    ),

    # Element 2: Medium (crosshatch)
    list(
      position = 2,
      label = "Medium",
      fill = "#1e3e69",              # Same navy blue
      pattern_type = "crosshatch",    # Crosshatch (more complex)
      pattern_fill = "#1e3e69",       # Same color
      pattern_color = "#1e3e69",
      pattern_angle = NA,             # Crosshatch doesn't use single angle
      pattern_density = 0.35,         # Medium density
      pattern_spacing = 0.03,
      pattern_linewidth = 0.5
    ),

    # Element 3: High (dense crosshatch)
    list(
      position = 3,
      label = "High",
      fill = "#1e3e69",              # Same navy blue
      pattern_type = "crosshatch",    # Dense crosshatch
      pattern_fill = "#1e3e69",       # Same color
      pattern_color = "#1e3e69",
      pattern_angle = NA,
      pattern_density = 0.45,         # Highest density
      pattern_spacing = 0.02,
      pattern_linewidth = 0.5
    )
  ),

  metadata = list(
    source_url = "https://observablehq.com/@tomshanley/cheysson-color-palettes",
    rumsey_url = "https://www.davidrumsey.com/luna/servlet/detail/RUMSEY~8~1~309110~90078973",
    rumsey_no = "12512.012",
    title = "Carte Formative du Tonnage des Voies Navigables en 1879",
    extracted_date = "2025-12-30",
    notes = "Monochrome sequential: single color with pattern density progression. Economical for one-ink printing."
  )
)

# ----------------------------------------------------------------------------
# Palette 3: 1881_04 (Grouped/Categorical - Solid Colors)
# ----------------------------------------------------------------------------

# This palette demonstrates pure color-based categorical encoding:
#   - FOUR DISTINCT COLORS (salmon, yellow, green, teal)
#   - NO PATTERNS (all solid fills)
#   - High color contrast for mutual distinction

cheysson_colorpat_palettes[["1881_04"]] <- list(
  name = "1881_04",
  type = "grouped",
  album = 1881,
  plate = 14,
  n_elements = 4,

  elements = list(
    # Element 1: Category A (salmon pink)
    list(
      position = 1,
      label = "Category A",
      fill = "#d18781",              # Salmon pink/coral
      pattern_type = "none",          # Solid fill only
      pattern_fill = "#d18781",       # Same as fill
      pattern_color = "#d18781",
      pattern_angle = NA,
      pattern_density = 1.0,          # Solid
      pattern_spacing = NA,
      pattern_linewidth = NA
    ),

    # Element 2: Category B (golden yellow)
    list(
      position = 2,
      label = "Category B",
      fill = "#edd493",              # Light golden yellow
      pattern_type = "none",
      pattern_fill = "#edd493",
      pattern_color = "#edd493",
      pattern_angle = NA,
      pattern_density = 1.0,
      pattern_spacing = NA,
      pattern_linewidth = NA
    ),

    # Element 3: Category C (sage green)
    list(
      position = 3,
      label = "Category C",
      fill = "#7c9a77",              # Sage green
      pattern_type = "none",
      pattern_fill = "#7c9a77",
      pattern_color = "#7c9a77",
      pattern_angle = NA,
      pattern_density = 1.0,
      pattern_spacing = NA,
      pattern_linewidth = NA
    ),

    # Element 4: Category D (teal)
    list(
      position = 4,
      label = "Category D",
      fill = "#6a8782",              # Teal/gray-green
      pattern_type = "none",
      pattern_fill = "#6a8782",
      pattern_color = "#6a8782",
      pattern_angle = NA,
      pattern_density = 1.0,
      pattern_spacing = NA,
      pattern_linewidth = NA
    )
  ),

  metadata = list(
    source_url = "https://observablehq.com/@tomshanley/cheysson-color-palettes",
    rumsey_url = "https://www.davidrumsey.com/luna/servlet/detail/RUMSEY~8~1~309112~90078971",
    rumsey_no = "12512.014",
    title = "Comparaison des Principaux Courants de Trafic International",
    extracted_date = "2025-12-30",
    notes = "Four-color grouped palette, all solid fills. No patterns in original design."
  )
)

# ----------------------------------------------------------------------------
# Palette 4: 1891_07 (Complex Sequential - Hybrid Encoding)
# ----------------------------------------------------------------------------

# This palette demonstrates hybrid sequential encoding:
#   - COLOR VARIATION at low end (mauve → cream → light blend)
#   - PATTERN VARIATION at high end (solid → crosshatch → stripes)
#   - 7 elements for fine-grained sequential data

cheysson_colorpat_palettes[["1891_07"]] <- list(
  name = "1891_07",
  type = "sequential",
  album = 1891,
  plate = 25,
  n_elements = 7,

  elements = list(
    # Elements 1-3: Color variation, solid fills
    # Element 1: Very low (dusty mauve)
    list(
      position = 1,
      label = "Very Low",
      fill = "#b2a6af",              # Dusty mauve
      pattern_type = "none",
      pattern_fill = "#b2a6af",
      pattern_color = "#b2a6af",
      pattern_angle = NA,
      pattern_density = 1.0,
      pattern_spacing = NA,
      pattern_linewidth = NA
    ),

    # Element 2: Low (cream/off-white)
    list(
      position = 2,
      label = "Low",
      fill = "#faf3e2",              # Cream/off-white
      pattern_type = "none",
      pattern_fill = "#faf3e2",
      pattern_color = "#faf3e2",
      pattern_angle = NA,
      pattern_density = 1.0,
      pattern_spacing = NA,
      pattern_linewidth = NA
    ),

    # Element 3: Below Average (light blend)
    list(
      position = 3,
      label = "Below Average",
      fill = "#d6cdd0",              # Light mauve-cream blend
      pattern_type = "none",
      pattern_fill = "#d6cdd0",
      pattern_color = "#d6cdd0",
      pattern_angle = NA,
      pattern_density = 1.0,
      pattern_spacing = NA,
      pattern_linewidth = NA
    ),

    # Elements 4-7: Same color (mauve), pattern variation
    # Element 4: Average (crosshatch)
    list(
      position = 4,
      label = "Average",
      fill = "#b2a6af",              # Back to mauve
      pattern_type = "crosshatch",
      pattern_fill = "#8a7e86",      # Darker mauve
      pattern_color = "#8a7e86",
      pattern_angle = NA,
      pattern_density = 0.35,
      pattern_spacing = 0.03,
      pattern_linewidth = 0.5
    ),

    # Element 5: Above Average (diagonal stripes)
    list(
      position = 5,
      label = "Above Average",
      fill = "#b2a6af",              # Mauve
      pattern_type = "stripe",
      pattern_fill = "#8a7e86",      # Darker mauve
      pattern_color = "#8a7e86",
      pattern_angle = 135,
      pattern_density = 0.30,
      pattern_spacing = 0.025,
      pattern_linewidth = 0.5
    ),

    # Element 6: High (denser diagonal stripes)
    list(
      position = 6,
      label = "High",
      fill = "#b2a6af",              # Mauve
      pattern_type = "stripe",
      pattern_fill = "#8a7e86",      # Darker mauve
      pattern_color = "#8a7e86",
      pattern_angle = 135,
      pattern_density = 0.35,
      pattern_spacing = 0.02,
      pattern_linewidth = 0.5
    ),

    # Element 7: Very High (densest diagonal stripes)
    list(
      position = 7,
      label = "Very High",
      fill = "#b2a6af",              # Mauve
      pattern_type = "stripe",
      pattern_fill = "#8a7e86",      # Darker mauve
      pattern_color = "#8a7e86",
      pattern_angle = 135,
      pattern_density = 0.40,
      pattern_spacing = 0.018,
      pattern_linewidth = 0.5
    )
  ),

  metadata = list(
    source_url = "https://observablehq.com/@tomshanley/cheysson-color-palettes",
    rumsey_url = "https://www.davidrumsey.com/luna/servlet/detail/RUMSEY~8~1~309566~90079428",
    rumsey_no = "12521.025",
    title = "Routes Nationales - Prix Moyen de la Journée de Terrassement",
    extracted_date = "2025-12-30",
    notes = "7-element sequential with hybrid encoding: color variation (low) + pattern variation (high). Most complex sequential palette."
  )
)

# ----------------------------------------------------------------------------
# Palette 5: 1886_08 (Grouped - Alternating Patterns)
# ----------------------------------------------------------------------------

# This palette demonstrates grouped encoding with pattern alternation:
#   - FOUR BASE COLORS (coral, yellow, blue, green)
#   - ALTERNATING PATTERNS (stripe vs crosshatch)
#   - 2 colors × 2 patterns × 2 repetitions = 8 elements

cheysson_colorpat_palettes[["1886_08"]] <- list(
  name = "1886_08",
  type = "grouped",
  album = 1886,
  plate = 11,
  n_elements = 8,

  elements = list(
    # Group 1: Coral/salmon with stripe (vertical)
    list(
      position = 1,
      label = "Group 1A",
      fill = "#e28784",              # Coral/salmon
      pattern_type = "stripe",
      pattern_fill = "#c26461",      # Darker coral
      pattern_color = "#c26461",
      pattern_angle = 90,            # Vertical
      pattern_density = 0.30,
      pattern_spacing = 0.025,
      pattern_linewidth = 0.5
    ),

    # Group 1: Yellow with crosshatch
    list(
      position = 2,
      label = "Group 1B",
      fill = "#e9ba46",              # Golden yellow
      pattern_type = "crosshatch",
      pattern_fill = "#c99826",      # Darker yellow
      pattern_color = "#c99826",
      pattern_angle = NA,
      pattern_density = 0.30,
      pattern_spacing = 0.025,
      pattern_linewidth = 0.5
    ),

    # Group 2: Blue with stripe (vertical)
    list(
      position = 3,
      label = "Group 2A",
      fill = "#224e79",              # Dark blue
      pattern_type = "stripe",
      pattern_fill = "#1a3d5f",      # Darker blue
      pattern_color = "#1a3d5f",
      pattern_angle = 90,            # Vertical
      pattern_density = 0.30,
      pattern_spacing = 0.025,
      pattern_linewidth = 0.5
    ),

    # Group 2: Green with crosshatch
    list(
      position = 4,
      label = "Group 2B",
      fill = "#58825f",              # Sage green
      pattern_type = "crosshatch",
      pattern_fill = "#406549",      # Darker green
      pattern_color = "#406549",
      pattern_angle = NA,
      pattern_density = 0.30,
      pattern_spacing = 0.025,
      pattern_linewidth = 0.5
    ),

    # Group 3: Blue with stripe (vertical) - repeat of Group 2A pattern
    list(
      position = 5,
      label = "Group 3A",
      fill = "#224e79",              # Dark blue (same as 3)
      pattern_type = "stripe",
      pattern_fill = "#1a3d5f",      # Darker blue
      pattern_color = "#1a3d5f",
      pattern_angle = 90,
      pattern_density = 0.30,
      pattern_spacing = 0.025,
      pattern_linewidth = 0.5
    ),

    # Group 3: Blue with crosshatch - blue base, crosshatch pattern
    list(
      position = 6,
      label = "Group 3B",
      fill = "#224e79",              # Dark blue
      pattern_type = "crosshatch",
      pattern_fill = "#1a3d5f",      # Darker blue
      pattern_color = "#1a3d5f",
      pattern_angle = NA,
      pattern_density = 0.30,
      pattern_spacing = 0.025,
      pattern_linewidth = 0.5
    ),

    # Group 4: Green with stripe (vertical)
    list(
      position = 7,
      label = "Group 4A",
      fill = "#58825f",              # Sage green (same as 4)
      pattern_type = "stripe",
      pattern_fill = "#406549",      # Darker green
      pattern_color = "#406549",
      pattern_angle = 90,
      pattern_density = 0.30,
      pattern_spacing = 0.025,
      pattern_linewidth = 0.5
    ),

    # Group 4: Green with crosshatch
    list(
      position = 8,
      label = "Group 4B",
      fill = "#58825f",              # Sage green
      pattern_type = "crosshatch",
      pattern_fill = "#406549",      # Darker green
      pattern_color = "#406549",
      pattern_angle = NA,
      pattern_density = 0.30,
      pattern_spacing = 0.025,
      pattern_linewidth = 0.5
    )
  ),

  metadata = list(
    source_url = "https://observablehq.com/@tomshanley/cheysson-color-palettes",
    rumsey_url = "https://www.davidrumsey.com/luna/servlet/detail/RUMSEY~8~1~309237~90079152",
    rumsey_no = "12516.011",
    title = "Carte Figurative des Expeditions de Marchandises",
    extracted_date = "2025-12-30",
    notes = "8-element grouped palette with alternating stripe/crosshatch patterns. Demonstrates systematic pattern variation."
  )
)

# ----------------------------------------------------------------------------
# Palette 6: 1880_07 (Categorical - 7 Solid Colors)
# ----------------------------------------------------------------------------

# This palette demonstrates a 7-category color-only palette:
#   - SEVEN DISTINCT COLORS
#   - NO PATTERNS (all solid fills)
#   - Warm and cool hues alternated for distinction

cheysson_colorpat_palettes[["1880_07"]] <- list(
  name = "1880_07",
  type = "category",
  album = 1880,
  plate = 21,
  n_elements = 7,

  elements = list(
    # Element 1: Dusty rose
    list(
      position = 1,
      label = "Category A",
      fill = "#d9636c",              # Dusty rose
      pattern_type = "none",
      pattern_fill = "#d9636c",
      pattern_color = "#d9636c",
      pattern_angle = NA,
      pattern_density = 1.0,
      pattern_spacing = NA,
      pattern_linewidth = NA
    ),

    # Element 2: Sage green
    list(
      position = 2,
      label = "Category B",
      fill = "#869e80",              # Sage green
      pattern_type = "none",
      pattern_fill = "#869e80",
      pattern_color = "#869e80",
      pattern_angle = NA,
      pattern_density = 1.0,
      pattern_spacing = NA,
      pattern_linewidth = NA
    ),

    # Element 3: Golden yellow
    list(
      position = 3,
      label = "Category C",
      fill = "#dec367",              # Golden yellow
      pattern_type = "none",
      pattern_fill = "#dec367",
      pattern_color = "#dec367",
      pattern_angle = NA,
      pattern_density = 1.0,
      pattern_spacing = NA,
      pattern_linewidth = NA
    ),

    # Element 4: Sky blue
    list(
      position = 4,
      label = "Category D",
      fill = "#85aab1",              # Sky blue
      pattern_type = "none",
      pattern_fill = "#85aab1",
      pattern_color = "#85aab1",
      pattern_angle = NA,
      pattern_density = 1.0,
      pattern_spacing = NA,
      pattern_linewidth = NA
    ),

    # Element 5: Warm gray
    list(
      position = 5,
      label = "Category E",
      fill = "#aea9a4",              # Warm gray
      pattern_type = "none",
      pattern_fill = "#aea9a4",
      pattern_color = "#aea9a4",
      pattern_angle = NA,
      pattern_density = 1.0,
      pattern_spacing = NA,
      pattern_linewidth = NA
    ),

    # Element 6: Burnt orange
    list(
      position = 6,
      label = "Category F",
      fill = "#ed8238",              # Burnt orange
      pattern_type = "none",
      pattern_fill = "#ed8238",
      pattern_color = "#ed8238",
      pattern_angle = NA,
      pattern_density = 1.0,
      pattern_spacing = NA,
      pattern_linewidth = NA
    ),

    # Element 7: Dusty lavender
    list(
      position = 7,
      label = "Category G",
      fill = "#ab90a4",              # Dusty lavender
      pattern_type = "none",
      pattern_fill = "#ab90a4",
      pattern_color = "#ab90a4",
      pattern_angle = NA,
      pattern_density = 1.0,
      pattern_spacing = NA,
      pattern_linewidth = NA
    )
  ),

  metadata = list(
    source_url = "https://observablehq.com/@tomshanley/cheysson-color-palettes",
    rumsey_url = "https://www.davidrumsey.com/luna/servlet/detail/RUMSEY~8~1~309778~90078927",
    rumsey_no = "12511.021",
    title = "Carte Figurative des Donnees Relatives a la Circulation des Voyageurs",
    extracted_date = "2025-12-30",
    notes = "7-category palette with diverse solid colors. Warm-cool alternation for maximum distinction."
  )
)

# ----------------------------------------------------------------------------
# Palette 7: 1906_04 (Categorical - 4 Solid Colors)
# ----------------------------------------------------------------------------

# This palette demonstrates a simple 4-category color palette:
#   - FOUR DISTINCT COLORS (black, blue, yellow, red)
#   - NO PATTERNS
#   - High contrast for clear categorical distinction

cheysson_colorpat_palettes[["1906_04"]] <- list(
  name = "1906_04",
  type = "category",
  album = 1906,
  plate = 50,
  n_elements = 4,

  elements = list(
    # Element 1: Black
    list(
      position = 1,
      label = "Category A",
      fill = "#0a0102",              # Near black
      pattern_type = "none",
      pattern_fill = "#0a0102",
      pattern_color = "#0a0102",
      pattern_angle = NA,
      pattern_density = 1.0,
      pattern_spacing = NA,
      pattern_linewidth = NA
    ),

    # Element 2: Steel blue
    list(
      position = 2,
      label = "Category B",
      fill = "#2f6388",              # Steel blue
      pattern_type = "none",
      pattern_fill = "#2f6388",
      pattern_color = "#2f6388",
      pattern_angle = NA,
      pattern_density = 1.0,
      pattern_spacing = NA,
      pattern_linewidth = NA
    ),

    # Element 3: Golden yellow
    list(
      position = 3,
      label = "Category C",
      fill = "#d9ab36",              # Golden yellow
      pattern_type = "none",
      pattern_fill = "#d9ab36",
      pattern_color = "#d9ab36",
      pattern_angle = NA,
      pattern_density = 1.0,
      pattern_spacing = NA,
      pattern_linewidth = NA
    ),

    # Element 4: Bright red
    list(
      position = 4,
      label = "Category D",
      fill = "#c81e1e",              # Bright red
      pattern_type = "none",
      pattern_fill = "#c81e1e",
      pattern_color = "#c81e1e",
      pattern_angle = NA,
      pattern_density = 1.0,
      pattern_spacing = NA,
      pattern_linewidth = NA
    )
  ),

  metadata = list(
    source_url = "https://observablehq.com/@tomshanley/cheysson-color-palettes",
    rumsey_url = "https://www.davidrumsey.com/luna/servlet/detail/RUMSEY~8~1~309755~90079597",
    rumsey_no = "12526.050",
    title = "Puissance Coloniale des Divers Pays",
    extracted_date = "2025-12-30",
    notes = "High-contrast 4-category palette with black, blue, yellow, and red. Strong categorical distinction."
  )
)

# ----------------------------------------------------------------------------
# Palette 8: 1891_06 (Sequential - 6 Elements, Monochrome with Patterns)
# ----------------------------------------------------------------------------

# This palette demonstrates monochrome sequential with pattern progression:
#   - SINGLE COLOR (#265d8e blue)
#   - PATTERN VARIATION (solid → increasing stripe density)
#   - 6 ordered levels

cheysson_colorpat_palettes[["1891_06"]] <- list(
  name = "1891_06",
  type = "sequential",
  album = 1891,
  plate = 19,
  n_elements = 6,

  elements = list(
    # Element 1: Lowest (solid)
    list(
      position = 1,
      label = "Very Low",
      fill = "#265d8e",              # Deep blue
      pattern_type = "none",
      pattern_fill = "#265d8e",
      pattern_color = "#265d8e",
      pattern_angle = NA,
      pattern_density = 1.0,
      pattern_spacing = NA,
      pattern_linewidth = NA
    ),

    # Element 2: Low (vertical stripes)
    list(
      position = 2,
      label = "Low",
      fill = "#265d8e",              # Same blue
      pattern_type = "stripe",
      pattern_fill = "#1a4669",      # Darker blue for stripes
      pattern_color = "#1a4669",
      pattern_angle = 90,            # Vertical
      pattern_density = 0.25,        # Sparse
      pattern_spacing = 0.04,
      pattern_linewidth = 0.5
    ),

    # Element 3: Below Average (denser vertical stripes)
    list(
      position = 3,
      label = "Below Average",
      fill = "#265d8e",              # Same blue
      pattern_type = "stripe",
      pattern_fill = "#1a4669",      # Darker blue
      pattern_color = "#1a4669",
      pattern_angle = 90,
      pattern_density = 0.30,        # Medium-low
      pattern_spacing = 0.03,
      pattern_linewidth = 0.5
    ),

    # Element 4: Average (medium density)
    list(
      position = 4,
      label = "Average",
      fill = "#265d8e",              # Same blue
      pattern_type = "stripe",
      pattern_fill = "#1a4669",      # Darker blue
      pattern_color = "#1a4669",
      pattern_angle = 90,
      pattern_density = 0.35,        # Medium
      pattern_spacing = 0.025,
      pattern_linewidth = 0.5
    ),

    # Element 5: Above Average (higher density)
    list(
      position = 5,
      label = "Above Average",
      fill = "#265d8e",              # Same blue
      pattern_type = "stripe",
      pattern_fill = "#1a4669",      # Darker blue
      pattern_color = "#1a4669",
      pattern_angle = 90,
      pattern_density = 0.40,        # Medium-high
      pattern_spacing = 0.02,
      pattern_linewidth = 0.5
    ),

    # Element 6: High (densest stripes)
    list(
      position = 6,
      label = "High",
      fill = "#265d8e",              # Same blue
      pattern_type = "stripe",
      pattern_fill = "#1a4669",      # Darker blue
      pattern_color = "#1a4669",
      pattern_angle = 90,
      pattern_density = 0.45,        # Dense
      pattern_spacing = 0.018,
      pattern_linewidth = 0.5
    )
  ),

  metadata = list(
    source_url = "https://observablehq.com/@tomshanley/cheysson-color-palettes",
    rumsey_url = "https://www.davidrumsey.com/luna/servlet/detail/RUMSEY~8~1~309560~90079434",
    rumsey_no = "12521.019",
    title = "Tonnage des Voies Navigables en 1889",
    extracted_date = "2025-12-30",
    notes = "6-element monochrome sequential with vertical stripe density progression. Economical single-color design."
  )
)

# ----------------------------------------------------------------------------
# Palette 9: 1906_06 (Categorical - 6 Elements with One Pattern)
# ----------------------------------------------------------------------------

# This palette demonstrates categorical encoding with mixed solid/pattern:
#   - SIX COLORS with varied hues
#   - ONE PATTERN element (blue with diagonal stripes)
#   - High color contrast

cheysson_colorpat_palettes[["1906_06"]] <- list(
  name = "1906_06",
  type = "category",
  album = 1906,
  plate = 6,
  n_elements = 6,

  elements = list(
    # Element 1: Black
    list(
      position = 1,
      label = "Category A",
      fill = "#130b09",              # Very dark brown/black
      pattern_type = "none",
      pattern_fill = "#130b09",
      pattern_color = "#130b09",
      pattern_angle = NA,
      pattern_density = 1.0,
      pattern_spacing = NA,
      pattern_linewidth = NA
    ),

    # Element 2: Gold
    list(
      position = 2,
      label = "Category B",
      fill = "#d3a928",              # Rich gold
      pattern_type = "none",
      pattern_fill = "#d3a928",
      pattern_color = "#d3a928",
      pattern_angle = NA,
      pattern_density = 1.0,
      pattern_spacing = NA,
      pattern_linewidth = NA
    ),

    # Element 3: Steel blue with pattern
    list(
      position = 3,
      label = "Category C",
      fill = "#92a1b2",              # Light steel blue
      pattern_type = "stripe",
      pattern_fill = "#333333",      # Dark gray for stripes
      pattern_color = "#333333",
      pattern_angle = 135,           # Diagonal
      pattern_density = 0.30,
      pattern_spacing = 0.025,
      pattern_linewidth = 0.5
    ),

    # Element 4: Green
    list(
      position = 4,
      label = "Category D",
      fill = "#678c68",              # Forest green
      pattern_type = "none",
      pattern_fill = "#678c68",
      pattern_color = "#678c68",
      pattern_angle = NA,
      pattern_density = 1.0,
      pattern_spacing = NA,
      pattern_linewidth = NA
    ),

    # Element 5: Red
    list(
      position = 5,
      label = "Category E",
      fill = "#cd2e22",              # Bright red
      pattern_type = "none",
      pattern_fill = "#cd2e22",
      pattern_color = "#cd2e22",
      pattern_angle = NA,
      pattern_density = 1.0,
      pattern_spacing = NA,
      pattern_linewidth = NA
    ),

    # Element 6: Dark gray
    list(
      position = 6,
      label = "Category F",
      fill = "#333333",              # Dark gray
      pattern_type = "none",
      pattern_fill = "#333333",
      pattern_color = "#333333",
      pattern_angle = NA,
      pattern_density = 1.0,
      pattern_spacing = NA,
      pattern_linewidth = NA
    )
  ),

  metadata = list(
    source_url = "https://observablehq.com/@tomshanley/cheysson-color-palettes",
    rumsey_url = "https://www.davidrumsey.com/luna/servlet/detail/RUMSEY~8~1~309711~90079641",
    rumsey_no = "12526.006",
    title = "Developpement des Voies de Communication",
    extracted_date = "2025-12-30",
    notes = "6-category palette with one patterned element for emphasis. Mixed solid/pattern approach."
  )
)

# ----------------------------------------------------------------------------
# Palette 10: 1891_03 (Grouped - 3 Elements)
# ----------------------------------------------------------------------------

# This palette demonstrates a simple grouped palette:
#   - TWO BASE COLORS (teal, orange)
#   - PATTERN on second orange element
#   - Small palette for basic grouping

cheysson_colorpat_palettes[["1891_03"]] <- list(
  name = "1891_03",
  type = "grouped",
  album = 1891,
  plate = 14,
  n_elements = 3,

  elements = list(
    # Element 1: Teal (solid)
    list(
      position = 1,
      label = "Group A",
      fill = "#6e929c",              # Dusty teal
      pattern_type = "none",
      pattern_fill = "#6e929c",
      pattern_color = "#6e929c",
      pattern_angle = NA,
      pattern_density = 1.0,
      pattern_spacing = NA,
      pattern_linewidth = NA
    ),

    # Element 2: Orange (solid)
    list(
      position = 2,
      label = "Group B1",
      fill = "#b75533",              # Burnt orange
      pattern_type = "none",
      pattern_fill = "#b75533",
      pattern_color = "#b75533",
      pattern_angle = NA,
      pattern_density = 1.0,
      pattern_spacing = NA,
      pattern_linewidth = NA
    ),

    # Element 3: Orange (with stripe)
    list(
      position = 3,
      label = "Group B2",
      fill = "#b75533",              # Same orange
      pattern_type = "stripe",
      pattern_fill = "#8a3d23",      # Darker orange
      pattern_color = "#8a3d23",
      pattern_angle = 135,           # Diagonal
      pattern_density = 0.30,
      pattern_spacing = 0.025,
      pattern_linewidth = 0.5
    )
  ),

  metadata = list(
    source_url = "https://observablehq.com/@tomshanley/cheysson-color-palettes",
    rumsey_url = "https://www.davidrumsey.com/luna/servlet/detail/RUMSEY~8~1~309555~90079439",
    rumsey_no = "12521.014",
    title = "Longueurs des Chemins de Fer dans les Divers Pays",
    extracted_date = "2025-12-30",
    notes = "3-element grouped palette. Demonstrates subgroup encoding with pattern variation on same base color."
  )
)

# ----------------------------------------------------------------------------
# Palette 11: 1881_08 (Grouped - 8 Elements with Mixed Patterns)
# ----------------------------------------------------------------------------

# This palette demonstrates complex grouped encoding:
#   - FOUR BASE COLORS + REPEATED BROWN
#   - MIXED PATTERNS (crosshatch, solid, stripes)
#   - 8 elements for detailed categorical grouping

cheysson_colorpat_palettes[["1881_08"]] <- list(
  name = "1881_08",
  type = "grouped",
  album = 1881,
  plate = 30,
  n_elements = 8,

  elements = list(
    # Element 1: Gold with crosshatch
    list(
      position = 1,
      label = "Group A",
      fill = "#d3af4b",              # Golden yellow
      pattern_type = "crosshatch",
      pattern_fill = "#a88a2b",      # Darker gold
      pattern_color = "#a88a2b",
      pattern_angle = NA,
      pattern_density = 0.30,
      pattern_spacing = 0.025,
      pattern_linewidth = 0.5
    ),

    # Element 2: Rust (solid)
    list(
      position = 2,
      label = "Group B",
      fill = "#cd7451",              # Rust/terracotta
      pattern_type = "none",
      pattern_fill = "#cd7451",
      pattern_color = "#cd7451",
      pattern_angle = NA,
      pattern_density = 1.0,
      pattern_spacing = NA,
      pattern_linewidth = NA
    ),

    # Element 3: Cream (solid)
    list(
      position = 3,
      label = "Group C",
      fill = "#f9ece3",              # Cream/off-white
      pattern_type = "none",
      pattern_fill = "#f9ece3",
      pattern_color = "#f9ece3",
      pattern_angle = NA,
      pattern_density = 1.0,
      pattern_spacing = NA,
      pattern_linewidth = NA
    ),

    # Element 4: Gray (solid)
    list(
      position = 4,
      label = "Group D",
      fill = "#737e7e",              # Blue-gray
      pattern_type = "none",
      pattern_fill = "#737e7e",
      pattern_color = "#737e7e",
      pattern_angle = NA,
      pattern_density = 1.0,
      pattern_spacing = NA,
      pattern_linewidth = NA
    ),

    # Elements 5-8: Dark brown with stripes (repeated pattern group)
    # Element 5: Brown stripe variant 1
    list(
      position = 5,
      label = "Group E1",
      fill = "#514031",              # Dark brown
      pattern_type = "stripe",
      pattern_fill = "#3a2d20",      # Very dark brown
      pattern_color = "#3a2d20",
      pattern_angle = 135,           # Diagonal
      pattern_density = 0.30,
      pattern_spacing = 0.025,
      pattern_linewidth = 0.5
    ),

    # Element 6: Brown stripe variant 2
    list(
      position = 6,
      label = "Group E2",
      fill = "#514031",              # Same brown
      pattern_type = "stripe",
      pattern_fill = "#3a2d20",
      pattern_color = "#3a2d20",
      pattern_angle = 90,            # Vertical
      pattern_density = 0.30,
      pattern_spacing = 0.025,
      pattern_linewidth = 0.5
    ),

    # Element 7: Brown stripe variant 3
    list(
      position = 7,
      label = "Group E3",
      fill = "#514031",              # Same brown
      pattern_type = "stripe",
      pattern_fill = "#3a2d20",
      pattern_color = "#3a2d20",
      pattern_angle = 45,            # Diagonal opposite
      pattern_density = 0.30,
      pattern_spacing = 0.025,
      pattern_linewidth = 0.5
    ),

    # Element 8: Brown stripe variant 4
    list(
      position = 8,
      label = "Group E4",
      fill = "#514031",              # Same brown
      pattern_type = "stripe",
      pattern_fill = "#3a2d20",
      pattern_color = "#3a2d20",
      pattern_angle = 135,           # Back to diagonal
      pattern_density = 0.35,        # Slightly denser
      pattern_spacing = 0.02,
      pattern_linewidth = 0.5
    )
  ),

  metadata = list(
    source_url = "https://observablehq.com/@tomshanley/cheysson-color-palettes",
    rumsey_url = "https://www.davidrumsey.com/luna/servlet/detail/RUMSEY~8~1~309128~90078955",
    rumsey_no = "12512.030",
    title = "Carte Figurative des Travaux D'Achevement",
    extracted_date = "2025-12-31",
    notes = "8-element grouped palette with 4 distinct colors plus 4 brown variations with different stripe angles. Demonstrates complex categorical grouping."
  )
)

# ============================================================================
# PART 2: ACCESSOR FUNCTION
# ============================================================================

#' Get Unified Color-Pattern Palette
#'
#' Retrieves a Cheysson color-pattern palette where colors and patterns
#' are paired as originally designed.
#'
#' @param palette Character. Name of palette (e.g., "1883_04")
#' @param n Integer. Number of colors needed. If NULL, returns all.
#' @param reverse Logical. Reverse the order?
#'
#' @return List with components for each aesthetic (fill, pattern_type, etc.)
#'
#' @examples
#' pal <- cheysson_colorpat("1883_04")
#' pal$fill           # Vector of fill colors
#' pal$pattern_type   # Vector of pattern types
cheysson_colorpat <- function(palette, n = NULL, reverse = FALSE) {

  # Check if palette exists
  if (!palette %in% names(cheysson_colorpat_palettes)) {
    stop(sprintf("Palette '%s' not found. Available: %s",
                 palette,
                 paste(names(cheysson_colorpat_palettes), collapse = ", ")))
  }

  pal <- cheysson_colorpat_palettes[[palette]]
  elements <- pal$elements

  # Determine number of elements
  n_available <- length(elements)
  if (is.null(n)) {
    n <- n_available
  }

  # Handle n > available: recycle
  if (n > n_available) {
    warning(sprintf("Requested %d colors but palette '%s' only has %d. Recycling.",
                    n, palette, n_available))
    indices <- rep(seq_len(n_available), length.out = n)
  } else if (n < n_available) {
    # Take first n elements
    indices <- seq_len(n)
  } else {
    indices <- seq_len(n)
  }

  # Extract elements
  selected_elements <- elements[indices]

  # Reverse if requested
  if (reverse) {
    selected_elements <- rev(selected_elements)
  }

  # Build return object with vectors for each aesthetic
  result <- list(
    fill = sapply(selected_elements, function(x) x$fill),
    pattern_type = sapply(selected_elements, function(x) x$pattern_type),
    pattern_fill = sapply(selected_elements, function(x) x$pattern_fill),
    pattern_color = sapply(selected_elements, function(x) x$pattern_color),
    pattern_angle = sapply(selected_elements, function(x) x$pattern_angle %||% NA),
    pattern_density = sapply(selected_elements, function(x) x$pattern_density),
    pattern_spacing = sapply(selected_elements, function(x) x$pattern_spacing %||% NA),
    pattern_linewidth = sapply(selected_elements, function(x) x$pattern_linewidth %||% NA),
    labels = sapply(selected_elements, function(x) x$label %||% ""),
    n = n,
    palette = palette,
    type = pal$type
  )

  class(result) <- c("cheysson_colorpat", "list")
  return(result)
}

# ============================================================================
# PART 3: UNIFIED SCALE FUNCTION
# ============================================================================

#' Apply Unified Cheysson Color-Pattern Scale
#'
#' Single function that applies BOTH fill colors AND patterns using the
#' original designed pairs. This ensures historically authentic reproduction
#' of Cheysson's palettes.
#'
#' @param palette Character. Palette name (e.g., "1883_04")
#' @param aesthetics Character vector. Which aesthetics to apply.
#'   Default "auto" detects if patterns are present and applies all relevant.
#' @param reverse Logical. Reverse palette order?
#' @param ... Additional arguments passed to scale functions
#'
#' @return List of ggplot2 scale objects to be added to plot
#'
#' @examples
#' library(ggplot2)
#' library(ggpattern)
#'
#' ggplot(data, aes(x, y, fill = category, pattern_type = category)) +
#'   geom_col_pattern() +
#'   scale_colorpat_cheysson("1883_04")
scale_colorpat_cheysson <- function(palette,
                                     aesthetics = "auto",
                                     reverse = FALSE,
                                     ...) {

  # Get unified palette
  pal <- cheysson_colorpat(palette, reverse = reverse)

  # Determine which aesthetics to apply
  if (length(aesthetics) == 1 && aesthetics == "auto") {
    # Check if palette has patterns
    has_patterns <- any(pal$pattern_type != "none", na.rm = TRUE)

    if (has_patterns) {
      aesthetics <- c("fill", "pattern_type", "pattern_fill",
                     "pattern_angle", "pattern_density", "pattern_spacing")
    } else {
      # Color-only palette
      aesthetics <- c("fill")
    }
  }

  # Build list of scale functions
  scales <- list()

  if ("fill" %in% aesthetics) {
    scales$fill <- scale_fill_manual(
      values = setNames(pal$fill, pal$labels),
      ...
    )
  }

  if ("pattern_type" %in% aesthetics) {
    scales$pattern_type <- scale_pattern_type_manual(
      values = setNames(pal$pattern_type, pal$labels),
      ...
    )
  }

  if ("pattern_fill" %in% aesthetics) {
    scales$pattern_fill <- scale_pattern_fill_manual(
      values = setNames(pal$pattern_fill, pal$labels),
      ...
    )
  }

  if ("pattern_color" %in% aesthetics) {
    scales$pattern_color <- scale_pattern_color_manual(
      values = setNames(pal$pattern_color, pal$labels),
      ...
    )
  }

  if ("pattern_angle" %in% aesthetics) {
    # Only create angle scale if there are non-NA angles
    if (any(!is.na(pal$pattern_angle))) {
      angles <- pal$pattern_angle
      # Convert NA to 0 for manual scale (for elements with no pattern)
      angles[is.na(angles)] <- 0
      scales$pattern_angle <- scale_pattern_angle_manual(
        values = setNames(angles, pal$labels)
      )
    }
  }

  if ("pattern_density" %in% aesthetics) {
    scales$pattern_density <- scale_pattern_density_manual(
      values = setNames(pal$pattern_density, pal$labels)
    )
  }

  if ("pattern_spacing" %in% aesthetics) {
    # Only create spacing scale if there are non-NA values
    if (any(!is.na(pal$pattern_spacing))) {
      spacing <- pal$pattern_spacing
      spacing[is.na(spacing)] <- 0.01
      scales$pattern_spacing <- scale_pattern_spacing_manual(
        values = setNames(spacing, pal$labels)
      )
    }
  }

  # Return list of scales
  # Note: Can't return directly as ggplot2 doesn't handle lists well
  # User will need to use them with `+`
  class(scales) <- c("cheysson_colorpat_scales", "list")
  return(scales)
}

# Helper to add scales to plot
#' @export
`+.gg` <- function(e1, e2) {
  if (inherits(e2, "cheysson_colorpat_scales")) {
    # Add each scale individually
    result <- e1
    for (scale in e2) {
      result <- result + scale
    }
    return(result)
  } else {
    # Default ggplot2 behavior
    NextMethod()
  }
}

# ============================================================================
# PART 4: HELPER FUNCTIONS
# ============================================================================

#' List Available Unified Color-Pattern Palettes
#'
#' @param type Character. Filter by palette type. NULL returns all.
#' @return Data frame with palette information
list_colorpat_palettes <- function(type = NULL) {

  pal_df <- map_df(names(cheysson_colorpat_palettes), function(pal_name) {
    pal <- cheysson_colorpat_palettes[[pal_name]]
    data.frame(
      name = pal$name,
      type = pal$type,
      album = pal$album,
      plate = pal$plate,
      n_elements = pal$n_elements,
      has_patterns = any(sapply(pal$elements, function(x) x$pattern_type != "none")),
      stringsAsFactors = FALSE
    )
  })

  if (!is.null(type)) {
    pal_df <- pal_df[pal_df$type == tolower(type), ]
  }

  return(pal_df)
}

#' Print method for unified palette
#' @export
print.cheysson_colorpat <- function(x, ...) {
  cat(sprintf("Cheysson Unified Color-Pattern Palette: %s\n", x$palette))
  cat(sprintf("Type: %s\n", x$type))
  cat(sprintf("Elements: %d\n\n", x$n))

  for (i in seq_len(x$n)) {
    cat(sprintf("[%d] %s\n", i, x$labels[i]))
    cat(sprintf("    Fill: %s\n", x$fill[i]))
    cat(sprintf("    Pattern: %s", x$pattern_type[i]))
    if (!is.na(x$pattern_angle[i])) {
      cat(sprintf(" @ %.0f°", x$pattern_angle[i]))
    }
    cat("\n")
    if (x$pattern_type[i] != "none") {
      cat(sprintf("    Pattern fill: %s\n", x$pattern_fill[i]))
      cat(sprintf("    Density: %.2f, Spacing: %.3f\n",
                  x$pattern_density[i],
                  x$pattern_spacing[i]))
    }
    cat("\n")
  }

  invisible(x)
}

# ============================================================================
# DEMONSTRATION
# ============================================================================

if (interactive() && FALSE) {
  # Demo 1: Access palette
  pal <- cheysson_colorpat("1883_04")
  print(pal)

  # Demo 2: List available palettes
  list_colorpat_palettes()

  # Demo 3: Get just colors (for color-only plots)
  colors <- cheysson_colorpat("1883_04")$fill
  colors

  # Demo 4: Use in ggplot (see test_prototype_colorpat.R)
}

cat("\n=== Prototype Unified Color-Pattern Palette System ===\n\n")
cat("Created 11 palettes (55% of full 20-palette set):\n\n")
cat("DIVERGING (1 palette):\n")
cat("  1. 1883_04 (4 elements) - Dual encoding: color=direction, pattern=magnitude\n\n")
cat("SEQUENTIAL (3 palettes):\n")
cat("  2. 1881_03 (3 elements) - Monochrome with pattern density progression\n")
cat("  3. 1891_07 (7 elements) - Hybrid: color variation (low) + pattern variation (high)\n")
cat("  4. 1891_06 (6 elements) - Monochrome blue with vertical stripe density progression\n\n")
cat("GROUPED (4 palettes):\n")
cat("  5. 1881_04 (4 elements) - Color-only, no patterns\n")
cat("  6. 1886_08 (8 elements) - Alternating stripe/crosshatch patterns\n")
cat("  7. 1891_03 (3 elements) - Two colors with pattern subgroup\n")
cat("  8. 1881_08 (8 elements) - Mixed patterns with angle variation\n\n")
cat("CATEGORICAL (3 palettes):\n")
cat("  9. 1880_07 (7 elements) - Diverse solid colors, warm-cool alternation\n")
cat(" 10. 1906_04 (4 elements) - High-contrast: black, blue, yellow, red\n")
cat(" 11. 1906_06 (6 elements) - Mixed solid/pattern approach\n\n")
cat("Functions:\n")
cat("  - Accessor: cheysson_colorpat('palette_name')\n")
cat("  - Scale: scale_colorpat_cheysson('palette_name')\n")
cat("  - List all: list_colorpat_palettes()\n\n")
cat("Try:\n")
cat("  pal <- cheysson_colorpat('1891_06'); print(pal)\n")
cat("  list_colorpat_palettes()\n")
