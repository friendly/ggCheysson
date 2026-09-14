# ggCheysson — development tasks

Not yet broken out from anywhere — `TASKS-all.md` has no entry for this package. Started
2026-09-14 at Claude's suggestion, after enough back-and-forth in one session that it was worth
keeping a record.

Version 1.0.0. Previously believed submitted to CRAN; as of 2026-09-14 the user says it either
wasn't submitted or wasn't accepted. Working towards a clean (re)submission.

## `theme_cheysson()` axis/legend title text too small — DONE

2026-09-14: User noticed axis labels render smaller in the README's `theme_cheysson()` example
than in the earlier `theme_minimal()` example. Measured with `systemfonts::font_info()` /
`string_metrics_dev()`: not a uniform problem. `axis.text` (body font `Cheysson`, size
`base_size * 0.85`) is fine - that multiplier already exceeds `theme_minimal()`'s default
`rel(0.8)`, and `Cheysson`'s glyphs measure slightly *taller* than Arial's at the same nominal
size (max_ascend 10.4 vs 9.95, size 11). The real problem is `axis.title`/`legend.title`/
`strip.text`, which use `CheyssonSansCaps` (an all-caps font) at `base_size * 0.95` - already
below `theme_bw()`'s default `rel(1)`, and `CheyssonSansCaps` itself measures ~12-20% smaller
than Arial at the same nominal size (max_ascend 8.8 vs 9.95; lineheight 10.1 vs 12.7). The two
effects compound.

Fix: multiply the three affected sizes by a `caps_size_adjust` factor of 1.15 (applied only when
`axis_title_family == "CheyssonSansCaps"`, so a user-supplied family isn't double-corrected) -
landing between the ascent-ratio-implied correction (1.13) and the lineheight-ratio-implied one
(1.26). `theme_cheysson_minimal()` inherits it via `theme_cheysson()`; `theme_cheysson_map()`
didn't need it (its `legend.title` uses `base_family`, not `axis_title_family`).

- [x] Applied to `R/theme.R`
- [x] Visually confirmed: knitr's README render uses `ragg`, not the plain `pdf()` device that
  crashes with "invalid font type" on this machine (see `\dontrun{}` notes in `R/theme.R`), so
  the "With Fonts and Theme" example actually rendered - axis titles now read at a comparable
  scale to the earlier `theme_minimal()` example. `1.15` looked right, no further tuning needed.
- [x] Regenerated docs/README, rebuilt pkgdown; commit pending

## CRAN (re)submission

- [x] `R CMD check --as-cran --run-donttest`: 0 errors, 0 warnings, 0 notes (2026-09-14)
- [x] win-builder R-devel: clean modulo 2 known-benign NOTEs (Cheysson spelling; Observable URL
  429 from bot-blocking, documented in `cran-comments.md`)
- [x] Cleaned up unnecessary `\dontrun{}`/`\donttest{}` wrapping (commit `89b81c9`)
- [x] roxygen2 bumped to 8.1.0 (`Config/roxygen2/version`, was pinned `RoxygenNote: 7.3.3`)
- [ ] Resolve the axis-title-size task above first (visible in generated docs/vignettes)
- [ ] Actually submit (`devtools::submit_cran()` or equivalent) once the above is settled

## Other loose ends

- `data-raw/albumColors-RJ.csv` added 2026-09-14 (RJ Andrews source metadata: album/plate/type/
  Rumsey link) - not yet wired into any `data-raw/*.R` extraction script; purpose/next step
  unconfirmed with user.
- `dev/colorpat/` (unified color-pattern palette system) - explicitly on hold, deferred past this
  release (`dev/README.md`).
