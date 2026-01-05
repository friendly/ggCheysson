# Cheysson Fonts Integration

## Overview

The ggCheysson package includes five authentic hand-drawn font families created by Kenneth Fields to replicate the lettering style used in the _Albums de Statistique Graphique_. These fonts add an essential element of historical authenticity to visualizations.

## Font Families

The package includes five TrueType font files (124 KB total):

### 1. Cheysson (Regular)
- **File**: `CheyssonRegular-Regular.ttf` (29.1 KB)
- **Style**: Regular serif, hand-drawn
- **Use**: Body text, axis labels, legends, general text
- **Character**: Warm, slightly irregular letterforms suggesting hand lettering

### 2. CheyssonItalic
- **File**: `CheyssonItalic-Italic.ttf` (30.3 KB)
- **Style**: Italic variant
- **Use**: Emphasis, annotations, special notes
- **Character**: Slanted version with more flowing strokes

### 3. CheyssonSansCaps
- **File**: `CheyssonSansCaps-Regular.ttf` (23.4 KB)
- **Style**: Sans-serif capitals only
- **Use**: Axis titles, category names, data labels
- **Character**: Clean, geometric capitals suitable for labeling

### 4. CheyssonOutlineCaps
- **File**: `CheyssonOutlineCaps-Regular.ttf` (14.6 KB)
- **Style**: Outlined capitals
- **Use**: Decorative titles, headings, special emphasis
- **Character**: Hollow letterforms with distinctive vintage appeal

### 5. CheyssonTitle
- **File**: `CheyssonTitle-Regular.ttf` (27.2 KB)
- **Style**: Decorative display font
- **Use**: Main plot titles, primary headings
- **Character**: Bold, artistic letterforms ideal for titles

## Installation

Fonts are automatically included in the package installation under `inst/fonts/`. They are loaded programmatically at runtime and do not need manual system installation.

## Loading Fonts

### Basic Usage

```r
library(ggCheysson)

# Load fonts (do this once per session)
load_cheysson_fonts()
#> Loaded 5 Cheysson font families using systemfonts
```

### Method Selection

The package supports two font loading backends:

**1. systemfonts (Default, Recommended)**
```r
load_cheysson_fonts(method = "systemfonts")
```
- Best for interactive use and RStudio
- Fonts work immediately in plot viewer
- No additional setup required

**2. showtext (For File Export)**
```r
load_cheysson_fonts(method = "showtext")
showtext::showtext_auto()

# Create plots...
ggsave("plot.png")

showtext::showtext_auto(FALSE)
```
- Required for high-quality PNG/PDF exports
- Better font rendering in saved files
- Requires explicit activation

## Using Fonts

### With Themes

The easiest way to use Cheysson fonts is with the included themes:

```r
library(ggplot2)

ggplot(iris, aes(Sepal.Length, Sepal.Width, color = Species)) +
  geom_point(size = 3) +
  labs(title = "Iris Dataset Analysis") +
  theme_cheysson()  # Automatically uses Cheysson fonts
```

Available themes:
- `theme_cheysson()` - Full theme with grid
- `theme_cheysson_minimal()` - Minimal grid lines
- `theme_cheysson_map()` - For cartographic visualizations

### Manual Font Selection

Use specific fonts for individual elements:

```r
ggplot(mtcars, aes(wt, mpg)) +
  geom_point() +
  labs(title = "My Analysis") +
  theme_minimal() +
  theme(
    plot.title = element_text(
      family = "CheyssonTitle",     # Title font
      size = 18
    ),
    axis.title = element_text(
      family = "CheyssonSansCaps",  # Axis labels
      size = 12
    ),
    axis.text = element_text(
      family = "Cheysson",           # Regular text
      size = 10
    ),
    legend.text = element_text(
      family = "Cheysson"
    )
  )
```

### Helper Function

Get font names programmatically:

```r
cheysson_font("title")    # "CheyssonTitle"
cheysson_font("regular")  # "Cheysson"
cheysson_font("sans")     # "CheyssonSansCaps"
cheysson_font("outline")  # "CheyssonOutlineCaps"
cheysson_font("italic")   # "CheyssonItalic"
```

## Complete Example

Combining fonts, colors, and patterns:

