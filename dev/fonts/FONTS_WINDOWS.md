# Using Cheysson Fonts on Windows

## The Issue

On Windows, there are two different systems for loading custom fonts in R:
1. **systemfonts** - Works for SAVED plots only (not on-screen preview)
2. **showtext** - Works for BOTH saved plots AND on-screen preview

## Quick Solutions

### Option 1: Use showtext (Recommended for Interactive Work)

```r
library(ggCheysson)

# Load fonts with showtext
load_cheysson_fonts(method = "showtext")

# Enable showtext rendering
showtext::showtext_auto()

# Create your plot - fonts will appear on screen!
p <- ggplot(mtcars, aes(wt, mpg)) +
  geom_point() +
  labs(title = "My Plot") +
  theme_cheysson()

print(p)  # Shows fonts on screen

# Save plot
ggsave("plot.png", p)  # Fonts appear in saved file

# Disable showtext when done
showtext::showtext_auto(FALSE)
```

**Pros:**
- ✅ Fonts appear on screen
- ✅ Fonts appear in saved files
- ✅ Works consistently

**Cons:**
- ⚠️ Must remember to call `showtext_auto()` before plotting
- ⚠️ Must call `showtext_auto(FALSE)` when done

### Option 2: Use systemfonts + ragg (For Production/Scripted Work)

```r
library(ggCheysson)

# Load fonts with systemfonts (default)
load_cheysson_fonts()

# Create your plot - fonts WON'T appear on screen (expected!)
p <- ggplot(mtcars, aes(wt, mpg)) +
  geom_point() +
  labs(title = "My Plot") +
  theme_cheysson()

# Save with ragg device - fonts WILL appear in saved file
ggsave("plot.png", p, device = ragg::agg_png)
```

**Pros:**
- ✅ Simpler code (no need for showtext_auto)
- ✅ Better for automated/scripted workflows

**Cons:**
- ❌ Fonts don't appear in on-screen preview
- ⚠️ Requires ragg package

### Option 3: Configure RStudio to use AGG Backend

If you're using RStudio and want on-screen preview with systemfonts:

1. Go to: **Tools** > **Global Options** > **General** > **Graphics**
2. Set **Backend** to: **AGG**
3. Restart RStudio
4. Now systemfonts will work on screen!

```r
library(ggCheysson)
load_cheysson_fonts()  # Now works on screen with AGG backend!

p <- ggplot(mtcars, aes(wt, mpg)) +
  geom_point() +
  theme_cheysson()

print(p)  # Fonts will appear!
```

## Comparison Table

| Method | On-Screen | Saved Files | Setup Complexity |
|--------|-----------|-------------|------------------|
| **showtext** | ✅ Yes | ✅ Yes | Medium (need auto on/off) |
| **systemfonts + ragg** | ❌ No | ✅ Yes | Low (just use ragg device) |
| **systemfonts + RStudio AGG** | ✅ Yes | ✅ Yes | One-time setup |

## Recommendation

- **For interactive data exploration**: Use **showtext** method
- **For automated reports/scripts**: Use **systemfonts + ragg**
- **If you use RStudio**: Configure **AGG backend** (best of both worlds!)

## Why This Happens

Windows' default graphics device (the built-in `windows()` device) doesn't support fonts registered through systemfonts. It only recognizes fonts installed in the Windows font directory. The ragg package provides a modern graphics device that properly supports custom fonts, but only for saving files, not for on-screen display.

The showtext package works differently - it renders text as graphics rather than using the system's font rendering, which is why it works everywhere.

## Test Scripts

Run these to verify your setup:

```r
# Test systemfonts + ragg (fonts in saved file only)
source("dev/test_ragg_fonts.R")

# Test showtext (fonts on screen AND in saved file)
source("dev/test_showtext_fonts.R")
```

## Need Help?

Check if fonts are loaded:
```r
cheysson_fonts_available()
list_cheysson_fonts()
```

See the loaded font registry:
```r
systemfonts::registry_fonts()[grepl("Cheysson", systemfonts::registry_fonts()$family),]
```
