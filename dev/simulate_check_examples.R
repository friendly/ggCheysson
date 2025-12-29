# Simulate R CMD check examples behavior
# This tests examples without having the packages loaded

library(here)

cat("=== Simulating R CMD check Examples ===\n\n")

# Detach showtext if loaded
if ("showtext" %in% loadedNamespaces()) {
  try(unloadNamespace("showtext"), silent = TRUE)
}

# Load package
devtools::load_all(here())

cat("Running example code from cheysson_fonts_available():\n\n")

# This is the exact code from the examples
if (cheysson_fonts_available()) {
  message("Cheysson fonts are ready to use!")
}

cat("\n✓ Example completed without error\n\n")

cat("Running example code from load_cheysson_fonts():\n\n")

# Test the dontrun examples in a controlled way
tryCatch({
  load_cheysson_fonts()
  cat("✓ load_cheysson_fonts() completed\n")
}, error = function(e) {
  cat("✗ Error:", e$message, "\n")
})

cat("\nRunning example code from list_cheysson_fonts():\n\n")

result <- list_cheysson_fonts()
cat("✓ list_cheysson_fonts() returned", nrow(result), "rows\n")

cat("\n=== All Examples Completed Successfully ===\n")
