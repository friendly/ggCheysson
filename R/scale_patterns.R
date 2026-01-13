#' Cheysson pattern scales for ggpattern
#'
#' Pattern fill scales using Cheysson patterns from the Albums de Statistique
#' Graphique. These scales work with ggpattern geoms to apply both colors and
#' hatching patterns.
#'
#' @param palette Name of palette (e.g., "1881_03") or palette type
#'   ("sequential", "diverging", "grouped", "category"). Default is "1881_03".
#' @param reverse Whether to reverse the pattern order. Default is FALSE.
#' @param ... Additional arguments passed to ggplot2 scale functions
#'
#' @returns A ggplot2 discrete scale object for the specified pattern aesthetic
#'   (pattern_fill, pattern_type, pattern_angle, or pattern_density). These
#'   scales apply the historically accurate Cheysson patterns to ggpattern geoms.
#'
#' @details
#' These scales require the ggpattern package. Use with ggpattern geoms like
#' \code{geom_col_pattern()}, \code{geom_bar_pattern()}, etc.
#'
#' The scales apply multiple pattern aesthetics simultaneously:
#' \itemize{
#'   \item \code{fill}: Base fill color
#'   \item \code{pattern_type}: Type of pattern (none, stripe, crosshatch)
#'   \item \code{pattern_fill}: Color of pattern lines
#'   \item \code{pattern_angle}: Angle of stripes
#'   \item \code{pattern_density}: Density of pattern lines
#' }
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
#'         pattern_type = category,
#'         pattern_fill = category,
#'         pattern_angle = category
#'       ),
#'       pattern = "stripe",
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
scale_pattern_fill_cheysson <- function(palette = "1881_03", reverse = FALSE, ...) {
  patterns <- cheysson_pattern(palette)

  if (reverse) {
    patterns <- rev(patterns)
  }

  # Extract fill colors
  fills <- cheysson_pattern_params(patterns, "fill")

  ggplot2::discrete_scale(
    aesthetics = "pattern_fill",
    scale_name = "cheysson_pattern_fill",
    palette = function(n) {
      if (n <= length(fills)) {
        fills[1:n]
      } else {
        rep(fills, length.out = n)
      }
    },
    ...
  )
}


#' @rdname scale_pattern_cheysson
#' @export
scale_pattern_type_cheysson <- function(palette = "1881_03", reverse = FALSE, ...) {
  patterns <- cheysson_pattern(palette)

  if (reverse) {
    patterns <- rev(patterns)
  }

  # Extract pattern types
  types <- cheysson_pattern_params(patterns, "pattern_type")

  ggplot2::discrete_scale(
    aesthetics = "pattern_type",
    scale_name = "cheysson_pattern_type",
    palette = function(n) {
      if (n <= length(types)) {
        types[1:n]
      } else {
        rep(types, length.out = n)
      }
    },
    ...
  )
}


#' @rdname scale_pattern_cheysson
#' @export
scale_pattern_angle_cheysson <- function(palette = "1881_03", reverse = FALSE, ...) {
  patterns <- cheysson_pattern(palette)

  if (reverse) {
    patterns <- rev(patterns)
  }

  # Extract angles
  angles <- cheysson_pattern_params(patterns, "pattern_angle")

  ggplot2::discrete_scale(
    aesthetics = "pattern_angle",
    scale_name = "cheysson_pattern_angle",
    palette = function(n) {
      if (n <= length(angles)) {
        angles[1:n]
      } else {
        rep(angles, length.out = n)
      }
    },
    ...
  )
}


#' @rdname scale_pattern_cheysson
#' @export
scale_pattern_density_cheysson <- function(palette = "1881_03", reverse = FALSE, ...) {
  patterns <- cheysson_pattern(palette)

  if (reverse) {
    patterns <- rev(patterns)
  }

  # Extract densities
  densities <- cheysson_pattern_params(patterns, "pattern_density")

  ggplot2::discrete_scale(
    aesthetics = "pattern_density",
    scale_name = "cheysson_pattern_density",
    palette = function(n) {
      if (n <= length(densities)) {
        densities[1:n]
      } else {
        rep(densities, length.out = n)
      }
    },
    ...
  )
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
#'     geom_col_pattern(aes(pattern_type = category), pattern = "stripe") +
#'     scale_fill_cheysson_pattern("category") +
#'     scale_pattern_type_cheysson("category") +
#'     theme_minimal()
#' }
#' }
#'
#' @export
scale_fill_cheysson_pattern <- function(palette = "1881_03", reverse = FALSE, ...) {
  patterns <- cheysson_pattern(palette)

  if (reverse) {
    patterns <- rev(patterns)
  }

  # Extract fill colors (base color, not pattern color)
  fills <- cheysson_pattern_params(patterns, "fill")

  ggplot2::discrete_scale(
    aesthetics = "fill",
    scale_name = "cheysson_fill",
    palette = function(n) {
      if (n <= length(fills)) {
        fills[1:n]
      } else {
        rep(fills, length.out = n)
      }
    },
    ...
  )
}