```r
library(ggplot2)
library(ggpattern)
library(ggCheysson)

# Load fonts
load_cheysson_fonts()

# Create data
data <- data.frame(
  category = LETTERS[1:4],
  value = c(15, 23, 18, 20)
)

# Create plot with full Cheysson aesthetic
ggplot(data, aes(category, value, fill = category)) +
  geom_col_pattern(
    aes(pattern_type = category, pattern_fill = category),
    pattern = "stripe",
    pattern_density = 0.35,
    pattern_spacing = 0.025,
    color = "black"
  ) +
  scale_fill_cheysson_pattern("1881_03") +
  scale_pattern_fill_cheysson("1881_03") +
  scale_pattern_type_cheysson("1881_03") +
  labs(
    title = "Statistical Comparison",
    subtitle = "Distribution across categories",
    x = "Category",
    y = "Value"
  ) +
  theme_cheysson() +
  theme(legend.position = "none")
```

## Checking Font Availability

Before using fonts, verify they're loaded:

```r
# Check if fonts are available
if (cheysson_fonts_available()) {
  message("Fonts ready!")
} else {
  load_cheysson_fonts()
}

# List available fonts
list_cheysson_fonts()
```

## Troubleshooting

### Fonts Not Showing

**Problem**: Plot uses system default fonts instead of Cheysson

**Solution**:
1. Ensure fonts are loaded: `load_cheysson_fonts()`
2. Check availability: `cheysson_fonts_available()`
3. Verify systemfonts is installed: `install.packages("systemfonts")`

### Export Issues

**Problem**: Fonts don't appear in saved PNG/PDF files

**Solution**: Use showtext method:
```r
load_cheysson_fonts(method = "showtext")
showtext::showtext_auto()

# Create and save plot
p <- ggplot(...) + theme_cheysson()
ggsave("plot.png", p)

showtext::showtext_auto(FALSE)
```

### RStudio Font Warnings

**Problem**: Warning messages about missing fonts in RStudio

**Solution**: This is normal. Fonts are registered programmatically and may trigger warnings. The fonts will still work correctly.

### Windows Font Rendering

**Problem**: Fonts look pixelated or jagged

**Solution**:
- Increase plot DPI: `ggsave("plot.png", dpi = 300)`
- Use PDF format: `ggsave("plot.pdf")`
- Try showtext method for better anti-aliasing

## Technical Details

### Font Registration

Fonts are registered using the systemfonts package:

```r
systemfonts::register_font(
  name = "Cheysson",
  plain = "path/to/CheyssonRegular-Regular.ttf"
)
```

### Package Structure

```
inst/fonts/
  ├── CheyssonRegular-Regular.ttf
  ├── CheyssonItalic-Italic.ttf
  ├── CheyssonSansCaps-Regular.ttf
  ├── CheyssonOutlineCaps-Regular.ttf
  └── CheyssonTitle-Regular.ttf
```

Fonts are accessed via `system.file("fonts", package = "ggCheysson")`.

### Font Licensing

These fonts were created by Kenneth Fields for use with the Cheysson style in ArcGIS Pro. They are included in this package for educational and visualization purposes, replicating the historical aesthetic of the Albums de Statistique Graphique.

## Dependencies

**Required**:
- ggplot2 (for themes and plotting)

**Suggested**:
- systemfonts (recommended for font loading)
- showtext (alternative for exports)

## Performance Notes

- Font loading is fast (~0.1 seconds for all 5 fonts)
- Fonts are loaded once per R session
- No performance impact on plot rendering
- Total font file size: ~124 KB

## Examples Gallery

All example plots are generated in `dev/font_test*.png`:

1. **font_test1_theme.png**: Basic scatter plot with theme_cheysson()
2. **font_test2_minimal.png**: Minimal theme with regression line
3. **font_test3_patterns.png**: Bar chart with patterns and fonts
4. **font_test4_faceted.png**: Faceted plot demonstrating font consistency
5. **font_test5_timeseries.png**: Time series with historical styling
6. **font_test6_specimens.png**: Font family specimens

## Credits

- **Font Design**: Kenneth Fields (ESRI)
- **Source**: [The style of Émile Cheysson](https://www.esri.com/arcgis-blog/products/arcgis-pro/mapping/the-style-of-emile-cheysson/)
- **Integration**: ggCheysson R package
- **Original Inspiration**: _Albums de Statistique Graphique_ (1879-1897)

## See Also

- `?theme_cheysson` - Theme documentation
- `?load_cheysson_fonts` - Font loading function
- `?cheysson_font` - Font name helper
- [systemfonts package](https://github.com/r-lib/systemfonts)
- [showtext package](https://github.com/yixuan/showtext)
