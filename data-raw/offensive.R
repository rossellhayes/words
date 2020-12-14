offensive <- readLines("data-raw/bad-words.txt")[-1] %>%
  c("pagan") %>%
  sort()

usethis::use_data(offensive, overwrite = TRUE)
