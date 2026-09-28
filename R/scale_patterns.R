#' Cheysson pattern scales for ggpattern
#'
#' Pattern fill scales using Cheysson patterns from the Albums de Statistique
#' Graphique. These scales work with ggpattern geoms to apply both colors and
#' hatching patterns.
#'
#' @param palette Name of palette (e.g., "1881_12") or palette type
#'   ("sequential", "diverging", "grouped", "category"). Default is "1881_12".
#' @param reverse Whether to reverse the pattern order. Default is FALSE.
#' @param ... Additional arguments passed to ggplot2 scale functions
#'
#' @returns A ggplot2 discrete scale object for the specified pattern aesthetic
#'   (pattern_fill, pattern_fill2, pattern, pattern_angle, or pattern_density). These
#'   scales apply the historically accurate Cheysson patterns to ggpattern geoms.
#'
#' @details
#' These scales require the ggpattern package. Use with ggpattern geoms like
#' `geom_col_pattern()`, `geom_bar_pattern()`, etc.
#'
#' The scales apply multiple pattern aesthetics simultaneously:
#' - `fill`: Base fill color
#' - `pattern`: Type of pattern (none, stripe, crosshatch) - set via
#'   `scale_pattern_type_cheysson()`, which targets ggpattern's `pattern`
#'   aesthetic
#' - `pattern_fill`: Color of pattern lines
#' - `pattern_fill2`: Color of a crosshatch's second set of lines (differs
#'   from `pattern_fill` only in the two-color crosshatches of `1883_30` and
#'   `1886_17`)
#' - `pattern_angle`: Angle of stripes
#' - `pattern_density`: Density of pattern lines
#'
#' For a sequential or diverging palette with more patterns than the data has
#' levels, the scales use patterns spread over the whole palette (keeping both
#' ends), not the first ones. See [cheysson_patterns] for the stored order.
#'
#' @examples
#' \donttest{
#' # Requires ggpattern package
#' if (requireNamespace("ggpattern", quietly = TRUE)) {
#'   library(ggplot2)
#'   library(ggpattern)
#'
#'   # Basic bar chart with patterns
#'   data <- data.frame(
#'     category = LETTERS[1:4],
#'     value = c(15, 23, 18, 20)
#'   )
#'
#'   ggplot(data, aes(category, value, fill = category)) +
#'     geom_col_pattern(
#'       aes(
#'         pattern = category,
#'         pattern_fill = category,
#'         pattern_angle = category
#'       ),
#'       pattern_density = 0.3,
#'       color = "black"
#'     ) +
#'     scale_pattern_fill_cheysson("category") +
#'     scale_pattern_type_cheysson("category") +
#'     scale_pattern_angle_cheysson("category") +
#'     theme_minimal()
#' }
#' }
#'
#' @name scale_pattern_cheysson
#' @rdname scale_pattern_cheysson
NULL


#' @rdname scale_pattern_cheysson
#' @export
scale_pattern_fill_cheysson <- function(palette = "1881_12", reverse = FALSE, ...) {
  cheysson_pattern_scale(palette, reverse, "pattern_fill", "cheysson_pattern_fill", "pattern_fill", ...)
}


#' @rdname scale_pattern_cheysson
#' @export
scale_pattern_fill2_cheysson <- function(palette = "1881_12", reverse = FALSE, ...) {
  cheysson_pattern_scale(palette, reverse, "pattern_fill2", "cheysson_pattern_fill2", "pattern_fill2", ...)
}


#' @rdname scale_pattern_cheysson
#' @export
scale_pattern_type_cheysson <- function(palette = "1881_12", reverse = FALSE, ...) {
  cheysson_pattern_scale(palette, reverse, "pattern", "cheysson_pattern_type", "pattern_type", ...)
}


#' @rdname scale_pattern_cheysson
#' @export
scale_pattern_angle_cheysson <- function(palette = "1881_12", reverse = FALSE, ...) {
  cheysson_pattern_scale(palette, reverse, "pattern_angle", "cheysson_pattern_angle", "pattern_angle", ...)
}


#' @rdname scale_pattern_cheysson
#' @export
scale_pattern_density_cheysson <- function(palette = "1881_12", reverse = FALSE, ...) {
  cheysson_pattern_scale(palette, reverse, "pattern_density", "cheysson_pattern_density", "pattern_density", ...)
}


#' Apply Cheysson patterns to fill aesthetic
#'
#' Convenience function that applies the base fill color from Cheysson patterns.
#' Use in combination with pattern_* scales for full pattern effect.
#'
#' @inheritParams scale_pattern_fill_cheysson
#'
#' @returns A ggplot2 discrete scale object for the fill aesthetic. Applies
#'   the base fill colors from Cheysson patterns.
#'
#' @examples
#' \donttest{
#' # Requires ggpattern package
#' if (requireNamespace("ggpattern", quietly = TRUE)) {
#'   library(ggplot2)
#'   library(ggpattern)
#'
#'   data <- data.frame(
#'     category = LETTERS[1:4],
#'     value = c(15, 23, 18, 20)
#'   )
#'
#'   ggplot(data, aes(category, value, fill = category)) +
#'     geom_col_pattern(aes(pattern = category)) +
#'     scale_fill_cheysson_pattern("category") +
#'     scale_pattern_type_cheysson("category") +
#'     theme_minimal()
#' }
#' }
#'
#' @export
scale_fill_cheysson_pattern <- function(palette = "1881_12", reverse = FALSE, ...) {
  cheysson_pattern_scale(palette, reverse, "fill", "cheysson_fill", "fill", ...)
}


# Shared body of the scale_*_cheysson() pattern scales: a discrete scale for
# `aesthetic` whose values are parameter `param` of the palette's patterns,
# chosen for n levels by select_values(). Missing data gets no pattern: an NA
# `pattern` (or angle, density) makes ggpattern fail, so those default to
# "none"/0; colors default to NA.
cheysson_pattern_scale <- function(palette, reverse, aesthetic, scale_name, param,
                                   na.value = pattern_na_value(aesthetic), ...) {
  pal <- get_palette(palette, cheysson_patterns)
  values <- cheysson_pattern_params(pal$patterns, param)
  ggplot2::discrete_scale(
    aesthetics = aesthetic,
    scale_name = scale_name,
    palette = function(n) select_values(values, n, pal$type, reverse = reverse),
    na.value = na.value,
    ...
  )
}

pattern_na_value <- function(aesthetic) {
  switch(aesthetic,
         pattern = "none",
         pattern_angle = 0,
         pattern_density = 0,
         NA)
}
