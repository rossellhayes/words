library(dplyr)
library(incase)
library(stringr)
library(tibble)
library(tidyr)

lemmas_frq <- readLines("data-raw/12dicts/Lemmatized/2+2+3frq.txt") %>%
  enframe(name = "id", value = "line") %>%
  mutate(
    type = grep_case(
      line,
      "(?<=\\-{5} )\\d+(?= \\-{5})" ~ "class",
      "(?<=    )\\w+"               ~ "variant",
      "(?<! )\\w+"                  ~ "lemma",
      perl                          = TRUE
    )
  ) %>%
  pivot_wider(names_from = type, values_from = line) %>%
  mutate(
    id      = NULL,
    class   = as.integer(str_replace_all(class, "-| ", "")),
    lemma   = str_replace_all(lemma,   "[[^\\w'-/.]\\(\\)]",  ""),
    variant = str_replace_all(variant, "[[^\\w'-/.,]\\(\\)]", "")
  ) %>%
  fill(class) %>%
  filter(!(is.na(lemma) & is.na(variant))) %>%
  fill(lemma) %>%
  group_by(class, lemma) %>%
  slice_tail(1) %>%
  ungroup() %>%
  mutate(
    variant = if_else(
      is.na(variant), list(character(0)), strsplit(variant, ",")
    )
  )

usethis::use_data(lemmas_frq, overwrite = TRUE)
