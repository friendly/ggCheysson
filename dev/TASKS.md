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
  
- [X] Fresh win-builder R-devel run -- clean now except for New submission / Cheysson spelling
- [x] Submitted to CRAN 2026-09-15 (on desktop), at commit `ac60e4f`; `CRAN-SUBMISSION` confirms
  Version 1.0.1. Awaiting CRAN's response.

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

2026-09-15, follow-up: user took `.git` out of Dropbox on the desktop machine (after submitting
1.0.1 to CRAN there). This laptop's `.git` is still inside Dropbox, and hit the same corruption
class again as a result: while the desktop was making its post-1.0.1-work commits (R-hub setup,
Observable URL fix, cran-comments rewrite, the README pattern-example fix), Dropbox synced the
*working-tree* files down to this laptop but left `.git/index` stale here (same "every tracked
file shown as both staged-deleted and untracked" signature as before - `git fsck` showed no
missing objects this time, so it was index-only, not object loss). Dropbox also created a
`docs (Selective Sync Conflict)/` folder holding what turned out to be the *correct* (matching
HEAD) `docs/` build, while the working `docs/` was a stale local one. Fixed via `git reset`
(mixed) + `git checkout -- docs/` (restoring docs/ from HEAD, which matched the conflict copy
modulo CRLF) + deleting the now-redundant conflict folder. Confirms the corruption risk isn't
limited to one machine - any machine with `.git` still inside a synced Dropbox folder can hit it,
even after another machine's `.git` has been moved out.

## Other loose ends

- `data-raw/albumColors-RJ.csv` added 2026-09-14 (RJ Andrews source metadata: album/plate/type/
  Rumsey link) - not yet wired into any `data-raw/*.R` extraction script; purpose/next step
  unconfirmed with user. 
  - Could this be useful in the package?
  
- `dev/colorpat/` (unified color-pattern palette system) - explicitly on hold, deferred past this
  release (`dev/README.md`).

## New development

- [ ] Make a plan to incorporate "palettes" that combine color and pattern fills. There are a 
  bunch of attempts and tests in `dev/colorpat/`. Review this work. If useful, check with authors
  of `ggpattern` on how best to do this. The goal would be to be able to use the palettes shown in
  C:\Dropbox\R\projects\ggCheysson\man\figures\RJ-Andrews-color-palettes.jpg
  
  - This should probably be done on a branch, `colorpat` since it is an API change.
  
  - [ ] Found 2026-09-15 while fixing the README's `1881_03` (1-color) example: two of the four
    `scale_pattern_*_cheysson()` functions are actually broken, which is directly relevant here.
    `scale_pattern_type_cheysson()` sets `aesthetics = "pattern_type"` in its `discrete_scale()`
    call, but ggpattern's real pattern-shape aesthetic is `pattern` (`pattern_type` is a
    different, mostly-unused aesthetic) - so it silently has no effect. Separately,
    `scale_pattern_fill_cheysson()` reads `cheysson_pattern_params(patterns, "fill")` (the base
    rect fill) instead of `"pattern_fill"` (the hatch color) - confirmed via `ggplot_build()`
    that it always returns `"transparent"` regardless of palette. `scale_pattern_angle_cheysson()`
    and `scale_fill_cheysson_pattern()` are correct. Full writeup, reproduction, and a working
    fix (verified visually, not yet applied to `R/`) in `dev/colorpat/PATTERN_SCALE_BUGS.md` and
    `dev/colorpat/test_pattern_scale_bugs.R`. Left `R/` untouched since 1.0.1 was just submitted
    to CRAN; the README's flagship pattern example was reworked to route around both bugs from
    calling code (`scale_pattern_manual()`/`scale_pattern_fill_manual()` fed by
    `cheysson_pattern_params()`, which itself is correct) rather than waiting on this fix.

- [ ] Another post from Tom Shanley: https://observablehq.com/@tomshanley/cheysson-grid discusses
  "programmatically creating gridlines like those used these charts created by Émile Cheysson in
  1881", via clipping. It proposes a `CheyssonLineChart`, and includes the data `cheysson18818data` 
  to draw this.

- [ ] Tom Shanley's post, https://observablehq.com/@tomshanley/cheysson-color-palettes, illustrates 
  each of the Cheysson palettes with a snip from an original figure. It would be useful to download 
  a couple of these and use in the README or elsewhere. Note that he uses different names than RJ 
  for the palettes.

