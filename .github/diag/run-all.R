# Diagnose CRAN r-*-macos-x86_64 vignette segfault in grid .setMask().
# Each case runs in a separate R process; report exit status per case.
outdir <- "diag-out"; dir.create(outdir, showWarnings = FALSE)
rscript <- file.path(R.home("bin"), "Rscript")

cat("== Platform ==\n")
print(R.version.string); print(Sys.info()[c("sysname", "release", "machine")])
cat("bitmapType:", getOption("bitmapType"), "\n")
print(capabilities()[c("aqua", "cairo", "png")])
for (p in c("ggplot2", "ggpattern", "gridpattern", "showtext", "sysfonts", "ragg", "sf", "knitr"))
  cat(sprintf("%-12s %s\n", p, as.character(packageVersion(p))))

cases <- expand.grid(plot = c("grid_mask", "sf_plain", "col_pattern", "sf_pattern"),
                     device = c("quartz", "cairo", "ragg"),
                     showtext = c("off", "on"), stringsAsFactors = FALSE)
cases$status <- NA_integer_
for (i in seq_len(nrow(cases))) {
  a <- c(".github/diag/one.R", cases$plot[i], cases$device[i], cases$showtext[i], outdir)
  log <- file.path(outdir, sprintf("%s_%s_%s.log", cases$plot[i], cases$device[i], cases$showtext[i]))
  cases$status[i] <- system2(rscript, a, stdout = log, stderr = log)
  cat(sprintf("%-12s %-7s showtext=%-3s -> %s\n", cases$plot[i], cases$device[i],
              cases$showtext[i], if (cases$status[i] == 0) "OK" else paste("FAIL", cases$status[i])))
  if (cases$status[i] != 0) cat(tail(readLines(log), 15), sep = "\n")
}

cat("\n== Summary (status by device x showtext) ==\n")
print(xtabs(status ~ plot + paste(device, showtext), cases))

cat("\n== Full vignette renders (knitr default device) ==\n")
for (v in list.files("vignettes", "\.Rmd$", full.names = TRUE)) {
  expr <- sprintf("rmarkdown::render('%s', output_dir = '%s', quiet = TRUE)", v, outdir)
  log <- file.path(outdir, paste0(basename(v), ".log"))
  st <- system2(rscript, c("-e", shQuote(expr)), stdout = log, stderr = log)
  cat(sprintf("%-25s -> %s\n", basename(v), if (st == 0) "OK" else paste("FAIL", st)))
  if (st != 0) cat(tail(readLines(log), 25), sep = "\n")
}
