## Test environments
* local Windows 11 install, R 4.6.1 (2026-06-24 ucrt), `--as-cran` and `--run-donttest`
* win-builder R Under development (unstable) (2026-09-13 r90534 ucrt)

## R CMD check results

0 errors | 0 warnings | 2 notes

**NOTE 1:** Possibly misspelled words in DESCRIPTION:
  Cheysson (2:32, 14:3)

This is a proper name (Émile Cheysson) and is spelled correctly.

**NOTE 2:** Found the following (possibly) invalid URLs:
  URL: https://observablehq.com/@tomshanley/cheysson-color-palettes
    Status: 429
    Message: Too Many Requests

This URL is valid and loads normally in a browser. Observable's servers return
HTTP 429 to automated, non-browser requests (confirmed with several different
HTTP clients from outside the CRAN check infrastructure), so this is expected
to recur on any automated check and is not a broken link.


* This is a new package release.
