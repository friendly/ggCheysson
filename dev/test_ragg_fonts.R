# Test font rendering with ragg device
library(here)
library(ggplot2)

devtools::load_all(here())

cat("=== Testing Font Rendering with ragg ===\n\n")

# Load fonts
load_cheysson_fonts()

# Check if ragg is available
if (!requireNamespace("ragg", quietly = TRUE)) {
  cat("Installing ragg package...\n")
  install.packages("ragg")
}

# Create simple test plot
p <- ggplot(mtcars, aes(wt, mpg, color = factor(cyl))) +
  geom_point(size = 3) +
  scale_color_cheysson("1883_04") +
  labs(
    title = "Automobile Efficiency Test",
    subtitle = "Testing Cheysson Fonts with ragg",
    x = "Weight (1000 lbs)",
    y = "Miles per Gallon"
  ) +
  theme_cheysson()
p


# Save with ragg device
cat("\nSaving with ragg device...\n")
ggsave(
  here("dev/ragg_test.png"),
  p,
  width = 8,
  height = 5,
  dpi = 150,
  device = ragg::agg_png
)

cat("✓ Saved: dev/ragg_test.png\n")
cat("\nCheck the saved image to verify fonts are rendering correctly.\n")
cat("You should see:\n")
cat("  - Title in CheyssonTitle font\n")
cat("  - Axis labels in CheyssonSansCaps font\n")
cat("  - Other text in Cheysson font\n")
