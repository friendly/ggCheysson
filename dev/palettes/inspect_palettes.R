# Inspect extracted palettes
library(here)
library(tidyverse)

# Load the palette list
load(here("dev/palette_list.RData"))

# Print first few palettes to inspect
cat("=== Sample Palettes ===\n\n")

for (i in 1:5) {
  pal_name <- names(palette_list)[i]
  pal <- palette_list[[pal_name]]

  cat(sprintf("%s (%s, %s):\n", pal_name, pal$album, pal$type))
  cat("  Colors:", paste(pal$colors, collapse = ", "), "\n\n")
}

# Show palettes by type
cat("\n=== Palettes by Type ===\n\n")

palette_types <- map_chr(palette_list, "type")

for (type in unique(palette_types)) {
  cat(sprintf("%s palettes:\n", type))
  type_palettes <- names(palette_list)[palette_types == type]
  for (pname in type_palettes) {
    pal <- palette_list[[pname]]
    cat(sprintf("  %s (%s): %d colors\n", pname, pal$album, pal$n_colors))
  }
  cat("\n")
}
