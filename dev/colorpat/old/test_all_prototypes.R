# Test Script: All Three Prototype Palettes
#
# Demonstrates the three palette types:
#   1. 1883_04 - Diverging (dual encoding)
#   2. 1881_03 - Sequential (monochrome with patterns)
#   3. 1881_04 - Grouped (solid colors only)

library(here)
library(ggplot2)
library(ggpattern)
library(Guerry)
library(sf)
library(dplyr)
library(patchwork)

# Load the prototype
source(here("dev/prototype_colorpat.R"))

# Load Guerry data
data(Guerry)
data(gfrance85)

# Convert to sf and join
france_sf <- st_as_sf(gfrance85)
france_data <- france_sf %>%
  mutate(CODE_DEPT = as.integer(as.character(CODE_DEPT))) %>%
  left_join(Guerry, by = c("CODE_DEPT" = "dept")) %>%
  filter(!is.na(geometry))

cat("\n=== Testing All Three Prototype Palettes ===\n\n")

# ============================================================================
# Palette 1: 1883_04 (Diverging - Dual Encoding)
# ============================================================================

cat("1. Testing 1883_04 (Diverging)...\n")

# Create diverging data (4 categories)
set.seed(123)
france_data <- france_data %>%
  mutate(
    test_value = row_number(),
    test_median = median(test_value),
    test_dev = test_value - test_median,
    diverging_cat = cut(
      test_dev,
      breaks = quantile(test_dev, probs = c(0, 0.25, 0.5, 0.75, 1.0)),
      labels = c("High negative", "Low negative", "Low positive", "High positive"),
      include.lowest = TRUE
    )
  )

scales_1883 <- scale_colorpat_cheysson("1883_04")

p1 <- ggplot(france_data) +
  geom_sf_pattern(
    aes(fill = diverging_cat,
        pattern_type = diverging_cat,
        pattern_fill = diverging_cat),
    pattern = "stripe",
    pattern_angle = 135,
    pattern_density = 0.3,
    pattern_spacing = 0.02,
    color = "black",
    linewidth = 0.3
  ) +
  scales_1883$fill +
  scales_1883$pattern_type +
  scales_1883$pattern_fill +
  labs(
    title = "1883_04: Diverging Palette",
    subtitle = "Dual encoding - Color: direction, Pattern: magnitude",
    fill = "Category"
  ) +
  theme_minimal() +
  theme(legend.position = "bottom") +
  guides(
    pattern_type = "none",
    pattern_fill = "none"
  )

ggsave(
  here("dev/test_1883_04_diverging.png"),
  p1,
  width = 8, height = 8,
  device = ragg::agg_png
)

cat("   Saved: dev/test_1883_04_diverging.png\n\n")

# ============================================================================
# Palette 2: 1881_03 (Sequential - Monochrome with Patterns)
# ============================================================================

cat("2. Testing 1881_03 (Sequential Monochrome)...\n")

# Create sequential data (3 categories)
france_data <- france_data %>%
  mutate(
    seq_cat = cut(
      test_value,
      breaks = quantile(test_value, probs = c(0, 0.33, 0.67, 1.0)),
      labels = c("Low", "Medium", "High"),
      include.lowest = TRUE
    )
  )

scales_1881_03 <- scale_colorpat_cheysson("1881_03")

p2 <- ggplot(france_data) +
  geom_sf_pattern(
    aes(fill = seq_cat,
        pattern_type = seq_cat,
        pattern_fill = seq_cat),
    pattern = "stripe",
    pattern_angle = 135,
    pattern_density = 0.3,
    pattern_spacing = 0.03,
    color = "black",
    linewidth = 0.3
  ) +
  scales_1881_03$fill +
  scales_1881_03$pattern_type +
  scales_1881_03$pattern_fill +
  labs(
    title = "1881_03: Sequential Monochrome",
    subtitle = "Single color (#1e3e69 navy) with pattern density progression",
    fill = "Level"
  ) +
  theme_minimal() +
  theme(legend.position = "bottom") +
  guides(
    pattern_type = "none",
    pattern_fill = "none"
  )

ggsave(
  here("dev/test_1881_03_sequential.png"),
  p2,
  width = 8, height = 8,
  device = ragg::agg_png
)

cat("   Saved: dev/test_1881_03_sequential.png\n\n")

