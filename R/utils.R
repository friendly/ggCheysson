# Base R has this only from 4.4.0
`%||%` <- function(x, y) if (is.null(x)) y else x
