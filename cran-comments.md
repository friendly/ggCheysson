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
* win-builder, R Under development (unstable) (2026-09-25 r90590 ucrt)
* R-hub (GitHub Actions), R-devel (4.7.0): linux (Ubuntu 24.04), windows (Server 2022),
  macos (macOS 15.7, x86_64 - the platform of the 1.0.1 ERROR), macos-arm64 (macOS 26.6):
  all Status OK, vignettes re-built

## R CMD check results

0 errors | 0 warnings | 1 note (win-builder; 0 notes locally)

* Days since last update: 2. This update fixes the check ERROR described above.

## Reverse dependencies

There are no reverse dependencies.
