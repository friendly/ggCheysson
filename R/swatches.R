#' Cheysson swatches as ggpattern patterns (experimental)
#'
#' Each element of each palette in [cheysson_patterns] is registered with
#' 'gridpattern' as a pattern of its own, a *swatch*, which draws its paper
#' or fill color, hatch type, line colors and angle together. A swatch is
#' named `"<palette>-<element>"`, e.g. `"1886_28-1"`, and is used through the
#' ordinary `pattern` aesthetic of 'ggpattern', with no other pattern
#' aesthetics or geom arguments needed:
#'
#' ```
#' ggplot(df, aes(x, y, pattern = group)) +
#'   geom_col_pattern() +
#'   scale_pattern_manual(values = paste0("1886_28-", 1:6))
#' ```
#'
#' All the swatches are shown below, one row per palette, so the swatch in row
#' `1886_24`, column 2 is `"1886_24-2"`. Draw this atlas, or the part of it for
#' chosen palettes or palette types, with [show_swatches()].
#'
#' \if{html}{\figure{swatches.png}{options: width=600 alt="Atlas of all 134 Cheysson swatches: one row per palette, grouped into panels by palette type (sequential, diverging, grouped, category), with columns numbered by element; each cell shows a solid fill, stripes or crosshatching"}}
#' \if{latex}{\figure{swatches.png}{options: width=5in}}
#'
#' Other pattern aesthetics such as `pattern_fill` or `pattern_angle` are
#' ignored by a swatch, apart from `pattern_spacing`, `pattern_density` and
#' (see below) `pattern_units`.
#'
#' The swatches are registered when 'gridpattern' is loaded (it is in
#' Suggests, so ggCheysson doesn't load it), using
#' `gridpattern::register_pattern()` when available (gridpattern >= 1.5.0),
#' else the `ggpattern_geometry_funcs` option.
#'
#' @section Spacing and density:
#' The swatches of a palette keep the relative line spacings Cheysson used,
#' e.g. the hatching of sequential palette `"1888_27"` gets denser at each
#' step. Each swatch's spacing is a *base spacing*, by default 0.025, times its
#' spacing relative to the palette's typical (median) hatched swatch, as
#' measured on the plates (limited to between half and twice the base, since
#' some measurements are unreliable). All swatches draw their lines with a
#' density of 0.3.
#'
#' `pattern_spacing` sets the base spacing, so the palette keeps its
#' proportions, and `pattern_density` sets the density. What setting them
#' means depends on the installed version of 'ggpattern':
#'
#' * **ggpattern >= 1.4.0**: they replace the default base spacing and
#'   density, in `pattern_units`.
#' * **Earlier versions** (which always supply their own defaults of 0.05 and
#'   0.2): they adjust the defaults relative to those values, e.g.
#'   `pattern_spacing = 0.1` doubles the spacing.
#'
#' Either way, with `pattern_units` other than `"snpc"` (e.g. `"cm"`), the
#' default base spacing is 0.3 cm, converted to those units.
#'
#' Set them only when needed, since code that sets them may draw differently
#' when 'ggpattern' is updated.
#'
#' @name cheysson_swatches
#' @aliases cheysson-swatches
#' @seealso [cheysson_patterns], [scale_cheysson()], [show_swatches()]
NULL

# The base line spacing (in "snpc", and in absolute units) and the density
swatch_spacing <- 0.025
swatch_spacing_cm <- 0.3
swatch_density <- 0.3
# ggpattern < 1.4.0 always supplies these, so "relative" mode scales against them
ggpattern_spacing <- 0.05
ggpattern_density <- 0.2

# Background for hatching on bare paper ("transparent" fill)
swatch_paper <- "white"

swatch_names <- function() {
  pats <- ggCheysson::cheysson_patterns
  unlist(lapply(names(pats), function(p) paste0(p, "-", seq_along(pats[[p]]$patterns))),
         use.names = FALSE)
}

# The spec for a swatch name, which may arrive qualified ("ggCheysson::1886_28-1").
# Read from the data directly, not via cheysson_pattern(), which would give the
# renamed-palette note for "1880_07" while drawing.
swatch_spec <- function(name) {
  name <- sub("^.*::", "", name)
  dash <- regexpr("-[0-9]+$", name)
  palette <- substr(name, 1, dash - 1)
  element <- as.integer(substring(name, dash + 1))
  ggCheysson::cheysson_patterns[[palette]]$patterns[[element]]
}

# "absolute" when ggpattern leaves unset aesthetics to the pattern's registered
# defaults (>= 1.4.0) or isn't installed (grid-only use); else "relative"
swatch_mode <- function() {
  v <- tryCatch(utils::packageVersion("ggpattern"), error = function(e) NULL)
  if (!is.null(v) && v < "1.4.0") "relative" else "absolute"
}

