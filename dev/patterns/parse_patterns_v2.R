# Parse pattern information from SVG files - Version 2
library(here)
library(tidyverse)

# Function to analyze line direction
get_line_angle <- function(x1, y1, x2, y2) {
  dx <- x2 - x1
  dy <- y2 - y1
  angle <- atan2(dy, dx) * 180 / pi
  # Normalize to 0-180
  angle <- abs(angle) %% 180
  return(angle)
}

# Function to classify angle
classify_angle <- function(angle) {
  if (angle < 10 || angle > 170) {
    return("horizontal")
  } else if (angle >= 80 && angle <= 100) {
    return("vertical")
  } else if (angle >= 35 && angle <= 55) {
    return("diagonal_right")
  } else if (angle >= 125 && angle <= 145) {
    return("diagonal_left")
  } else {
    return("other")
  }
}

# Function to parse a single SVG file
parse_svg_patterns <- function(svg_file) {
  content <- readLines(svg_file, warn = FALSE)

  patterns <- list()
  current_pattern <- NULL
  in_pattern <- FALSE

  for (line in content) {
    # Start of pattern
    if (str_detect(line, '<pattern')) {
      in_pattern <- TRUE
      # Extract pattern ID
      id_match <- str_match(line, 'id="([^"]+)"')
      if (!is.na(id_match[1,2])) {
        current_pattern <- list(
          id = id_match[1,2],
          fill_color = NA,
          line_color = NA,
          line_width = NA,
          lines = list(),
          has_rect = FALSE,
          has_lines = FALSE
        )
      }
    }

    # End of pattern
    if (str_detect(line, '</pattern>')) {
      if (!is.null(current_pattern)) {
        # Analyze the pattern
        if (current_pattern$has_rect && !current_pattern$has_lines &&
            !is.na(current_pattern$fill_color) && current_pattern$fill_color != "none") {
          # Solid fill
          current_pattern$type <- "solid"
          current_pattern$angle <- NA
          current_pattern$spacing <- NA
        } else if (current_pattern$has_lines && length(current_pattern$lines) > 0) {
          # Analyze lines
          angles <- sapply(current_pattern$lines, function(l) l$angle)
          directions <- sapply(current_pattern$lines, function(l) l$direction)

          unique_dirs <- unique(directions)

          if (length(unique_dirs) > 1) {
            current_pattern$type <- "crosshatch"
            current_pattern$angle <- mean(angles, na.rm = TRUE)
          } else {
            current_pattern$type <- "lines"
            current_pattern$angle <- median(angles, na.rm = TRUE)
            current_pattern$direction <- unique_dirs[1]
          }

          # Estimate spacing
          current_pattern$spacing <- 100 / length(current_pattern$lines)
          current_pattern$n_lines <- length(current_pattern$lines)
        }

        patterns[[current_pattern$id]] <- current_pattern
      }
      in_pattern <- FALSE
      current_pattern <- NULL
    }

    if (in_pattern && !is.null(current_pattern)) {
      # Check for rect
      if (str_detect(line, '<rect')) {
        current_pattern$has_rect <- TRUE
        # Extract fill color
        fill_match <- str_match(line, 'fill="([^"]+)"')
        if (!is.na(fill_match[1,2])) {
          current_pattern$fill_color <- fill_match[1,2]
        }
      }

      # Check for lines
      if (str_detect(line, '<line')) {
        current_pattern$has_lines <- TRUE

        # Extract stroke color
        if (is.na(current_pattern$line_color)) {
          stroke_match <- str_match(line, 'stroke:(#[0-9a-fA-F]{3,6})')
          if (!is.na(stroke_match[1,2])) {
            current_pattern$line_color <- stroke_match[1,2]
          }
        }

        # Extract stroke width
        if (is.na(current_pattern$line_width)) {
          width_match <- str_match(line, 'stroke-width:([0-9.]+)')
          if (!is.na(width_match[1,2])) {
            current_pattern$line_width <- as.numeric(width_match[1,2])
          }
        }

        # Extract coordinates
        x1 <- str_match(line, 'x1="([^"]+)"')[1,2]
        y1 <- str_match(line, 'y1="([^"]+)"')[1,2]
        x2 <- str_match(line, 'x2="([^"]+)"')[1,2]
        y2 <- str_match(line, 'y2="([^"]+)"')[1,2]

        if (!any(is.na(c(x1, y1, x2, y2)))) {
          x1 <- as.numeric(x1)
          y1 <- as.numeric(y1)
          x2 <- as.numeric(x2)
          y2 <- as.numeric(y2)

          angle <- get_line_angle(x1, y1, x2, y2)
          direction <- classify_angle(angle)

          current_pattern$lines[[length(current_pattern$lines) + 1]] <- list(
            x1 = x1, y1 = y1, x2 = x2, y2 = y2,
            angle = angle,
            direction = direction
          )
        }
      }
    }
  }

  return(patterns)
}

# Parse all SVG files
svg_files <- list.files(here("data-raw/observable"),
                       pattern = "^dec\\d+\\.txt$",
                       full.names = TRUE)

all_patterns <- list()

cat("=== Parsing SVG Patterns ===\n\n")

for (svg_file in svg_files) {
  filename <- basename(svg_file)
  dec_day <- str_extract(filename, "\\d+")

  patterns <- parse_svg_patterns(svg_file)

  cat(sprintf("dec%02d: %d patterns\n", as.numeric(dec_day), length(patterns)))

  all_patterns[[dec_day]] <- patterns
}

# Save results
save(all_patterns, file = here("dev/svg_patterns.RData"))

# Create summary
cat("\n=== Pattern Summary ===\n\n")

pattern_types <- character()
for (day in names(all_patterns)) {
  for (pat in all_patterns[[day]]) {
    if (!is.null(pat$type)) {
      pattern_types <- c(pattern_types, pat$type)
    }
  }
}

cat("Pattern types found:\n")
print(table(pattern_types))

# Show detailed examples
cat("\n=== Example Patterns ===\n\n")
for (i in c("01", "06", "13")) {
  if (i %in% names(all_patterns)) {
    cat(sprintf("Dec %s (%d patterns):\n", i, length(all_patterns[[i]])))
    for (j in seq_along(all_patterns[[i]])) {
      pat <- all_patterns[[i]][[j]]
      cat(sprintf("  [%d] %s - Type: %s\n", j, pat$id, pat$type %||% "unknown"))

      if (!is.null(pat$type)) {
        if (pat$type == "solid") {
          cat(sprintf("      Fill: %s\n", pat$fill_color))
        } else if (pat$type %in% c("lines", "crosshatch")) {
          cat(sprintf("      Color: %s, Width: %.1f, Angle: %.0f°, Lines: %d\n",
                      pat$line_color %||% "NA",
                      pat$line_width %||% 1,
                      pat$angle %||% 0,
                      pat$n_lines %||% 0))
          if (!is.null(pat$direction)) {
            cat(sprintf("      Direction: %s\n", pat$direction))
          }
        }
      }
    }
    cat("\n")
  }
}

cat("Saved: dev/svg_patterns.RData\n")
