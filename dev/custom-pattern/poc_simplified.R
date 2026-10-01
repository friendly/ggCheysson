# Proof of concept 2 (2026-10-01): can a Cheysson swatch be used with *no* extra geom arguments?
#
# poc_custom_pattern.R needed
#   geom_col_pattern(aes(pattern_type = x), pattern = "cheysson", fill = NA,
#                    pattern_density = 0.3, pattern_spacing = 0.025)
# Here each swatch is registered as its own ggpattern pattern, named "<palette>:<element>",
# so the ordinary `pattern` aesthetic carries the swatch, and the pattern function
#   - paints its own paper background (so the geom's default fill doesn't show through),
#   - uses its own default line density and spacing, treating the geom's pattern_density /
#     pattern_spacing only as relative adjustments to them (ggpattern's defaults = 1x).
# Usage is then:  aes(pattern = x) + geom_col_pattern() + scale_cheysson2(palette)

suppressMessages({library(ggCheysson); library(ggplot2); library(ggpattern)})
out <- here::here("dev/custom-pattern")

paper <- "white"   # background for hatching on bare paper; could be a package option

draw_swatch <- function(params, boundary_df, aspect_ratio, legend = FALSE) {
  key  <- strsplit(params$pattern, ":", fixed = TRUE)[[1]]
  spec <- cheysson_pattern(key[1])[[as.integer(key[2])]]
  x <- boundary_df$x; y <- boundary_df$y; id <- boundary_df$id
  bg_col <- if (spec$type == "solid") spec$fill else
    if (identical(spec$fill, "transparent")) paper else spec$fill
  bg <- grid::polygonGrob(x, y, id = id, gp = grid::gpar(fill = bg_col, col = NA))
  if (spec$type == "solid") return(bg)
  # ggpattern's defaults are pattern_spacing = 0.05, pattern_density = 0.2: treat them as 1x
  spacing <- 0.025 * params$pattern_spacing / 0.05
  density <- 0.30  * params$pattern_density / 0.2
  lines <- gridpattern::patternGrob(
    if (spec$type == "crosshatch") "crosshatch" else "stripe",
    x = x, y = y, id = id, colour = NA,
    fill = spec$pattern_fill, fill2 = spec$pattern_fill2 %||% spec$pattern_fill,
    angle = spec$pattern_angle %||% 45, density = density, spacing = spacing)
  grid::grobTree(bg, lines)
}

# register every swatch of every palette under its own name
swatch_names <- unlist(lapply(names(cheysson_patterns), function(p)
  paste0(p, ":", seq_along(cheysson_patterns[[p]]$patterns))))
options(ggpattern_geometry_funcs = c(
  getOption("ggpattern_geometry_funcs"),
  setNames(rep(list(draw_swatch), length(swatch_names)), swatch_names)))
cat(length(swatch_names), "swatches registered as patterns\n")

# the one scale: picks swatch names for the levels (a package version would reuse
# select_values() for the light -> dark spread of sequential/diverging palettes)
scale_cheysson2 <- function(palette, ...) {
  n_el <- length(cheysson_pattern(palette))
  scale_pattern_manual(values = paste0(palette, ":", seq_len(n_el)), ...)
}

trade <- data.frame(country = c("France", "England", "Germany", "Italy"),
                    exports = c(2350, 3120, 2680, 1890))

# --- the target usage: one aesthetic, no geom arguments, one scale
p <- ggplot(trade, aes(country, exports, pattern = country)) +
  geom_col_pattern() +
  scale_cheysson2("1886_28") +
  labs(title = "aes(pattern = country) + geom_col_pattern() + scale_cheysson2()")
ggsave(file.path(out, "poc_simplified_bars.png"), p, width = 7, height = 4.5, dpi = 96,
       device = ragg::agg_png)

# --- the same on a map: Guerry's regions with geom_sf_pattern(), again no geom arguments
france <- sf::st_as_sf(Guerry::gfrance85)
m <- ggplot(france, aes(pattern = Region)) +
  geom_sf_pattern() +
  scale_cheysson2("1883_30") +
  labs(title = "aes(pattern = Region) + geom_sf_pattern() + scale_cheysson2()") +
  theme_void()
ggsave(file.path(out, "poc_simplified_map.png"), m, width = 7, height = 6, dpi = 96,
       device = ragg::agg_png)
cat("done\n")
