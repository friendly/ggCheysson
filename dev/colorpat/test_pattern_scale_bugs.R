# Reproduces the two scale_pattern_*_cheysson() bugs documented in
# PATTERN_SCALE_BUGS.md, and shows a working fix applied from calling code
# (without touching R/scale_patterns.R - the package was just submitted to
# CRAN and the user wants it left as-is until that's settled).
#
# Bug 1: scale_pattern_type_cheysson() uses aesthetics = "pattern_type",
#        should be "pattern" (ggpattern's actual pattern-shape aesthetic).
# Bug 2: scale_pattern_fill_cheysson() reads cheysson_pattern_params(x, "fill")
#        (the base rect fill), should read "pattern_fill" (the hatch color).

library(ggCheysson)
library(ggplot2)
library(ggpattern)

data <- data.frame(category = LETTERS[1:4], value = c(15, 23, 18, 20))
patterns <- cheysson_pattern("1883_06")

## --- Reproduce: current (buggy) package functions ------------------------

p_broken <- ggplot(data, aes(category, value, fill = category)) +
  geom_col_pattern(
    aes(pattern_type = category, pattern_fill = category, pattern_angle = category),
    pattern = "stripe", pattern_density = 0.35, color = "black"
  ) +
  scale_fill_cheysson_pattern("1883_06") +
  scale_pattern_fill_cheysson("1883_06") +
  scale_pattern_type_cheysson("1883_06") +
  scale_pattern_angle_cheysson("1883_06") +
  labs(title = "BROKEN: current scale_pattern_*_cheysson()") +
  theme_minimal() + theme(legend.position = "none")

ggsave("dev/colorpat/test_broken.png", p_broken, width = 7, height = 5,
       dpi = 120, device = ragg::agg_png)

b <- ggplot_build(p_broken)
cat("Broken: pattern_fill values (should vary, all come out 'transparent'):\n")
print(unique(b$data[[1]]$pattern_fill))

## --- Fix, applied from calling code (no R/ changes) -----------------------
## scale_pattern_manual()/scale_pattern_fill_manual() are ggpattern's own
## constructors; feeding them from cheysson_pattern_params() sidesteps both
## bugs without needing to edit scale_pattern_type_cheysson()/
## scale_pattern_fill_cheysson() themselves.

p_fixed <- ggplot(data, aes(category, value, fill = category)) +
  geom_col_pattern(
    aes(pattern = category, pattern_fill = category, pattern_angle = category),
    pattern_density = 0.35, color = "black"
  ) +
  scale_fill_cheysson_pattern("1883_06") +
  scale_pattern_manual(values = cheysson_pattern_params(patterns, "pattern_type")) +
  scale_pattern_fill_manual(values = cheysson_pattern_params(patterns, "pattern_fill")) +
  scale_pattern_angle_cheysson("1883_06") +
  labs(title = "FIXED: pattern/pattern_fill computed correctly") +
  theme_minimal() + theme(legend.position = "none")

ggsave("dev/colorpat/test_fixed.png", p_fixed, width = 7, height = 5,
       dpi = 120, device = ragg::agg_png)

cat("\nSaved dev/colorpat/test_broken.png and test_fixed.png\n")

## --- The actual R/ fix, for reference (not applied) ------------------------
## In scale_pattern_type_cheysson():
##   aesthetics = "pattern_type"   ->   aesthetics = "pattern"
## In scale_pattern_fill_cheysson():
##   cheysson_pattern_params(patterns, "fill")   ->   cheysson_pattern_params(patterns, "pattern_fill")
