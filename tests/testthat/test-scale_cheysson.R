test_that("scale_cheysson() is one discrete scale giving swatch names", {
  s <- scale_cheysson("1886_28")
  expect_s3_class(s, "ScaleDiscrete")
  expect_identical(s$aesthetics, "pattern")
  expect_identical(s$palette(6), paste0("1886_28-", 1:6))
  expect_identical(s$palette(3), paste0("1886_28-", 1:3))   # category: the first n
  expect_identical(s$na.value, "none")
  expect_true(all(s$palette(6) %in% swatch_names()))
})

test_that("ordered palettes spread over the whole palette, and reverse flips them", {
  n_el <- length(cheysson_patterns[["1888_27"]]$patterns)
  picks <- scale_cheysson("1888_27")$palette(2)          # sequential: keep both ends
  expect_identical(picks, paste0("1888_27-", c(1, n_el)))
  expect_identical(scale_cheysson("1888_27", reverse = TRUE)$palette(2), rev(picks))
})

test_that("a palette type name gives that palette's swatches", {
  s <- scale_cheysson("sequential")
  name <- names(Filter(function(p) p$type == "sequential", cheysson_patterns))[1]
  expect_true(all(startsWith(s$palette(3), paste0(name, "-"))))
})

test_that("`aesthetics` is ignored with a warning; other arguments reach the scale", {
  expect_warning(s <- scale_cheysson("1886_28", aesthetics = c("fill", "pattern")),
                 "no longer used")
  expect_identical(s$aesthetics, "pattern")
  expect_identical(scale_cheysson("1886_28", name = "Country")$name, "Country")
})

test_that("aes_cheysson() maps only pattern, with a once-per-session note", {
  .ggcheysson_env$noted_aes_cheysson <- NULL
  expect_message(m <- aes_cheysson(g, x = a), "deprecated")
  expect_setequal(names(m), c("pattern", "x"))
  expect_silent(aes_cheysson(g))
})

test_that("scale_cheysson() draws, with missing values in the geom's fill", {
  skip_if_not_installed("ggpattern")
  skip_if_not_installed("gridpattern")
  grDevices::pdf(NULL)
  on.exit(grDevices::dev.off())

  df <- data.frame(x = c("a", "b", "c", NA), y = 1:4)
  p <- ggplot2::ggplot(df, ggplot2::aes(x, y, pattern = x)) +
    ggpattern::geom_col_pattern(fill = "grey80", colour = "black") +
    scale_cheysson("1886_28")
  expect_no_error(print(p))
  built <- ggplot2::ggplot_build(p)$data[[1]]
  expect_identical(built$pattern, c(paste0("1886_28-", 1:3), "none"))
})
