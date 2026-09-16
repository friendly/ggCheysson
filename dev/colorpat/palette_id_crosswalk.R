# Build a one-row-per-advent-day crosswalk of every naming scheme touching
# these 25 palettes, to make the Album+Qty collision bug (PATTERN_SCALE_BUGS.md
# is the pattern-aesthetic bugs; this is a separate, bigger naming bug - see
# dev/TASKS.md "Album+Qty naming collision" entry) fully explicit, and to
# support looking a palette up by whichever label a given source uses.
#
# Written 2026-09-16 on the `colorpat` branch, alongside
# RJ-Andrews-reconstruct.{R,png}. Will need to be re-run once/if the
# underlying naming scheme is fixed (current_pkg_name/shipped columns reflect
# today's Album+Qty scheme, not a hypothetical fixed one) - kept as its own
# script rather than a one-off so that re-run is just `Rscript this-file.R`.
#
# Column notes:
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
#   any source data available in this repo.
# - qty: kept from the source CSV for reference. Despite the name, it is NOT
#   a plate discriminator - it matches the shipped pattern-element count for
#   18/20 currently-shipped palettes (checked against actual
#   length(cheysson_patterns[[name]]$patterns); 2 mismatches - adventDay 5
#   and 22 - not investigated further here), strongly suggesting it's a
#   swatch/element count, not an identifier. That's exactly why two
#   genuinely different plates can share a Qty value and collide under the
#   current Album+Qty naming scheme.
# - current_pkg_name: the name data-raw/cheysson_palettes.R /
#   cheysson_patterns.R would assign via paste0(Album, "_", sprintf("%02d",
#   Qty)) - may not be unique (see the 4 collisions below).
# - shipped: TRUE if this adventDay's data survived extraction under
#   current_pkg_name (FALSE = silently overwritten by a later adventDay
#   sharing the same current_pkg_name; see dev/TASKS.md for the 4 collision
#   groups and dev/colorpat/PATTERN_SCALE_BUGS.md-style writeup).
# - andrews_label / shanley_id: derived programmatically from the verified
#   rule (type + adventDay + Album + plate), not scraped from either image -
#   both are believed correct even for the 2 adventDays where Shanley's own
#   site has a typo.

devtools::load_all(quiet = TRUE)
library(readr)
library(dplyr)

album_info <- read_csv("data-raw/observable/albumColors.csv",
                        col_types = cols(RumseyListNo = "c", .default = "c")) |>
  transform(adventDay = as.integer(adventDay))

dec_to_name <- setNames(names(cheysson_patterns),
                         sapply(cheysson_patterns, `[[`, "dec_day"))

crosswalk <- lapply(seq_len(nrow(album_info)), function(i) {
  row <- album_info[i, ]
  day <- row$adventDay
  plate <- as.integer(sub("^[0-9]+\\.", "", row$RumseyListNo))
  qty <- as.integer(row$Qty)
  album_year <- as.integer(row$Album)
  type <- row$Type
  current_pkg_name <- paste0(album_year, "_", sprintf("%02d", qty))
  shipped_name <- unname(dec_to_name[as.character(day)])
  shipped <- !is.na(shipped_name) && identical(shipped_name, current_pkg_name)

  data.frame(
    advent_day = day,
    album_year = album_year,
    plate = plate,
    type = type,
    qty = qty,
    rumsey_no = row$RumseyListNo,
    current_pkg_name = current_pkg_name,
    shipped = shipped,
    andrews_label = sprintf("Dec.%02d-%d.%02d", day, album_year, plate),
    shanley_id = paste0(tolower(type), album_year, plate |> sprintf(fmt = "%02d"))
  )
})
crosswalk <- do.call(rbind, crosswalk)

# shanley_id should be {type}{RumseyListNo digits with no dot}, not
# {type}{album_year}{plate} - fix that (album_year isn't part of his scheme).
crosswalk$shanley_id <- paste0(tolower(crosswalk$type),
                                gsub("\\.", "", crosswalk$rumsey_no))

crosswalk <- crosswalk[order(crosswalk$advent_day), ]

write_csv(crosswalk, "dev/colorpat/palette_id_crosswalk.csv")

cat("=== collision groups (current_pkg_name shared by >1 advent_day) ===\n")
dupes <- crosswalk |> count(current_pkg_name) |> filter(n > 1)
print(dupes)

cat("\n=== summary ===\n")
cat("total advent days:", nrow(crosswalk), "\n")
cat("shipped:", sum(crosswalk$shipped), " lost to collision:", sum(!crosswalk$shipped), "\n")

cat("\nSaved: dev/colorpat/palette_id_crosswalk.csv\n")
print(crosswalk, row.names = FALSE)
