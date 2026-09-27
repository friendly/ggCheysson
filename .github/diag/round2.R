# Round 2: the guerry-maps vignette segfaults at print(p3b) on Intel macOS, but
# the same plot rendered standalone does not. Find which part of the knitr
# context triggers it, and test candidate fixes. Each case runs in its own process.
outdir <- "diag-out"; dir.create(outdir, showWarnings = FALSE)
rscript <- file.path(R.home("bin"), "Rscript")
cat(R.version.string, Sys.info()[["machine"]], "\n")

run_r <- function(label, code) {
  rf <- tempfile(fileext = ".R"); writeLines(code, rf)
  log <- file.path(outdir, paste0("r2-", label, ".log"))
  st <- system2(rscript, rf, stdout = log, stderr = log)
  cat(sprintf("%-34s -> %s\n", label, if (st == 0) "OK" else paste("FAIL", st)))
  if (st != 0) {
    l <- readLines(log)
    hit <- grep("caught segfault|^Error", l)
    if (length(hit)) cat(l[hit[1]:min(length(l), hit[1] + 3)], sep = "\n")
  }
}

# --- A/B: standalone p3b under knitr-like device settings -----------------------
prep <- c(
  "suppressPackageStartupMessages({library(ggCheysson); library(ggplot2); library(sf); library(ggpattern)})",
  "code <- knitr::purl('vignettes/guerry-maps.Rmd', output = tempfile(), quiet = TRUE, documentation = 0)",
  "src <- readLines(code)",
  "src <- src[seq_len(grep('^print[(]p3b[)]', src)[1] - 1)]",
  "src <- src[!grepl('^print[(]', src)]",
  "eval(parse(text = src))"
)
dev_open <- list(
  quartz72  = "png(f, 8, 7, units = 'in', res = 72, type = 'quartz')",
  quartz96  = "png(f, 8, 7, units = 'in', res = 96, type = 'quartz')",
  quartz192 = "png(f, 8, 7, units = 'in', res = 192, type = 'quartz')",
  ragg96    = "ragg::agg_png(f, 8, 7, units = 'in', res = 96)"
)
for (d in names(dev_open)) for (dl in c("off", "on")) {
  run_r(sprintf("p3b-%s-displaylist-%s", d, dl), c(
    prep,
    sprintf("f <- '%s/r2-p3b-%s-%s.png'", outdir, d, dl),
    dev_open[[d]],
    if (dl == "on") "dev.control(displaylist = 'enable')",
    "print(p3b)", "invisible(dev.off())"))
}

# --- C: vignette variants rendered with knitr --------------------------------
vig <- readLines("vignettes/guerry-maps.Rmd")
variant <- function(label, lines) {
  f <- file.path(outdir, paste0("r2-", label, ".Rmd")); writeLines(lines, f)
  run_r(paste0("vignette-", label), sprintf(
    "rmarkdown::render('%s', output_dir = '%s', quiet = TRUE)", f, outdir))
}
add_opt <- function(lines, opt) {
  i <- grep("knitr::opts_chunk[$]set[(]", lines)[1]
  append(lines, paste0("  ", opt, ","), after = i)
}
variant("asis", vig)
variant("ragg", add_opt(vig, "dev = 'ragg_png'"))
variant("no-showtext", sub("showtext::showtext_auto[(][)]", "invisible(NULL)", vig))
variant("dpi192", add_opt(vig, "dpi = 192"))
# Drop the maps drawn before p3b: does earlier drawing matter?
variant("p3b-first", sub("^print[(]p(1|2|3)[)]$", "invisible(NULL)", vig))
