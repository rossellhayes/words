library(dplyr)
library(incase)
library(stringr)
library(tibble)
library(tidyr)

lemmas <- readLines("data-raw/12dicts/Lemmatized/2+2+3lem.txt") %>%
  enframe(name = "id", value = "line") %>%
  mutate(
    type = grep_case(
      line,
      "(?<=    )\\w+"               ~ "variant",
      "(?<! )\\w+"                  ~ "lemma",
      perl                          = TRUE
    )
  ) %>%
  pivot_wider(names_from = type, values_from = line) %>%
  mutate(
    id      = NULL,
    lemma   = str_replace_all(
      lemma, c(" -\\>.*" = "", "[[^\\w'-/.]\\(\\)]" = "")
    ),
    variant = str_replace_all(variant, "[[^\\w'-/.,]\\(\\)]", "")
  ) %>%
  fill(lemma) %>%
  group_by(lemma) %>%
  slice_tail(1) %>%
  ungroup() %>%
  mutate(
    variant = if_else(
      is.na(variant), list(character(0)), strsplit(variant, ",")
    )
  )

words <- lemmas %>%
  unnest(variant) %>%
  {c(pull(., lemma), pull(., variant))} %>%
  unique() %>%
  sort()

usethis::use_data(lemmas, words, overwrite = TRUE)
