# Region Column Fix

## Issue

The `map-by-region` chunk in the Guerry vignette failed with:
```
Error in `geom_sf()`:
! Problem while computing aesthetics.
! object 'Region' not found
```

## Root Cause

Both the `gfrance85` spatial data and the `Guerry` dataset contain a `Region` column:

```r
# Both have Region column
gfrance85@data:  dept, Region, Department, ...
Guerry:          dept, Region, Department, ...
```

When merging:
```r
france_data <- merge(france_sf, guerry_ranked, by = "Department", all.x = TRUE)
```

R automatically renames duplicate columns to `Region.x` and `Region.y`, so the simple reference to `Region` fails.

## Solution

Added dynamic column name detection:

```r
# Check which column name exists after merge
region_col <- if("Region" %in% names(france_data)) {
  "Region"
} else if("Region.x" %in% names(france_data)) {
  "Region.x"
} else {
  "Region.y"
}

# Use .data[[]] for programmatic column access
ggplot(france_data) +
  geom_sf(aes(fill = .data[[region_col]]), ...)
```

This approach:
1. Checks which column name exists
2. Uses `.data[[]]` for programmatic access in ggplot2
3. Falls back gracefully if column names change

## Alternative Solutions Considered

### 1. Select Columns Before Merge
```r
# Only include Region from spatial data
france_data <- merge(
  france_sf,
  guerry_ranked %>% select(-Region),
  by = "Department"
)
```

### 2. Rename After Merge
```r
france_data <- merge(france_sf, guerry_ranked, by = "Department")
france_data$Region <- france_data$Region.x
```

### 3. Use Spatial Data Directly
```r
# Just use france_sf which already has Region
ggplot(france_sf) +
  geom_sf(aes(fill = Region), ...)
```

The dynamic detection approach was chosen because it's most robust to potential changes in the data structure.

## Files Modified

1. `vignettes/guerry-maps.Rmd` - Added dynamic region column detection
2. `DESCRIPTION` - Added `dplyr` to Suggests (used in faceted map)
3. `dev/REGION_COLUMN_FIX.md` - This documentation

## Testing

```r
# Test the vignette
devtools::build_vignettes()

# Or test just the Guerry map
source("dev/test_guerry_map.R")
```

The vignette should now build successfully!
