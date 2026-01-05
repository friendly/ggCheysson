# Visualize all Cheysson palettes
library(ggplot2)
library(here)
library(purrr)
library(dplyr)

# Load package
devtools::load_all(here())

# Function to display a single palette
show_palette <- function(colors, name, type) {
  n <- length(colors)
  data.frame(
    x = 1:n,
    y = 1,
    color = colors,
    name = name,
    type = type
  )
}

# Create data for all palettes
palette_data <- map2_dfr(
  names(cheysson_palettes),
  cheysson_palettes,
  function(name, pal) {
    show_palette(pal$colors, name, pal$type)
  }
)

# Create the visualization
p <- ggplot(palette_data, aes(x = x, y = name, fill = color)) +
  geom_tile(color = "white", linewidth = 0.5) +
  scale_fill_identity() +
  facet_wrap(~type, ncol = 1, scales = "free_y") +
  labs(
    title = "Cheysson Color Palettes",
    subtitle = "From the Albums de Statistique Graphique",
    x = NULL,
    y = NULL
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_blank(),
    axis.ticks = element_blank(),
    panel.grid = element_blank(),
    strip.text = element_text(face = "bold", hjust = 0, size = 12)
  )

ggsave(here("dev/all_palettes.png"), p, width = 10, height = 12, dpi = 150)
cat("Saved: dev/all_palettes.png\n")

# Create a more compact version showing just the colors
palette_info <- list_cheysson_pals() %>%
  arrange(type, name)

# Print summary
cat("\n=== Palette Summary ===\n")
for (type in c("category", "diverging", "grouped", "sequential")) {
  type_pals <- palette_info %>% filter(type == .env$type)
  cat(sprintf("\n%s (%d palettes):\n", toupper(type), nrow(type_pals)))
  for (i in 1:nrow(type_pals)) {
    row <- type_pals[i, ]
    colors <- cheysson_pal(row$name)
    cat(sprintf("  %s: %s\n", row$name, paste(colors, collapse = " ")))
  }
}
