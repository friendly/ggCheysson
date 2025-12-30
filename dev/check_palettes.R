library(here)
devtools::load_all(here())

cat("=== Available Palettes by Type ===\n\n")

for(p in names(cheysson_palettes)) {
  pal_info <- cheysson_palettes[[p]]
  cat(sprintf("%-10s : %-12s (%d colors)\n", p, pal_info$type, length(pal_info$colors)))
}

cat("\n=== By Type ===\n")
cat("\nSequential:\n")
print(list_cheysson_pals("sequential"))

cat("\nDiverging:\n")
print(list_cheysson_pals("diverging"))

cat("\nGrouped:\n")
print(list_cheysson_pals("grouped"))

cat("\nCategory:\n")
print(list_cheysson_pals("category"))
