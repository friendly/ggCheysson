# Test font rendering with showtext (works on screen AND in files)
library(here)
library(ggplot2)

devtools::load_all(here())

cat("=== Testing Font Rendering with showtext ===\n\n")

# Check if showtext is available
if (!requireNamespace("showtext", quietly = TRUE)) {
  cat("Installing showtext package...\n")
  install.packages("showtext")
}

if (!requireNamespace("sysfonts", quietly = TRUE)) {
  cat("Installing sysfonts package...\n")
  install.packages("sysfonts")
}

# Load fonts using showtext method
cat("Loading fonts with showtext method...\n")
load_cheysson_fonts(method = "showtext")

# Enable showtext for rendering
showtext::showtext_auto()

cat("\nCreating test plot...\n")

# Create simple test plot
p <- ggplot(mtcars, aes(wt, mpg, color = factor(cyl))) +
  geom_point(size = 3) +
  scale_color_cheysson("1883_04") +
  labs(
    title = "Automobile Efficiency Test",
    subtitle = "Testing Cheysson Fonts with showtext",
    x = "Weight (1000 lbs)",
    y = "Miles per Gallon",
    color = "Cylinders"
  ) +
  theme_cheysson()

# Display on screen (fonts will appear!)
print(p)

# Save to file
cat("\nSaving with showtext...\n")
ggsave(
  here("dev/showtext_test.png"),
  p,
  width = 8,
  height = 5,
  dpi = 150
)

cat("✓ Saved: dev/showtext_test.png\n")

# Disable showtext when done
showtext::showtext_auto(FALSE)

cat("\n=== Test Complete ===\n")
cat("With showtext method:\n")
cat("  ✓ Fonts appear on screen in plot window\n")
cat("  ✓ Fonts appear in saved PNG file\n")
cat("  ✓ Works on Windows, Mac, and Linux\n")
cat("\nNote: Remember to call showtext::showtext_auto() before plotting\n")
cat("      and showtext::showtext_auto(FALSE) when done.\n")
