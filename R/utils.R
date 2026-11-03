# Base R has this only from 4.4.0
`%||%` <- function(x, y) if (is.null(x)) y else x

# ggplot2::discrete_scale(), passing `scale_name` only to ggplot2 < 3.5.0, which
# requires it (later versions deprecate it)
cheysson_discrete_scale <- function(aesthetics, scale_name, ...) {
  if (utils::packageVersion("ggplot2") >= "3.5.0") {
    ggplot2::discrete_scale(aesthetics, ...)
  } else {
    ggplot2::discrete_scale(aesthetics, scale_name, ...)
  }
}
