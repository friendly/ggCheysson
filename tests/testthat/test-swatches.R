test_that("every pattern palette element has a swatch name that finds its spec", {
  names <- swatch_names()
  n_elements <- sum(vapply(cheysson_patterns, function(p) length(p$patterns), integer(1)))
  expect_length(names, n_elements)
  expect_false(anyDuplicated(names) > 0)
  expect_false(any(grepl(":", names, fixed = TRUE)))   # register_pattern() rejects ":"

  for (nm in names) expect_true(swatch_spec(nm)$type %in% c("solid", "stripe", "crosshatch"))
  expect_identical(swatch_spec("1886_28-2"), cheysson_patterns[["1886_28"]]$patterns[[2]])
  expect_identical(swatch_spec("ggCheysson::1886_28-2"), swatch_spec("1886_28-2"))
})

test_that("swatch_spec() doesn't give the renamed-palette note", {
  expect_silent(swatch_spec("1880_07-1"))
})

# converting units needs a device; without one, R opens Rplots.pdf
local_null_device <- function(env = parent.frame()) {
  grDevices::pdf(NULL)
  dev <- grDevices::dev.cur()
  do.call(on.exit, list(substitute(grDevices::dev.off(dev)), add = TRUE), envir = env)
}

test_that("relative mode scales against ggpattern's old defaults, in the user's units", {
  local_null_device()
  p <- function(spacing, density, units = "snpc")
    list(pattern_spacing = spacing, pattern_density = density, pattern_units = units)
  expect_equal(swatch_line_params(p(0.05, 0.2), "relative"),
               list(spacing = 0.025, density = 0.3, units = "snpc"))
  expect_equal(swatch_line_params(p(0.1, 0.4), "relative"),
               list(spacing = 0.05, density = 0.6, units = "snpc"))
  expect_equal(swatch_line_params(p(0.05, 0.2, "cm"), "relative"),
               list(spacing = 0.3, density = 0.3, units = "cm"))
  expect_equal(swatch_line_params(p(0.1, 0.2, "cm"), "relative")$spacing, 0.6)
})

test_that("absolute mode uses the values and units as they arrive", {
  expect_equal(
    swatch_line_params(list(pattern_spacing = 0.3, pattern_density = 0.5, pattern_units = "cm"), "absolute"),
    list(spacing = 0.3, density = 0.5, units = "cm"))
  expect_equal(
    swatch_line_params(list(pattern_spacing = 0.025, pattern_density = 0.3), "absolute")$units,
    "snpc")
})

test_that("the absolute-mode default spacing follows pattern_units", {
  local_null_device()
  expect_equal(swatch_spacing_default(list(pattern_units = "snpc"), NULL), 0.025)
  expect_equal(swatch_spacing_default(list(), NULL), 0.025)
  expect_equal(swatch_spacing_default(list(pattern_units = "cm"), NULL), 0.3)
  expect_equal(swatch_spacing_default(list(pattern_units = "in"), NULL), 0.3 / 2.54)
})

test_that("the mode follows the installed ggpattern", {
  v <- tryCatch(utils::packageVersion("ggpattern"), error = function(e) NULL)
  expected <- if (!is.null(v) && v < "1.4.0") "relative" else "absolute"
  expect_identical(swatch_mode(), expected)
})

test_that("the swatches are registered when gridpattern loads, owned by ggCheysson", {
  skip_if_not_installed("gridpattern")
  loadNamespace("gridpattern")
  if (exists("register_pattern", envir = asNamespace("gridpattern"), inherits = FALSE)) {
    reg <- gridpattern::registered_patterns()
    reg <- reg[reg$name %in% swatch_names(), ]
    expect_setequal(reg$name, swatch_names())
    expect_true(all(reg$owner == "ggCheysson"))
  } else {
    expect_true(all(swatch_names() %in% names(getOption("ggpattern_geometry_funcs"))))
  }
})

test_that("swatches draw with grid and with ggpattern", {
  skip_if_not_installed("gridpattern")
  local_null_device()

  # all three kinds: stripe, crosshatch (two colors), solid
  for (nm in c("1886_28-1", "1883_30-3", "1886_28-4")) {
    expect_no_error(gridpattern::grid.pattern(nm, x = c(0.1, 0.9, 0.9, 0.1), y = c(0.1, 0.1, 0.9, 0.9)))
  }

  skip_if_not_installed("ggpattern")
  df <- data.frame(x = c("a", "b", "c", "d"), y = 1:4)
  p <- ggplot2::ggplot(df, ggplot2::aes(x, y, pattern = x)) +
    ggpattern::geom_col_pattern() +
    ggpattern::scale_pattern_manual(values = paste0("1886_28-", 1:4))
  expect_no_error(print(p))
  expect_no_error(print(p + ggpattern::geom_col_pattern(pattern_spacing = 0.06)))
})
