#' Correction factor for a Cheysson display font's undersized metrics
#'
#' The four non-body Cheysson font families (`CheyssonSansCaps`,
#' `CheyssonTitle`, `CheyssonItalic`, `CheyssonOutlineCaps`) each measure
#' smaller than a typical sans font (Arial) at the same nominal point size -
#' a common trait of hand-drawn/all-caps/decorative designs, which have less
#' ascender/descender space filling out the type's em box. Sizes for text set
#' in one of these families are scaled up by this factor so they read at
#' roughly the intended visual size, rather than shrinking further on top of
#' an already-undersized glyph. Factors were derived from
#' `systemfonts::font_info()` (`max_ascend`, `lineheight` vs Arial at size
#' 11), landing between the ascent-ratio-implied and lineheight-ratio-implied
#' corrections for each family; `CheyssonSansCaps` and `CheyssonTitle` were
#' additionally checked against rendered comparisons (see
#' `dev/fonts/test_title_size_fix.R`).
#'
#' @param family A font family name.
#' @return A numeric scaling factor (1 if `family` isn't one of the four
#'   known undersized display fonts).
#' @keywords internal
cheysson_font_size_adjust <- function(family) {
  switch(family,
    CheyssonSansCaps = 1.15,
    CheyssonTitle = 1.10,
    CheyssonItalic = 1.12,
    CheyssonOutlineCaps = 1.30,
    1
  )
}


