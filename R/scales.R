#' Cheysson color scales for ggplot2
#'
#' Color and fill scales using Cheysson palettes from the Albums de Statistique
#' Graphique.
#'
#' @param palette Name of palette (e.g., "1880_07") or palette type
#'   ("sequential", "diverging", "grouped", "category"). Default is "1880_07".
#' @param discrete Whether to use a discrete (TRUE) or continuous (FALSE) scale.
#'   Default is TRUE.
#' @param reverse Whether to reverse the palette colors. Default is FALSE.
#' @param ... Additional arguments passed to ggplot2 scale functions
#'
#' @returns A ggplot2 scale object that can be added to a plot. For discrete
#'   scales, returns a discrete_scale object. For continuous scales, returns
#'   a continuous scale object (gradient).
#'
#' @examples
#' \donttest{
#' library(ggplot2)
#'
#' # Discrete color scale
#' ggplot(iris, aes(Sepal.Length, Sepal.Width, color = Species)) +
#'   geom_point() +
#'   scale_color_cheysson()
#'
#' # Use a specific palette
#' ggplot(iris, aes(Sepal.Length, Sepal.Width, color = Species)) +
#'   geom_point() +
#'   scale_color_cheysson(palette = "1881_04")
#'
#' # Use a sequential palette for continuous data
#' ggplot(iris, aes(Sepal.Length, Sepal.Width, color = Petal.Length)) +
#'   geom_point() +
#'   scale_color_cheysson(palette = "sequential", discrete = FALSE)
#'
#' # Fill scale with category colors
#' ggplot(iris, aes(Species, Sepal.Width, fill = Species)) +
#'   geom_boxplot() +
#'   scale_fill_cheysson(palette = "category")
#' }
#'
#' @name scale_cheysson
#' @rdname scale_cheysson
NULL


#' @rdname scale_cheysson
#' @export
scale_color_cheysson <- function(palette = "1880_07", discrete = TRUE, reverse = FALSE, ...) {
  pal_colors <- cheysson_pal(palette)

  if (reverse) {
    pal_colors <- rev(pal_colors)
  }

  if (discrete) {
    ggplot2::discrete_scale("colour", "cheysson",
                           palette = function(n) {
                             if (n <= length(pal_colors)) {
                               pal_colors[1:n]
                             } else {
                               grDevices::colorRampPalette(pal_colors)(n)
                             }
                           },
                           ...)
  } else {
    ggplot2::scale_color_gradientn(colours = pal_colors, ...)
  }
}


#' @rdname scale_cheysson
#' @export
scale_colour_cheysson <- scale_color_cheysson


#' @rdname scale_cheysson
#' @export
scale_fill_cheysson <- function(palette = "1880_07", discrete = TRUE, reverse = FALSE, ...) {
  pal_colors <- cheysson_pal(palette)

  if (reverse) {
    pal_colors <- rev(pal_colors)
  }

  if (discrete) {
    ggplot2::discrete_scale("fill", "cheysson",
                           palette = function(n) {
                             if (n <= length(pal_colors)) {
                               pal_colors[1:n]
                             } else {
                               grDevices::colorRampPalette(pal_colors)(n)
                             }
                           },
                           ...)
  } else {
    ggplot2::scale_fill_gradientn(colours = pal_colors, ...)
  }
}
