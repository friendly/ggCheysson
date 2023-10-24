library(here)
albumImages <- read_csv("data-raw/observable/albumColors.csv")
save(albumImages, file=here("data", "albumImages.RData"))
