# Reconstruct RJ Andrews' 25-palette reference grid (man/figures/RJ-Andrews-
# color-palettes.jpg) using the package's *current* cheysson_palettes/
# cheysson_patterns data and scale functions, for direct visual comparison.
#
# Written 2026-09-16 on the `colorpat` branch, after fixing the 15 NULL
# pattern-element gaps (see PATTERN_SCALE_BUGS.md / TASKS.md). While mapping
# reference rows to shipped palettes, found a separate, bigger bug: the
# palette naming scheme in data-raw/cheysson_palettes.R and
# data-raw/cheysson_patterns.R builds names from Album + Qty
# (e.g. "1880_07"), but Qty is NOT a unique plate discriminator - the real
# key is RumseyListNo (equivalently dec_day/adventDay, 1-25, always unique).
# 4 Album+Qty collisions silently overwrote 5 of the original 25 palettes
# during extraction (list assignment by name, last adventDay wins):
#   "1880_07"  <- adventDay 6 (lost, Grouped) and 24 (kept, Category)
#   "1881_04"  <- adventDay 21 (lost, Grouped) and 25 (kept, Category)
#   "1886_04"  <- adventDay 4, 15 (both lost, Grouped) and 19 (kept, Sequential)
#   "1886_08"  <- adventDay 2 (lost, Grouped) and 7 (kept, Grouped)
# So 20 of 25 reference palettes are available; the 5 lost ones (adventDay
# 2, 4, 6, 15, 21) are drawn here as explicit grey/crosshatched placeholders
# rather than omitted or approximated - not yet fixed in R/ or data-raw/,
# left for a follow-up (would need a real unique key, which touches public
# palette names throughout the package).
#
# Column/row order below is NOT re-derived from any naming scheme - it's
# read directly off the reference image's own layout (3 columns of 8, 8, 9),
# recorded here as adventDay sequences so the two images can be compared
# position-for-position. All 25 adventDays appear exactly once (verified).

devtools::load_all(quiet = TRUE)
library(ggplot2)
library(ggpattern)
library(readr)
library(patchwork)

album_info <- read_csv("data-raw/observable/albumColors.csv",
                        col_types = cols(RumseyListNo = "c", .default = "c")) |>
  transform(adventDay = as.integer(adventDay))

make_label <- function(day) {
  row <- album_info[album_info$adventDay == day, ]
  suffix <- sub("^[0-9]+\\.", "", row$RumseyListNo[1])
  sprintf("Dec.%02d-%s.%02d", day, row$Album[1], as.integer(suffix))
}

dec_to_name <- setNames(names(cheysson_patterns),
                         sapply(cheysson_patterns, `[[`, "dec_day"))

col1_days <- c(6, 24, 3, 22, 21, 25, 23, 14)
col2_days <- c(1, 16, 7, 4, 15, 2, 19, 5)
col3_days <- c(8, 9, 11, 20, 12, 10, 18, 13, 17)
stopifnot(setequal(c(col1_days, col2_days, col3_days), 1:25))

# One row of rect+pattern data for a single reference position (a "row" in
# the sense of a horizontal strip of swatches, with a row index for y and a
# column id for arranging the three panels).
row_data <- function(day, row_idx, col_id) {
  label <- make_label(day)
  nm <- unname(dec_to_name[as.character(day)])

  if (is.na(nm)) {
    # Lost to the Album+Qty collision - single grey crosshatch placeholder,
    # still correctly labeled from the source CSV.
    d <- data.frame(
      x = 1, fill = "grey85", pattern = "crosshatch",
      pattern_fill = "grey50", pattern_angle = 45
    )
  } else {
    pat <- cheysson_patterns[[nm]]$patterns
    n <- length(pat)
    d <- data.frame(
      x = seq_len(n),
      fill = cheysson_pattern_params(pat, "fill"),
      pattern = cheysson_pattern_params(pat, "pattern_type"),
      pattern_fill = cheysson_pattern_params(pat, "pattern_fill"),
      pattern_angle = cheysson_pattern_params(pat, "pattern_angle")
    )
  }
  d$xmin <- d$x - 1
  d$xmax <- d$x
  d$row <- row_idx
  d$col <- col_id
  d$label <- label
  d$missing <- is.na(nm)
  d
}

cols <- list(col1_days, col2_days, col3_days)
all_rows <- do.call(rbind, unlist(lapply(seq_along(cols), function(col_id) {
  lapply(seq_along(cols[[col_id]]), function(row_idx) {
    row_data(cols[[col_id]][row_idx], row_idx, col_id)
  })
}), recursive = FALSE))

row_h <- 1
gap <- 0.35
all_rows$ymin <- -( (all_rows$row - 1) * (row_h + gap) + row_h )
all_rows$ymax <- all_rows$ymin + row_h

labels_df <- unique(all_rows[, c("col", "row", "label", "missing")])
labels_df$x <- 0
labels_df$y <- -((labels_df$row - 1) * (row_h + gap)) + 0.12

make_panel <- function(col_num) {
  d <- all_rows[all_rows$col == col_num, ]
  lab <- labels_df[labels_df$col == col_num, ]

  ggplot() +
    geom_rect_pattern(
      data = d,
      aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax,
          fill = fill, pattern = pattern, pattern_fill = pattern_fill,
          pattern_angle = pattern_angle),
      pattern_density = 0.35, pattern_spacing = 0.03,
      color = "black", linewidth = 0.3
    ) +
    geom_text(
      data = lab,
      aes(x = x, y = y, label = label,
          colour = ifelse(missing, "grey50", "grey30")),
      hjust = 0, vjust = 0, size = 3, family = "mono"
    ) +
    scale_fill_identity() +
    scale_pattern_identity() +
    scale_pattern_fill_identity() +
    scale_pattern_angle_identity() +
    scale_colour_identity() +
    coord_fixed(xlim = c(0, 9), ylim = c(min(d$ymin) - 0.2, 0.3), expand = FALSE) +
    theme_void()
}

panels <- make_panel(1) | make_panel(2) | make_panel(3)
panels <- panels +
  plot_annotation(
    title = "Reconstruction from current ggCheysson data/functions",
    subtitle = "Compare to man/figures/RJ-Andrews-color-palettes.jpg - grey crosshatch = palette lost to the\nAlbum+Qty naming collision (dev/TASKS.md), not yet recovered",
    theme = theme(
      plot.title = element_text(size = 12, face = "bold"),
      plot.subtitle = element_text(size = 9, colour = "grey30")
    )
  )

ggsave("dev/colorpat/RJ-Andrews-reconstruct.png", panels,
       width = 15, height = 8.5, dpi = 120, device = ragg::agg_png)
cat("Saved: dev/colorpat/RJ-Andrews-reconstruct.png\n")
