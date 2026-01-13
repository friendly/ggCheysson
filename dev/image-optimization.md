# Package Size Optimization - Image Hosting

## Problem
The package had a large installed size (~5.6 MB) due to demonstration images in `man/figures/` used in README.Rmd.

## Solution
Moved the 4 largest images to GitHub hosting while keeping them in the repository for the GitHub README.

### Files Excluded from CRAN Tarball

Added to `.Rbuildignore`:
1. `man/figures/maps.png` (1.7M)
2. `man/figures/RJ-Andrews-color-palettes.jpg` (988K)
3. `man/figures/cheysson1.png` (701K)
4. `man/figures/cheysson2.png` (473K)

**Total saved:** ~3.9 MB

### Updated References in README.Rmd

Changed local paths to GitHub URLs:
- `maps.png` (2 occurrences) → `https://raw.githubusercontent.com/friendly/ggCheysson/master/man/figures/maps.png`
- `RJ-Andrews-color-palettes.jpg` → `https://raw.githubusercontent.com/friendly/ggCheysson/master/man/figures/RJ-Andrews-color-palettes.jpg`

Note: `cheysson1.png` and `cheysson2.png` are not used in README.Rmd but are excluded from the tarball.

## Result

- **Before:** ~5.4 MB tarball
- **After:** ~1.5 MB tarball
- **Reduction:** ~72% smaller

The images remain in the GitHub repository so:
- ✅ GitHub README displays correctly with images
- ✅ CRAN tarball is much smaller
- ✅ Users can still see all demonstration images on GitHub
- ✅ Package documentation (help files) remains complete

## Files Modified

1. `.Rbuildignore` - Added 4 large image files
2. `README.Rmd` - Changed 3 image references to GitHub URLs
3. `cran-comments.md` - Updated NOTE 2 explanation

## Important Notes

- Images are NOT deleted from the repository, just excluded from the CRAN package
- When you commit and push to GitHub, the images will still be there
- The GitHub URLs will work once the changes are pushed to the master branch
- For pkgdown site, the images will still work from the local files
