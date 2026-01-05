# Test ggCheysson package functions
library(ggplot2)
library(here)

# Load package functions
devtools::load_all(here())

# Test 1: List palettes
cat("=== Available Palettes ===\n")
all_pals <- list_cheysson_pals()
print(all_pals)

cat("\n=== Sequential Palettes ===\n")
print(list_cheysson_pals("sequential"))

# Test 2: Get palette colors
cat("\n=== Get Palette Colors ===\n")
cat("1880_07:\n")
print(cheysson_pal("1880_07"))

cat("\nFirst 5 colors from 1880_07:\n")
print(cheysson_pal("1880_07", n = 5))

cat("\nSequential palette (first one):\n")
print(cheysson_pal("sequential"))

# Test 3: Create example plots
cat("\n=== Creating Example Plots ===\n")

# Discrete color scale
p1 <- ggplot(iris, aes(Sepal.Length, Sepal.Width, color = Species)) +
  geom_point(size = 3) +
  scale_color_cheysson() +
  labs(title = "Discrete Color Scale (default palette)") +
  theme_minimal()

ggsave(here("dev/plot1_discrete.png"), p1, width = 7, height = 5)
cat("Saved: dev/plot1_discrete.png\n")

# Different palette
p2 <- ggplot(iris, aes(Sepal.Length, Sepal.Width, color = Species)) +
  geom_point(size = 3) +
  scale_color_cheysson(palette = "1881_04") +
  labs(title = "Discrete Color Scale (1881_04 palette)") +
  theme_minimal()

ggsave(here("dev/plot2_palette.png"), p2, width = 7, height = 5)
cat("Saved: dev/plot2_palette.png\n")

# Fill scale
p3 <- ggplot(iris, aes(Species, Sepal.Width, fill = Species)) +
  geom_boxplot() +
  scale_fill_cheysson(palette = "category") +
  labs(title = "Fill Scale (category palette)") +
  theme_minimal()

ggsave(here("dev/plot3_fill.png"), p3, width = 7, height = 5)
cat("Saved: dev/plot3_fill.png\n")

# Continuous scale
p4 <- ggplot(iris, aes(Sepal.Length, Sepal.Width, color = Petal.Length)) +
  geom_point(size = 3) +
  scale_color_cheysson(palette = "sequential", discrete = FALSE) +
  labs(title = "Continuous Color Scale (sequential palette)") +
  theme_minimal()

ggsave(here("dev/plot4_continuous.png"), p4, width = 7, height = 5)
cat("Saved: dev/plot4_continuous.png\n")

cat("\n=== All tests complete! ===\n")
