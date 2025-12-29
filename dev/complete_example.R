# Complete ggCheysson Example
# Demonstrates colors, patterns, fonts, and theme together

library(ggplot2)
library(ggpattern)
library(here)

# Load package
devtools::load_all(here())

cat("=== Complete Cheysson Aesthetic Demo ===\n\n")

# Load fonts
cat("Loading Cheysson fonts...\n")
load_cheysson_fonts()

# Example 1: Bar chart with all elements
cat("\n1. Creating bar chart with patterns, colors, and fonts...\n")

trade_data <- data.frame(
  country = c("France", "England", "Germany", "Italy", "Spain", "Belgium"),
  tonnage = c(2350, 3120, 2680, 1890, 1560, 1240)
)

p1 <- ggplot(trade_data, aes(reorder(country, tonnage), tonnage, fill = country)) +
  geom_col_pattern(
    aes(pattern_type = country, pattern_fill = country),
    pattern = "stripe",
    pattern_density = 0.3,
    pattern_spacing = 0.025,
    color = "black",
    linewidth = 0.7
  ) +
  scale_fill_cheysson_pattern("category") +
  scale_pattern_fill_cheysson("category") +
  scale_pattern_type_cheysson("category") +
  labs(
    title = "Maritime Commerce Statistics",
    subtitle = "Annual Tonnage by Nation (1885)",
    x = NULL,
    y = "Tonnage (thousands of tons)"
  ) +
  theme_cheysson() +
  theme(
    legend.position = "none",
    axis.text.x = element_text(angle = 45, hjust = 1)
  )

ggsave(here("dev/complete_example1.png"), p1, width = 9, height = 6, dpi = 150)
cat("Saved: dev/complete_example1.png\n")

# Example 2: Time series with Cheysson aesthetic
cat("\n2. Creating time series plot...\n")

years <- 1880:1900
railway_data <- data.frame(
  year = rep(years, 3),
  type = rep(c("Passengers", "Freight", "Express"), each = length(years)),
  value = c(
    cumsum(rnorm(length(years), 50, 20)) + 1000,
    cumsum(rnorm(length(years), 40, 15)) + 800,
    cumsum(rnorm(length(years), 20, 10)) + 300
  )
)

p2 <- ggplot(railway_data, aes(year, value, color = type, linetype = type)) +
  geom_line(linewidth = 1.2) +
  geom_point(size = 2.5) +
  scale_color_cheysson("1883_04") +
  scale_linetype_manual(values = c("solid", "dashed", "dotted")) +
  labs(
    title = "Railway Traffic Development",
    subtitle = "Transportation Volume Index (1880-1900)",
    x = "Year",
    y = "Volume Index",
    color = "Type",
    linetype = "Type"
  ) +
  theme_cheysson_minimal() +
  theme(legend.position = c(0.15, 0.85))

ggsave(here("dev/complete_example2.png"), p2, width = 10, height = 6, dpi = 150)
cat("Saved: dev/complete_example2.png\n")

# Example 3: Stacked area chart
cat("\n3. Creating stacked area chart...\n")

industry_data <- data.frame(
  year = rep(1880:1895, 4),
  sector = rep(c("Manufacturing", "Mining", "Agriculture", "Services"), each = 16),
  value = c(
    seq(100, 180, length.out = 16) + rnorm(16, 0, 5),
    seq(80, 140, length.out = 16) + rnorm(16, 0, 5),
    seq(200, 180, length.out = 16) + rnorm(16, 0, 5),
    seq(60, 120, length.out = 16) + rnorm(16, 0, 5)
  )
)

p3 <- ggplot(industry_data, aes(year, value, fill = sector)) +
  geom_area(alpha = 0.8, color = "black", linewidth = 0.3) +
  scale_fill_cheysson("1881_04") +
  labs(
    title = "Industrial Production by Sector",
    subtitle = "Economic Output Distribution (1880-1895)",
    x = "Year",
    y = "Production Value",
    fill = "Sector"
  ) +
  theme_cheysson() +
  theme(legend.position = "bottom")

ggsave(here("dev/complete_example3.png"), p3, width = 9, height = 6, dpi = 150)
cat("Saved: dev/complete_example3.png\n")

# Example 4: Grouped bar chart with patterns
cat("\n4. Creating grouped comparison...\n")

comparison_data <- data.frame(
  region = rep(c("North", "South", "East", "West"), each = 3),
  category = rep(c("Rail", "Canal", "Road"), 4),
  value = c(
    45, 30, 25,  # North
    35, 40, 25,  # South
    50, 20, 30,  # East
    40, 35, 25   # West
  )
)

p4 <- ggplot(comparison_data, aes(region, value, fill = category)) +
  geom_col_pattern(
    aes(pattern_type = category, pattern_fill = category),
    pattern = "stripe",
    position = "dodge",
    pattern_density = 0.35,
    pattern_spacing = 0.02,
    color = "black",
    linewidth = 0.5
  ) +
  scale_fill_cheysson_pattern("1881_03") +
  scale_pattern_fill_cheysson("1881_03") +
  scale_pattern_type_cheysson("1881_03") +
  labs(
    title = "Transportation Network Comparison",
    subtitle = "Infrastructure Development by Region",
    x = "Region",
    y = "Network Extent (km × 100)",
    fill = "Type",
    pattern_type = "Type",
    pattern_fill = "Type"
  ) +
  theme_cheysson() +
  theme(legend.position = "right")

ggsave(here("dev/complete_example4.png"), p4, width = 10, height = 6, dpi = 150)
cat("Saved: dev/complete_example4.png\n")

# Example 5: Small multiples
cat("\n5. Creating faceted comparison...\n")

set.seed(42)
regional_data <- data.frame(
  region = rep(c("Paris", "Lyon", "Marseille", "Bordeaux"), each = 20),
  year = rep(1880:1899, 4),
  value = c(
    seq(100, 250, length.out = 20) + rnorm(20, 0, 15),
    seq(60, 160, length.out = 20) + rnorm(20, 0, 10),
    seq(50, 140, length.out = 20) + rnorm(20, 0, 12),
    seq(40, 120, length.out = 20) + rnorm(20, 0, 8)
  )
)

p5 <- ggplot(regional_data, aes(year, value)) +
  geom_area(fill = "#d18781", alpha = 0.6, color = "#d18781", linewidth = 1) +
  geom_line(color = "#7c9a77", linewidth = 1.2) +
  facet_wrap(~region, ncol = 2) +
  labs(
    title = "Regional Economic Development",
    subtitle = "Growth Trajectories of Major French Cities (1880-1899)",
    x = "Year",
    y = "Economic Index"
  ) +
  theme_cheysson() +
  theme(
    strip.background = element_rect(fill = "#edd493", color = "black"),
    strip.text = element_text(family = "CheyssonSansCaps", size = 11)
  )

ggsave(here("dev/complete_example5.png"), p5, width = 10, height = 7, dpi = 150)
cat("Saved: dev/complete_example5.png\n")

cat("\n=== All examples complete! ===\n")
cat("\nThe ggCheysson package provides a complete aesthetic system:\n")
cat("  ✓ Authentic Cheysson fonts (5 families)\n")
cat("  ✓ Historical color palettes (20 palettes)\n")
cat("  ✓ Hatching patterns (83 specifications)\n")
cat("  ✓ Period-appropriate themes\n")
cat("\nYour plots now capture the spirit of the Golden Age of Statistical Graphics!\n")
