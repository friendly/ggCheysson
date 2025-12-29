# Create cheysson_palettes data object for the package
library(here)
library(tidyverse)

# Read the CSV mapping file to get album/plate info
album_info <- read_csv(here("data-raw/observable/albumColors.csv"))

# Function to extract colors from an SVG file
extract_colors_from_svg <- function(svg_file) {
  content <- read_lines(svg_file)
  svg_text <- paste(content, collapse = "\n")

  # Extract all hex colors from fill and stroke attributes
  fill_colors <- str_extract_all(svg_text, 'fill="(#[0-9a-fA-F]{6}|#[0-9a-fA-F]{3})"')[[1]]
  fill_colors <- str_extract(fill_colors, "#[0-9a-fA-F]{6}|#[0-9a-fA-F]{3}")

  stroke_colors <- str_extract_all(svg_text, 'stroke:(#[0-9a-fA-F]{6}|#[0-9a-fA-F]{3})')[[1]]
  stroke_colors <- str_extract(stroke_colors, "#[0-9a-fA-F]{6}|#[0-9a-fA-F]{3}")

  # Combine and get unique colors
  all_colors <- unique(c(fill_colors, stroke_colors))
  all_colors <- all_colors[!is.na(all_colors) & all_colors != "none"]

  return(unique(all_colors))
}

# Get all dec*.txt files
svg_files <- list.files(here("data-raw/observable"),
                       pattern = "^dec\\d+\\.txt$",
                       full.names = TRUE)

# Create the palette list with better names
cheysson_palettes <- list()

for (svg_file in svg_files) {
  filename <- basename(svg_file)
  dec_day <- as.numeric(str_extract(filename, "\\d+"))

  # Get palette info from CSV
  info <- album_info %>%
    filter(adventDay == dec_day)

  if (nrow(info) > 0) {
    # Create a more meaningful name using album year and number
    # e.g., "1880_07" for 1880 album, plate 7
    album_year <- info$Album[1]
    album_plate <- sprintf("%02d", info$Qty[1])
    palette_name <- paste0(album_year, "_", album_plate)

    # Extract colors
    colors <- extract_colors_from_svg(svg_file)

    # Store palette with metadata
    cheysson_palettes[[palette_name]] <- list(
      colors = colors,
      type = tolower(info$Type[1]),  # diverging, sequential, grouped, category
      album = album_year,
      plate = info$Qty[1],
      rumsey_no = info$RumseyListNo[1],
      dec_day = dec_day
    )
  }
}

# Sort by album year and plate number
cheysson_palettes <- cheysson_palettes[order(names(cheysson_palettes))]

# Save as package data
usethis::use_data(cheysson_palettes, overwrite = TRUE)

# Print summary
cat("Created cheysson_palettes with", length(cheysson_palettes), "palettes\n\n")
cat("Palette names:\n")
print(names(cheysson_palettes))

cat("\n\nBy type:\n")
types <- map_chr(cheysson_palettes, "type")
print(table(types))
