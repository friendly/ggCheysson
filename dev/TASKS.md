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
- [x] Resolve the axis-title-size task above first (visible in generated docs/vignettes)
- [x] pkgdown site rebuilt and committed (`f53d0e9`, 2026-09-14) - see git-corruption note below
- [x] Version bumped 1.0.0 -> 1.0.1, Date -> 2026-09-14 (`55eb244`, 2026-09-14); NEWS.md, README.md
  (re-knit via `devtools::build_readme()`), and cran-comments.md updated to note this is a
  resubmission of the version rejected 2026-01-08
- [x] Ran `ry check` (static type checker for R) across `R/` - flagged 4 real length-safety
  warnings, all fixed (`7b93765`, 2026-09-14): `cheysson_fonts_available()`'s `method == "..."`
  checks replaced with `identical()` (avoids R 4.3+'s `||`/`&&` length>1 error), and
  `cheysson_pal()`/`cheysson_pattern()` now validate `n` is a single positive number before
  comparing it to the palette/pattern length. `ry check` clean afterward.
- [x] R-hub Ubuntu check (2026-09-15): set up `rhub::rhub_setup()` (new
  `.github/workflows/rhub.yaml`, `workflow_dispatch`-only, commit `c5edc2f`) - needed a `gh auth
  refresh --scopes workflow` first, user's `gh` token lacked `workflow` scope. Ran
  `rhub::rhub_check(platforms = "linux")`: Ubuntu 24.04.5 LTS, R-devel (2026-09-14 r90539),
  24m18s, 0 errors/0 warnings/1 NOTE ("hidden files and directories: .github" - caused by the
  workflow file itself, not a real problem). Fixed by adding `.github` to `.Rbuildignore`;
  confirmed clean in a subsequent local `--as-cran` run. Not yet re-verified clean on R-hub
  itself (would need another ~24min run) - `cran-comments.md` documents the found-and-fixed NOTE
  rather than claiming an unverified 0/0/0 on that specific platform.
- [x] Eliminated the Observable URL NOTE (2026-09-15) rather than just explaining it: found a
  working Wayback Machine snapshot (`web.archive.org/web/20210130125506/...`, verified real
  content via its og:title/og:description, not a blank JS shell, and 200s reliably across 3
  attempts) and swapped it in everywhere the live observablehq.com URL appeared (`R/data.R`,
  `R/palettes.R`, `README.Rmd` x2). `urlchecker::url_check()` and local `--as-cran` both confirm
  it's gone - down to the single benign "Cheysson" spelling NOTE.
- [x] `cran-comments.md` rewritten (2026-09-15): reframed as "new submission" (1.0.0 was never
  accepted, so nothing to resubmit over) instead of "resubmission"; added full NEWS.md text for
  1.0.1 and 1.0.0, per user request.
- [ ] Fresh win-builder R-devel run attempted 2026-09-15, FAILED: FTP `STOR` rejected with a bare
  `550` (confirmed with a manual `curl -v -T ... ftp://win-builder.r-project.org/R-devel/`, so
  it's the server, not `devtools`/`curl` R packages). Most likely cause: the server still has
  `ggCheysson_1.0.1.tar.gz` queued/unprocessed from the earlier run under the same filename.
  Retried twice, same result both times - did not retry further or wait it out. Options for next
  time: wait longer and retry, or use `rhub::rhub_check(platforms = "windows")` (infrastructure
  already set up) as a substitute Windows check.
- [ ] Actually submit (`devtools::submit_cran()` or equivalent) once the above is settled

## Git/Dropbox corruption (fixed 2026-09-14)

The repo lives inside a Dropbox-synced folder, and Dropbox corrupted `.git` mid-session: the
4 most recent commits' objects went missing from `.git/objects` (loose files never landed, or
were removed post-write) even though `refs/heads/master` and the reflog still pointed to them,
and `.git/index` was left stale/wrong - `git status` failed outright (`fatal: bad object HEAD`),
and after that, showed every tracked file as both staged-deleted and untracked.

Fixed via `git fetch origin` (recovered the missing commit objects - they'd already been pushed,
so nothing was lost) + `git reset` (mixed, resynced the index to HEAD without touching the
working tree). Confirmed no source work was lost: R/, DESCRIPTION, NAMESPACE, man/, vignettes/
were already identical to HEAD and to `origin/master`.

Also hit two more Dropbox-lock symptoms while rebuilding pkgdown: a transient
`cannot open the connection ... Invalid argument` on `docs/articles/guerry-maps.html` (cleared on
retry), and `pkgdown::clean_site()` hit `[EBUSY] resource busy or locked` on
`docs/deps/JetBrains_Mono-0.4.10` partway through deleting `docs/`, leaving it half-gone (fixed
via `git checkout -- docs/` to restore from the index, then a plain `build_site()` without
`clean_site()`).

**Takeaway: this repo should not live in a continuously-syncing Dropbox folder.** Recommend
moving it out of Dropbox (or adding it to Dropbox's ignore list) before the next session - the
same class of corruption can recur, and this time it happened to be recoverable only because
`origin` had already received the missing commits.

2026-09-14, follow-up: user confirmed Dropbox's per-folder "Ignore" flag doesn't reliably stop
sync of newly-created files (checked via File Info - showed excluded, but `.git` kept syncing
anyway), which tracks with `.git/objects` constantly gaining new loose files as git writes them.
User agrees the real fix is moving R project folders out of Dropbox entirely, not just `.git`,
but isn't ready to do that migration yet. Not planning to relocate just `.git` (the `gitdir:`
pointer trick) either, since it's a partial fix superseded by the eventual full move. No action
needed here until the user is ready - don't re-suggest the partial fix unprompted.

## Other loose ends

- `data-raw/albumColors-RJ.csv` added 2026-09-14 (RJ Andrews source metadata: album/plate/type/
  Rumsey link) - not yet wired into any `data-raw/*.R` extraction script; purpose/next step
  unconfirmed with user.
- `dev/colorpat/` (unified color-pattern palette system) - explicitly on hold, deferred past this
  release (`dev/README.md`).
