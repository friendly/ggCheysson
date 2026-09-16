# Display all 20 palettes in data/cheysson_patterns.rda as pattern swatches.
#
# Written 2026-09-16 on the `colorpat` branch, after fixing the two bugs in
# scale_pattern_type_cheysson()/scale_pattern_fill_cheysson() documented in
# PATTERN_SCALE_BUGS.md. Supersedes dev/patterns/test_patterns.R, which
# predates the fix and still uses the old (broken) aes(pattern_type = ...)
# mapping - that script would not render pattern-type variety correctly even
# now, since "pattern_type" is a different, unrelated ggpattern aesthetic.
#
# Each palette is drawn as one row of swatches, one per pattern element,
# using the real (now-fixed) scale_fill_cheysson_pattern() /
# scale_pattern_fill_cheysson() / scale_pattern_type_cheysson() functions -
# this exercises the fix directly, not a workaround.
#
# 6 of 20 palettes (1882_04, 1883_07, 1886_04, 1886_07, 1887_06, 1900_06)
# have NULL entries in $patterns for some elements (15 total across all
# palettes) - genuine extraction gaps from data-raw/cheysson_patterns.R, not
# a scale bug. cheysson_pattern_params() returns bare NA for a NULL element
# regardless of which param is requested, and ggpattern hard-crashes
# ("missing value where TRUE/FALSE needed" inside fill_default_params()) if
# an NA reaches the `pattern` aesthetic - so those positions are dropped
# here rather than plotted, with a per-palette gap count noted in the title.

devtools::load_all(quiet = TRUE)
library(ggplot2)
library(ggpattern)
library(patchwork)

palette_names <- names(cheysson_patterns)

swatch_plot <- function(name) {
  pal <- cheysson_patterns[[name]]
  patterns <- pal$patterns
  is_gap <- sapply(patterns, is.null)
  n_gap <- sum(is_gap)
  patterns <- patterns[!is_gap]
  n <- length(patterns)
  d <- data.frame(i = factor(seq_len(n)), y = 1)

  title <- sprintf("%s (%s, n=%d%s)", name, pal$type, pal$n_patterns,
                    if (n_gap > 0) sprintf(", %d NA", n_gap) else "")

  ggplot(d, aes(i, y, fill = i)) +
    geom_col_pattern(
      aes(pattern = i, pattern_fill = i),
      pattern_density = 0.35,
      pattern_spacing = 0.03,
      color = "black",
      linewidth = 0.3,
      width = 0.9
    ) +
    scale_fill_manual(values = cheysson_pattern_params(patterns, "fill")) +
    scale_pattern_fill_manual(values = cheysson_pattern_params(patterns, "pattern_fill")) +
    scale_pattern_manual(values = cheysson_pattern_params(patterns, "pattern_type")) +
    labs(title = title) +
    theme_void() +
    theme(
      legend.position = "none",
      plot.title = element_text(size = 9, margin = margin(b = 2))
    )
}

plots <- lapply(palette_names, swatch_plot)

overview <- wrap_plots(plots, ncol = 4)

out <- "dev/colorpat/all_patterns_overview.png"
ggsave(out, overview, width = 14, height = 12, dpi = 110, device = ragg::agg_png)
cat("Saved:", out, "\n")
