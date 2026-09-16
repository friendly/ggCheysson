# Create the cheysson_labels data object for the package: one row per advent
# day (25 rows), tying together every naming scheme that touches these
# palettes, so a palette can be looked up by whichever label a given source
# uses. Started as a throwaway dev/colorpat/ diagnostic for the Album+Qty
# naming collision bug (dev/TASKS.md, PATTERN_SCALE_BUGS.md is the separate
# pattern-aesthetic bugs) - promoted to a real package dataset 2026-09-16,
# since it's directly useful beyond that one bug: a documented way to specify
# a palette by advent day, Rumsey plate, or either external (Andrews/Shanley)
# label, not just the package's own `name`.
#
# Build-order dependency: must be run *after* cheysson_palettes.R and
# cheysson_patterns.R (and the package reloaded), since `name` is read back
# from names(cheysson_palettes) rather than recomputed independently - that
# guarantees it always matches reality instead of silently drifting if the
# naming logic ever changes again.
#
# Column notes:
# - name: the actual current package name (matches names(cheysson_palettes)/
#   names(cheysson_patterns) exactly for every row) - use this to look a
#   palette up, e.g. scale_color_cheysson("1881_22").
#
# - plate: NOT a field that exists anywhere in the source data as such. This
#   is RumseyListNo's decimal suffix (e.g. 12514.021 -> 21), which functions
#   as a de facto unique plate identifier - it's what both RJ Andrews'
#   ("Dec.01-1883.21") and Tom Shanley's ("diverging12541021") labels encode,
#   confirmed against every ID legible in man/figures/shanley-palettes.png
#   (24/24 resolved to a unique adventDay; 2 had isolated typos in Shanley's
#   ID string itself - digit transposition, and a missing trailing digit -
#   his own prose descriptions and Andrews' labels do not have these typos).
#   This is Rumsey's own catalog suffix, not necessarily Cheysson's original
#   plate/page number from the physical Albums - that isn't recoverable from
#   any source data available in this repo. `name` is built from this.
#
# - qty: kept from the source CSV for reference. Despite the name, it is NOT
#   a plate discriminator - it matched the pre-fix shipped pattern-element
#   count for 18/20 palettes (checked against actual
#   length(cheysson_patterns[[name]]$patterns); 2 mismatches - adventDay 5
#   and 22, not investigated further), strongly suggesting it's a
#   swatch/element count, not an identifier. That's exactly why two
#   genuinely different plates could share a Qty value and collide under the
#   old Album+Qty naming scheme.
#
# - old_name: the name data-raw/cheysson_palettes.R / cheysson_patterns.R
#   assigned before the 2026-09-16 fix, via paste0(Album, "_", sprintf("%02d",
#   Qty)) - not unique (see the 4 collisions below); 5 of these 25 rows were
#   silently dropped under this scheme (see dev/TASKS.md). Kept so the
#   collision history stays documented even though `name` is now correct.
#
# - andrews_label / shanley_id: derived programmatically from the verified
#   rule (type + adventDay + Album + plate), not scraped from either image -
#   both are believed correct even for the 2 adventDays where Shanley's own
#   site has a typo.

library(here)
library(readr)
library(dplyr)
devtools::load_all(quiet = TRUE)

album_info <- read_csv(here("data-raw/observable/albumColors.csv"),
                        col_types = cols(RumseyListNo = "c", .default = "c")) |>
  transform(adventDay = as.integer(adventDay))

dec_to_name <- setNames(names(cheysson_patterns),
                         sapply(cheysson_patterns, `[[`, "dec_day"))

cheysson_labels <- lapply(seq_len(nrow(album_info)), function(i) {
  row <- album_info[i, ]
  day <- row$adventDay
  plate <- as.integer(sub("^[0-9]+\\.", "", row$RumseyListNo))
  qty <- as.integer(row$Qty)
  album_year <- as.integer(row$Album)
  type <- row$Type
  name <- unname(dec_to_name[as.character(day)])
  old_name <- paste0(album_year, "_", sprintf("%02d", qty))

  data.frame(
    name = name,
    advent_day = day,
    album_year = album_year,
    plate = plate,
    type = type,
    qty = qty,
    rumsey_no = row$RumseyListNo,
    old_name = old_name,
    andrews_label = sprintf("Dec.%02d-%d.%02d", day, album_year, plate),
    shanley_id = paste0(tolower(type), album_year, plate |> sprintf(fmt = "%02d"))
  )
})
cheysson_labels <- do.call(rbind, cheysson_labels)

# shanley_id should be {type}{RumseyListNo digits with no dot}, not
# {type}{album_year}{plate} - fix that (album_year isn't part of his scheme).
cheysson_labels$shanley_id <- paste0(tolower(cheysson_labels$type),
                                      gsub("\\.", "", cheysson_labels$rumsey_no))

cheysson_labels <- cheysson_labels[order(cheysson_labels$advent_day), ]
row.names(cheysson_labels) <- NULL

stopifnot(
  "name should be unique for all 25 rows" = !any(duplicated(cheysson_labels$name)),
  "name should match names(cheysson_palettes) exactly" =
    setequal(cheysson_labels$name, names(cheysson_palettes)),
  "name should match names(cheysson_patterns) exactly" =
    setequal(cheysson_labels$name, names(cheysson_patterns))
)

# Save as package data
usethis::use_data(cheysson_labels, overwrite = TRUE)

cat("Created cheysson_labels with", nrow(cheysson_labels), "rows\n\n")

cat("=== old_name collision groups (pre-fix scheme, kept for history) ===\n")
dupes <- cheysson_labels |> count(old_name) |> filter(n > 1)
print(dupes)

cat("\nSample:\n")
print(head(cheysson_labels, 3), row.names = FALSE)
