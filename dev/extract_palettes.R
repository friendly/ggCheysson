# Extract color palettes from Observable SVG pattern files
library(here)
library(tidyverse)
library(xml2)

# Read the CSV mapping file
album_info <- read_csv(here("data-raw/observable/albumColors.csv"))

# Function to extract colors from an SVG file
extract_colors_from_svg <- function(svg_file) {
  # Read the SVG content
  content <- read_lines(svg_file)
  svg_text <- paste(content, collapse = "\n")

  # Extract all hex colors from fill and stroke attributes
  fill_colors <- str_extract_all(svg_text, 'fill="(#[0-9a-fA-F]{6}|#[0-9a-fA-F]{3})"')[[1]]
  fill_colors <- str_extract(fill_colors, "#[0-9a-fA-F]{6}|#[0-9a-fA-F]{3}")

  stroke_colors <- str_extract_all(svg_text, 'stroke:(#[0-9a-fA-F]{6}|#[0-9a-fA-F]{3})')[[1]]
  stroke_colors <- str_extract(stroke_colors, "#[0-9a-fA-F]{6}|#[0-9a-fA-F]{3}")

  # Combine and get unique colors, excluding "none"
  all_colors <- unique(c(fill_colors, stroke_colors))
  all_colors <- all_colors[!is.na(all_colors) & all_colors != "none"]

  # Return colors in order they appear
  return(unique(all_colors))
}

# Get all dec*.txt files
svg_files <- list.files(here("data-raw/observable"),
                       pattern = "^dec\\d+\\.txt$",
                       full.names = TRUE)

# Extract colors from each file
palette_list <- list()

for (svg_file in svg_files) {
  # Extract the dec number (e.g., "dec01" from "dec01.txt")
  filename <- basename(svg_file)
  dec_day <- str_extract(filename, "\\d+")
  palette_name <- paste0("dec", dec_day)

  # Extract colors
  colors <- extract_colors_from_svg(svg_file)

  # Get palette info from CSV
  info <- album_info %>%
    filter(adventDay == as.numeric(dec_day))

  if (nrow(info) > 0) {
    palette_list[[palette_name]] <- list(
      colors = colors,
      album = info$Album[1],
      rumsey_no = info$RumseyListNo[1],
      type = info$Type[1],
      n_colors = length(colors)
    )

    cat(sprintf("%-6s: %d colors, Type: %-10s Album: %s\n",
                palette_name, length(colors), info$Type[1], info$Album[1]))
  }
}

# Save palette list
save(palette_list, file = here("dev/palette_list.RData"))

# Create a summary data frame
palette_summary <- map_dfr(names(palette_list), function(name) {
  pal <- palette_list[[name]]
  tibble(
    palette = name,
    album = pal$album,
    rumsey_no = pal$rumsey_no,
    type = pal$type,
    n_colors = pal$n_colors,
    colors = list(pal$colors)
  )
})

write_csv(palette_summary %>% select(-colors),
          here("dev/palette_summary.csv"))

# Print summary statistics
cat("\n=== Summary ===\n")
cat("Total palettes:", length(palette_list), "\n")
cat("\nBy type:\n")
print(table(map_chr(palette_list, "type")))
cat("\nColor counts:\n")
print(summary(map_int(palette_list, "n_colors")))
