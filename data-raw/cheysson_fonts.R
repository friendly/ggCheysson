# Create cheysson_fonts data object for the package

# Font metadata data frame
cheysson_fonts <- data.frame(
  family = c("Cheysson", "CheyssonItalic", "CheyssonSansCaps",
             "CheyssonOutlineCaps", "CheyssonTitle"),
  description = c(
    "Regular serif font for body text",
    "Italic variant for emphasis",
    "Sans-serif capitals for labels",
    "Outlined capitals for decorative titles",
    "Decorative font for main titles"
  ),
  use = c(
    "General text, axis labels, legends",
    "Emphasis, annotations",
    "Axis labels, category names",
    "Plot titles, headings",
    "Main plot titles"
  ),
  file = c(
    "CheyssonRegular-Regular.ttf",
    "CheyssonItalic-Italic.ttf",
    "CheyssonSansCaps-Regular.ttf",
    "CheyssonOutlineCaps-Regular.ttf",
    "CheyssonTitle-Regular.ttf"
  ),
  stringsAsFactors = FALSE
)

# Save as package data
usethis::use_data(cheysson_fonts, overwrite = TRUE)

# Print summary
cat("Created cheysson_fonts with", nrow(cheysson_fonts), "font families\n")
print(cheysson_fonts[, c("family", "description")])
