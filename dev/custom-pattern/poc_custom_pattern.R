# Proof of concept (2026-10-01): a custom ggpattern pattern, "cheysson", that draws a whole
# Cheysson swatch - background fill, hatch type, line color(s), angle - from one value of the
# `pattern_type` aesthetic, "<palette>:<element>". Suggested by Trevor Davis (ggpattern
# maintainer): https://github.com/trevorld/ggpattern/issues/154 . See dev/TASKS.md,
# "New development", for the 1.2.0 plan built on this.
#
# Registers the pattern with ggpattern's documented mechanism (options(ggpattern_geometry_funcs))
# and writes two PNGs next to this script.

suppressMessages({library(ggCheysson); library(ggplot2); library(ggpattern)})
out <- here::here("dev/custom-pattern")

# A "cheysson" geometry pattern: pattern_type names one swatch, "<palette>:<element>".
# Everything about the swatch comes from cheysson_patterns; the geom's own
# pattern_density / pattern_spacing still control line weight and spacing.
create_pattern_cheysson <- function(params, boundary_df, aspect_ratio, legend = FALSE) {
  key <- strsplit(params$pattern_type, ":", fixed = TRUE)[[1]]
  spec <- cheysson_pattern(key[1])[[as.integer(key[2])]]
  x <- boundary_df$x; y <- boundary_df$y; id <- boundary_df$id
  bg_col <- if (spec$type == "solid") spec$fill else spec$fill %||% "transparent"
  bg <- grid::polygonGrob(x, y, id = id, gp = grid::gpar(fill = bg_col, col = NA))
  if (spec$type == "solid") return(bg)
  lines <- gridpattern::patternGrob(
    if (spec$type == "crosshatch") "crosshatch" else "stripe",
    x = x, y = y, id = id,
    colour = NA,
    fill = spec$pattern_fill,
    fill2 = spec$pattern_fill2 %||% spec$pattern_fill,
    angle = spec$pattern_angle %||% 45,
    density = params$pattern_density,
    spacing = params$pattern_spacing
  )
  grid::grobTree(bg, lines)
}
options(ggpattern_geometry_funcs = list(cheysson = create_pattern_cheysson))

trade <- data.frame(country = c("France", "England", "Germany", "Italy"),
                    exports = c(2350, 3120, 2680, 1890))

# one mapping, one scale: the swatch name is the only thing that varies
p <- ggplot(trade, aes(country, exports)) +
  geom_col_pattern(aes(pattern_type = country), pattern = "cheysson", fill = NA,
                   pattern_density = 0.3, pattern_spacing = 0.025, colour = "black") +
  scale_pattern_type_manual(values = paste0("1886_28:", 1:4), name = "Country") +
  labs(title = "Custom 'cheysson' pattern: one aesthetic, one scale")
ggsave(file.path(out, "poc_custom_pattern.png"), p, width = 7, height = 4.5, dpi = 96,
       device = ragg::agg_png)

# the two-colour crosshatch of 1883_30 element 3, as a check on pattern_fill2
q <- ggplot(data.frame(k = factor(1:5), v = 1), aes(k, v)) +
  geom_col_pattern(aes(pattern_type = k), pattern = "cheysson", fill = NA,
                   pattern_density = 0.35, pattern_spacing = 0.04, colour = "black", width = 0.95) +
  scale_pattern_type_manual(values = paste0("1883_30:", 1:5)) +
  theme_void() + theme(legend.position = "none")
ggsave(file.path(out, "poc_custom_1883_30.png"), q, width = 7, height = 1.6, dpi = 96,
       device = ragg::agg_png)
cat("done\n")
