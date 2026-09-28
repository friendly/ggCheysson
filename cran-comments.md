## Update submission (1.1.0)

This update fixes the ERROR in the CRAN checks of 1.0.1 on `r-release-macos-x86_64` and
`r-oldrel-macos-x86_64`, which is why it follows 1.0.1 (published 2026-09-26) so closely.

Re-building `guerry-maps.Rmd` segfaulted ("memory not mapped", in grid's `.setMask()` under
`pushViewport()`), and the R process that built `getting-started.Rmd` also segfaulted after
finishing. I reproduced this on GitHub's Intel macOS runner and narrowed it down to the
Quartz `png()` device drawing the grid masks that 'ggpattern' uses for pattern fills at >= 96
dpi; the same plots render fine with 'ragg'. Both vignettes now use
`dev = "ragg_png"` when 'ragg' (in Suggests) is available, and fall back to `png` otherwise. Both vignettes then build and exit cleanly on Intel and arm64 macOS.

The update also fixes several bugs in the package's pattern scales (e.g.
`scale_pattern_type_cheysson()` did not vary the pattern, and 6 palettes made ggpattern fail),
and corrects the palette data: a naming bug had silently dropped 5 of the 25 source palettes.
Restoring them required renaming palettes; old names now give an informative error with the
new name. Details are in NEWS.md.

## Test environments

* local Windows 11, R 4.6.1 (2026-06-24 ucrt), `R CMD check --as-cran`
* TODO: win-builder, R-devel and R-release
* TODO: R-hub (GitHub Actions): linux (R-devel), macos (arm64), macos-x86_64 (Intel), windows

## R CMD check results

0 errors | 0 warnings | 0 notes (local)

TODO: confirm against win-builder. Expected NOTEs on CRAN's incoming checks:

* Days since last update: this update fixes the check ERROR described above.
* Possibly misspelled words in DESCRIPTION: Cheysson. This is a proper name (Émile Cheysson)
  and is spelled correctly.

## Reverse dependencies

There are no reverse dependencies.
