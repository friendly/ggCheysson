# Extract unified color-pattern pairings from source data
# This script combines color and pattern information to document
# the true color-pattern pairs as designed by Cheysson/Andrews/Shanley

library(here)
library(tidyverse)
library(xml2)

# Load existing palette and pattern data
load(here("data/cheysson_palettes.rda"))
load(here("data/cheysson_patterns.rda"))

# Read metadata
album_info <- read_csv(here("data-raw/observable/albumColors.csv"))

# Create output directory for extraction documentation
dir.create(here("dev/colorpat_extraction"), showWarnings = FALSE)

# Function to extract SVG pattern details
extract_svg_patterns <- function(svg_file) {
  content <- read_lines(svg_file)
  svg_text <- paste(content, collapse = "\n")

  # Parse as XML
  doc <- tryCatch({
    read_xml(paste0("<root>", svg_text, "</root>"))
  }, error = function(e) {
    NULL
  })

  if (is.null(doc)) return(list())

  # Find all pattern elements
  patterns <- xml_find_all(doc, ".//pattern")

  pattern_list <- list()

  for (i in seq_along(patterns)) {
    pat <- patterns[[i]]

    # Get pattern ID
    pattern_id <- xml_attr(pat, "id")

    # Get pattern transform (contains rotation info)
    transform <- xml_attr(pat, "patternTransform")

    # Extract rotation angle if present
    angle <- NA
    if (!is.na(transform) && grepl("rotate", transform)) {
      angle_match <- str_extract(transform, "rotate\\((-?\\d+\\.?\\d*)\\)")
      if (!is.na(angle_match)) {
        angle <- as.numeric(str_extract(angle_match, "-?\\d+\\.?\\d*"))
      }
    }

    # Find all lines in this pattern
    lines <- xml_find_all(pat, ".//line")

    # Get fill rect (background)
    rects <- xml_find_all(pat, ".//rect")
    fill_color <- NA
    if (length(rects) > 0) {
      fill_color <- xml_attr(rects[[1]], "fill")
    }

    # Pattern type determination
    pattern_type <- if (length(lines) == 0) {
      "solid"
    } else {
      # Simple heuristic: if many lines, likely stripe or crosshatch
      "stripe"
    }

    # Get line color from first line
    line_color <- NA
    line_width <- NA
    if (length(lines) > 0) {
      style <- xml_attr(lines[[1]], "style")
      if (!is.na(style)) {
        # Extract stroke color
        stroke_match <- str_extract(style, "stroke:(#[0-9a-fA-F]{3,6})")
        if (!is.na(stroke_match)) {
          line_color <- str_extract(stroke_match, "#[0-9a-fA-F]{3,6}")
        }
        # Extract stroke width
        width_match <- str_extract(style, "stroke-width:(\\d+\\.?\\d*)px")
        if (!is.na(width_match)) {
          line_width <- as.numeric(str_extract(width_match, "\\d+\\.?\\d*"))
        }
      }
    }

    pattern_list[[i]] <- list(
      id = pattern_id,
      type = pattern_type,
      fill_color = fill_color,
      line_color = line_color,
      line_width = line_width,
      angle = angle,
      n_lines = length(lines)
    )
  }

  return(pattern_list)
}

# Process all palettes
all_extractions <- list()

