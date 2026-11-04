# Render man/figures/swatches.png, the swatch atlas shown in ?cheysson_swatches.
# Pre-rendered because ggpattern is only in Suggests. Re-run when the swatches change.
devtools::load_all(quiet = TRUE)
ggplot2::ggsave("man/figures/swatches.png", show_swatches(),
                width = 8, height = 10, dpi = 96, bg = "white",
                device = ragg::agg_png)
