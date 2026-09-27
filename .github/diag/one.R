# Render one plot on one device, with or without showtext. Run in its own
# process by run-all.R so a segfault only kills this case.
# Usage: Rscript one.R <plot> <device> <showtext: on|off> <outdir>
args <- commandArgs(trailingOnly = TRUE)
plot_id <- args[1]; device <- args[2]; st <- args[3]; outdir <- args[4]

suppressPackageStartupMessages({
  library(ggCheysson); library(ggplot2); library(ggpattern); library(sf); library(grid)
})

if (st == "on") {
  load_cheysson_fonts(method = "showtext")
  showtext::showtext_auto()
}

make_plot <- function(id) {
  if (id == "grid_mask") return(NULL)
  if (id %in% c("sf_plain", "sf_pattern")) {
    data(gfrance85, package = "Guerry"); data(Guerry, package = "Guerry")
    fr <- merge(st_as_sf(gfrance85), Guerry, by = "Department", all.x = TRUE)
    fr$q <- cut(fr$Literacy, quantile(fr$Literacy, 0:5 / 5, na.rm = TRUE),
                include.lowest = TRUE, labels = paste0("Q", 1:5))
  }
  switch(id,
    sf_plain = ggplot(fr) + geom_sf(aes(fill = q)) +
      scale_fill_cheysson("1881_22") + theme_cheysson_map(),
    sf_pattern = ggplot(fr) +
      geom_sf_pattern(aes(fill = q, pattern = q, pattern_fill = q),
                      pattern_density = 0.3, pattern_spacing = 0.02) +
      scale_fill_cheysson_pattern("1881_22") +
      scale_pattern_fill_cheysson("1881_22") +
      scale_pattern_type_cheysson("1881_22") + theme_cheysson_map(),
    col_pattern = ggplot(data.frame(x = letters[1:4], y = 1:4),
                         aes(x, y, fill = x)) +
      geom_col_pattern(aes(pattern = x, pattern_fill = x),
                       pattern_density = 0.3, pattern_spacing = 0.025) +
      scale_fill_cheysson_pattern("1881_12") +
      scale_pattern_fill_cheysson("1881_12") +
      scale_pattern_type_cheysson("1881_12") + theme_cheysson()
  )
}
p <- make_plot(plot_id)

f <- file.path(outdir, sprintf("%s_%s_%s.png", plot_id, device, st))
switch(device,
  quartz = png(f, 800, 700, type = "quartz"),
  cairo  = png(f, 800, 700, type = "cairo"),
  ragg   = ragg::agg_png(f, 800, 700)
)
cat("masks capability:", format(dev.capabilities()$masks), "\n")
if (is.null(p)) {
  # Pure grid mask, no ggplot2/ggpattern: is the device's mask support itself broken?
  grid.rect(gp = gpar(fill = "steelblue"),
            vp = viewport(mask = circleGrob(r = 0.4, gp = gpar(fill = "black"))))
} else {
  print(p)
}
invisible(dev.off())
cat("OK\n")
