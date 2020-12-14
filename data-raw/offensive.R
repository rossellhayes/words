library(magrittr)

offensive <- readLines("data-raw/bad-words.txt")[-1] %>%
  c("pagan", "tumor") %>%
  sort()

usethis::use_data(offensive, overwrite = TRUE)
