#' Display the Cheysson swatches
#'
#' Draws an atlas of the swatches (see [cheysson_swatches]): one row per
#' palette, one column per element, with the rows grouped into panels by
#' palette type. Each cell is drawn by the registered swatch itself, so the
#' swatch for a cell is named by its row and column, e.g. row `1886_28`,
#' column 3 is `"1886_28-3"`.
#'
#' @param palettes Character vector of palette names. If NULL (default), shows
#'   all palettes. Can also be one or more palette types ("sequential",
#'   "diverging", "grouped", "category") to show all palettes of those types.
#'
#' @return A ggplot object, which draws the atlas when printed. Requires the
#'   'ggpattern' package.
#'
#' @seealso [cheysson_swatches], [scale_cheysson()], [show_palettes()]
#'
#' @examples
#' if (requireNamespace("ggpattern", quietly = TRUE)) {
#'   show_swatches("sequential")
#' }
#'
#' @importFrom rlang .data
#' @export
show_swatches <- function(palettes = NULL) {
  if (!requireNamespace("ggpattern", quietly = TRUE)) {
    stop("show_swatches() needs the 'ggpattern' package; ",
         "install it with install.packages(\"ggpattern\")", call. = FALSE)
  }
  pats <- ggCheysson::cheysson_patterns
  types <- c("sequential", "diverging", "grouped", "category")

  if (is.null(palettes)) {
    pal_names <- names(pats)
  } else if (all(tolower(palettes) %in% types)) {
    pal_names <- names(Filter(function(x) x$type %in% tolower(palettes), pats))
  } else {
    bad <- setdiff(palettes, names(pats))
    if (length(bad)) {
      stop("Unknown palette(s): ", paste(bad, collapse = ", "),
           "; see list_cheysson_patterns()", call. = FALSE)
    }
    pal_names <- palettes
  }

  df <- do.call(rbind, lapply(pal_names, function(p) {
    x <- pats[[p]]
    n <- length(x$patterns)
    data.frame(palette = p,
               type = x$type,
               element = seq_len(n),
               swatch = paste0(p, "-", seq_len(n)),
               stringsAsFactors = FALSE)
  }))
  df$type <- factor(df$type, levels = intersect(types, df$type))

  # palette names are "<album year>_<plate>"; first palette at the top of each panel
  df$row <- factor(df$palette, levels = rev(unique(pal_names)))

  n_max <- max(df$element)
  ggplot2::ggplot(df, ggplot2::aes(.data$element, .data$row)) +
    ggpattern::geom_tile_pattern(ggplot2::aes(pattern = .data$swatch),
                                 width = 0.9, height = 0.8,
                                 colour = "gray30", linewidth = 0.3) +
    ggpattern::scale_pattern_identity() +
    ggplot2::scale_x_continuous(breaks = seq_len(n_max), expand = ggplot2::expansion(add = 0.1),
                                sec.axis = ggplot2::dup_axis()) +
    ggplot2::facet_grid(type ~ ., scales = "free_y", space = "free_y", switch = "y") +
    ggplot2::labs(x = NULL, y = NULL) +
    ggplot2::theme_minimal(base_size = 11) +
    ggplot2::theme(panel.grid = ggplot2::element_blank(),
                   strip.placement = "outside",
                   strip.text.y.left = ggplot2::element_text(angle = 90, face = "bold"),
                   strip.background = ggplot2::element_rect(fill = "gray92", colour = NA),
                   axis.text.y = ggplot2::element_text(family = "mono", face = "bold", hjust = 0,
                                                       size = ggplot2::rel(1.1), colour = "gray10"),
                   axis.text.x = ggplot2::element_text(colour = "gray20"),
                   panel.spacing.y = ggplot2::unit(6, "pt"))
}
