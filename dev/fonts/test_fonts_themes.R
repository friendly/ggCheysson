# Test Cheysson fonts and themes
library(here)
library(ggplot2)

# Load package
devtools::load_all(here())

cat("=== Testing Cheysson Fonts ===\n\n")

# Test 1: List available fonts
cat("Available Cheysson fonts:\n")
print(list_cheysson_fonts())

# Test 2: Load fonts
cat("\n=== Loading Fonts ===\n")
loaded <- load_cheysson_fonts()
cat("Loaded fonts:", paste(loaded, collapse = ", "), "\n")

# Test 3: Check availability
cat("\n=== Checking Font Availability ===\n")
available <- cheysson_fonts_available()
cat("Fonts available:", available, "\n")

if (!available) {
  cat("\nFonts not loaded. Some plots may use fallback fonts.\n")
}

# Test 4: Get font names
cat("\n=== Font Name Helpers ===\n")
cat("Regular:", cheysson_font("regular"), "\n")
cat("Title:", cheysson_font("title"), "\n")
cat("Sans caps:", cheysson_font("sans"), "\n")

# Create example data
data <- data.frame(
  x = 1:10,
  y = rnorm(10, 10, 2),
  category = rep(c("A", "B"), each = 5)
)

cat("\n=== Creating Example Plots ===\n")

# Plot 1: Basic theme_cheysson
p1 <- ggplot(iris, aes(Sepal.Length, Sepal.Width, color = Species)) +
  geom_point(size = 3, alpha = 0.7) +
  labs(
    title = "Iris Dataset Analysis",
    subtitle = "Sepal dimensions by species",
    x = "Sepal Length (cm)",
    y = "Sepal Width (cm)"
  ) +
  scale_color_cheysson("1881_04") +
  theme_cheysson()

ggsave(here("dev/font_test1_theme.png"), p1, width = 8, height = 6, dpi = 150)
cat("Saved: dev/font_test1_theme.png\n")

# Plot 2: Minimal theme with different font
p2 <- ggplot(mtcars, aes(wt, mpg)) +
  geom_point(aes(color = factor(cyl)), size = 3) +
  geom_smooth(method = "lm", se = FALSE, color = "grey40", linetype = "dashed") +
  labs(
    title = "Automobile Efficiency",
    subtitle = "Weight vs Fuel Economy",
    x = "Weight (1000 lbs)",
    y = "Miles per Gallon",
    color = "Cylinders"
  ) +
  scale_color_cheysson("category") +
  theme_cheysson_minimal()

ggsave(here("dev/font_test2_minimal.png"), p2, width = 8, height = 6, dpi = 150)
cat("Saved: dev/font_test2_minimal.png\n")

# Plot 3: Bar chart with patterns and fonts
if (requireNamespace("ggpattern", quietly = TRUE)) {
  library(ggpattern)

  bar_data <- data.frame(
    category = LETTERS[1:4],
    value = c(15, 23, 18, 20)
  )

  p3 <- ggplot(bar_data, aes(category, value, fill = category)) +
    geom_col_pattern(
      aes(pattern_type = category, pattern_fill = category),
      pattern = "stripe",
      pattern_density = 0.35,
      pattern_spacing = 0.025,
      color = "black",
      linewidth = 0.5
    ) +
    scale_fill_cheysson_pattern("1881_03") +
    scale_pattern_fill_cheysson("1881_03") +
    scale_pattern_type_cheysson("1881_03") +
    labs(
      title = "Statistical Comparison",
      subtitle = "Values across categories",
      x = "Category",
      y = "Value"
    ) +
    theme_cheysson() +
    theme(legend.position = "none")

  ggsave(here("dev/font_test3_patterns.png"), p3, width = 7, height = 5, dpi = 150)
  cat("Saved: dev/font_test3_patterns.png\n")
}

# Plot 4: Faceted plot
p4 <- ggplot(iris, aes(Petal.Length, Petal.Width)) +
  geom_point(aes(color = Species), size = 2, alpha = 0.7) +
  facet_wrap(~Species, ncol = 3) +
  labs(
    title = "Petal Dimensions by Species",
    subtitle = "Iris dataset - faceted view",
    x = "Petal Length (cm)",
    y = "Petal Width (cm)"
  ) +
  scale_color_cheysson("1881_04") +
  theme_cheysson() +
  theme(legend.position = "bottom")

ggsave(here("dev/font_test4_faceted.png"), p4, width = 10, height = 4, dpi = 150)
cat("Saved: dev/font_test4_faceted.png\n")

# Plot 5: Time series style
set.seed(123)
ts_data <- data.frame(
  year = 1880:1910,
  value1 = cumsum(rnorm(31, 5, 10)) + 100,
  value2 = cumsum(rnorm(31, 3, 8)) + 80
)

ts_long <- tidyr::pivot_longer(ts_data, cols = c(value1, value2),
                               names_to = "series", values_to = "value")

p5 <- ggplot(ts_long, aes(year, value, color = series)) +
  geom_line(linewidth = 1.2) +
  geom_point(size = 2) +
  labs(
    title = "Historical Trends",
    subtitle = "Statistical data from 1880-1910",
    x = "Year",
    y = "Value",
    color = "Series"
  ) +
  scale_color_cheysson("1883_04") +
  theme_cheysson_minimal()

ggsave(here("dev/font_test5_timeseries.png"), p5, width = 9, height = 5, dpi = 150)
cat("Saved: dev/font_test5_timeseries.png\n")

# Plot 6: Show all fonts
font_demo <- data.frame(
  x = 1,
  y = 5:1,
  font = c("Cheysson", "CheyssonItalic", "CheyssonSansCaps",
           "CheyssonOutlineCaps", "CheyssonTitle"),
  label = c(
    "The quick brown fox jumps over the lazy dog (Regular)",
    "The quick brown fox jumps over the lazy dog (Italic)",
    "THE QUICK BROWN FOX (Sans Caps)",
    "THE QUICK BROWN FOX (Outline Caps)",
    "The Quick Brown Fox (Title)"
  )
)

p6 <- ggplot(font_demo, aes(x, y, label = label)) +
  geom_text(aes(family = font), hjust = 0, size = 5) +
  xlim(0.5, 10) +
  labs(title = "Cheysson Font Family Specimens") +
  theme_void() +
  theme(
    plot.title = element_text(
      family = "CheyssonTitle",
      size = 18,
      hjust = 0.5,
      margin = margin(b = 20)
    ),
    plot.background = element_rect(fill = "white", color = NA),
    plot.margin = margin(20, 20, 20, 20)
  )

ggsave(here("dev/font_test6_specimens.png"), p6, width = 10, height = 6, dpi = 150)
cat("Saved: dev/font_test6_specimens.png\n")

cat("\n=== All font tests complete! ===\n")

# Show system info
cat("\nSystem Information:\n")
cat("Platform:", R.version$platform, "\n")
cat("R version:", R.version$version.string, "\n")
if (requireNamespace("systemfonts", quietly = TRUE)) {
  cat("systemfonts version:", as.character(packageVersion("systemfonts")), "\n")
}
if (requireNamespace("showtext", quietly = TRUE)) {
  cat("showtext version:", as.character(packageVersion("showtext")), "\n")
}
