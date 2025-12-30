# Test font loading and registry
library(here)

devtools::load_all(here())

cat("=== Testing Font Loading ===\n\n")

# Load fonts
cat("Loading fonts...\n")
load_cheysson_fonts()

cat("\n--- Checking systemfonts registry ---\n")
reg <- systemfonts::registry_fonts()
chey <- reg[grepl("Cheysson", reg$family),]
print(chey)

cat("\n--- Testing font availability ---\n")
available <- cheysson_fonts_available()
cat("Fonts available:", available, "\n")

cat("\n--- Creating simple test plot ---\n")
library(ggplot2)

p <- ggplot(mtcars, aes(wt, mpg)) +
  geom_point() +
  labs(title = "Test Plot") +
  theme_minimal() +
  theme(
    plot.title = element_text(family = "Cheysson", size = 16)
  )

ggsave(here("dev/font_test.png"), p, width = 6, height = 4, dpi = 100)
cat("Saved test plot to dev/font_test.png\n")
