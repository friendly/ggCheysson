# Proof of concept 3 (2026-11-03): poc_simplified.R, but with gridpattern::register_pattern()
# (needs gridpattern >= 1.6.0 / ggpattern >= 1.4.0, the development versions as of 2026-11).
#
# Changes from poc_simplified.R:
#   - swatches are registered with register_pattern(), not options(ggpattern_geometry_funcs = ...)
#   - names use "-" instead of ":" ("1886_28-1"), since register_pattern() rejects ":"
#   - each swatch's spacing and density are registered `defaults`; the pattern function uses
#     params$pattern_spacing / pattern_density as they arrive (no relative scaling), so a
#     user's value replaces the swatch's rather than adjusting it
#   - line drawing is delegated to the qualified "gridpattern::stripe" / "gridpattern::crosshatch"
#   - pattern_units is passed on, and the default spacing depends on it: 0.025 in "snpc",
#     otherwise 0.3 cm converted to the user's units (about 0.025 snpc on a 7 x 4.5 in plot)

suppressMessages({library(ggCheysson); library(ggplot2); library(ggpattern)})
out <- here::here("dev/custom-pattern")

paper <- "white"   # background for hatching on bare paper; could be a package option
sep   <- "-"

swatch_spec <- function(name) {
  key <- strsplit(name, sep, fixed = TRUE)[[1]]
  cheysson_pattern(key[1])[[as.integer(key[2])]]
}

seen <- new.env()   # record the spacing/density each swatch is drawn with, for checking
draw_swatch <- function(params, boundary_df, aspect_ratio, legend = FALSE) {
  spec <- swatch_spec(params$pattern)
  seen[[params$pattern]] <- data.frame(spacing = params$pattern_spacing,
    density = params$pattern_density, units = format(params$pattern_units))
  x <- boundary_df$x; y <- boundary_df$y; id <- boundary_df$id
  bg_col <- if (spec$type == "solid") spec$fill else
    if (identical(spec$fill, "transparent")) paper else spec$fill
  bg <- grid::polygonGrob(x, y, id = id, gp = grid::gpar(fill = bg_col, col = NA))
  if (spec$type == "solid") return(bg)
  lines <- gridpattern::patternGrob(
    if (spec$type == "crosshatch") "gridpattern::crosshatch" else "gridpattern::stripe",
    x = x, y = y, id = id, colour = NA,
    fill = spec$pattern_fill, fill2 = spec$pattern_fill2 %||% spec$pattern_fill,
    angle = spec$pattern_angle %||% 45,
    density = params$pattern_density, spacing = params$pattern_spacing,
    units = params$pattern_units)
  grid::grobTree(bg, lines)
}

# default spacing in the user's pattern_units (generic parameters such as units are
# filled in before a pattern's own defaults, so this can use them)
spacing_default <- function(params, gp) {
  u <- params$pattern_units
  if (identical(u, "snpc")) 0.025 else
    grid::convertUnit(grid::unit(0.3, "cm"), u, valueOnly = TRUE)
}

# register every swatch of every palette under its own name, with its own defaults
# (the same for all here; a package version could vary them per swatch)
swatch_names <- unlist(lapply(names(cheysson_patterns), function(p)
  paste0(p, sep, seq_along(cheysson_patterns[[p]]$patterns))))
for (nm in swatch_names)
  gridpattern::register_pattern(nm, draw_swatch,
    defaults = list(pattern_spacing = spacing_default, pattern_density = 0.30))
cat(length(swatch_names), "swatches registered as patterns\n")

scale_cheysson3 <- function(palette, ...) {
  n_el <- length(cheysson_pattern(palette))
  scale_pattern_manual(values = paste0(palette, sep, seq_len(n_el)), ...)
}

trade <- data.frame(country = c("France", "England", "Germany", "Italy"),
                    exports = c(2350, 3120, 2680, 1890))

report <- function(label) {
  cat("\n", label, ":\n", sep = "")
  r <- do.call(rbind, as.list(seen))
  print(r[order(rownames(r)), ])
  rm(list = ls(seen), envir = seen)
}

# --- 1. target usage, no geom arguments: the registered defaults should apply
p <- ggplot(trade, aes(country, exports, pattern = country)) +
  geom_col_pattern() +
  scale_cheysson3("1886_28") +
  labs(title = "1. defaults: geom_col_pattern() + scale_cheysson3()")
ggsave(file.path(out, "poc_register_bars.png"), p, width = 7, height = 4.5, dpi = 96,
       device = ragg::agg_png)
report("1. bars, defaults (expect 0.025 / 0.30)")

# --- 2. user overrides: should replace the swatch defaults
p2 <- ggplot(trade, aes(country, exports, pattern = country)) +
  geom_col_pattern(pattern_spacing = 0.06, pattern_density = 0.6) +
  scale_cheysson3("1886_28") +
  labs(title = "2. override: pattern_spacing = 0.06, pattern_density = 0.6")
ggsave(file.path(out, "poc_register_bars_override.png"), p2, width = 7, height = 4.5, dpi = 96,
       device = ragg::agg_png)
report("2. bars, override (expect 0.06 / 0.6)")

# --- 2b. absolute units: the default spacing follows them, and a user's spacing is in them
p2b <- ggplot(trade, aes(country, exports, pattern = country)) +
  geom_col_pattern(pattern_units = "cm") +
  scale_cheysson3("1886_28") +
  labs(title = "2b. pattern_units = \"cm\"")
ggsave(file.path(out, "poc_register_bars_cm.png"), p2b, width = 7, height = 4.5, dpi = 96,
       device = ragg::agg_png)
report("2b. bars, pattern_units = \"cm\" (expect 0.3 / 0.30 cm)")

p2c <- ggplot(trade, aes(country, exports, pattern = country)) +
  geom_col_pattern(pattern_units = "cm", pattern_spacing = 0.5) +
  scale_cheysson3("1886_28") +
  labs(title = "2c. pattern_units = \"cm\", pattern_spacing = 0.5")
ggsave(file.path(out, "poc_register_bars_cm_05.png"), p2c, width = 7, height = 4.5, dpi = 96,
       device = ragg::agg_png)
report("2c. bars, pattern_units = \"cm\", pattern_spacing = 0.5 (expect 0.5 / 0.30 cm)")

# --- 3. map
france <- sf::st_as_sf(Guerry::gfrance85)
m <- ggplot(france, aes(pattern = Region)) +
  geom_sf_pattern() +
  scale_cheysson3("1883_30") +
  labs(title = "3. aes(pattern = Region) + geom_sf_pattern() + scale_cheysson3()") +
  theme_void()
ggsave(file.path(out, "poc_register_map.png"), m, width = 7, height = 6, dpi = 96,
       device = ragg::agg_png)
report("3. map, defaults")

# --- 4. plain grid, no ggpattern
ragg::agg_png(file.path(out, "poc_register_grid.png"), width = 300, height = 300)
gridpattern::grid.pattern("1883_30-3", x = c(0.1, 0.9, 0.9, 0.1), y = c(0.1, 0.1, 0.9, 0.9))
invisible(dev.off())
report("4. grid.pattern(), defaults")
cat("done\n")
