# Migration aids for the palette rename in ggCheysson 1.1.0.
#
# Before 1.1.0, palettes were named `Album_Qty`, which collided; they are now
# `Album_plate` (see `cheysson_labels` and `cheysson_name()`). A 1.0.1 name
# now either doesn't exist (18 of 20) - handled by palette_not_found() - or,
# for "1880_07", silently means a different palette - handled by
# note_renamed_palette(). "1906_06" is the only name that still means the same.

.ggcheysson_env <- new.env(parent = emptyenv())

# Current name of the palette that shipped under `palette` in 1.0.1, or NULL.
# For a collided old name, 1.0.1 shipped the highest advent_day (as in
# cheysson_name()).
old_name_target <- function(palette) {
  hit <- cheysson_labels[cheysson_labels$old_name == palette, , drop = FALSE]
  if (nrow(hit) == 0) return(NULL)
  hit$name[which.max(hit$advent_day)]
}

# Error for an unknown palette name, pointing an old (1.0.1) name to its new one
palette_not_found <- function(palette, available) {
  new <- old_name_target(palette)
  if (!is.null(new)) {
    stop(sprintf(
      paste0("Palette '%s' was renamed in ggCheysson 1.1.0: ",
             "the palette called '%s' in 1.0.1 is now '%s'.\n",
             "See ?cheysson_name to translate old palette names."),
      palette, palette, new
    ), call. = FALSE)
  }
  stop(sprintf("Palette '%s' not found. Available palettes: %s",
               palette, paste(available, collapse = ", ")), call. = FALSE)
}

# Once per session, note that "1880_07" changed meaning in 1.1.0
note_renamed_palette <- function(palette) {
  if (!identical(palette, "1880_07") || isTRUE(.ggcheysson_env$noted_1880_07)) {
    return(invisible())
  }
  .ggcheysson_env$noted_1880_07 <- TRUE
  message(
    "Note: since ggCheysson 1.1.0, '1880_07' is a different palette ",
    "(grouped, plate 7 of the 1880 album).\n",
    "The palette called '1880_07' in 1.0.1 is now '1880_21'. ",
    "This message is shown once per session."
  )
}
