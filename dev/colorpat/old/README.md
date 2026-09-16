# Superseded prototype snapshots

Moved here 2026-09-16 during a `dev/colorpat/` cleanup pass (see `dev/TASKS.md`). This is the
incremental history of the unified color-pattern prototype's growth from 3 to 11 (of the then-20)
palettes across two sessions (2025-12-30/31) - three successive milestone docs plus their test
scripts and generated images, each fully superseded by the next:

```
THREE_PALETTES_SUMMARY.md  -> test_prototype_colorpat.R -> test_colorpat_old/new/comparison.png,
                               test_1883_04_diverging.png, test_1881_03_sequential.png,
                               test_1881_04_categorical.png
FIVE_PALETTES_SUMMARY.md   -> test_all_prototypes.R      -> test_all_three_palettes.png,
                               test_1891_07_sequential.png, test_1886_08_grouped.png
                            -> test_five_palettes.R       -> test_five_palettes_swatches.png
TEN_PALETTES_SUMMARY.md    -> (11th palette added without its own milestone doc)
PROTOTYPE_SUMMARY.md         (an earlier, differently-scoped summary; superseded by the above)
```

**The final state of this work is `dev/colorpat/PROGRESS_UPDATE.md`** (11/20 palettes, dated
2025-12-31) plus `dev/colorpat/prototype_colorpat.R`, `test_ten_palettes.R`, and
`test_ten_palettes_swatches.png` - those stayed in `dev/colorpat/` directly since they're still
the right starting point if this work resumes. Everything in this `old/` folder is here for
narrative/historical record only (how the design evolved, decisions made along the way) - not
needed for active use. Kept together as one unit rather than partially deleted, since these docs
and their referenced images cross-reference each other by filename.

**Also stale**: all of it (including `PROGRESS_UPDATE.md` and `prototype_colorpat.R` outside this
folder) predates the 2026-09-16 palette naming fix and uses the old, now-invalid `Album_Qty` names
throughout (e.g. "1883_04", "1881_03") - see `dev/TASKS.md`'s "Album+Qty naming collision" entry
and `dev/colorpat/palette_id_crosswalk.R` for the old-name -> new-name mapping. Any of this work
would need a rename pass before reuse.
