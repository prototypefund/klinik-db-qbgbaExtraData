# People in care facilities -----------------------------------------------

people_care_facilities <- read_delim("./data-raw/peopleCareFacilitiesCategorical/22411-02-03-4.csv",
                                     delim = ";", escape_double = FALSE, col_names = FALSE,
                                     locale = locale(date_names = "de", encoding = "ISO-8859-1"),
                                     trim_ws = TRUE, skip = 3, lazy = FALSE, col_types = "c")
people_care_facilities <- people_care_facilities[1:(nrow(people_care_facilities) - 3), ]

colnames(people_care_facilities) <- c("date", "AGS", "name", "gender",
                                      paste0(people_care_facilities[1, 5:ncol(people_care_facilities)]))
people_care_facilities <- people_care_facilities[3:nrow(people_care_facilities), ]

colnames(people_care_facilities) <- str_replace(colnames(people_care_facilities), "^Pflegebedürftige$", "persons_needing_care")
colnames(people_care_facilities) <- str_replace(colnames(people_care_facilities), "^ambulante Pflege$", "outpatient_care")
colnames(people_care_facilities) <- str_replace(colnames(people_care_facilities),
                                                "Pflegebedürftige der Pflegeheime, vollstationär",
                                                "full_stationary_care")
colnames(people_care_facilities) <- str_replace(colnames(people_care_facilities),
                                                "Pflegebedürft\\.d\\.Pflegeheime Dauerpflege, vollstat\\.",
                                                "fully_inpatient_care")
colnames(people_care_facilities) <- str_replace(colnames(people_care_facilities),
                                                "Pflegebed\\.d\\.Pflegeheime vollstat\\. Kurzzeitpflege",
                                                "short_term_stationary_care")
colnames(people_care_facilities) <- str_replace(colnames(people_care_facilities),
                                                "Pflegegeldempfänger",
                                                "recipients_of_long_term_care_allowance")
colnames(people_care_facilities) <- str_replace(colnames(people_care_facilities),
                                                "mit erheblich eingeschränkter Alltagskompetenz",
                                                "people_with_significant_disabilities")
colnames(people_care_facilities) <- str_replace(colnames(people_care_facilities),
                                                "nachrichtlich: teilstationäre Pflege",
                                                "partial_inpatient_care")
colnames(people_care_facilities) <- str_replace(colnames(people_care_facilities),
                                                "nachrichtl\\.: o\\.Pflegest m\\.erheb\\.eingesch\\.Alltagsk\\.",
                                                "care_level_with_considerable_diminished_abilities")
peopleCareFacilitiesCategorical <- people_care_facilities %>%
    mutate(across(persons_needing_care:care_level_with_considerable_diminished_abilities,
                  ~ if_else(trimws(.x) == "-", NA_character_, .x))) %>%
    mutate(across(persons_needing_care:care_level_with_considerable_diminished_abilities,
                  ~ if_else(trimws(.x) == "x", NA_character_, .x))) %>%
    mutate(across(persons_needing_care:care_level_with_considerable_diminished_abilities,
                  ~ if_else(trimws(.x) == ".", NA_character_, .x))) %>%
    mutate(across(persons_needing_care:care_level_with_considerable_diminished_abilities,
                  ~ as.integer(.x))) %>%
    mutate(gender = case_when(
        gender == "männlich" ~ "male",
        gender == "weiblich" ~ "female",
        TRUE ~ gender
    )) %>%
    filter(gender != "Insgesamt") %>%
    filter(nchar(AGS) > 2) %>%
    mutate(year = str_extract(date, "[0-9]{4,4}$")) %>%
    select(year, everything()) %>%
    select(-date)

usethis::use_data(peopleCareFacilitiesCategorical, overwrite = TRUE)
