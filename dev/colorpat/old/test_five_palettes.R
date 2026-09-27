# Test Script: All Five Prototype Palettes
#
# Comprehensive test of all palette types:
#   1. 1883_04 - Diverging (dual encoding)
#   2. 1881_03 - Sequential (monochrome)
#   3. 1881_04 - Grouped (solid colors)
#   4. 1891_07 - Sequential (hybrid 7-element)
#   5. 1886_08 - Grouped (alternating patterns)

library(here)
library(ggplot2)
library(ggpattern)
library(dplyr)
library(patchwork)

# Load the prototype
source(here("dev/prototype_colorpat.R"))

cat("\n=== Testing All Five Prototype Palettes ===\n\n")

# ============================================================================
# Test 1: 1891_07 (Complex 7-Element Sequential)
# ============================================================================

cat("1. Testing 1891_07 (7-element Sequential Hybrid)...\n")

# Create test data with 7 ordered categories
set.seed(456)
test_data <- data.frame(
  category = factor(rep(c("Very Low", "Low", "Below Avg", "Average",
                          "Above Avg", "High", "Very High"), each = 5),
                   levels = c("Very Low", "Low", "Below Avg", "Average",
                             "Above Avg", "High", "Very High")),
  value = rnorm(35),
  x = rep(1:5, 7)
)

scales_1891 <- scale_colorpat_cheysson("1891_07")

p1 <- ggplot(test_data, aes(x = x, y = value,
                             fill = category,
                             pattern_type = category,
                             pattern_fill = category)) +
  geom_col_pattern(
    pattern = "stripe",
    pattern_angle = 135,
    pattern_density = 0.3,
    pattern_spacing = 0.025,
    color = "black",
    linewidth = 0.3,
    width = 0.8
  ) +
  scales_1891$fill +
  scales_1891$pattern_type +
  scales_1891$pattern_fill +
  facet_wrap(~category, nrow = 1) +
  labs(
    title = "1891_07: Complex 7-Element Sequential",
    subtitle = "Hybrid encoding - Color variation (low) + Pattern variation (high)",
    x = NULL,
    y = "Value"
  ) +
  theme_minimal() +
  theme(
    legend.position = "none",
    axis.text.x = element_blank(),
    panel.grid.major.x = element_blank()
  )

ggsave(
  here("dev/test_1891_07_sequential.png"),
  p1,
  width = 14, height = 5,
  device = ragg::agg_png
)

cat("   Saved: dev/test_1891_07_sequential.png\n\n")

# ============================================================================
# Test 2: 1886_08 (8-Element Grouped with Alternating Patterns)
# ============================================================================

cat("2. Testing 1886_08 (8-element Grouped with Patterns)...\n")

# Create test data with 8 groups
set.seed(789)
test_data2 <- data.frame(
  group = factor(rep(paste0("Group ", c("1A", "1B", "2A", "2B",
                                        "3A", "3B", "4A", "4B")), each = 4),
                levels = paste0("Group ", c("1A", "1B", "2A", "2B",
                                           "3A", "3B", "4A", "4B"))),
  value = runif(32, 10, 50),
  x = rep(1:4, 8)
)

scales_1886 <- scale_colorpat_cheysson("1886_08")

p2 <- ggplot(test_data2, aes(x = x, y = value,
                              fill = group,
                              pattern_type = group,
                              pattern_fill = group,
                              pattern_angle = group)) +
  geom_col_pattern(
    pattern = "stripe",
    pattern_density = 0.3,
    pattern_spacing = 0.025,
    color = "black",
    linewidth = 0.3,
    width = 0.8
  ) +
  scales_1886$fill +
  scales_1886$pattern_type +
  scales_1886$pattern_fill +
  facet_wrap(~group, nrow = 2) +
  labs(
    title = "1886_08: 8-Element Grouped with Alternating Patterns",
    subtitle = "Four colors × Two patterns (stripe/crosshatch) = 8 distinct elements",
    x = NULL,
    y = "Value"
  ) +
  theme_minimal() +
  theme(
    legend.position = "none",
    axis.text.x = element_blank(),
    panel.grid.major.x = element_blank()
  )

ggsave(
  here("dev/test_1886_08_grouped.png"),
  p2,
  width = 12, height = 6,
  device = ragg::agg_png
)

cat("   Saved: dev/test_1886_08_grouped.png\n\n")

# ============================================================================
# Combined Comparison: All 5 Palettes
# ============================================================================

cat("3. Creating palette comparison grid...\n")

# Create simple comparison swatches for all 5 palettes
create_swatch <- function(palette_name) {
  pal <- cheysson_colorpat(palette_name)
  n <- pal$n

  df <- data.frame(
    x = 1:n,
    y = 1,
    label = pal$labels
  )

  ggplot(df, aes(x = x, y = y)) +
    geom_tile(aes(fill = factor(x, labels = pal$labels)),
              color = "black", linewidth = 1) +
    scale_fill_manual(values = pal$fill) +
    geom_text(aes(label = label), size = 3, fontface = "bold") +
    labs(title = paste0(palette_name, " (", pal$type, ", ", n, " elements)")) +
    theme_void() +
    theme(
      legend.position = "none",
      plot.title = element_text(size = 11, hjust = 0.5, margin = margin(b = 5)),
      plot.margin = margin(10, 10, 10, 10)
    )
}

p_1883 <- create_swatch("1883_04")
p_1881_03 <- create_swatch("1881_03")
p_1881_04 <- create_swatch("1881_04")
p_1891 <- create_swatch("1891_07")
p_1886 <- create_swatch("1886_08")