#' Cheysson theme for ggplot2
#'
#' A ggplot2 theme inspired by the visual style of the _Albums de Statistique
#' Graphique_, using Cheysson fonts and appropriate styling.
#'
#' @param base_size Base font size (default: 11)
#' @param base_family Base font family. If "auto" (default), uses Cheysson if
#'   available, otherwise falls back to sans-serif
#' @param title_family Font family for titles (default: "auto")
#' @param axis_title_family Font family for axis titles (default: "auto")
#' @param load_fonts Automatically load Cheysson fonts if not already loaded
#'   (default: TRUE)
#'
#' @details
#' This theme applies the following styling:
#' - Cheysson fonts for all text elements
#' - Minimal grid lines
#' - Classic axis styling
#' - Subtle colors matching historical aesthetics
#'
#' Font selection:
#' - Plot title: CheyssonTitle (decorative)
#' - Axis titles: CheyssonSansCaps (capitals)
#' - Body text: Cheysson (regular)
#'
#' @importFrom ggplot2 theme_bw
#' @return A ggplot2 theme object
#'
#' @examples
#' \dontrun{
#' # Not run automatically: rendering text with a Cheysson font registered via
#' # systemfonts can crash grid with "invalid font type" on some graphics
#' # devices (reproduced under R CMD check --as-cran); works fine interactively.
#' library(ggplot2)
#'
#' # Load fonts first (required for proper rendering)
#' load_cheysson_fonts()
#'
#' # Basic usage
#' ggplot(mtcars, aes(wt, mpg)) +
#'   geom_point() +
#'   labs(title = "Automobile Statistics") +
#'   theme_cheysson()
#'
#' # With Cheysson color palette
#' ggplot(iris, aes(Sepal.Length, Sepal.Width, color = Species)) +
#'   geom_point(size = 3) +
#'   scale_color_cheysson("1881_22") +
#'   theme_cheysson()
#' }
#'
#' @export
theme_cheysson <- function(base_size = 11,
                          base_family = "auto",
                          title_family = "auto",
                          axis_title_family = "auto",
                          load_fonts = TRUE) {

  # Attempt to load fonts if requested
  if (load_fonts && !cheysson_fonts_available()) {
    tryCatch({
      load_cheysson_fonts(method = "systemfonts")
    }, error = function(e) {
      warning("Could not load Cheysson fonts. Using system defaults.")
    })
  }

  # Determine font families
  fonts_available <- cheysson_fonts_available()

  if (base_family == "auto") {
    base_family <- if (fonts_available) "Cheysson" else "sans"
  }

  if (title_family == "auto") {
    title_family <- if (fonts_available) "CheyssonTitle" else base_family
  }

  if (axis_title_family == "auto") {
    axis_title_family <- if (fonts_available) "CheyssonSansCaps" else base_family
  }

  # See cheysson_font_size_adjust(): CheyssonSansCaps and CheyssonTitle both
  # measure smaller than a typical sans font at the same nominal point size,
  # so text set in either is scaled back up to read at roughly the intended
  # visual size.
  axis_title_size_adjust <- cheysson_font_size_adjust(axis_title_family)
  title_size_adjust <- cheysson_font_size_adjust(title_family)

  # Base theme
  theme_bw(base_size = base_size, base_family = base_family) +
    ggplot2::theme(
      # Text elements
      text = ggplot2::element_text(family = base_family),

      # Plot title
      plot.title = ggplot2::element_text(
        family = title_family,
        size = base_size * 1.4 * title_size_adjust,
        face = "plain",
        hjust = 0,
        margin = ggplot2::margin(b = base_size * 0.8)
      ),

      plot.subtitle = ggplot2::element_text(
        family = base_family,
        size = base_size * 1.1,
        face = "plain",
        hjust = 0,
        margin = ggplot2::margin(b = base_size * 0.6)
      ),

      # Axis titles
      axis.title = ggplot2::element_text(
        family = axis_title_family,
        size = base_size * 0.95 * axis_title_size_adjust
      ),

      axis.title.x = ggplot2::element_text(
        margin = ggplot2::margin(t = base_size * 0.5)
      ),

      axis.title.y = ggplot2::element_text(
        margin = ggplot2::margin(r = base_size * 0.5),
        angle = 90
      ),

      # Axis text
      axis.text = ggplot2::element_text(
        family = base_family,
        size = base_size * 0.85,
        color = "grey30"
      ),

      # Legend
      legend.title = ggplot2::element_text(
        family = axis_title_family,
        size = base_size * 0.95 * axis_title_size_adjust
      ),

      legend.text = ggplot2::element_text(
        family = base_family,
        size = base_size * 0.85
      ),

      legend.background = ggplot2::element_rect(
        fill = "white",
        color = "grey70",
        linewidth = 0.3
      ),

      legend.key = ggplot2::element_rect(
        fill = "white",
        color = NA
      ),

      # Panel
      panel.background = ggplot2::element_rect(
        fill = "#fefefe",
        color = NA
      ),

      panel.border = ggplot2::element_rect(
        fill = NA,
        color = "grey40",
        linewidth = 0.5
      ),

      panel.grid.major = ggplot2::element_line(
        color = "grey85",
        linewidth = 0.3
      ),

      panel.grid.minor = ggplot2::element_line(
        color = "grey92",
        linewidth = 0.2
      ),

      # Strip (facet labels)
      strip.background = ggplot2::element_rect(
        fill = "grey90",
        color = "grey40",
        linewidth = 0.5
      ),

      strip.text = ggplot2::element_text(
        family = axis_title_family,
        size = base_size * 0.95 * axis_title_size_adjust,
        margin = ggplot2::margin(4, 4, 4, 4)
      ),

      # Plot background
      plot.background = ggplot2::element_rect(
        fill = "#fefefe",
        color = NA
      ),

      plot.margin = ggplot2::margin(
        base_size * 0.8,
        base_size * 0.8,
        base_size * 0.8,
        base_size * 0.8
      )
    )
}


