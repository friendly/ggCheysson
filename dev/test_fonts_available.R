# Test cheysson_fonts_available() function
library(here)

cat("=== Testing cheysson_fonts_available() ===\n\n")

# Load package
devtools::load_all(here())

# Test 1: Without any fonts loaded (should return FALSE or handle gracefully)
cat("1. Testing before fonts are loaded:\n")
result1 <- cheysson_fonts_available()
cat("   Result:", result1, "\n\n")

# Test 2: After loading fonts with systemfonts
cat("2. Testing after loading fonts with systemfonts:\n")
if (requireNamespace("systemfonts", quietly = TRUE)) {
  load_cheysson_fonts(method = "systemfonts")
  result2 <- cheysson_fonts_available(method = "systemfonts")
  cat("   Result:", result2, "\n\n")
} else {
  cat("   Skipped (systemfonts not available)\n\n")
}

# Test 3: Check for showtext (may not be installed)
cat("3. Testing showtext method:\n")
if (requireNamespace("showtext", quietly = TRUE)) {
  result3 <- cheysson_fonts_available(method = "showtext")
  cat("   Result:", result3, "\n")
} else {
  cat("   Skipped (showtext not installed)\n")
}

# Test 4: Run the example from the documentation
cat("\n4. Running documentation example:\n")
if (cheysson_fonts_available()) {
  message("Cheysson fonts are ready to use!")
} else {
  cat("   No fonts available yet\n")
}

cat("\n=== Test Complete ===\n")
cat("The function should not error even if showtext is not installed.\n")
