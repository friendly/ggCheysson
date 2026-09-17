#' Translate a palette label from another naming scheme to the current name
#'
#' Looks up a palette by whichever label you have it in - the package's own
#' (possibly outdated) name, RJ Andrews' Advent-calendar label, Tom Shanley's
#' Observable notebook ID, a David Rumsey catalog number, or an advent day -
#' and returns the current name to pass to [scale_color_cheysson()],
#' [cheysson_pal()], [cheysson_pattern()], and friends.
#'
#' @param label Character string to look up.
#' @param from Which naming scheme `label` is in:
#'   - `"auto"` (default): try, in order, the current `name`, `andrews_label`,
#'     `shanley_id`, `rumsey_no`, and finally `old_name` (see Details for why
#'     `old_name` is tried last and can be ambiguous)
#'   - `"name"`: the package's current palette name
#'   - `"andrews"`: RJ Andrews' label, e.g. "Dec.01-1883.21"
#'   - `"shanley"`: Tom Shanley's Observable ID, e.g. "diverging12514021"
#'   - `"rumsey_no"`: David Rumsey catalog number, e.g. "12514.021"
#'   - `"old_name"`: the name this palette had before the 1.1.0 naming fix -
#'     see Details, this can be ambiguous
#' @param advent_day Optional advent day (1-25) to disambiguate when `label`
#'   alone matches more than one palette (only possible for
#'   `from = "old_name"`/`"auto"`), or to assert which palette you mean even
#'   when `label` is already unambiguous. An `advent_day` that contradicts
#'   what `label` resolves to is an error.
#'
#' @returns A character string: the current palette name.
#'
#' @details
#' Before ggCheysson 1.1.0, 4 different `old_name` values were each used by
#' 2-3 genuinely different palettes (a naming collision bug - see
#' [cheysson_labels]), so translating from `old_name` alone can be
#' ambiguous. When it is, `cheysson_name()` returns the palette that
#' actually shipped under that name in 1.0.1 (the one with the highest
#' `advent_day` among the candidates - this is what the pre-fix extraction
#' logic itself picked) and issues a `warning()` listing every candidate it
#' did *not* return. Pass `advent_day` explicitly to get a different one
#' without a warning.
#'
#' @examples
#' # RJ Andrews' label -> current name
#' cheysson_name("Dec.01-1883.21")
#'
#' # Tom Shanley's ID -> current name
#' cheysson_name("diverging12514021")
#'
#' # An old (pre-1.1.0) name that's unambiguous
#' cheysson_name("1883_04", from = "old_name")
#'
#' # An old name that collided across 2 palettes: returns the one that
#' # shipped under this name in 1.0.1, with a warning
#' cheysson_name("1880_07", from = "old_name")
#'
#' # Disambiguate explicitly - no warning
#' cheysson_name("1880_07", from = "old_name", advent_day = 6)
#'
#' @seealso [cheysson_labels]
#' @export
cheysson_name <- function(label,
                           from = c("auto", "name", "andrews", "shanley",
                                     "rumsey_no", "old_name"),
                           advent_day = NULL) {
  from <- match.arg(from)

  if (!is.character(label) || length(label) != 1 || is.na(label)) {
    stop("`label` must be a single non-NA character string")
  }
  if (!is.null(advent_day)) {
    if (length(advent_day) != 1 || !advent_day %in% cheysson_labels$advent_day) {
      stop("`advent_day` must be a single value in 1:25")
    }
  }

  col_map <- c(
    name = "name",
    andrews = "andrews_label",
    shanley = "shanley_id",
    rumsey_no = "rumsey_no",
    old_name = "old_name"
  )

  find_in <- function(col) {
    cheysson_labels[cheysson_labels[[col]] == label, , drop = FALSE]
  }

  if (from == "auto") {
    # Safe, always-unique columns first; old_name (can be ambiguous) last
    search_order <- c("name", "andrews_label", "shanley_id", "rumsey_no", "old_name")
    candidates <- cheysson_labels[0, ]
    for (col in search_order) {
      hit <- find_in(col)
      if (nrow(hit) > 0) {
        candidates <- hit
        break
      }
    }
  } else {
    candidates <- find_in(col_map[[from]])
  }

  if (nrow(candidates) == 0) {
    stop(sprintf('"%s" not found (from = "%s")', label, from))
  }

  if (!is.null(advent_day)) {
    matched <- candidates[candidates$advent_day == advent_day, , drop = FALSE]
    if (nrow(matched) == 0) {
      stop(sprintf(
        'advent_day = %d contradicts label "%s": it resolves to advent_day %s, not %d',
        advent_day, label, paste(candidates$advent_day, collapse = ", "), advent_day
      ))
    }
    return(matched$name[1])
  }

  if (nrow(candidates) > 1) {
    winner <- candidates[which.max(candidates$advent_day), ]
    others <- candidates[candidates$advent_day != winner$advent_day, ]
    warning(sprintf(
      '"%s" matches %d palettes (%s). Returning advent_day %d (name "%s"), matching what 1.0.1 shipped under this name. Pass advent_day = to get a different one: %s',
      label, nrow(candidates),
      paste(sprintf('advent_day %d (now "%s")', candidates$advent_day, candidates$name),
            collapse = "; "),
      winner$advent_day, winner$name,
      paste(sprintf('%d -> "%s"', others$advent_day, others$name), collapse = ", ")
    ), call. = FALSE)
    return(winner$name)
  }

  candidates$name[1]
}
