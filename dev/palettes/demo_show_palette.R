# Demonstration of show_palette() and show_palettes() functions
# These functions provide better visualization than colorspace::swatchplot()
# by including hex codes directly on the plot

library(here)
devtools::load_all(here())

# ============================================================================
# Example 1: Display a single palette with full information
# ============================================================================
png(here("man/figures/palette-demo-1.png"), width = 800, height = 200, res = 100)
show_palette("1895_04")
dev.off()
cat("Created: man/figures/palette-demo-1.png\n")

# ============================================================================
# Example 2: Compare palettes side by side
# ============================================================================
png(here("man/figures/palette-demo-compare.png"), width = 800, height = 800, res = 100)
show_palettes(c("1880_07", "1881_03", "1881_04", "1895_04"))
dev.off()
cat("Created: man/figures/palette-demo-compare.png\n")

# ============================================================================
# Example 3: Display all sequential palettes
# ============================================================================
png(here("man/figures/palettes-sequential.png"), width = 900, height = 1500, res = 100)
show_palettes("sequential")
dev.off()
cat("Created: man/figures/palettes-sequential.png\n")

# ============================================================================
# Example 4: Display all diverging palettes
# ============================================================================
png(here("man/figures/palettes-diverging.png"), width = 900, height = 400, res = 100)
show_palettes("diverging")
dev.off()
cat("Created: man/figures/palettes-diverging.png\n")

# ============================================================================
# Example 5: Display all grouped palettes
# ============================================================================
png(here("man/figures/palettes-grouped.png"), width = 900, height = 1100, res = 100)
show_palettes("grouped")
dev.off()
cat("Created: man/figures/palettes-grouped.png\n")

# ============================================================================
# Example 6: Display all category palettes
# ============================================================================
png(here("man/figures/palettes-category.png"), width = 900, height = 1300, res = 100)
show_palettes("category")
dev.off()
cat("Created: man/figures/palettes-category.png\n")

# ============================================================================
# Example 7: Comparison with colorspace::swatchplot
# ============================================================================
if (requireNamespace("colorspace", quietly = TRUE)) {
  # Using colorspace::swatchplot (no hex codes)
  png(here("man/figures/colorspace-comparison.png"), width = 800, height = 200, res = 100)
  colorspace::swatchplot("1895_04" = cheysson_pal("1895_04"))
  dev.off()
  cat("Created: man/figures/colorspace-comparison.png\n")
  cat("\nComparison: colorspace::swatchplot() shows colors but not hex codes.\n")
  cat("Our show_palette() includes hex codes and metadata for better documentation.\n")
}

cat("\n=== Summary ===\n")
cat("The show_palette() and show_palettes() functions provide:\n")
cat("  1. Color swatches with clear borders\n")
cat("  2. Hex codes displayed below each color\n")
cat("  3. Palette metadata (name, type, album, plate, n_colors)\n")
cat("  4. Support for displaying multiple palettes\n")
cat("  5. Support for filtering by palette type\n")
cat("\nThese are ideal for use in README, vignettes, and documentation!\n")
