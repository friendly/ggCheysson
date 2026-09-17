# Verifies the 2026-09-17 title/axis-title undersizing fix
# (cheysson_font_size_adjust() in R/theme.R): plot.title (CheyssonTitle,
# factor 1.10) and axis.title/legend.title/strip.text (CheyssonSansCaps,
# factor 1.15, fixed earlier) should now read at a comparable visual size to
# theme_minimal()'s Arial-based defaults, at several base_size values.
#
# Fonts only render correctly in *saved* plots via ragg on this machine
# (systemfonts + the on-screen device crashes with "invalid font type" -
# see \dontrun{} notes in R/theme.R) - not run under R CMD check.

library(here)
library(ggplot2)
devtools::load_all(here(), quiet = TRUE)
load_cheysson_fonts()

base_sizes <- c(9, 11, 14, 18)

for (bs in base_sizes) {
  p_minimal <- ggplot(mtcars, aes(wt, mpg, color = factor(cyl))) +
    geom_point(size = 3) +
    labs(
      title = "Automobile Efficiency",
      subtitle = "Weight vs Fuel Economy",
      x = "Weight (1000 lbs)", y = "Miles per Gallon", color = "Cylinders"
    ) +
    theme_minimal(base_size = bs)

  p_cheysson <- ggplot(mtcars, aes(wt, mpg, color = factor(cyl))) +
    geom_point(size = 3) +
    labs(
      title = "Automobile Efficiency",
      subtitle = "Weight vs Fuel Economy",
      x = "Weight (1000 lbs)", y = "Miles per Gallon", color = "Cylinders"
    ) +
    scale_color_cheysson("category") +
    theme_cheysson(base_size = bs)

  ragg::agg_png(
    here(sprintf("dev/fonts/title_size_fix_base%d_minimal.png", bs)),
    width = 900, height = 600, res = 144
  )
  print(p_minimal)
  dev.off()

  ragg::agg_png(
    here(sprintf("dev/fonts/title_size_fix_base%d_cheysson.png", bs)),
    width = 900, height = 600, res = 144
  )
  print(p_cheysson)
  dev.off()

  cat(sprintf("Saved base_size = %d (minimal + cheysson)\n", bs))
}

cat("\nDone. Compare title_size_fix_base*_minimal.png against\n")
cat("title_size_fix_base*_cheysson.png for each base_size.\n")
