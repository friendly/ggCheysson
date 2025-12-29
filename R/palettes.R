#' Cheysson Color Palettes
#'
#' Color palettes extracted from the Albums de Statistique Graphique produced
#' under the direction of Émile Cheysson. These palettes are organized by
#' album year and plate number.
#'
#' @format A list of 20 color palettes, each containing:
#' \describe{
#'   \item{colors}{Character vector of hex color codes}
#'   \item{type}{Palette type: "sequential", "diverging", "grouped", or "category"}
#'   \item{album}{Year of the album}
#'   \item{plate}{Plate number within the album}
#'   \item{rumsey_no}{David Rumsey collection reference number}
#'   \item{dec_day}{Advent calendar day from original source}
#' }
#'
#' @details
#' The palettes are named using the convention `YYYY_PP` where YYYY is the
#' album year and PP is the zero-padded plate number. For example, "1880_07"
#' refers to plate 7 from the 1880 album.
#'
#' Palette types:
#' \itemize{
#'   \item \strong{Sequential} (7 palettes): Ordered colors for quantitative data
#'   \item \strong{Diverging} (2 palettes): Two contrasting colors with neutral midpoint
#'   \item \strong{Grouped} (5 palettes): Related colors for comparing groups
#'   \item \strong{Category} (6 palettes): Distinct colors for categorical data
#' }
#'
#' @source
#' Color patterns digitized by RJ Andrews from the David Rumsey Map Collection
#' \url{https://github.com/infowetrust/albumcolors}
#'
#' Observable implementation by Tom Shanley
#' \url{https://observablehq.com/@tomshanley/cheysson-color-palettes}
#'
#' @examples
#' # List available palettes
#' names(cheysson_palettes)
#'
#' # Get colors from a specific palette
#' cheysson_palettes$`1880_07`$colors
#'
#' # Find palettes by type
#' sequential_pals <- Filter(function(x) x$type == "sequential", cheysson_palettes)
#' names(sequential_pals)
#'
#' @seealso \code{\link{cheysson_pal}}, \code{\link{scale_color_cheysson}}
"cheysson_palettes"


#' Get a Cheysson color palette
#'
#' Returns colors from a specified Cheysson palette. Palettes can be referenced
#' by name (e.g., "1880_07") or by selecting a palette of a particular type.
#'
#' @param palette Name of palette (e.g., "1880_07"), or palette type
#'   ("sequential", "diverging", "grouped", "category"). If a type is specified,
#'   the first palette of that type is returned.
#' @param n Number of colors to return. If NULL, returns all colors in the palette.
#'   If n is greater than the number of colors in the palette, colors will be
#'   interpolated.
#' @param type If palette is a type name, optionally specify which palette of
#'   that type to use (default is 1 for the first).
#'
#' @return A character vector of hex color codes
#'
#' @examples
#' # Get all colors from a specific palette
#' cheysson_pal("1880_07")
#'
#' # Get 5 colors from a palette
#' cheysson_pal("1880_07", n = 5)
#'
#' # Get colors from first sequential palette
#' cheysson_pal("sequential")
#'
#' # Get colors from second category palette
#' cheysson_pal("category", type = 2)
#'
#' @export
cheysson_pal <- function(palette = "1880_07", n = NULL, type = 1) {
  # Check if palette exists directly
  if (palette %in% names(cheysson_palettes)) {
    pal <- cheysson_palettes[[palette]]
  } else {
    # Check if it's a type name
    palette_type <- tolower(palette)
    if (palette_type %in% c("sequential", "diverging", "grouped", "category")) {
      # Get palettes of this type
      type_palettes <- Filter(function(x) x$type == palette_type, cheysson_palettes)
      if (length(type_palettes) == 0) {
        stop(sprintf("No palettes of type '%s' found", palette_type))
      }
      if (type > length(type_palettes)) {
        stop(sprintf("Only %d palettes of type '%s' available", length(type_palettes), palette_type))
      }
      pal <- type_palettes[[type]]
    } else {
      available <- paste(names(cheysson_palettes), collapse = ", ")
      stop(sprintf("Palette '%s' not found. Available palettes: %s", palette, available))
    }
  }

  colors <- pal$colors

  # Return colors
  if (is.null(n)) {
    return(colors)
  }

  # If n is specified
  if (n <= length(colors)) {
    # Return first n colors
    return(colors[1:n])
  } else {
    # Interpolate colors if n > length(colors)
    colorRampPalette(colors)(n)
  }
}


#' List available Cheysson palettes
#'
#' Returns information about available Cheysson color palettes, optionally
#' filtered by type.
#'
#' @param type Optional palette type to filter by: "sequential", "diverging",
#'   "grouped", or "category". If NULL (default), returns all palettes.
#'
#' @return A data frame with columns: name, type, album, plate, n_colors
#'
#' @examples
#' # List all palettes
#' list_cheysson_pals()
#'
#' # List only sequential palettes
#' list_cheysson_pals("sequential")
#'
#' # List only category palettes
#' list_cheysson_pals("category")
#'
#' @export
list_cheysson_pals <- function(type = NULL) {
  # Get all palettes
  pals <- cheysson_palettes

  # Filter by type if specified
  if (!is.null(type)) {
    type <- tolower(type)
    pals <- Filter(function(x) x$type == type, pals)
  }

  # Create data frame
  df <- data.frame(
    name = names(pals),
    type = sapply(pals, function(x) x$type),
    album = sapply(pals, function(x) x$album),
    plate = sapply(pals, function(x) x$plate),
    n_colors = sapply(pals, function(x) length(x$colors)),
    row.names = NULL,
    stringsAsFactors = FALSE
  )

  return(df)
}
