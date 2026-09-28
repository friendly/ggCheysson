# Stored element order for cheysson_palettes and cheysson_patterns.
# Sourced by data-raw/cheysson_palettes.R and data-raw/cheysson_patterns.R.
#
# The source SVGs (data-raw/observable/decNN.txt) list elements in RJ Andrews'
# swatch order (man/figures/RJ-Andrews-color-palettes.jpg), which is not always
# a data order. The package convention (see ?cheysson_palettes) is:
#   - sequential: low -> high, i.e. light -> dark
#   - diverging:  end to end, one extreme -> neutral middle -> other extreme,
#                 with the strongest (solid) marks at the extremes
# so that `reverse = TRUE` means the same thing for every palette, and so that
# selecting n < length elements can spread over the palette (keeping both ends).
# Category and grouped palettes keep the swatch order.
#
# Each entry is either "rev" or an index permutation. 1886_26 ("sequential",
# but two hues: red solid/stripe, blue solid/stripe) has no light -> dark
# order and is left as is.

palette_order <- list(
  colors = list(
    "1891_25" = "rev",              # grey-violet, paper
    "1900_28" = "rev"               # black, paper
  ),
  patterns = list(
    "1883_31" = c(2, 1, 4, 3),      # hatched/solid blue, solid/hatched orange -> solid at the ends
    "1891_19" = "rev",              # solid blue, then lighter stripes and dots
    "1891_25" = "rev",              # solids, crosshatch, then lighter stripes
    "1900_28" = "rev"               # solid black, lighter stripes, paper
  )
)

apply_order <- function(x, ord) {
  if (is.null(ord)) return(x)
  if (identical(ord, "rev")) return(rev(x))
  stopifnot(length(ord) == length(x), setequal(ord, seq_along(x)))
  x[ord]
}