# ============================================================================
# Palette 3: 1881_04 (Grouped - Solid Colors Only)
# ============================================================================

cat("3. Testing 1881_04 (Grouped/Categorical)...\n")

# Create categorical data (4 categories)
france_data <- france_data %>%
  mutate(
    cat_group = cut(
      test_value,
      breaks = quantile(test_value, probs = c(0, 0.25, 0.5, 0.75, 1.0)),
      labels = c("Category A", "Category B", "Category C", "Category D"),
      include.lowest = TRUE
    )
  )

scales_1881_04 <- scale_colorpat_cheysson("1881_04")

p3 <- ggplot(france_data) +
  geom_sf(
    aes(fill = cat_group),
    color = "black",
    linewidth = 0.3
  ) +
  scales_1881_04$fill +
  labs(
    title = "1881_04: Grouped/Categorical",
    subtitle = "Four distinct solid colors - no patterns",
    fill = "Category"
  ) +
  theme_minimal() +
  theme(legend.position = "bottom")

ggsave(
  here("dev/test_1881_04_categorical.png"),
  p3,
  width = 8, height = 8,
  device = ragg::agg_png
)

cat("   Saved: dev/test_1881_04_categorical.png\n\n")

# ============================================================================
# Combined Comparison
# ============================================================================

cat("4. Creating combined comparison...\n")

p_combined <- (p1 / p2 / p3) +
  plot_annotation(
    title = "Three Cheysson Palette Design Patterns",
    subtitle = "Demonstrating the diversity of Cheysson's color-pattern strategies",
    caption = "Top: Dual encoding (color+pattern) | Middle: Monochrome sequential | Bottom: Color-only categorical",
    theme = theme(
      plot.title = element_text(size = 16, face = "bold"),
      plot.subtitle = element_text(size = 12)
    )
  )

ggsave(
  here("dev/test_all_three_palettes.png"),
  p_combined,
  width = 10, height = 18,
  device = ragg::agg_png
)

cat("   Saved: dev/test_all_three_palettes.png\n\n")

# ============================================================================
# Palette Inspection
# ============================================================================

cat("=== Palette Details ===\n\n")

cat("--- 1883_04 (Diverging) ---\n")
pal1 <- cheysson_colorpat("1883_04")
print(pal1)

cat("\n--- 1881_03 (Sequential) ---\n")
pal2 <- cheysson_colorpat("1881_03")
print(pal2)

cat("\n--- 1881_04 (Grouped) ---\n")
pal3 <- cheysson_colorpat("1881_04")
print(pal3)

cat("\n=== Available Palettes ===\n")
print(list_colorpat_palettes())

# ============================================================================
# Design Pattern Summary
# ============================================================================

cat("\n=== Design Pattern Summary ===\n\n")

cat("1. DIVERGING (1883_04):\n")
cat("   - Use case: Data with direction AND magnitude\n")
cat("   - Strategy: Color encodes direction, pattern encodes magnitude\n")
cat("   - Example: Deviation from median (negative vs positive, high vs low)\n")
cat("   - Elements: 4 (2 colors × 2 pattern levels)\n\n")

cat("2. SEQUENTIAL MONOCHROME (1881_03):\n")
cat("   - Use case: Ordered data, economical printing (1 ink)\n")
cat("   - Strategy: Single color with increasing pattern density\n")
cat("   - Example: Low → Medium → High values\n")
cat("   - Elements: 3 (stripe → crosshatch → dense crosshatch)\n\n")

cat("3. CATEGORICAL/GROUPED (1881_04):\n")
cat("   - Use case: Nominal categories with no inherent order\n")
cat("   - Strategy: Distinct colors with high mutual contrast\n")
cat("   - Example: Different regions, types, or groups\n")
cat("   - Elements: 4 (all solid fills, no patterns needed)\n\n")

cat("Key Insight:\n")
cat("Cheysson used DIFFERENT strategies for different data types:\n")
cat("  - Diverging → Dual channel (color + pattern)\n")
cat("  - Sequential → Pattern density progression\n")
cat("  - Categorical → Color distinction only\n\n")

cat("This flexibility is what makes the unified palette system so powerful.\n")
cat("Each palette preserves its original design intent.\n\n")

cat("=== Test Complete ===\n")
cat("Check generated PNG files in dev/\n")
