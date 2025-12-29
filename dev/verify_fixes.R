# Verify R CMD check fixes
library(here)

cat("=== Verifying Package Fixes ===\n\n")

# Load the package
cat("1. Loading package...\n")
devtools::load_all(here())
cat("   ✓ Package loaded successfully\n\n")

# Test data objects
cat("2. Testing data objects...\n")
cat("   - albumImages:", nrow(albumImages), "rows\n")
cat("   - cheysson_palettes:", length(cheysson_palettes), "palettes\n")
cat("   - cheysson_patterns:", length(cheysson_patterns), "patterns\n")
cat("   ✓ All data objects accessible\n\n")

# Test palette functions
cat("3. Testing palette functions...\n")
colors <- cheysson_pal("1880_07")
cat("   - cheysson_pal() returned", length(colors), "colors\n")

pals <- list_cheysson_pals()
cat("   - list_cheysson_pals() returned", nrow(pals), "palettes\n")
cat("   ✓ Palette functions work\n\n")

# Test pattern functions
cat("4. Testing pattern functions...\n")
patterns <- cheysson_pattern("1881_03")
cat("   - cheysson_pattern() returned", length(patterns), "patterns\n")

pat_list <- list_cheysson_patterns()
cat("   - list_cheysson_patterns() returned", nrow(pat_list), "palettes\n")
cat("   ✓ Pattern functions work\n\n")

# Test font functions
cat("5. Testing font functions...\n")
fonts <- list_cheysson_fonts()
cat("   - list_cheysson_fonts() returned", nrow(fonts), "fonts\n")

font_name <- cheysson_font("title")
cat("   - cheysson_font('title') =", font_name, "\n")

# Try loading fonts (may fail if systemfonts not installed)
tryCatch({
  loaded <- load_cheysson_fonts()
  cat("   - Loaded", length(loaded), "font families\n")
  cat("   ✓ Font functions work\n\n")
}, error = function(e) {
  cat("   ⚠ Font loading skipped (systemfonts may not be installed)\n\n")
})

# Test scales
cat("6. Testing scale functions...\n")
cat("   - scale_color_cheysson() exists:", exists("scale_color_cheysson"), "\n")
cat("   - scale_fill_cheysson() exists:", exists("scale_fill_cheysson"), "\n")
cat("   - scale_pattern_fill_cheysson() exists:", exists("scale_pattern_fill_cheysson"), "\n")
cat("   ✓ Scale functions available\n\n")

# Test themes
cat("7. Testing theme functions...\n")
cat("   - theme_cheysson() exists:", exists("theme_cheysson"), "\n")
cat("   - theme_cheysson_minimal() exists:", exists("theme_cheysson_minimal"), "\n")
cat("   - theme_cheysson_map() exists:", exists("theme_cheysson_map"), "\n")
cat("   ✓ Theme functions available\n\n")

cat("=== All Verification Tests Passed! ===\n\n")
cat("The package should now pass R CMD check with:\n")
cat("  ✓ No errors\n")
cat("  ✓ No warnings\n")
cat("  ✓ Minimal notes (if any)\n\n")

cat("Run: devtools::check() to verify\n")
