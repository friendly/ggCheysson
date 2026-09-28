# Round 3: confirm the fix (dev = "ragg_png" in both vignettes' opts_chunk).
# Render each current vignette in its own process, as R CMD build does; a
# segfault at process exit (as getting-started had on CRAN) shows as exit 139.
outdir <- "diag-out"; dir.create(outdir, showWarnings = FALSE)
rscript <- file.path(R.home("bin"), "Rscript")
cat(R.version.string, Sys.info()[["machine"]], "\n")

fails <- 0
for (v in c("getting-started", "guerry-maps")) {
  rf <- tempfile(fileext = ".R")
  writeLines(sprintf(
    "rmarkdown::render('vignettes/%s.Rmd', output_dir = '%s', quiet = TRUE)", v, outdir), rf)
  log <- file.path(outdir, paste0("r3-", v, ".log"))
  st <- system2(rscript, rf, stdout = log, stderr = log)
  cat(sprintf("%-20s -> %s\n", v, if (st == 0) "OK" else paste("FAIL", st)))
  if (st != 0) {
    fails <- fails + 1
    cat(tail(readLines(log), 20), sep = "\n")
  }
}
if (fails) quit(status = 1)
