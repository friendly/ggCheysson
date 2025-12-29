# Test Cheysson fonts availability
library(here)

# Check what fonts we have
font_dir <- here("fonts")
font_files <- list.files(font_dir, pattern = "\\.ttf$", full.names = TRUE)

cat("=== Cheysson Font Files ===\n")
for (f in font_files) {
  cat(sprintf("%s (%.1f KB)\n", basename(f), file.info(f)$size / 1024))
}

# Try using systemfonts
if (requireNamespace("systemfonts", quietly = TRUE)) {
  cat("\n=== Testing systemfonts ===\n")

  # Register fonts
  for (font_file in font_files) {
    font_name <- tools::file_path_sans_ext(basename(font_file))
    cat(sprintf("Registering: %s\n", font_name))

    tryCatch({
      systemfonts::register_font(
        name = font_name,
        plain = font_file
      )
    }, error = function(e) {
      cat(sprintf("  Error: %s\n", e$message))
    })
  }

  # List registered fonts
  cat("\n=== Registered Fonts ===\n")
  registered <- systemfonts::registry_fonts()
  cheysson_fonts <- registered[grepl("Cheysson", registered$family, ignore.case = TRUE), ]
  if (nrow(cheysson_fonts) > 0) {
    print(cheysson_fonts[, c("family", "name")])
  } else {
    cat("No Cheysson fonts found in registry\n")
  }
} else {
  cat("\nsystemfonts package not installed\n")
  cat("Install with: install.packages('systemfonts')\n")
}

# Try using showtext
if (requireNamespace("showtext", quietly = TRUE)) {
  cat("\n=== Testing showtext ===\n")

  # Add fonts
  for (font_file in font_files) {
    font_name <- tools::file_path_sans_ext(basename(font_file))
    cat(sprintf("Adding: %s\n", font_name))

    tryCatch({
      showtext::font_add(
        family = font_name,
        regular = font_file
      )
    }, error = function(e) {
      cat(sprintf("  Error: %s\n", e$message))
    })
  }

  # List fonts
  cat("\nShowtext fonts:\n")
  fonts <- showtext::font_families()
  cheysson_fonts <- fonts[grepl("Cheysson", fonts, ignore.case = TRUE)]
  if (length(cheysson_fonts) > 0) {
    print(cheysson_fonts)
  } else {
    cat("No Cheysson fonts found\n")
  }
} else {
  cat("\nshowtext package not installed\n")
  cat("Install with: install.packages('showtext')\n")
}
