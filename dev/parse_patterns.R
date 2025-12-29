# Parse pattern information from SVG files
library(here)
library(tidyverse)
library(xml2)

# Function to analyze line direction from coordinates
analyze_line_direction <- function(x1, y1, x2, y2) {
  dx <- x2 - x1
  dy <- y2 - y1

  # Calculate angle in degrees
  angle <- atan2(dy, dx) * 180 / pi

  # Normalize to 0-180
  angle <- angle %% 180

  # Classify the line type
  if (abs(angle) < 10 || abs(angle - 180) < 10) {
    return(list(type = "horizontal", angle = 0))
  } else if (abs(angle - 90) < 10) {
    return(list(type = "vertical", angle = 90))
  } else if (abs(angle - 45) < 10) {
    return(list(type = "diagonal", angle = 45))
  } else if (abs(angle - 135) < 10) {
    return(list(type = "diagonal", angle = 135))
  } else {
    return(list(type = "other", angle = angle))
  }
}

# Function to parse a single SVG pattern file
parse_svg_pattern <- function(svg_file) {
  content <- read_lines(svg_file)
  svg_text <- paste(content, collapse = "\n")

  # Extract pattern blocks
  pattern_blocks <- str_extract_all(svg_text, '<pattern id="[^"]*"[^>]*>.*?</pattern>')[[1]]

  patterns <- list()

  for (block in pattern_blocks) {
    # Extract pattern ID
    pattern_id <- str_extract(block, 'id="([^"]*)"')
    pattern_id <- str_replace(pattern_id, 'id="|"', '')
    pattern_id <- str_replace_all(pattern_id, '"', '')

    # Check for solid fill (rect with fill, no lines)
    has_rect <- str_detect(block, '<rect')
    has_lines <- str_detect(block, '<line')

    # Extract fill color from rect
    rect_fill <- str_extract(block, 'fill="(#[0-9a-fA-F]{6}|#[0-9a-fA-F]{3}|none)"')
    if (!is.na(rect_fill)) {
      rect_fill <- str_extract(rect_fill, '#[0-9a-fA-F]{6}|#[0-9a-fA-F]{3}|none')
    }

    if (has_rect && !has_lines && !is.na(rect_fill) && rect_fill != "none") {
      # Solid fill pattern
      patterns[[pattern_id]] <- list(
        id = pattern_id,
        type = "solid",
        fill_color = rect_fill,
        line_color = NA,
        line_width = NA,
        angle = NA,
        spacing = NA,
        cross_hatch = FALSE
      )
    } else if (has_lines) {
      # Extract line properties
      lines <- str_extract_all(block, '<line[^>]*>')[[1]]

      if (length(lines) > 0) {
        # Get stroke color and width from first line
        first_line <- lines[1]
        stroke_match <- str_extract(first_line, 'stroke:(#[0-9a-fA-F]{6}|#[0-9a-fA-F]{3})')
        stroke_color <- if (!is.na(stroke_match)) {
          str_extract(stroke_match, '#[0-9a-fA-F]{6}|#[0-9a-fA-F]{3}')
        } else {
          NA
        }

        stroke_width_match <- str_extract(first_line, 'stroke-width:([0-9.]+)px')
        stroke_width <- if (!is.na(stroke_width_match)) {
          as.numeric(str_extract(stroke_width_match, '[0-9.]+'))
        } else {
          1
        }

        # Analyze line directions
        line_coords <- str_match_all(lines, 'x1="([^"]*)".*?y1="([^"]*)".*?x2="([^"]*)".*?y2="([^"]*)"')

        angles <- c()
        for (i in 1:length(line_coords)) {
          if (length(line_coords[[i]]) >= 5) {
            coords <- line_coords[[i]][1, 2:5]
            coords <- as.numeric(coords)
            if (!any(is.na(coords))) {
              dir_info <- analyze_line_direction(coords[1], coords[2], coords[3], coords[4])
              angles <- c(angles, dir_info$angle)
            }
          }
        }

        # Determine if cross-hatch (multiple distinct angles)
        unique_angles <- unique(round(angles))
        is_crosshatch <- length(unique_angles) > 1

        # Estimate spacing from line count
        spacing <- if (length(lines) > 1) {
          100 / length(lines) * 2  # Approximate
        } else {
          10
        }

        patterns[[pattern_id]] <- list(
          id = pattern_id,
          type = if (is_crosshatch) "crosshatch" else "lines",
          fill_color = if (!is.na(rect_fill) && rect_fill != "none") rect_fill else NA,
          line_color = stroke_color,
          line_width = stroke_width,
          angle = if (length(angles) > 0) mean(angles) else 45,
          angles = unique_angles,
          spacing = spacing,
          cross_hatch = is_crosshatch,
          n_lines = length(lines)
        )
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

  patterns <- parse_svg_pattern(svg_file)

  cat(sprintf("%s: %d patterns\n", filename, length(patterns)))

  all_patterns[[dec_day]] <- patterns
}

# Save results
save(all_patterns, file = here("dev/svg_patterns.RData"))

# Create summary
cat("\n=== Pattern Summary ===\n\n")

pattern_types <- c()
for (day in names(all_patterns)) {
  for (pat in all_patterns[[day]]) {
    pattern_types <- c(pattern_types, pat$type)
  }
}

cat("Pattern types found:\n")
print(table(pattern_types))

# Show examples
cat("\n=== Example Patterns ===\n\n")
for (i in 1:3) {
  day <- names(all_patterns)[i]
  cat(sprintf("\nDec %s:\n", day))
  for (pat in all_patterns[[day]]) {
    cat(sprintf("  %s: %s\n", pat$id, pat$type))
    if (pat$type == "solid") {
      cat(sprintf("    Fill: %s\n", pat$fill_color))
    } else {
      cat(sprintf("    Line color: %s, width: %.1f, angle: %.0f°\n",
                  pat$line_color, pat$line_width, pat$angle))
    }
  }
}

cat("\nSaved: dev/svg_patterns.RData\n")
