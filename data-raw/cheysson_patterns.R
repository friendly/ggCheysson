# Create cheysson_patterns data object for the package
library(here)
library(tidyverse)

# Read the CSV mapping file
album_info <- read_csv(here("data-raw/observable/albumColors.csv"))

# Load parsed patterns
load(here("dev/svg_patterns.RData"))

# Create a structured patterns object organized by album/plate
cheysson_patterns <- list()

for (dec_day in names(all_patterns)) {
  # Get album info
  info <- album_info %>%
    filter(adventDay == as.numeric(dec_day))

  if (nrow(info) == 0) next

  # Create palette name
  album_year <- info$Album[1]
  album_plate <- sprintf("%02d", info$Qty[1])
  palette_name <- paste0(album_year, "_", album_plate)

  # Get patterns for this palette
  dec_patterns <- all_patterns[[dec_day]]

  # Extract pattern specs
  pattern_specs <- list()

  for (i in seq_along(dec_patterns)) {
    pat <- dec_patterns[[i]]

    if (is.null(pat$type)) next

    if (pat$type == "solid") {
      # Solid fill pattern
      spec <- list(
        type = "solid",
        fill = pat$fill_color,
        pattern = "none"
      )
    } else if (pat$type == "lines") {
      # Line pattern (hatch)
      # Ensure fill is a valid color, not "none"
      fill_col <- pat$fill_color
      if (is.na(fill_col) || fill_col == "none") {
        fill_col <- "transparent"
      }

      spec <- list(
        type = "stripe",
        fill = fill_col,
        pattern_fill = pat$line_color,
        pattern_color = pat$line_color,
        pattern_angle = pat$angle,
        pattern_density = 1 - (pat$spacing / 100),  # Inverse relationship
        pattern_spacing = pat$spacing / 100,
        pattern_linewidth = pat$line_width %||% 1,
        direction = pat$direction %||% "unknown"
      )
    } else if (pat$type == "crosshatch") {
      # Crosshatch pattern
      # Ensure fill is a valid color, not "none"
      fill_col <- pat$fill_color
      if (is.na(fill_col) || fill_col == "none") {
        fill_col <- "transparent"
      }

      spec <- list(
        type = "crosshatch",
        fill = fill_col,
        pattern_fill = pat$line_color,
        pattern_color = pat$line_color,
        pattern_density = 1 - (pat$spacing / 100),
        pattern_spacing = pat$spacing / 100,
        pattern_linewidth = pat$line_width %||% 1
      )
    }

    pattern_specs[[i]] <- spec
  }

  # Store with metadata
  cheysson_patterns[[palette_name]] <- list(
    patterns = pattern_specs,
    type = tolower(info$Type[1]),
    album = album_year,
    plate = info$Qty[1],
    rumsey_no = info$RumseyListNo[1],
    dec_day = as.numeric(dec_day),
    n_patterns = length(pattern_specs)
  )
}

# Sort by name
cheysson_patterns <- cheysson_patterns[order(names(cheysson_patterns))]

# Save as package data
usethis::use_data(cheysson_patterns, overwrite = TRUE)

# Print summary
cat("Created cheysson_patterns with", length(cheysson_patterns), "palettes\n\n")

cat("Sample patterns:\n")
for (i in 1:min(3, length(cheysson_patterns))) {
  pal_name <- names(cheysson_patterns)[i]
  pal <- cheysson_patterns[[pal_name]]

  cat(sprintf("\n%s (%s, %d patterns):\n", pal_name, pal$type, pal$n_patterns))

  for (j in seq_along(pal$patterns)) {
    pat <- pal$patterns[[j]]
    if (!is.null(pat)) {
      cat(sprintf("  [%d] %s", j, pat$type))
      if (pat$type == "solid") {
        cat(sprintf(": %s\n", pat$fill))
      } else {
        cat(sprintf(": %s @ %.0f°\n",
                    pat$pattern_color %||% "none",
                    pat$pattern_angle %||% 0))
      }
    }
  }
}

cat("\n\nPattern type distribution:\n")
all_types <- character()
for (pal in cheysson_patterns) {
  for (pat in pal$patterns) {
    if (!is.null(pat) && !is.null(pat$type)) {
      all_types <- c(all_types, pat$type)
    }
  }
}
print(table(all_types))
