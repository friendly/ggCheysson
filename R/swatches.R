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
#' Each swatch draws its lines with a spacing of 0.025 and a density of 0.3,
#' unless these are set. What setting `pattern_spacing` / `pattern_density`
#' means depends on the installed version of 'ggpattern':
#'
#' * **ggpattern >= 1.4.0**: they replace the swatch's values, in
#'   `pattern_units`.
#' * **Earlier versions** (which always supply their own defaults of 0.05 and
#'   0.2): they adjust the swatch's values relative to those defaults, e.g.
#'   `pattern_spacing = 0.1` doubles the spacing.
#'
#' Either way, with `pattern_units` other than `"snpc"` (e.g. `"cm"`), the
#' swatch's own spacing is 0.3 cm, converted to those units.
#'
#' Set them only when needed, since code that sets them may draw differently
#' when 'ggpattern' is updated.
#'
#' @name cheysson_swatches
#' @aliases cheysson-swatches
#' @seealso [cheysson_patterns], [scale_cheysson()]
NULL

# The swatch's own line spacing (in "snpc", and in absolute units) and density
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

# The swatch's own spacing in the user's pattern_units: the registered default in
# "absolute" mode, and the base that "relative" mode scales
swatch_spacing_default <- function(params, gp = NULL) {
  units <- params$pattern_units %||% "snpc"
  if (identical(units, "snpc")) swatch_spacing else
    grid::convertUnit(grid::unit(swatch_spacing_cm, "cm"), units, valueOnly = TRUE)
}

# Line spacing, density and units for gridpattern, from the pattern parameters
swatch_line_params <- function(params, mode) {
  if (mode == "relative") {
    # scale the swatch's own spacing in the same units, so legend keys (which get the
    # same absolute value as the plot when units aren't "snpc") match the plot
    list(spacing = swatch_spacing_default(params) * params$pattern_spacing / ggpattern_spacing,
         density = swatch_density * params$pattern_density / ggpattern_density,
         units = params$pattern_units %||% "snpc")
  } else {
    list(spacing = params$pattern_spacing,
         density = params$pattern_density,
         units = params$pattern_units %||% "snpc")
  }
}

# A gridpattern geometry pattern function drawing any swatch, by name
make_draw_swatch <- function(mode) {
  function(params, boundary_df, aspect_ratio, legend = FALSE) {
    spec <- swatch_spec(params$pattern)
    x <- boundary_df$x
    y <- boundary_df$y
    id <- boundary_df$id
    bg_col <- if (spec$type == "solid" || !identical(spec$fill, "transparent")) spec$fill else swatch_paper
    bg <- grid::polygonGrob(x, y, id = id, gp = grid::gpar(fill = bg_col, col = NA))
    if (spec$type == "solid") return(bg)
    line <- swatch_line_params(params, mode)
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
