#' Load Cheysson fonts
#'
#' Registers the Cheysson font families for use in plots. This function should
#' be called before using Cheysson fonts in ggplot2.
#'
#' @param method Font loading method: "systemfonts" (default) or "showtext".
#'   systemfonts is recommended for most uses. showtext is useful for saving
#'   plots to files.
#'
#' @details
#' The package includes five Cheysson font families:
#' \itemize{
#'   \item \strong{Cheysson}: Regular serif font for body text
#'   \item \strong{CheyssonItalic}: Italic variant
#'   \item \strong{CheyssonSansCaps}: Sans-serif capitals
#'   \item \strong{CheyssonOutlineCaps}: Outlined capitals for titles
#'   \item \strong{CheyssonTitle}: Decorative font for titles
#' }
#'
#' When using showtext, you must call \code{showtext::showtext_auto()} before
#' creating plots, and \code{showtext::showtext_auto(FALSE)} when done.
#'
#' \strong{Windows users}: The systemfonts method works for saved plots (with ragg)
#' but custom fonts won't appear in the on-screen plot window. For on-screen
#' preview with fonts:
#' \itemize{
#'   \item Use \code{method = "showtext"} instead, or
#'   \item In RStudio: Tools > Global Options > General > Graphics > Backend: "AGG"
#' }
#' For saving plots with systemfonts, use \code{ggsave(..., device = ragg::agg_png)}.
#'
#' @return Invisibly returns a character vector of loaded font family names
#'
#' @importFrom utils getFromNamespace
#'
#' @examples
#' \donttest{
#' # Load fonts (default method)
#' load_cheysson_fonts()
#'
#' # Use in a plot
#' library(ggplot2)
#' p <- ggplot(mtcars, aes(wt, mpg)) +
#'   geom_point() +
#'   labs(title = "Using Cheysson Fonts") +
#'   theme(
#'     text = element_text(family = "Cheysson"),
#'     plot.title = element_text(family = "CheyssonTitle")
#'   )
#'
#' # Save to temporary file
#' tmp <- tempfile(fileext = ".png")
#' if (requireNamespace("ragg", quietly = TRUE)) {
#'   ggsave(tmp, p, device = ragg::agg_png)
#' } else {
#'   ggsave(tmp, p)
#' }
#' unlink(tmp)
#' }
#'
#' @export
load_cheysson_fonts <- function(method = c("systemfonts", "showtext")) {
  method <- match.arg(method)

  # Get font directory
  font_dir <- system.file("fonts", package = "ggCheysson")

  if (!dir.exists(font_dir) || length(list.files(font_dir)) == 0) {
    stop("Font directory not found. Fonts may not be installed with the package.")
  }

  # Font file mapping
  fonts <- list(
    Cheysson = "CheyssonRegular-Regular.ttf",
    CheyssonItalic = "CheyssonItalic-Italic.ttf",
    CheyssonSansCaps = "CheyssonSansCaps-Regular.ttf",
    CheyssonOutlineCaps = "CheyssonOutlineCaps-Regular.ttf",
    CheyssonTitle = "CheyssonTitle-Regular.ttf"
  )

  loaded <- character()

  if (method == "systemfonts") {
    if (!requireNamespace("systemfonts", quietly = TRUE)) {
      stop("Package 'systemfonts' is required. Install with: install.packages('systemfonts')")
    }

    for (family in names(fonts)) {
      font_file <- file.path(font_dir, fonts[[family]])

      if (file.exists(font_file)) {
        tryCatch({
          systemfonts::register_font(
            name = family,
            plain = font_file
          )
          loaded <- c(loaded, family)
        }, error = function(e) {
          warning(sprintf("Failed to register font '%s': %s", family, e$message))
        })
      } else {
        warning(sprintf("Font file not found: %s", font_file))
      }
    }

    message(sprintf("Loaded %d Cheysson font families using systemfonts", length(loaded)))

    # Windows-specific note about graphics devices
    if (.Platform$OS.type == "windows") {
      message("\nWindows users - Important notes:")
      message("  * Fonts work in SAVED plots: use ggsave(..., device = ragg::agg_png)")
      message("  * Fonts DON'T appear in on-screen plot window with systemfonts")
      message("  * For on-screen preview: use load_cheysson_fonts(method = 'showtext')")
      message("  * Or in RStudio: Tools > Global Options > Graphics > Backend: 'AGG'")
    }

  } else if (method == "showtext") {
    if (!requireNamespace("showtext", quietly = TRUE)) {
      stop("Package 'showtext' is required. Install with: install.packages('showtext')")
    }
    if (!requireNamespace("sysfonts", quietly = TRUE)) {
      stop("Package 'sysfonts' is required (dependency of showtext). Install with: install.packages('sysfonts')")
    }

    # Get sysfonts functions (showtext uses sysfonts for font loading)
    font_add <- getFromNamespace("font_add", "sysfonts")

    for (family in names(fonts)) {
      font_file <- file.path(font_dir, fonts[[family]])

      if (file.exists(font_file)) {
        tryCatch({
          font_add(
            family = family,
            regular = font_file
          )
          loaded <- c(loaded, family)
        }, error = function(e) {
          warning(sprintf("Failed to add font '%s': %s", family, e$message))
        })
      } else {
        warning(sprintf("Font file not found: %s", font_file))
      }
    }

    message(sprintf("Loaded %d Cheysson font families using showtext", length(loaded)))
    message("Remember to call `showtext::showtext_auto()` before creating plots")
  }

  invisible(loaded)
}




#' Check if Cheysson fonts are loaded
#'
#' Checks whether Cheysson fonts have been registered and are available for use.
#'
#' @param method Check for "systemfonts" or "showtext". If NULL (default),
#'   checks both methods.
#'
#' @return Logical indicating whether fonts are available
#'
#' @examples
#' if (cheysson_fonts_available()) {
#'   message("Cheysson fonts are ready to use!")
#' }
#'
#' @export
cheysson_fonts_available <- function(method = NULL) {
  available <- FALSE

  if (is.null(method) || method == "systemfonts") {
    if (requireNamespace("systemfonts", quietly = TRUE)) {
      registered <- systemfonts::registry_fonts()
      cheysson_count <- sum(grepl("^Cheysson", registered$family))
      if (cheysson_count > 0) {
        available <- TRUE
      }
    }
  }

  if (!available && (is.null(method) || method == "showtext")) {
    if (requireNamespace("sysfonts", quietly = TRUE)) {
      tryCatch({
        font_families <- getFromNamespace("font_families", "sysfonts")
        fonts <- font_families()
        cheysson_count <- sum(grepl("^Cheysson", fonts))
        if (cheysson_count > 0) {
          available <- TRUE
        }
      }, error = function(e) {
        # Silently ignore if sysfonts function not available
      })
    }
  }

  return(available)
}


#' Get Cheysson font family name
#'
#' Returns the appropriate Cheysson font family name for a given purpose.
#'
#' @param type Font type: "regular", "italic", "sans", "outline", or "title"
#'
#' @return Character string with font family name
#'
#' @examples
#' cheysson_font("title")  # Returns "CheyssonTitle"
#' cheysson_font("regular")  # Returns "Cheysson"
#'
#' @export
cheysson_font <- function(type = c("regular", "italic", "sans", "outline", "title")) {
  type <- match.arg(type)

  switch(type,
         regular = "Cheysson",
         italic = "CheyssonItalic",
         sans = "CheyssonSansCaps",
         outline = "CheyssonOutlineCaps",
         title = "CheyssonTitle")
}