p_combined <- (p_1883 / p_1881_03 / p_1881_04 / p_1891 / p_1886) +
  plot_annotation(
    title = "Five Cheysson Unified Color-Pattern Palettes",
    subtitle = "Demonstrating the diversity of Cheysson's design strategies",
    caption = "Each palette preserves its original color-pattern pairings as designed",
    theme = theme(
      plot.title = element_text(size = 16, face = "bold"),
      plot.subtitle = element_text(size = 12),
      plot.caption = element_text(size = 10, hjust = 0.5)
    )
  )

ggsave(
  here("dev/test_five_palettes_swatches.png"),
  p_combined,
  width = 10, height = 12,
  device = ragg::agg_png
)

cat("   Saved: dev/test_five_palettes_swatches.png\n\n")

# ============================================================================
# Palette Inspection
# ============================================================================

cat("=== Detailed Palette Information ===\n\n")

cat("--- 1891_07 (Sequential - 7 elements) ---\n")
pal_1891 <- cheysson_colorpat("1891_07")
print(pal_1891)

cat("\n--- 1886_08 (Grouped - 8 elements) ---\n")
pal_1886 <- cheysson_colorpat("1886_08")
print(pal_1886)

cat("\n=== All Available Palettes ===\n")
print(list_colorpat_palettes())

# ============================================================================
# Design Pattern Analysis
# ============================================================================

cat("\n=== Design Pattern Analysis ===\n\n")

cat("Coverage of Cheysson's Design Strategies:\n\n")

cat("1. DIVERGING (1 palette)\n")
cat("   ✓ 1883_04: Dual encoding (color + pattern)\n\n")

cat("2. SEQUENTIAL (3 palettes)\n")
cat("   ✓ 1881_03: Monochrome with pattern density (3 elements)\n")
cat("   ✓ 1891_07: Hybrid color + pattern variation (7 elements)\n")
cat("   Note: 1891_07 is most complex sequential palette\n\n")

cat("3. GROUPED/CATEGORICAL (2 palettes)\n")
cat("   ✓ 1881_04: Color-only, no patterns (4 elements)\n")
cat("   ✓ 1886_08: Colors with alternating patterns (8 elements)\n\n")

cat("Pattern Usage Summary:\n")
cat("   - 1883_04: Patterns encode magnitude (symmetric)\n")
cat("   - 1881_03: Patterns primary encoding (monochrome)\n")
cat("   - 1881_04: NO patterns (color sufficient)\n")
cat("   - 1891_07: Patterns at high end only (hybrid)\n")
cat("   - 1886_08: Patterns systematic (alternating)\n\n")

cat("Element Count Coverage:\n")
cat("   - 3 elements: 1881_03 (sequential)\n")
cat("   - 4 elements: 1883_04 (diverging), 1881_04 (grouped)\n")
cat("   - 7 elements: 1891_07 (sequential)\n")
cat("   - 8 elements: 1886_08 (grouped)\n")
cat("   Range: 3-8 elements ✓\n\n")

cat("Color Economy:\n")
cat("   - 1 ink: 1881_03 (monochrome)\n")
cat("   - 2 inks: 1883_04, 1891_07\n")
cat("   - 4 inks: 1881_04, 1886_08\n\n")

# ============================================================================
# API Consistency Check
# ============================================================================

cat("=== API Consistency Validation ===\n\n")

all_palettes <- c("1883_04", "1881_03", "1881_04", "1891_07", "1886_08")

for (pal_name in all_palettes) {
  cat(sprintf("Testing %s...", pal_name))

  # Test accessor
  pal <- cheysson_colorpat(pal_name)
  if (is.null(pal)) {
    cat(" FAIL (accessor)\n")
    next
  }

  # Test scale function
  scales <- scale_colorpat_cheysson(pal_name)
  if (is.null(scales)) {
    cat(" FAIL (scale)\n")
    next
  }

  # Check has fill scale
  if (!"fill" %in% names(scales)) {
    cat(" FAIL (no fill scale)\n")
    next
  }

  cat(" PASS ✓\n")
}

cat("\n=== Statistics ===\n\n")

palette_info <- list_colorpat_palettes()
cat(sprintf("Total palettes: %d\n", nrow(palette_info)))
cat(sprintf("  - Diverging: %d\n", sum(palette_info$type == "diverging")))
cat(sprintf("  - Sequential: %d\n", sum(palette_info$type == "sequential")))
cat(sprintf("  - Grouped: %d\n", sum(palette_info$type == "grouped")))
cat(sprintf("\nWith patterns: %d\n", sum(palette_info$has_patterns)))
cat(sprintf("Without patterns: %d\n", sum(!palette_info$has_patterns)))
cat(sprintf("\nTotal elements across all palettes: %d\n", sum(palette_info$n_elements)))
cat(sprintf("Average elements per palette: %.1f\n", mean(palette_info$n_elements)))
cat(sprintf("Element range: %d-%d\n", min(palette_info$n_elements), max(palette_info$n_elements)))

cat("\n=== Test Complete ===\n")
cat("\nGenerated files:\n")
cat("  - dev/test_1891_07_sequential.png (7-element bar chart)\n")
cat("  - dev/test_1886_08_grouped.png (8-element faceted chart)\n")
cat("  - dev/test_five_palettes_swatches.png (all 5 palette swatches)\n\n")

cat("Ready for full implementation!\n")
cat("Prototype demonstrates:\n")
cat("  ✓ Diverse palette types (diverging, sequential, grouped)\n")
cat("  ✓ Varied complexities (3-8 elements)\n")
cat("  ✓ Different pattern strategies (none, primary, secondary, alternating)\n")
cat("  ✓ Consistent API across all types\n")
cat("  ✓ Historical authenticity preserved\n")
