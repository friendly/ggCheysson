#' Cheysson Pattern Data
#'
#' Pattern specifications (fills and hatching) extracted from the Albums de
#' Statistique Graphique. These patterns combine solid colors with line hatching
#' (stripes and crosshatching) as used in Cheysson's maps.
#'
#' @format A list of 20 pattern palettes, each containing:
#' \describe{
#'   \item{patterns}{List of pattern specifications with fill colors and hatching parameters}
#'   \item{type}{Palette type: "sequential", "diverging", "grouped", or "category"}
#'   \item{album}{Year of the album}
#'   \item{plate}{Plate number within the album}
#'   \item{rumsey_no}{David Rumsey collection reference number}
#'   \item{dec_day}{Advent calendar day from original source}
#'   \item{n_patterns}{Number of patterns in the palette}
#' }
#'
#' @details
#' Each pattern specification includes:
#' \itemize{
#'   \item \strong{type}: "solid", "stripe", or "crosshatch"
#'   \item \strong{fill}: Base fill color
#'   \item \strong{pattern_fill}: Color for pattern lines
#'   \item \strong{pattern_angle}: Angle of stripes (in degrees)
#'   \item \strong{pattern_density}: Density of pattern lines (0-1)
#'   \item \strong{pattern_spacing}: Spacing between pattern lines
#'   \item \strong{pattern_linewidth}: Width of pattern lines
#' }
#'
#' @source
#' Pattern specifications digitized from the David Rumsey Map Collection
#'
#' @examples
#' # List available pattern palettes
#' names(cheysson_patterns)
#'
#' # Get patterns from a specific palette
#' cheysson_patterns$`1881_03`
#'
#' @seealso \code{\link{cheysson_pattern}}, \code{\link{scale_pattern_fill_cheysson}}
"cheysson_patterns"


#' Get Cheysson pattern specifications
#'
#' Returns pattern specifications from a Cheysson palette for use with ggpattern.
#'
#' @param palette Name of palette (e.g., "1881_03") or palette type
#'   ("sequential", "diverging", "grouped", "category").
#' @param n Number of patterns to return. If NULL, returns all patterns.
#' @param type If palette is a type name, which palette of that type to use (default 1).
#'
#' @return A list of pattern specifications suitable for ggpattern
#'
#' @examples
#' # Get all patterns from a palette
#' cheysson_pattern("1881_03")
#'
#' # Get first 3 patterns
#' cheysson_pattern("1881_03", n = 3)
#'
#' # Get patterns from a sequential palette
#' cheysson_pattern("sequential")
#'
#' @export
cheysson_pattern <- function(palette = "1881_03", n = NULL, type = 1) {
  # Check if palette exists directly
  if (palette %in% names(cheysson_patterns)) {
    pal <- cheysson_patterns[[palette]]
  } else {
    # Check if it's a type name
    palette_type <- tolower(palette)
    if (palette_type %in% c("sequential", "diverging", "grouped", "category")) {
      # Get palettes of this type
      type_palettes <- Filter(function(x) x$type == palette_type, cheysson_patterns)
      if (length(type_palettes) == 0) {
        stop(sprintf("No palettes of type '%s' found", palette_type))
      }
      if (type > length(type_palettes)) {
        stop(sprintf("Only %d palettes of type '%s' available", length(type_palettes), palette_type))
      }
      pal <- type_palettes[[type]]
    } else {
      available <- paste(names(cheysson_patterns), collapse = ", ")
      stop(sprintf("Palette '%s' not found. Available: %s", palette, available))
    }
  }

  patterns <- pal$patterns

  # Return patterns
  if (is.null(n)) {
    return(patterns)
  }

  # If n is specified, return first n patterns
  if (n <= length(patterns)) {
    return(patterns[1:n])
  } else {
    # Repeat if needed
    rep_patterns <- rep(patterns, length.out = n)
    return(rep_patterns)
  }
}


#' Extract pattern parameters for ggpattern
#'
#' Helper function to extract specific pattern parameters from a pattern spec.
#'
#' @param pattern_spec A pattern specification from cheysson_pattern()
#' @param param Parameter name to extract (e.g., "pattern_fill", "pattern_angle")
#' @param default Default value if parameter not found
#'
#' @return The parameter value or default
#'
#' @keywords internal
get_pattern_param <- function(pattern_spec, param, default = NA) {
  if (param %in% names(pattern_spec)) {
    return(pattern_spec[[param]])
  }
  return(default)
}


#' Create ggpattern-compatible pattern parameters
#'
#' Converts Cheysson pattern specifications to parameters suitable for
#' ggpattern geoms.
#'
#' @param patterns List of pattern specifications from cheysson_pattern()
#' @param param Which parameter to extract: "type", "fill", "pattern_fill",
#'   "pattern_angle", "pattern_density", "pattern_spacing", or "pattern_type"
#'
#' @return Vector of parameter values
#'
#' @examples
#' \dontrun{
#' patterns <- cheysson_pattern("1881_03")
#' cheysson_pattern_params(patterns, "fill")
#' cheysson_pattern_params(patterns, "pattern_angle")
#' }
#'
#' @export
cheysson_pattern_params <- function(patterns, param = "fill") {
  sapply(patterns, function(p) {
    if (is.null(p)) return(NA)

    switch(param,
           "fill" = p$fill %||% "transparent",
           "pattern_fill" = p$pattern_fill %||% p$fill %||% "grey50",
           "pattern_color" = p$pattern_color %||% p$pattern_fill %||% "grey50",
           "pattern_angle" = p$pattern_angle %||% 45,
           "pattern_density" = p$pattern_density %||% 0.3,
           "pattern_spacing" = p$pattern_spacing %||% 0.01,
           "pattern_linewidth" = p$pattern_linewidth %||% 0.5,
           "pattern_type" = {
             # Map our types to ggpattern types
             if (p$type == "solid") "none"
             else if (p$type == "stripe") "stripe"
             else if (p$type == "crosshatch") "crosshatch"
             else "none"
           },
           NA)
  })
}


#' List available Cheysson pattern palettes
#'
#' Returns information about available Cheysson pattern palettes.
#'
#' @param type Optional palette type to filter by: "sequential", "diverging",
#'   "grouped", or "category". If NULL (default), returns all palettes.
#'
#' @return A data frame with columns: name, type, album, plate, n_patterns
#'
#' @examples
#' # List all pattern palettes
#' list_cheysson_patterns()
#'
#' # List only sequential palettes
#' list_cheysson_patterns("sequential")
#'
#' @export
list_cheysson_patterns <- function(type = NULL) {
  # Get all palettes
  pals <- cheysson_patterns

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
    n_patterns = sapply(pals, function(x) x$n_patterns),
    row.names = NULL,
    stringsAsFactors = FALSE
  )

  return(df)
}
