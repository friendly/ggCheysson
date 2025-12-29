# Test ggCheysson pattern functions
library(here)

# Load package
devtools::load_all(here())

cat("=== Testing Pattern Data ===\n\n")

# Test 1: List pattern palettes
cat("Available pattern palettes:\n")
pals <- list_cheysson_patterns()
print(pals)

# Test 2: Get patterns from a specific palette
cat("\n=== Pattern Details ===\n\n")
pat_1881_03 <- cheysson_pattern("1881_03")
cat("1881_03 patterns:\n")
for (i in seq_along(pat_1881_03)) {
  p <- pat_1881_03[[i]]
  cat(sprintf("  [%d] Type: %s, Fill: %s",
              i, p$type, p$fill %||% "none"))
  if (p$type != "solid") {
    cat(sprintf(", Pattern: %s @ %.0f°",
                p$pattern_color %||% "none",
                p$pattern_angle %||% 0))
  }
  cat("\n")
}

# Test 3: Extract pattern parameters
cat("\n=== Pattern Parameters ===\n\n")
fills <- cheysson_pattern_params(pat_1881_03, "fill")
cat("Fills:", paste(fills, collapse = ", "), "\n")

pattern_types <- cheysson_pattern_params(pat_1881_03, "pattern_type")
cat("Pattern types:", paste(pattern_types, collapse = ", "), "\n")

angles <- cheysson_pattern_params(pat_1881_03, "pattern_angle")
cat("Angles:", paste(round(angles), collapse = ", "), "\n")

# Test 4: Check if ggpattern is available
cat("\n=== Checking ggpattern ===\n")
if (requireNamespace("ggpattern", quietly = TRUE)) {
  cat("ggpattern is installed - creating pattern plots\n\n")

  library(ggplot2)
  library(ggpattern)

  # Simple example data
  data <- data.frame(
    category = c("A", "B", "C"),
    value = c(10, 15, 12)
  )

  # Example 1: Basic pattern plot
  cat("Creating pattern bar plot...\n")
  p1 <- ggplot(data, aes(category, value, fill = category)) +
    ggpattern::geom_col_pattern(
      aes(
        pattern_fill = category,
        pattern_type = category,
        pattern_angle = category
      ),
      pattern = "stripe",
      pattern_density = 0.4,
      pattern_spacing = 0.02,
      color = "black",
      size = 0.5
    ) +
    scale_fill_cheysson_pattern("1881_03") +
    scale_pattern_fill_cheysson("1881_03") +
    scale_pattern_type_cheysson("1881_03") +
    scale_pattern_angle_cheysson("1881_03") +
    labs(title = "Cheysson Patterns - 1881 Plate 3",
         subtitle = "Stripes and crosshatching") +
    theme_minimal() +
    theme(legend.position = "bottom")

  ggsave(here("dev/pattern_example1.png"), p1, width = 7, height = 5)
  cat("Saved: dev/pattern_example1.png\n")

  # Example 2: Category palette
  data2 <- data.frame(
    category = LETTERS[1:6],
    value = c(8, 12, 10, 15, 9, 14)
  )

  p2 <- ggplot(data2, aes(category, value, fill = category)) +
    ggpattern::geom_col_pattern(
      aes(
        pattern_fill = category,
        pattern_type = category
      ),
      pattern = "stripe",
      pattern_density = 0.3,
      pattern_spacing = 0.025,
      color = "black",
      size = 0.5
    ) +
    scale_fill_cheysson_pattern("category") +
    scale_pattern_fill_cheysson("category") +
    scale_pattern_type_cheysson("category") +
    labs(title = "Cheysson Patterns - Category Palette",
         subtitle = "Solid fills from category palette") +
    theme_minimal() +
    theme(legend.position = "bottom")

  ggsave(here("dev/pattern_example2.png"), p2, width = 8, height = 5)
  cat("Saved: dev/pattern_example2.png\n")

  # Example 3: Stacked bars
  data3 <- data.frame(
    x = rep(c("Group 1", "Group 2"), each = 3),
    category = rep(c("A", "B", "C"), 2),
    value = c(5, 8, 6, 7, 9, 5)
  )

  p3 <- ggplot(data3, aes(x, value, fill = category)) +
    ggpattern::geom_col_pattern(
      aes(
        pattern_fill = category,
        pattern_type = category,
        pattern_angle = category
      ),
      pattern = "stripe",
      pattern_density = 0.35,
      pattern_spacing = 0.02,
      color = "white",
      size = 0.3
    ) +
    scale_fill_cheysson_pattern("1881_03") +
    scale_pattern_fill_cheysson("1881_03") +
    scale_pattern_type_cheysson("1881_03") +
    scale_pattern_angle_cheysson("1881_03") +
    labs(title = "Stacked Bars with Cheysson Patterns",
         subtitle = "1881 Plate 3 palette") +
    theme_minimal() +
    theme(legend.position = "right")

  ggsave(here("dev/pattern_example3.png"), p3, width = 7, height = 5)
  cat("Saved: dev/pattern_example3.png\n")

  cat("\n✓ Pattern plots created successfully!\n")

} else {
  cat("ggpattern is not installed.\n")
  cat("Install with: install.packages('ggpattern')\n")
  cat("\nCreating simple demonstration without patterns...\n\n")

  library(ggplot2)

  # Show just the colors
  data <- data.frame(
    category = c("A", "B", "C"),
    value = c(10, 15, 12)
  )

  p <- ggplot(data, aes(category, value, fill = category)) +
    geom_col(color = "black", size = 0.5) +
    scale_fill_cheysson("1881_03") +
    labs(title = "Cheysson Colors (without patterns)",
         subtitle = "Install ggpattern for full pattern support") +
    theme_minimal()

  ggsave(here("dev/pattern_colors_only.png"), p, width = 7, height = 5)
  cat("Saved: dev/pattern_colors_only.png\n")
}

cat("\n=== All tests complete! ===\n")
