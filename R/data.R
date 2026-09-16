#' Album Images Metadata
#'
#' Metadata linking the 25 color palettes from the Albums de Statistique
#' Graphique to their corresponding album years, plate numbers, and David
#' Rumsey collection reference numbers.
#'
#' @format A data frame with 25 rows and 6 variables:
#' \describe{
#'   \item{adventDay}{Advent calendar day number (1-25) from original digitization}
#'   \item{RumseyListNo}{David Rumsey Map Collection list number}
#'   \item{Album}{Year of the album (1880-1906)}
#'   \item{Qty}{Number of colors/pattern elements in the palette - not a plate
#'     identifier (see \code{\link{cheysson_palettes}} for the actual unique
#'     plate number, derived from \code{RumseyListNo}'s decimal suffix)}
#'   \item{Type}{Palette type: "Sequential", "Diverging", "Grouped", or "Category"}
#'   \item{link}{URL to the digitized image in the David Rumsey Map Collection}
#' }
#'
#' @details
#' This dataset provides the mapping between the original SVG pattern files
#' (named by Advent calendar days by RJ Andrews) and the actual album years
#' and plate numbers from the _Albums de Statistique Graphique_.
#'
#' The naming convention "adventDay" comes from RJ Andrews' original digitization
#' project where he released one palette per day during December as an Advent
#' calendar. The package uses the Album year and plate number for more intuitive
#' palette naming (e.g., "1880_07" instead of "dec06"). The plate number is
#' derived from \code{RumseyListNo}'s decimal suffix (e.g. "12511.007" -> 7),
#' which is the real unique per-plate identifier - not \code{Qty}, which is a
#' count of colors/pattern elements in the palette and can repeat across
#' genuinely different plates.
#'
#' @source
#' \itemize{
#'   \item David Rumsey Map Collection: \url{https://www.davidrumsey.com/}
#'   \item RJ Andrews Album Colors: \url{https://github.com/infowetrust/albumcolors}
#'   \item Tom Shanley Observable: \url{https://web.archive.org/web/20210130125506/https://observablehq.com/@tomshanley/cheysson-color-palettes}
#' }
#'
#' @examples
#' # View the dataset
#' head(albumImages)
#'
#' # Find information about a specific album
#' subset(albumImages, Album == 1880)
#'
#' # Count palettes by type
#' table(albumImages$Type)
#'
#' # Get the Rumsey link for a specific palette
#' albumImages[albumImages$Album == 1881 & albumImages$Qty == 3, "link"]
#'
#' @seealso \code{\link{cheysson_palettes}}, \code{\link{cheysson_patterns}}
"albumImages"


#' Cheysson Font Families
#'
#' Metadata about the five Cheysson font families included in the package,
#' describing their characteristics and recommended uses.
#'
#' @format A data frame with 5 rows and 4 variables:
#' \describe{
#'   \item{family}{Font family name (e.g., "Cheysson", "CheyssonTitle")}
#'   \item{description}{Brief description of the font style}
#'   \item{use}{Recommended use cases for the font}
#'   \item{file}{TrueType font filename in the inst/fonts/ directory}
#' }
#'
#' @details
#' The package includes five hand-drawn font families created by Kenneth Fields
#' (ESRI) to match the lettering style of the original Albums de Statistique
#' Graphique:
#'
#' \itemize{
#'   \item \strong{Cheysson}: Regular serif font suitable for body text, axis
#'     labels, and legends
#'   \item \strong{CheyssonItalic}: Italic variant for emphasis and annotations
#'   \item \strong{CheyssonSansCaps}: Sans-serif capitals for axis labels and
#'     category names
#'   \item \strong{CheyssonOutlineCaps}: Outlined capitals for decorative plot
#'     titles and headings
#'   \item \strong{CheyssonTitle}: Decorative font for main plot titles
#' }
#'
#' These fonts must be loaded before use with \code{\link{load_cheysson_fonts}}.
#' The Cheysson themes (\code{\link{theme_cheysson}}, etc.) automatically select
#' appropriate fonts for different plot elements.
#'
#' @source
#' Font families created by Kenneth Fields (ESRI) based on the lettering style
#' of Émile Cheysson's Albums de Statistique Graphique.
#'
#' @examples
#' # View font metadata
#' cheysson_fonts
#'
#' # Get recommended uses
#' cheysson_fonts[, c("family", "use")]
#'
#' # Find the title font
#' subset(cheysson_fonts, grepl("title", use, ignore.case = TRUE))
#'
#' @seealso \code{\link{load_cheysson_fonts}}, \code{\link{cheysson_fonts_available}},
#'   \code{\link{theme_cheysson}}
"cheysson_fonts"


