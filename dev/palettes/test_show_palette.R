# Test the new show_palette() and show_palettes() functions
library(here)

# Load package
devtools::load_all(here())

# Test 1: Show a single palette with info
png(here("dev/test_show_palette_1.png"), width = 800, height = 200, res = 100)
show_palette("1895_04")
dev.off()
cat("Created: dev/test_show_palette_1.png\n")

# Test 2: Show a single palette without info
png(here("dev/test_show_palette_2.png"), width = 800, height = 200, res = 100)
show_palette("1881_03", show_info = FALSE)
dev.off()
cat("Created: dev/test_show_palette_2.png\n")

# Test 3: Show palette with interpolated colors
png(here("dev/test_show_palette_3.png"), width = 800, height = 200, res = 100)
show_palette("1880_07", n = 10)
dev.off()
cat("Created: dev/test_show_palette_3.png\n")

# Test 4: Show all sequential palettes
png(here("dev/test_show_palettes_sequential.png"), width = 800, height = 1400, res = 100)
show_palettes("sequential")
dev.off()
cat("Created: dev/test_show_palettes_sequential.png\n")

# Test 5: Show specific palettes
png(here("dev/test_show_palettes_multi.png"), width = 800, height = 600, res = 100)
show_palettes(c("1880_07", "1881_03", "1895_04"))
dev.off()
cat("Created: dev/test_show_palettes_multi.png\n")

# Test 6: Show all category palettes
png(here("dev/test_show_palettes_category.png"), width = 800, height = 1200, res = 100)
show_palettes("category")
dev.off()
cat("Created: dev/test_show_palettes_category.png\n")

cat("\nAll tests completed!\n")
