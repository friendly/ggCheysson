# Test the cheysson_palettes data object
library(here)
library(tidyverse)

# Load the data
load(here("data/cheysson_palettes.rda"))

# Inspect structure
cat("=== Cheysson Palettes ===\n\n")
cat("Number of palettes:", length(cheysson_palettes), "\n\n")

# Show a few examples
cat("Example palettes:\n\n")
for (i in 1:min(5, length(cheysson_palettes))) {
  pal_name <- names(cheysson_palettes)[i]
  pal <- cheysson_palettes[[pal_name]]

  cat(sprintf("%s (%s, Album %s Plate %d):\n",
              pal_name, pal$type, pal$album, pal$plate))
  cat("  Colors:", paste(pal$colors, collapse = ", "), "\n\n")
}

# Summary by type
cat("\n=== By Type ===\n")
for (type in c("sequential", "diverging", "grouped", "category")) {
  type_pals <- names(cheysson_palettes)[map_chr(cheysson_palettes, "type") == type]
  if (length(type_pals) > 0) {
    cat(sprintf("\n%s (%d):\n", tools::toTitleCase(type), length(type_pals)))
    cat("  ", paste(type_pals, collapse = ", "), "\n")
  }
}

# Check color counts
cat("\n\n=== Color Counts ===\n")
color_counts <- map_int(cheysson_palettes, ~length(.x$colors))
print(summary(color_counts))
cat("\nPalettes with most colors:\n")
top_pals <- names(sort(color_counts, decreasing = TRUE)[1:5])
for (pname in top_pals) {
  cat(sprintf("  %s: %d colors\n", pname, length(cheysson_palettes[[pname]]$colors)))
}
