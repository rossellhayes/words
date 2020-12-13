offensive <- readLines("data-raw/bad-words.txt")[-1]

usethis::use_data(offensive, overwrite = TRUE)
