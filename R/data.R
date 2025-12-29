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
#'   \item{Qty}{Plate number within the album}
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
#' palette naming (e.g., "1880_07" instead of "dec06").
#'
#' @source
#' \itemize{
#'   \item David Rumsey Map Collection: \url{https://www.davidrumsey.com/}
#'   \item RJ Andrews Album Colors: \url{https://github.com/infowetrust/albumcolors}
#'   \item Tom Shanley Observable: \url{https://observablehq.com/@tomshanley/cheysson-color-palettes}
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
