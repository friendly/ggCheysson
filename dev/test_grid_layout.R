# Test 2x2 grid layout for README example
library(here)
devtools::load_all(here())

# Create 2x2 grid of four palettes
png(here("man/figures/palette-grid-2x2.png"), width = 1000, height = 400, res = 100)
show_palettes(c("1880_07", "1881_03", "1895_04", "1906_06"), ncol = 2)
dev.off()

cat("Created: man/figures/palette-grid-2x2.png\n")
cat("This shows four different Cheysson palettes in a 2x2 array layout.\n")