#' Cheysson Palette Naming Crosswalk
#'
#' A one-row-per-plate lookup table tying together every naming scheme used
#' for these 25 palettes: the package's own \code{\link{cheysson_palettes}}/
#' \code{\link{cheysson_patterns}} names, RJ Andrews' original Advent calendar
#' labels, and Tom Shanley's Observable notebook IDs. Useful whenever you have
#' a palette identified in someone else's terms - an Advent day, a David
#' Rumsey catalog number, or a label copied from Andrews' or Shanley's own
#' work - and need the package name to actually use it in
#' \code{\link{scale_color_cheysson}()} and friends, or vice versa.
#'
#' @format A data frame with 25 rows and 10 variables:
#' \describe{
#'   \item{name}{The package's current palette name (e.g. "1881_22") - pass
#'     this to \code{scale_color_cheysson()}, \code{cheysson_pal()},
#'     \code{cheysson_pattern()}, etc. Unique; matches
#'     \code{names(cheysson_palettes)} and \code{names(cheysson_patterns)}
#'     exactly}
#'   \item{advent_day}{Advent calendar day (1-25) from RJ Andrews' original
#'     digitization project, where he released one palette per day during
#'     December}
#'   \item{album_year}{Year of the album (1880-1906)}
#'   \item{plate}{The plate number within the album, derived from
#'     \code{rumsey_no}'s decimal suffix (e.g. "12511.007" -> 7) - the real
#'     unique per-plate identifier that \code{name} is built from}
#'   \item{type}{Palette type: "Sequential", "Diverging", "Grouped", or
#'     "Category"}
#'   \item{qty}{Number of colors/pattern elements in the palette - despite
#'     the name, not a plate identifier (see \code{plate})}
#'   \item{rumsey_no}{David Rumsey Map Collection list number}
#'   \item{old_name}{The name this palette would have received under the
#'     package's original (Album + \code{qty}) naming scheme, before a
#'     2026-09-16 fix - kept for historical reference. Not unique: 4 pairs
#'     of genuinely different plates shared an \code{old_name}, silently
#'     overwriting one another during data extraction until the fix}
#'   \item{andrews_label}{RJ Andrews' own label for this palette, in the form
#'     "Dec.DD-YYYY.PP" (Advent day - album year . plate)}
#'   \item{shanley_id}{Tom Shanley's Observable notebook ID for this palette:
#'     \code{type} followed directly by \code{rumsey_no}'s digits with the
#'     dot removed (e.g. "diverging12514021")}
#' }
#'
#' @details
#' This table exists because the package's own \code{name} (Album + plate)
#' is a convenient but package-internal convention - it isn't what you'll see
#' if you're reading Andrews' or Shanley's original write-ups, or working
#' from a Rumsey catalog reference. \code{andrews_label} and \code{shanley_id}
#' are derived programmatically from the verified rule linking all three
#' schemes (album year + plate, taken from \code{rumsey_no}'s decimal
#' suffix), not scraped from either source - both were cross-checked against
#' every legible label/ID in the reference images below and matched for all
#' 24/24 checked. (Two of Shanley's own ID *strings* have isolated typos - a
#' digit transposition and a missing trailing digit; his prose descriptions
#' don't have these typos, and this table's \code{shanley_id} gives the
#' corrected form, not the typo'd one.)
#'
#' \code{old_name} also documents a real bug this table helped uncover:
#' before 2026-09-16, palette names were built from \code{qty} (a color
#' count) instead of \code{plate} (the real per-plate identifier), causing 4
#' collisions between genuinely different plates and silently dropping 5 of
#' the original 25 palettes from the package. Comparing \code{name} to
#' \code{old_name} shows exactly what changed for each plate.
#'
#' @source
#' \itemize{
#'   \item David Rumsey Map Collection: \url{https://www.davidrumsey.com/}
#'   \item RJ Andrews Album Colors: \url{https://github.com/infowetrust/albumcolors} -
#'     see also \code{man/figures/RJ-Andrews-color-palettes.jpg} in the package
#'     sources for his own reference grid of all 25 labeled palettes
#'   \item Tom Shanley Observable: \url{https://web.archive.org/web/20210130125506/https://observablehq.com/@tomshanley/cheysson-color-palettes} -
#'     see also \code{man/figures/shanley-palettes.png} in the package sources
#'     for his own reference grid of all 25 labeled palettes
#'   \item \code{data-raw/observable/albumColors.csv} (this package) - the
#'     original Advent day / Rumsey number / album / type mapping everything
#'     else here is derived from
#' }
#'
#' @examples
#' # View the crosswalk
#' head(cheysson_labels)
#'
#' # Find the package name for a palette described in Andrews' terms
#' cheysson_labels[cheysson_labels$andrews_label == "Dec.01-1883.21", "name"]
#'
#' # Find the package name for a palette described in Shanley's terms
#' cheysson_labels[cheysson_labels$shanley_id == "grouped12511007", "name"]
#'
#' # See what a palette used to be called before the 2026-09-16 naming fix
#' subset(cheysson_labels, name != old_name)[, c("name", "old_name")]
#'
#' @seealso \code{\link{cheysson_palettes}}, \code{\link{cheysson_patterns}},
#'   \code{\link{albumImages}}
"cheysson_labels"
