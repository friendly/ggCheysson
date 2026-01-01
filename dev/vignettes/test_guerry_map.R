# Quick test of Guerry maps functionality
library(here)
library(ggplot2)
library(ggCheysson)

cat("=== Testing Guerry Maps Functionality ===\n\n")

# Check required packages
if (!requireNamespace("Guerry", quietly = TRUE)) {
  cat("Installing Guerry package...\n")
  install.packages("Guerry")
}

if (!requireNamespace("sf", quietly = TRUE)) {
  cat("Installing sf package...\n")
  install.packages("sf")
}

library(Guerry)
library(sf)

cat("Loading package...\n")
devtools::load_all(here())

cat("\nLoading Guerry data...\n")
data(Guerry)
data(gfrance85)

cat("Departments in dataset:", nrow(Guerry), "\n")
cat("Available variables:", paste(names(Guerry)[1:10], collapse = ", "), "...\n")

cat("\nConverting map to sf object...\n")
france_sf <- st_as_sf(gfrance85)
cat("Map has", nrow(france_sf), "polygons\n")

cat("\nCreating ranked data...\n")
Guerry$Crime_pers_rank <- rank(Guerry$Crime_pers)

cat("\nJoining data...\n")
france_data <- merge(france_sf, Guerry, by = "Department", all.x = TRUE)
cat("Successful matches:", sum(!is.na(france_data$Crime_pers)), "\n")

cat("\nLoading fonts...\n")
load_cheysson_fonts(method = "showtext")
showtext::showtext_auto()

cat("\nCreating test map...\n")
# Use 1880_07 which is a category palette with 7 colors
# Works well with discrete=FALSE to create a gradient
p <- ggplot(france_data) +
  geom_sf(aes(fill = Crime_pers_rank), color = "black", linewidth = 0.3) +
  scale_fill_cheysson("1880_07", discrete = FALSE, name = "Rank") +
  labs(
    title = "Test: Crimes Against Persons",
    subtitle = "France, 1830s (ranked by department)",
    caption = "Data: André-Michel Guerry (1833)"
  ) +
  theme_cheysson_map()

print(p)

# Save test
cat("\nSaving test map...\n")
if (requireNamespace("ragg", quietly = TRUE)) {
  ggsave(here("dev/guerry_test.png"), p,
         width = 8, height = 7, dpi = 150,
         device = ragg::agg_png)
} else {
  ggsave(here("dev/guerry_test.png"), p,
         width = 8, height = 7, dpi = 150)
}

cat("\n✓ Test complete!\n")
cat("Check dev/guerry_test.png to see the result.\n\n")

cat("All functionality working! The vignette should render correctly.\n")

showtext::showtext_auto(FALSE)
