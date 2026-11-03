# The palette data are lazy-loaded datasets, which live outside the namespace. Package
# code that names them bare finds them only when ggCheysson is attached, so these run
# in a fresh R session where ggCheysson is loaded via `::` but never attached.
# (tests/testthat.R attaches it, so an in-process test would miss the bug.)

run_unattached <- function(f) {
  callr::r(function(f) {
    stopifnot(!"package:ggCheysson" %in% search())
    f()
  }, args = list(f = f))
}

test_that("palette functions work without library(ggCheysson)", {
  skip_if_not_installed("callr")

  expect_type(run_unattached(function() ggCheysson::cheysson_pal("1886_28")), "character")
  expect_no_error(run_unattached(function() ggCheysson::cheysson_pattern("1886_28")))
  expect_no_error(run_unattached(function() ggCheysson::list_cheysson_pals()))
  expect_no_error(run_unattached(function() ggCheysson::list_cheysson_patterns()))
  expect_equal(
    run_unattached(function() ggCheysson::cheysson_name("Dec.01-1883.21")),
    "1883_21"
  )
})

test_that("scales build a plot without library(ggCheysson)", {
  skip_if_not_installed("callr")

  expect_no_error(run_unattached(function() {
    df <- data.frame(x = letters[1:4], y = 1:4)
    p <- ggplot2::ggplot(df, ggplot2::aes(x, y, fill = x)) +
      ggplot2::geom_col() +
      ggCheysson::scale_fill_cheysson("1886_28")
    ggplot2::ggplot_build(p)
    ggCheysson::scale_cheysson("1886_28")
    invisible(NULL)
  }))
})

test_that("an old palette name gives its new name without library(ggCheysson)", {
  skip_if_not_installed("callr")

  msg <- run_unattached(function() {
    tryCatch(ggCheysson::cheysson_pal("1883_06"), error = conditionMessage)
  })
  expect_match(msg, "1883_30")
})