for (dec_day in 1:25) {
  dec_file <- here("data-raw/observable", sprintf("dec%02d.txt", dec_day))

  if (!file.exists(dec_file)) next

  cat(sprintf("\n=== Processing Day %d ===\n", dec_day))

  # Get metadata
  info <- album_info %>% filter(adventDay == dec_day)
  if (nrow(info) == 0) next

  album_year <- info$Album[1]
  qty <- info$Qty[1]
  palette_type <- tolower(info$Type[1])
  rumsey_no <- info$RumseyListNo[1]

  # Create palette name
  palette_name <- paste0(album_year, "_", sprintf("%02d", qty))

  cat(sprintf("  Palette: %s (%s, %d elements)\n",
              palette_name, palette_type, qty))

  # Extract SVG patterns
  svg_patterns <- extract_svg_patterns(dec_file)

  # Get color data
  pal_colors <- cheysson_palettes[[palette_name]]$colors

  # Get pattern data
  pal_patterns <- cheysson_patterns[[palette_name]]$patterns

  # Build unified elements
  elements <- list()

  for (i in 1:qty) {
    elem <- list(
      position = i,
      label = sprintf("Element %d", i)
    )

    # Add color if available
    if (!is.null(pal_colors) && i <= length(pal_colors)) {
      elem$fill = pal_colors[i]
    } else if (!is.null(svg_patterns) && i <= length(svg_patterns)) {
      # Try to get from SVG
      elem$fill = svg_patterns[[i]]$line_color %||% NA
    }

    # Add pattern info
    if (!is.null(pal_patterns) && i <= length(pal_patterns)) {
      pat <- pal_patterns[[i]]
      elem$pattern_type = pat$type %||% "solid"
      elem$pattern_fill = pat$pattern_fill %||% pat$pattern_color %||% NA
      elem$pattern_angle = pat$pattern_angle %||% NA
      elem$pattern_density = pat$pattern_density %||% NA
      elem$pattern_spacing = pat$pattern_spacing %||% NA
    } else if (!is.null(svg_patterns) && i <= length(svg_patterns)) {
      # Use SVG data
      pat <- svg_patterns[[i]]
      elem$pattern_type = pat$type
      elem$pattern_fill = pat$line_color %||% NA
      elem$pattern_angle = pat$angle %||% NA
      elem$pattern_density = if (!is.na(pat$n_lines)) {
        min(1.0, pat$n_lines / 100)
      } else {
        NA
      }
    } else {
      elem$pattern_type = "solid"
    }

    elements[[i]] <- elem
  }

  # Store extraction
  all_extractions[[palette_name]] <- list(
    name = palette_name,
    type = palette_type,
    album = album_year,
    qty = qty,
    rumsey_no = rumsey_no,
    dec_day = dec_day,
    elements = elements,
    metadata = list(
      source_url = "https://observablehq.com/@tomshanley/cheysson-color-palettes",
      rumsey_url = info$link[1],
      extracted_date = Sys.Date()
    )
  )

  # Print summary
  for (i in seq_along(elements)) {
    elem <- elements[[i]]
    cat(sprintf("    [%d] fill=%s, pattern=%s",
                i,
                elem$fill %||% "NA",
                elem$pattern_type %||% "NA"))
    if (!is.na(elem$pattern_angle %||% NA)) {
      cat(sprintf(" @ %.0f°", elem$pattern_angle))
    }
    cat("\n")
  }
}

# Save extractions
save(all_extractions, file = here("dev/colorpat_extractions.RData"))

cat(sprintf("\n\nExtracted %d palettes\n", length(all_extractions)))
cat("Saved to: dev/colorpat_extractions.RData\n")

# Create summary document
summary_md <- c(
  "# Color-Pattern Extraction Summary",
  "",
  sprintf("**Extraction Date**: %s", Sys.Date()),
  sprintf("**Total Palettes**: %d", length(all_extractions)),
  "",
  "## Palettes by Type",
  ""
)

# Count by type
type_counts <- table(sapply(all_extractions, function(x) x$type))
for (type in names(type_counts)) {
  summary_md <- c(summary_md,
                  sprintf("- **%s**: %d palettes",
                          tools::toTitleCase(type), type_counts[[type]]))
}

summary_md <- c(summary_md,
  "",
  "## Extracted Palettes",
  ""
)

# List all palettes
for (pal_name in names(all_extractions)) {
  pal <- all_extractions[[pal_name]]
  summary_md <- c(summary_md,
    sprintf("### %s", pal_name),
    "",
    sprintf("- **Type**: %s", tools::toTitleCase(pal$type)),
    sprintf("- **Album**: %d", pal$album),
    sprintf("- **Elements**: %d", pal$qty),
    sprintf("- **Rumsey**: [%s](%s)", pal$rumsey_no, pal$metadata$rumsey_url),
    "",
    "**Elements**:",
    ""
  )

  for (i in seq_along(pal$elements)) {
    elem <- pal$elements[[i]]
    summary_md <- c(summary_md,
      sprintf("%d. Fill: `%s`, Pattern: %s",
              i,
              elem$fill %||% "NA",
              elem$pattern_type %||% "solid"))
    if (!is.na(elem$pattern_angle %||% NA)) {
      summary_md <- c(summary_md,
        sprintf("   - Angle: %.0f°, Fill: `%s`",
                elem$pattern_angle,
                elem$pattern_fill %||% "NA"))
    }
  }

  summary_md <- c(summary_md, "")
}

writeLines(summary_md, here("dev/colorpat_extraction/EXTRACTION_SUMMARY.md"))

cat("Created summary: dev/colorpat_extraction/EXTRACTION_SUMMARY.md\n")
