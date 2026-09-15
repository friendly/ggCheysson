## Test environments
* local Windows 11 install, R 4.6.1 (2026-06-24 ucrt), `--as-cran` and `--run-donttest`
* win-builder R Under development (unstable) (2026-09-13 r90534 ucrt)
* R-hub (GitHub Actions), Ubuntu 24.04.5 LTS, R Under development (unstable) (2026-09-14 r90539),
  x86_64 - 0 errors, 0 warnings; found and fixed 1 NOTE ("hidden files and directories: .github",
  from adding the R-hub workflow file itself - `.github` added to `.Rbuildignore`, confirmed
  clean in a subsequent local `--as-cran` run)

## R CMD check results

0 errors | 0 warnings | 1 note

**NOTE 1:** Possibly misspelled words in DESCRIPTION:
  Cheysson (2:32, 14:3)

This is a proper name (Émile Cheysson) and is spelled correctly.

* This package (as v1.0.0) was submitted to CRAN on 2026-01-08 but was not accepted. The issues
  raised have been addressed in this v1.0.1 resubmission (see NEWS.md), and R CMD check is clean
  as reported above.
* The Tom Shanley Observable notebook citation (`R/data.R`, `R/palettes.R`, `README.md`) previously
  linked directly to observablehq.com, which returns HTTP 429 to automated, non-browser requests
  and was flagged as a possibly-invalid URL. Replaced with a Wayback Machine snapshot of the same
  page, which resolves reliably; no more URL NOTE.