#' Minimal Cheysson theme
#'
#' A more minimal version of theme_cheysson with fewer grid lines,
#' suitable for maps and diagrams.
#'
#' @inheritParams theme_cheysson
#'
#' @returns A ggplot2 theme object that can be added to a plot with `+`.
#'
#' @examples
#' \dontrun{
#' # Not run automatically: see theme_cheysson() for why (same font/grid crash).
#' library(ggplot2)
#'
#' # Load fonts first
#' load_cheysson_fonts()
#'
#' ggplot(mtcars, aes(wt, mpg)) +
#'   geom_point() +
#'   theme_cheysson_minimal()
#' }
#'
#' @export
theme_cheysson_minimal <- function(base_size = 11,
                                   base_family = "auto",
                                   title_family = "auto",
                                   axis_title_family = "auto",
                                   load_fonts = TRUE) {

  theme_cheysson(
    base_size = base_size,
    base_family = base_family,
    title_family = title_family,
    axis_title_family = axis_title_family,
    load_fonts = load_fonts
  ) +
    ggplot2::theme(
      panel.grid.major = ggplot2::element_line(
        color = "grey90",
        linewidth = 0.25
      ),
      panel.grid.minor = ggplot2::element_blank(),
      axis.ticks = ggplot2::element_line(
        color = "grey40",
        linewidth = 0.3
      ),
      axis.ticks.length = grid::unit(0.15, "cm")
    )
}


#' Cheysson map theme
#'
#' A theme specifically designed for maps, with no grid and minimal elements,
#' in the style of Cheysson's cartographic works.
#'
#' @inheritParams theme_cheysson
#'
#' @returns A ggplot2 theme object that can be added to a plot with `+`.
#'
#' @examples
#' \dontrun{
#' # Not run automatically: see theme_cheysson() for why (same font/grid crash)
#' # once a plot with this theme is actually rendered/printed.
#' # For use with spatial data/maps
#' library(ggplot2)
#'
#' # Load fonts first
#' load_cheysson_fonts()
#'
#' # Example with spatial data (requires sf package)
#' if (requireNamespace("sf", quietly = TRUE)) {
#'   # ggplot(map_data) + geom_sf() + theme_cheysson_map()
#' }
#' }
#'
#' @export
theme_cheysson_map <- function(base_size = 11,
                               base_family = "auto",
                               title_family = "auto",
                               load_fonts = TRUE) {

  # Attempt to load fonts if requested
  if (load_fonts && !cheysson_fonts_available()) {
    tryCatch({
      load_cheysson_fonts(method = "systemfonts")
    }, error = function(e) {
      warning("Could not load Cheysson fonts. Using system defaults.")
    })
  }

  fonts_available <- cheysson_fonts_available()

  if (base_family == "auto") {
    base_family <- if (fonts_available) "Cheysson" else "sans"
  }

  if (title_family == "auto") {
    title_family <- if (fonts_available) "CheyssonTitle" else base_family
  }

  # See cheysson_font_size_adjust().
  title_size_adjust <- cheysson_font_size_adjust(title_family)

  # A poster-style hierarchy in the spirit of Guerry's own maps, whose titles
  # nearly filled the map's width - deliberately not the modest title/body
  # ratio theme_cheysson() uses. All still scale together from base_size.
  ggplot2::theme_void(base_size = base_size, base_family = base_family) +
    ggplot2::theme(
      # Title
      plot.title = ggplot2::element_text(
        family = title_family,
        size = base_size * 5.0 * title_size_adjust,
        face = "plain",
        hjust = 0.5,
        margin = ggplot2::margin(b = base_size)
      ),

      plot.subtitle = ggplot2::element_text(
        family = base_family,
        size = base_size * 3.2,
        hjust = 0.5,
        margin = ggplot2::margin(b = base_size * 0.5)
      ),

      # Legend
      legend.title = ggplot2::element_text(
        family = base_family,
        size = base_size * 1.5
      ),

      legend.text = ggplot2::element_text(
        family = base_family,
        size = base_size * 1.3
      ),

      # Caption
      plot.caption = ggplot2::element_text(
        family = base_family,
        size = base_size * 1.1
      ),

      # Background
      plot.background = ggplot2::element_rect(
        fill = "#fefefe",
        color = NA
      ),

      plot.margin = ggplot2::margin(
        base_size,
        base_size,
        base_size,
        base_size
      )
    )
}
