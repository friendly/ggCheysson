# Build and preview the vignette
library(here)

cat("=== Building Getting Started Vignette ===\n\n")

# Build the vignette
cat("Building vignette...\n")
devtools::build_vignettes(here())

cat("\n✓ Vignette built successfully!\n\n")

cat("To view the vignette:\n")
cat("  1. In R: vignette('getting-started', package = 'ggCheysson')\n")
cat("  2. Or install the package with vignettes:\n")
cat("     devtools::install(build_vignettes = TRUE)\n\n")

cat("The built vignette HTML is in: doc/getting-started.html\n")
