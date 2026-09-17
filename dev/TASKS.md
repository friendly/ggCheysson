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
  of `ggpattern` on how best to do this. 
  
  The goal would be to be able to use the palettes shown in
  C:\Dropbox\R\projects\ggCheysson\man\figures\RJ-Andrews-color-palettes.jpg
  Consider this to be ground truth here.

  - [x] 2026-09-16: created the `colorpat` branch (pushed to origin).

  - [x] Fixed the two real bugs found 2026-09-15 while reworking the README's `1881_03` example
    (`scale_pattern_type_cheysson()` targeted the wrong ggpattern aesthetic - `"pattern_type"`
    instead of `"pattern"`; `scale_pattern_fill_cheysson()` read the wrong param -`"fill"` instead
    of `"pattern_fill"`). Full diagnosis in `dev/colorpat/PATTERN_SCALE_BUGS.md`. Applied to
    `R/scale_patterns.R` plus its two roxygen examples, and to all 5 affected plots across
    `vignettes/getting-started.Rmd` and `vignettes/guerry-maps.Rmd` (same bug pattern:
    `aes(pattern_type = ...)` -> `aes(pattern = ...)`, dropped the now-redundant fixed
    `pattern = "stripe"` param, `guides()`/`labs()` `pattern_type =` -> `pattern =`). Verified via
    `ggplot_build()` and visually; full `R CMD check` clean (0/0/1, only the expected "New
    submission" NOTE), vignettes rebuild fine. Commit `853d36d` on `colorpat`. `README.Rmd` left
    as-is - it already works around both bugs via `scale_pattern_manual()`, which still works.

  - Asked a subagent (2026-09-16) to read all ~35 files under `dev/colorpat/` plus git history and
    cross-reference against shipped `R/`/`data/`, to sort current work from stale exploration
    before resuming. Findings:
    - **Timeline**: 2025-12-30 problem framed + `UNIFIED_COLOR_PATTERN_PLAN.md` written +
      `data-raw/observable/` SVGs parsed (7/20 palettes clean, 13/20 with `NA` gaps) ->
      2025-12-31 `prototype_colorpat.R` built working functions, grew 1->11/20 palettes across
      the session (each milestone = a superseded snapshot doc + test script + PNG) -> 2026-01-04
      pure reorg into `dev/colorpat/`, marked **ON HOLD** in `dev/README.md` ("too complex for
      current release") -> ~8.5 months dormant until the unrelated 2026-09-15 bug-fix pass above,
      filed in the same folder but conceptually separate.
      
    - **Best starting point**: `prototype_colorpat.R` (1472 lines, working
      `cheysson_colorpat()`/`scale_colorpat_cheysson()`/`list_colorpat_palettes()`/print method,
      11/20 palettes) + `PROGRESS_UPDATE.md` (final-state summary) + `test_ten_palettes.R`/
      `test_ten_palettes_swatches.png` (best combined visual QA).
      
    - **Important finding**: the shipped `data/cheysson_patterns.rda` (built by
      `data-raw/cheysson_patterns.R`) already stores positionally-paired fill+pattern data per
      palette element for all 20 palettes - matches `colorpat_extraction/1883_04.md`/`1881_03.md`
      element-for-element. So the "unified color-pattern pairs" data structure `dev/colorpat/` set
      out to build largely **already exists in production**; none of the prototype *functions*
      have been ported (`grep -ril colorpat R/` is empty), but the *data* substantially has. This
      narrows the likely remaining scope to a thin scale/accessor layer over existing
      `cheysson_patterns` data (now that the two bugs above are fixed), not a from-scratch
      20-palette re-extraction. Worth checking the production data covers all 20 palettes (closing
      the 9/20 gap that stalled the prototype) before doing any new manual Rumsey-plate work.
      
    - [x] 2026-09-16: checked. 6 of 20 palettes (`1882_04`, `1883_07`, `1886_04`, `1886_07`,
      `1887_06`, `1900_06`) have 15 total gap elements out of 98 - much smaller than the
      prototype's "9/20 need work" framing suggested. Root cause is more specific than "NA
      fields": those positions are literal `NULL` entries in `$patterns` (not list elements with
      missing fields) - a genuine `data-raw/cheysson_patterns.R` extraction gap, one array slot
      per missing color/pattern. This isn't just cosmetic: `cheysson_pattern_params()` returns
      bare `NA` for any `NULL` element regardless of which param is asked for, and feeding that
      `NA` to ggpattern's `pattern` aesthetic **hard-crashes** rendering ("missing value where
      TRUE/FALSE needed" inside `ggpattern:::fill_default_params()`) - reproduced for all 6
      palettes. So today, calling any `scale_pattern_*_cheysson()` on one of these 6 palettes
      breaks, not just renders incompletely. Wrote `dev/colorpat/show_all_patterns.R` (supersedes
      stale `dev/patterns/test_patterns.R`, which predates the aesthetic-name fix) to visualize
      all 20 palettes at once, dropping `NULL` positions with a per-palette gap count in the
      title; output at `dev/colorpat/all_patterns_overview.png`. Options for closing the gap:
      manual Rumsey-plate color-picking (as the prototype started), or making
      `cheysson_pattern_params()`/the scale functions substitute a safe default (e.g. `"none"`
      pattern, `"grey50"` fill) instead of `NA` for a `NULL` element - the latter is a quick
      robustness fix but doesn't recover the actual missing historical color/pattern.

    - [x] 2026-09-16: **root-caused and fixed all 15 gaps** - turned out to be neither of the two
      options above. Checked which source SVG pattern block each gap position corresponds to
      (`data-raw/observable/decNN.txt`, via `dec_day`): every single one is a `<line>`-based hatch
      pattern where every `<line>` tag omits at least one of `x1`/`y1`/`x2`/`y2` (valid SVG - these
      default to 0 - e.g. a horizontal line just omits `x1="0"`). `dev/patterns/parse_patterns_v2.R`
      required all four attributes to be explicitly present before accepting a line
      (`if (!any(is.na(c(x1,y1,x2,y2))))`), so every line in these patterns was silently dropped;
      with zero parsed lines, the pattern's `type` was never set, propagating as `NULL` through
      `data-raw/cheysson_patterns.R`'s `if (is.null(pat$type)) next`. Fixed by defaulting a missing
      coordinate to 0 instead of treating it as unparseable. Also found and fixed a second, distinct
      issue while re-running the parser: `dec01.txt` (`1883_07`) uses `x2="100%"` (percentage units)
      and plain `stroke="#xxx"`/`stroke-width="Npx"` attributes instead of the `style="stroke:...`
      syntax used elsewhere - added `parse_coord()` (strips a trailing `%`) and broadened the
      stroke/width regexes to `stroke[:=]"?`/`stroke-width[:=]"?` to accept both syntaxes.
      Regenerated `dev/svg_patterns.RData` and `data/cheysson_patterns.rda`. Verified: 0 gaps
      remain across all 20 palettes (was 15 across 6); the 3 truncated arrays (`1882_04`,
      `1886_04`, `1887_06`) now match their true source lengths; a regression check against 3
      previously-good entries (`1880_07[1]`, `1881_04[1]`, `1883_06[1]`) shows byte-identical
      fill/pattern_fill/pattern_angle values - fix is purely additive. `R CMD check` clean
      (0/0/0). Note: `dev/colorpat/show_all_patterns.R`'s swatches never map `pattern_angle` (uses
      ggpattern's default 30° for every swatch), so its rendered angles don't reflect the real
      per-palette data even though the underlying data is now correct (e.g. `1882_04`'s recovered
      entries are genuinely `pattern_angle = 0`/horizontal, confirmed via `str()`, despite
      rendering diagonal in that script) - worth fixing when building the RJ-Andrews comparison
      grid next.

    - [x] 2026-09-16: built `dev/colorpat/RJ-Andrews-reconstruct.{R,png}` - a 3-column
      reconstruction of `man/figures/RJ-Andrews-color-palettes.jpg` from current data/functions,
      same row order as the reference (read directly off the image as an adventDay sequence, not
      re-derived from any naming scheme), small "Dec.DD-Album.plate" labels per row (`plate` =
      the true unique identifier - `RumseyListNo`'s decimal suffix, e.g. `12514.021` -> `21` -
      confirmed against Shanley's own `{type}{RumseyListNo digits}` naming in
      `man/figures/shanley-palettes.png`, e.g. his `diverging12541021`, NOT the `fill`/`Qty`-based
      names our package uses). Building this surfaced a **third, bigger data bug**: our
      `data-raw/cheysson_palettes.R`/`cheysson_patterns.R` build palette names from `Album + Qty`
      (e.g. `"1880_07"`), but `Qty` is not a unique plate discriminator - 4 real collisions
      (`1880_07` <- adventDay 6 & 24; `1881_04` <- 21 & 25; `1886_04` <- 4, 15 & 19; `1886_08` <-
      2 & 7) silently overwrote 5 of the original 25 palettes during extraction (plain
      `list[[name]] <-` assignment, last adventDay wins - confirmed against each shipped
      `dec_day`). So 5 of 25 reference palettes are **not just gapped but entirely absent** from
      the shipped package, recoverable from the same source SVGs (not yet done - would need a
      real unique key, e.g. `dec_day` or `RumseyListNo`, which touches public palette names
      throughout the package). Per user decision: built the grid now with the 20 available,
      showing the 5 lost ones as explicit grey crosshatch placeholders (correctly labeled from
      `data-raw/observable/albumColors.csv`, which has all 25 rows) rather than omitting or
      approximating them.

    - [x] 2026-09-16: cross-checked the naming-collision finding against Tom Shanley's own IDs
      (`man/figures/shanley-palettes.png`, scheme `{type}{RumseyListNo digits}`, e.g.
      `diverging12541021`) - 24/24 legible IDs resolve to a unique `advent_day` via
      `RumseyListNo`, confirming it (equivalently `dec_day`) really is the one reliable key. Found
      2 isolated typos in Shanley's ID *strings* specifically (not his prose, not Andrews' labels):
      `diverging12541021` has digits 4/5 transposed (should be `diverging12514021`), and
      `category1252605` is missing a trailing digit (should be `category12526050`). Also checked
      whether `Qty` (the field the current naming bug uses) might mean something else useful: it
      matches the actual shipped pattern-element count for 18/20 currently-shipped palettes
      (2 mismatches, `advent_day` 5 and 22, not investigated further) - strong evidence `Qty` is a
      swatch/element count, not a plate identifier, which is exactly why it collides.
    - [x] 2026-09-16: built `dev/colorpat/palette_id_crosswalk.{R,csv}` - one row per advent day
      (25 rows), columns `advent_day, album_year, plate, type, qty, rumsey_no,
      current_pkg_name, shipped, andrews_label, shanley_id`. `plate` = `rumsey_no`'s decimal
      suffix (there's no separate "plate number" field in any source data - this functions as the
      de facto unique plate identifier, per the Shanley cross-check above; it's Rumsey's own
      catalog suffix, not necessarily Cheysson's original plate/page number, which isn't
      recoverable from data in this repo). Makes the 4 collision groups and all 5 lost advent days
      fully explicit via `shipped == FALSE`, and gives three lookup paths (advent_day, rumsey_no,
      or either external label) into the same data. Will need re-running if/when the underlying
      Album+Qty naming scheme is fixed (kept as a script, not a one-off, for exactly that reason).

    - [x] 2026-09-16: **fixed the Album+Qty naming scheme itself.** `data-raw/cheysson_palettes.R`
      and `cheysson_patterns.R` now derive `plate` from `RumseyListNo`'s decimal suffix instead of
      `Qty` (both scripts had the identical flawed line; also fixed the `plate` metadata field
      each stored, which was silently just `Qty` under a misleading name). Regenerated
      `data/cheysson_palettes.rda` and `data/cheysson_patterns.rda`: 20 -> **25** palettes, all 4
      collisions resolved, all 5 previously-lost advent days recovered. Verified: names match
      `dev/colorpat/palette_id_crosswalk.csv`'s `new_name` column exactly for both data objects;
      `dec_day` -> name is now a clean 1:1 map covering 1:25; 0 NULL gaps still (the earlier fix
      holds); renamed palettes carry forward byte-identical color data (e.g. `1883_06` -> `1883_13`
      still `#060201 #cb3f50 #366788 #365178`).
      
      This renames 19 of the 20 previously-shipped palettes (only `1906_06` coincides by chance -
      `plate == Qty` for that one row), so propagated the new names everywhere: every
      `scale_*_cheysson()`/`cheysson_pal()`/`cheysson_pattern()`/`show_palette()` default
      argument, every roxygen `@examples` block, `README.Rmd`, both vignettes
      (`getting-started.Rmd`, `guerry-maps.Rmd`), and the stale "20 palettes"/"83 patterns"
      counts throughout (now 25/134). Left two illustrative "e.g." mentions of `"1880_07"`
      unchanged (`R/palettes.R`'s and `R/data.R`'s naming-convention explainers) since that name
      is still valid and, happily, now actually accurate (plate 7 of the 1880 album) where before
      it was only coincidentally so. Also fixed a related doc bug in `R/data.R`: `albumImages`'s
      `Qty` field was documented as "Plate number within the album" - corrected to describe what
      it actually is.
      
      Verified via full `R CMD check` (0/0/0, examples included) and an actual
      `devtools::build_vignettes()` run (both vignettes rebuild clean) - not just a check that
      skips vignettes. Rebuilt pkgdown and `README.md` afterward. Pushed (`faa789a`).

    - [x] 2026-09-16: added 2 real (previously eval=FALSE / nonexistent) pattern examples to
      README's Pattern Support section, using `1886_24` (good solid/stripe/crosshatch variety).
      Pushed (`c384ad9`). **User flag, for the record - not yet addressed**: these examples don't
      actually show the color+pattern *combination* style that inspired Andrews/Shanley's
      original swatches (a solid color field with a contrasting pattern overlaid on top - two
      encodings combined). The swatch example maps `fill` from
      `cheysson_pattern_params(patterns, "fill")`, which is `"transparent"` for every hatch-type
      entry (see `PATTERN_SCALE_BUGS.md`'s note on `scale_fill_cheysson_pattern()` - this is by
      design, matching the historical "hatching on bare paper" style, not a bug) - so those
      swatches show *only* a pattern on white, not a colored background with a pattern on top.
      This is the same underlying gap the unified color-pattern work below was meant to close.
      
    - **`UNIFIED_COLOR_PATTERN_PLAN.md` has a real API plan**: new data object
      `cheysson_colorpat_palettes` (list of palettes, each with `elements` =
      `{fill, pattern_type, pattern_fill, pattern_angle, pattern_density, label}`); accessor
      `cheysson_colorpat(palette, n)`; unified scale `scale_colorpat_cheysson(palette,
      aesthetics = "auto", reverse, ...)` that auto-detects and returns/applies multiple ggplot2
      scales at once; lister `list_colorpat_palettes(type)`; explicit stance to keep old
      `scale_fill_cheysson()`/`scale_pattern_*_cheysson()` working alongside the new ones.
      
    - **Known dead ends / unresolved, don't repeat**: 
      (1) `1883_04`'s neutral-midpoint color
      (`#f5f5f5`) was invented, not extracted from the plate - `colorpat_extraction/1883_04.md`
      still has it as an open question; 
      (2) `scale_colorpat_cheysson()` returns a *list* of scale
      objects requiring manual `+` per aesthetic, not one addable object - unsolved, flagged in
      `PROTOTYPE_SUMMARY.md`; there's also a stray `+.gg` operator override near
      `prototype_colorpat.R:1358` that shadows ggplot2's own `+` - do not reuse, it's an abandoned,
      risky approach; (3) pattern interpolation for `n > palette size` was punted on in the plan
      ("recycle patterns, but warn") and never implemented/tested.
      
    - **Safe to archive/delete** (all fully superseded, nothing orphaned - every PNG traced to its
      generating script): 
      `PROTOTYPE_SUMMARY.md`/`THREE_PALETTES_SUMMARY.md`/
      `FIVE_PALETTES_SUMMARY.md`/`TEN_PALETTES_SUMMARY.md` (four successive snapshots, superseded
      by `PROGRESS_UPDATE.md`); `
      test_prototype_colorpat.R`/`test_all_prototypes.R`/
      `test_five_palettes.R` and their PNGs (`test_colorpat_old/new/comparison.png`,
      `test_1883_04_diverging.png`, `test_1881_03_sequential.png`, `test_1881_04_categorical.png`,
      `test_all_three_palettes.png`, `test_1891_07_sequential.png`, `test_1886_08_grouped.png`,
      `test_five_palettes_swatches.png`) - superseded by `test_ten_palettes.R`/
      `test_ten_palettes_swatches.png`. `colorpat_extraction/` + `colorpat_extractions.RData` +
      `extract_colorpat_pairings.R` + `COLORPAT_EXTRACTION_TEMPLATE.md` are reference-only now
      (Rumsey-plate URLs, `NA`-gap list) given production data likely already covers this.
      
    - [x] 2026-09-16: **resolved.** Read the actual content myself (not just the subagent's
      earlier pass) before deciding, since it matters which category each file lands in. One
      correction to the subagent's read: it called `colorpat_extraction/` "reference-only... given
      production data likely already covers this" - disagree after reading it directly. It holds
      manually-verified (color, pattern) *pairing* data plus qualitative judgment calls
      (flagged ambiguous patterns, identified design patterns like "monochrome sequential" /
      "diverging dual-encoded") that the production `cheysson_patterns` table doesn't capture -
      this is the most directly relevant resource for the color+pattern-combination gap noted
      above, not superseded by anything. Kept in place, not moved.
      
      Verdict: **nothing in `dev/colorpat/` is "truly not useful"** - everything is real work
      product, nothing broken/empty/junk. Split into current (stays in `dev/colorpat/` directly)
      vs. superseded-but-has-narrative-value (moved to `dev/colorpat/old/`, kept as one unit since
      the docs/scripts/images cross-reference each other by filename - see
      `dev/colorpat/old/README.md`):
      - **Moved to `old/`** (17 files): `PROTOTYPE_SUMMARY.md`, `THREE_PALETTES_SUMMARY.md`,
        `FIVE_PALETTES_SUMMARY.md`, `TEN_PALETTES_SUMMARY.md`, `test_prototype_colorpat.R`,
        `test_all_prototypes.R`, `test_five_palettes.R`, and the 10 PNGs those three scripts
        generate - all genuinely superseded by `PROGRESS_UPDATE.md`/`test_ten_palettes.R`, but
        kept (not deleted) for the narrative record of how the design evolved.
      - **Kept in place**: `COLORPAT_ISSUE_SUMMARY.md`, `UNIFIED_COLOR_PATTERN_PLAN.md`,
        `COLORPAT_EXTRACTION_TEMPLATE.md`, `colorpat_extraction/` (all 7 files, see above),
        `colorpat_extractions.RData`, `extract_colorpat_pairings.R`, `PROGRESS_UPDATE.md`,
        `prototype_colorpat.R`, `test_ten_palettes.R`/`.png`, plus everything from this week's
        active session work (`PATTERN_SCALE_BUGS.md`, `RJ-Andrews-reconstruct.*`,
        `all_patterns_overview.png`, `palette_id_crosswalk.*`, `show_all_patterns.R`,
        `test_pattern_scale_bugs.R`, `test_broken/fixed.png`).
      
      Checked nothing outside `dev/colorpat/` references any moved file before moving (`grep -rl`
      across `R/`, `data-raw/`, vignettes, README - clean). Updated `dev/README.md`'s stale
      "ON HOLD"/"too complex" framing to point at this file and note the branch resumed.
      
      **Important caveat, not fixed here**: `colorpat_extraction/`'s 4 palette `.md` files,
      `PROGRESS_UPDATE.md`, and `prototype_colorpat.R` all predate 2026-09-16's naming fix and use
      the old, now-invalid `Album_Qty` names throughout - `colorpat_extraction/README.md` even
      flags the exact collision we later found and fixed ("'1881_04' appears twice in source data
      with different types"). Any reuse of this material needs a rename pass first (mapping now in
      `data-raw/cheysson_labels.R`, see next item - moved since the crosswalk table it was).

    - [x] 2026-09-16: **promoted the crosswalk table to a real package dataset**,
      `cheysson_labels` (name chosen by user). Moved `dev/colorpat/palette_id_crosswalk.R` ->
      `data-raw/cheysson_labels.R` (`git mv`, preserves history) and adapted it to package
      convention: `library(here)` for paths (matching `cheysson_palettes.R`/`cheysson_patterns.R`),
      `usethis::use_data(cheysson_labels, overwrite = TRUE)` instead of `write_csv()` to a `dev/`
      path, and 3 `stopifnot()` assertions (name unique; name matches
      `names(cheysson_palettes)`/`names(cheysson_patterns)` exactly) so a future re-run fails loudly
      if the naming logic ever drifts again instead of silently producing a wrong table. Deleted
      the now-redundant `dev/colorpat/palette_id_crosswalk.csv` (single source of truth is now
      `data/cheysson_labels.rda`, built by the script above).
      
      Per user request: dropped `shipped` (always `TRUE` now that the naming bug is fixed - no
      longer meaningful) and renamed `current_pkg_name` -> `old_name`; added `name` *first* as the
      real, current, verified-unique package identifier (what you'd pass to
      `scale_color_cheysson()` etc.) - previously the table had no such column, since it predated
      the fix and only recorded what a palette *would* be called. Final columns: `name`,
      `advent_day`, `album_year`, `plate`, `type`, `qty`, `rumsey_no`, `old_name`,
      `andrews_label`, `shanley_id`.
      
      Verified: `Rscript data-raw/cheysson_labels.R` runs clean, all 3 `stopifnot` checks pass;
      reinstalled the package and confirmed `cheysson_labels` loads with the right 25x10
      shape/content; spot-checked lookups by `name`, `andrews_label`, and `shanley_id` all resolve
      correctly; confirmed every `name` resolves to both a `cheysson_palettes` and
      `cheysson_patterns` entry. `R CMD check`: 0 errors, 1 WARNING ("Undocumented data sets:
      'cheysson_labels'") - expected at the time.

    - [x] 2026-09-16: **documented it.** Added a `cheysson_labels` roxygen block to `R/data.R`
      (matching the existing `albumImages`/`cheysson_fonts` style) explaining what it's *for* (look
      up a palette by whichever scheme you have it in - an Advent day, a Rumsey catalog number, or
      an Andrews/Shanley label - and get back the `name` to actually use with
      `scale_color_cheysson()` etc.), documenting all 10 columns, and linking to all 4 sources
      (David Rumsey, RJ Andrews' GitHub + his own `man/figures/RJ-Andrews-color-palettes.jpg`
      reference grid, Tom Shanley's Observable notebook + his own
      `man/figures/shanley-palettes.png` reference grid, and the package's own
      `data-raw/observable/albumColors.csv`). `@details` also explains the `old_name`
      naming-collision history this table documents. Hit one Rd markup NOTE (literal `{...}` in
      prose text being parsed as markup - `checkRd: Lost braces`) - fixed by rewording, not
      escaping, since the escaped form was harder to read. Also needed a `_pkgdown.yml` reference
      index entry (pkgdown errors on a "missing from index" topic otherwise, separate from R CMD
      check). Verified: full `R CMD check` 0/0/0, rendered the Rd with `tools::Rd2txt()` and
      read it end to end, pkgdown rebuilds clean.
      
      Still open: an actual lookup *function* (e.g. something like
      `cheysson_lookup(label, from = "andrews")`) rather than requiring users to subset
      `cheysson_labels` by hand - not asked for yet, noting it as a natural next step if wanted.

    - [x] 2026-09-16: bumped `DESCRIPTION` to **1.1.0** (Date 2026-09-16) and started a NEWS.md
      section for it. User's call, reasoned explicitly: the palette rename is a breaking change to
      public identifiers (not a bugfix in the semver sense, even though it started as one), so
      1.1.0 over the initially-considered 1.0.2 - and safe to do now regardless of `master`'s
      1.0.1 being under CRAN review, since branches can carry any version and this only matters at
      merge/release time. NEWS.md 1.1.0 covers: the breaking naming fix (25 palettes now, was 20;
      134 pattern specs, was 83), the 15-gap SVG-parsing fix, the two `scale_pattern_*_cheysson()`
      bugs, the new `cheysson_labels` dataset, and the README pattern examples. `R CMD check`
      still 0/0/0 after the bump.

    - [x] 2026-09-17: added `cheysson_name(label, from = "auto", advent_day = NULL)` in the new
      `R/cheysson_name.R` - the lookup function flagged as "still open" above. Design worked out
      collaboratively over several turns: `from = "auto"` tries, in priority order, the always-
      unique columns first (`name`, `andrews_label`, `shanley_id`, `rumsey_no`) and falls back to
      `old_name` last, since that's the only column with real duplicates (4 collision groups from
      the pre-1.1.0 naming bug). Explicit `from` values search only that one column. `advent_day`
      is an optional disambiguator/assertion: if supplied and it contradicts what `label` resolves
      to, errors; if supplied and consistent, returns that row silently (no warning even for an
      otherwise-ambiguous `old_name`). If `advent_day` is *not* supplied and more than one
      candidate matches (only possible via `old_name`), `warning()`s listing every candidate and
      returns the one with `max(advent_day)` - verified this exactly matches what 1.0.1 actually
      shipped under each colliding name, for all 4 real collision groups (`1880_07`->24,
      `1881_04`->25, `1886_04`->19, `1886_08`->7). Verified via a standalone scratchpad script
      covering all paths: each scheme's happy path, the ambiguous-`old_name` warning + winner
      selection (all 4 groups), explicit-`advent_day` disambiguation with no warning,
      `advent_day` contradicting an unambiguous label (errors), not-found (errors), invalid
      `advent_day` (errors), and direct use as `scale_color_cheysson(cheysson_name(...))`. Hit one
      `R CMD check` NOTE ("no visible binding for global variable 'cheysson_labels'") - fixed by
      adding `cheysson_labels` to the existing `utils::globalVariables()` call in `R/globals.R`
      alongside `cheysson_palettes`/`cheysson_patterns`. Added to `_pkgdown.yml`'s Color Palettes
      section. `R CMD check` 0/0/0.

    - [x] 2026-09-17: cleaned up old-style Rd macros (`\code{}`, `\link{}`, `\link[]{}`, `\url{}`,
      `\strong{}`, `\itemize{}`/`\item`) in roxygen prose across `R/data.R`, `R/fonts.R`,
      `R/palettes.R`, `R/patterns.R`, `R/scale_patterns.R`, `R/theme.R`, converting to markdown
      (`` `code` ``, `[fun()]`/`[obj]`, `<url>`, `**bold**`, `- ` bullets), per the user's global
      convention (`Roxygen: list(markdown = TRUE)` is set, and prose should use markdown, not raw
      Rd). Deliberately left `\describe{}`/`\item{}{}` alone in `@format` data-frame column lists
      (`albumImages`, `cheysson_fonts`, `cheysson_palettes`, `cheysson_patterns`,
      `cheysson_labels`) - there's no clean markdown equivalent for that definition-list structure,
      it's the standard convention even in markdown-mode packages, and markdown still processes
      fine *inside* the `\item{}{}` bodies (confirmed: backticks/links inside these render
      correctly). Verified via `devtools::document()`: several files regenerated identical Rd
      output (proving the itemize->bullet conversion is exactly equivalent), others reflowed
      cleanly with no semantic change. `R CMD check` 0/0/0 after.

    - [x] 2026-09-17: fixed pkgdown's "Missing alt-text" accessibility warning on 5 `<img>` tags
      in `README.Rmd` (2 uses of `maps.png`, plus `color-palettes.png`, `fonts1.png`, and
      `RJ-Andrews-color-palettes.jpg`) - proposed alt text for each, user approved, added
      `alt="..."` attributes, re-knitted `README.md`. Rebuilt pkgdown: "Checking for problems"
      section now clean (was 5 items). Left knitr's auto-generated code-chunk figures alone
      (they get `alt=""` from rmarkdown/knitr itself, not flagged by pkgdown's check, and fixing
      would need `fig.alt` chunk options on every plot chunk - out of scope here).

    - [x] 2026-09-17: made the `## Available Palettes` section's full palette listing
      (`list_cheysson_pals()` output) collapsible in `README.Rmd`, using the `<details>`/
      `<summary>` trick from ggpattern's README
      (<https://github.com/trevorld/ggpattern/blob/master/README.Rmd>) - raw HTML wrapping the
      code chunk, blank lines on both sides so pandoc still parses the fenced code block inside
      it. Verified by re-knitting: the chunk and its printed output land correctly nested between
      `<details>`/`</details>` in `README.md`. Also added a one-sentence description of what
      `cheysson_palettes` actually contains (25 named palettes, each with type, album year, plate
      number, hex colors) right before the collapsible list, since the section previously jumped
      straight into `list_cheysson_pals()` output with no explanation. Rebuilt pkgdown - no new
      warnings.

- [x] 2026-09-17: **The Cheysson font sizes for titles, axis labels, legends are still too small in
  quite a few examples.** E.g., see the examples in the getting started vignette. Perhaps that is
  just due to `base_size = 11` as the default, but maybe something more fundamental about the
  fonts included here.

  Investigated both hypotheses. `plot.title` (`CheyssonTitle`) turned out to have the same kind of
  bug as the earlier `axis.title`/`legend.title`/`strip.text` fix (`theme_cheysson()`
  axis/legend title task, above): it measures ~8% smaller than Arial at the same nominal size
  (`systemfonts::font_info()`: lineheight 11.61 vs Arial's 12.66) but got *no* correction factor -
  the earlier fix only touched the `CheyssonSansCaps`-based elements. Rendering a direct
  `theme_minimal()` vs `theme_cheysson()` comparison (`compare_minimal.png`/`compare_cheysson.png`
  in scratchpad) confirmed it visually: title and axis-title text read noticeably smaller/lighter
  than the minimal version. Separately confirmed `plot.subtitle`/`axis.text`/`legend.text` (which
  use the base `Cheysson` body font, not `title_family`/`axis_title_family`) are *not* undersized -
  `Cheysson`'s own metrics are equal to or larger than Arial's - so those were correctly left alone
  by the earlier fix and still are.

  Generalized the fix rather than special-casing `CheyssonTitle` the same way `CheyssonSansCaps`
  was: added `cheysson_font_size_adjust(family)` (new, internal, top of `R/theme.R`) - a lookup
  table giving a correction factor for all 4 non-body display fonts, each derived the same way as
  the original `CheyssonSansCaps` fix (landing between the ascent-ratio-implied and
  lineheight-ratio-implied correction vs Arial): `CheyssonSansCaps` 1.15 (unchanged),
  `CheyssonTitle` 1.10 (user's call, from visually comparing rendered output at this and the
  metrics-implied ~1.07 - the "Automobile Efficiency" example in
  `dev/fonts/test_fonts_themes.R` looked better at 1.10), `CheyssonItalic` 1.12,
  `CheyssonOutlineCaps` 1.30 - the latter two aren't used as theme defaults anywhere today, so this
  only matters if a user manually passes one of them via `title_family`/`axis_title_family`
  (previously they'd have silently gotten no correction at all). Applied
  `title_size_adjust <- cheysson_font_size_adjust(title_family)` to `plot.title` in *both*
  `theme_cheysson()` and `theme_cheysson_map()` (which independently duplicates the same
  `plot.title` styling); `theme_cheysson_minimal()` inherits both fixes via `theme_cheysson()`.
  Renamed the old `caps_size_adjust` variable to `axis_title_size_adjust` for symmetry, no
  behavior change there.

  Verified: rendered `theme_cheysson()` at `base_size` 9/11/14/18 against `theme_minimal()` at the
  same sizes (new `dev/fonts/test_title_size_fix.R`, saved as
  `dev/fonts/title_size_fix_base{9,11,14,18}_{minimal,cheysson}.png`) - title/axis-title text now
  reads at a comparable visual size to the minimal version across the whole range, not just at the
  default. Re-knitted `README.md` (its "With Fonts and Theme" example uses this exact
  "Automobile Efficiency" plot) and rebuilt both vignettes via `devtools::build_vignettes()` (the
  `guerry-maps` vignette leans heavily on `theme_cheysson_map()`) - both build clean. `R CMD check`
  0/0/0 (after removing a stray `Rplots.pdf` a scratchpad script left at the top level, unrelated
  to this fix - a plot rendered without an explicit device open).

  Caught a process gap while doing this: the first re-knit of `README.md` produced a byte-identical
  `README-with-fonts-1.png` - because `README.Rmd` does `library(ggCheysson)`, which loads the
  *installed* package, and the installed copy hadn't been rebuilt since editing `R/theme.R` (or,
  it turned out, since the 1.1.0 version bump at all - `citation("ggCheysson")`'s README output was
  still showing "1.0.1"). Reran `devtools::install()` before re-knitting; `README-with-fonts-1.png`
  and `README-complete-aesthetic-1.png` (also uses `theme_cheysson()`) then updated correctly, and
  the citation output now correctly reads 1.1.0. Worth remembering for future theme.R/similar
  changes: re-knitting README.Rmd without an intervening install silently uses stale code.

- [ ] The way of specifying the combinations of colors and patterns used in examples seems unnecesarily
  complicated. E.g., in the README example, "Complete Cheysson Aesthetic", there are four calls to
  `scale_*()` functions. Perhaps this needs a `scale_cheysson()` wrapper to simplify this.

- [ ] Should get some feedback from the maintainer of `ggpattern` (Trevor Davis) regarding the
  design of our pattern system. But how to raise an issue that gives examples and refers to the `colorpat`
  branch?

- [ ] Another post from Tom Shanley: https://observablehq.com/@tomshanley/cheysson-grid discusses
  "programmatically creating gridlines like those used these charts created by Émile Cheysson in
  1881", via clipping. It proposes a `CheyssonLineChart`, and includes the data `cheysson18818data` 
  to draw this.

- [ ] Tom Shanley's post, https://observablehq.com/@tomshanley/cheysson-color-palettes, illustrates 
  each of the Cheysson palettes with a snip from an original figure. It would be useful to download 
  a couple of these and use in the README or elsewhere. Note that he uses different names than RJ 
  for the palettes.
  Files: man/figures/cheysson1.png, man/figures/cheysson2.png are two examples

- [ ] It would be nice to make a chart of the colors in the cheysson palettes in the form of a color
  wheel/circle -- points in their colors, with labels for the palette name.
  
  