# Each swatch's line spacing relative to its palette's median hatched swatch, from the
# measured spacings, as a vector named by swatch. Measured crosshatch spacings count
# the lines of both directions, so they are doubled to compare with stripes (gridpattern's
# crosshatch spacing is per direction). Limited to [0.5, 2]: some palettes have
# placeholder (1883_21: all 1) or implausible (1891_19: 0.006 to 0.2, traded against
# line widths of 2 to 54) values. Solids and swatches without a measurement get 1.
swatch_spacing_ratios <- function() {
  pats <- ggCheysson::cheysson_patterns
  ratios <- lapply(names(pats), function(p) {
    spacing <- vapply(pats[[p]]$patterns, function(s) {
      if (s$type == "solid" || is.null(s$pattern_spacing)) return(NA_real_)
      s$pattern_spacing * if (s$type == "crosshatch") 2 else 1
    }, numeric(1))
    r <- spacing / stats::median(spacing, na.rm = TRUE)
    r[is.na(r)] <- 1
    stats::setNames(pmin(pmax(r, 0.5), 2), paste0(p, "-", seq_along(r)))
  })
  unlist(ratios)
}

# The base spacing in the user's pattern_units: the registered default in
# "absolute" mode, and the base that "relative" mode scales
swatch_spacing_default <- function(params, gp = NULL) {
  units <- params$pattern_units %||% "snpc"
  if (identical(units, "snpc")) swatch_spacing else
    grid::convertUnit(grid::unit(swatch_spacing_cm, "cm"), units, valueOnly = TRUE)
}

# Line spacing, density and units for gridpattern, from the pattern parameters and the
# swatch's spacing ratio; pattern_spacing is the base spacing
swatch_line_params <- function(params, mode, ratio = 1) {
  if (mode == "relative") {
    # scale the base spacing in the same units, so legend keys (which get the
    # same absolute value as the plot when units aren't "snpc") match the plot
    list(spacing = ratio * swatch_spacing_default(params) * params$pattern_spacing / ggpattern_spacing,
         density = swatch_density * params$pattern_density / ggpattern_density,
         units = params$pattern_units %||% "snpc")
  } else {
    list(spacing = ratio * params$pattern_spacing,
         density = params$pattern_density,
         units = params$pattern_units %||% "snpc")
  }
}

# A gridpattern geometry pattern function drawing any swatch, by name
make_draw_swatch <- function(mode) {
  ratios <- swatch_spacing_ratios()
  function(params, boundary_df, aspect_ratio, legend = FALSE) {
    spec <- swatch_spec(params$pattern)
    x <- boundary_df$x
    y <- boundary_df$y
    id <- boundary_df$id
    bg_col <- if (spec$type == "solid" || !identical(spec$fill, "transparent")) spec$fill else swatch_paper
    bg <- grid::polygonGrob(x, y, id = id, gp = grid::gpar(fill = bg_col, col = NA))
    if (spec$type == "solid") return(bg)
    line <- swatch_line_params(params, mode, ratios[[sub("^.*::", "", params$pattern)]])
    lines <- gridpattern::patternGrob(
      if (spec$type == "crosshatch") "gridpattern::crosshatch" else "gridpattern::stripe",
      x = x, y = y, id = id, colour = NA,
      fill = spec$pattern_fill, fill2 = spec$pattern_fill2 %||% spec$pattern_fill,
      angle = spec$pattern_angle %||% 45,
      density = line$density, spacing = line$spacing, units = line$units)
    grid::grobTree(bg, lines)
  }
}

register_swatches <- function(mode = swatch_mode()) {
  draw <- make_draw_swatch(mode)
  names <- swatch_names()
  if (exists("register_pattern", envir = asNamespace("gridpattern"), inherits = FALSE)) {
    defaults <- if (mode == "absolute") {
      list(pattern_spacing = swatch_spacing_default, pattern_density = swatch_density)
    } else {
      # so grid-only use, which gets these, scales to the swatch's own values
      list(pattern_spacing = ggpattern_spacing, pattern_density = ggpattern_density)
    }
    for (nm in names) gridpattern::register_pattern(nm, draw, defaults = defaults)
  } else {
    funcs <- getOption("ggpattern_geometry_funcs", list())
    funcs[names] <- list(draw)
    options(ggpattern_geometry_funcs = funcs)
  }
  invisible(names)
}

.onLoad <- function(libname, pkgname) {
  rlang::on_package_load("gridpattern", {
    tryCatch(register_swatches(), error = function(e) {
      warning("ggCheysson couldn't register its swatch patterns with gridpattern: ",
              conditionMessage(e), call. = FALSE)
    })
  })
}
