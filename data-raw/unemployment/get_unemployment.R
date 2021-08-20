# Unemployment

unemployed <- read_delim("./data-raw/unemployment/13211-02-05-4.csv",
                         delim = ";", escape_double = FALSE, col_names = FALSE,
                         locale = locale(date_names = "de", encoding = "ISO-8859-1"),
                         trim_ws = TRUE, skip = 5, col_types = "c", lazy = FALSE)
unemployed <- unemployed[1:(nrow(unemployed) - 4),]

colnames(unemployed) <- c("year", "AGS", "name",
                          paste0(unemployed[1, 4:ncol(unemployed)], " - ", unemployed[2, 4:ncol(unemployed)]))
colnames(unemployed) <- str_replace(colnames(unemployed), " - NA$", " - total")
unemployed <- unemployed[4:nrow(unemployed), ]


unemployed_counts <- unemployed[, 1:10]

unemploymentCountsAge <- unemployed_counts %>%
    pivot_longer(-c(year, AGS, name), names_to = "category", values_to = "count") %>%
    mutate(category = str_replace(category, "Arbeitslose - ", "")) %>%
    filter(str_detect(category, "Jahre")) %>%
    rename("ageGroup" = category) %>%
    filter(nchar(AGS) > 2) %>%
    mutate(ageGroup = case_when(
        ageGroup == "15 bis unter 20 Jahre" ~ "15_to_less_than_20_years",
        ageGroup == "15 bis unter 25 Jahre" ~ "15_to_less_than_25_years",
        ageGroup == "55 bis unter 65 Jahre" ~ "55_to_less_than_65_years",
        TRUE ~ ageGroup
    )) %>%
    mutate(count = str_replace_all(count, "-", NA_character_)) %>%
    mutate(count = str_replace_all(count, "\\*", NA_character_)) %>%
    mutate(count = str_replace_all(count, "\\.", NA_character_)) %>%
    mutate(count = as.integer(count))

usethis::use_data(unemploymentCountsAge, overwrite = TRUE)




unemploymentCountsCategories <- unemployed_counts %>%
    pivot_longer(-c(year, AGS, name), names_to = "category", values_to = "count") %>%
    mutate(category = str_replace(category, "Arbeitslose - ", "")) %>%
    filter(!str_detect(category, "Jahre")) %>%
    filter(nchar(AGS) > 2) %>%
    mutate(category = case_when(
        category == "Ausländer" ~ "foreigner",
        category == "langzeitarbeitslos" ~ "long_term_unemployed",
        category == "schwerbehindert" ~ "severely_disabled",
        TRUE ~ category
    )) %>%
    mutate(count = str_replace_all(count, "-", NA_character_)) %>%
    mutate(count = str_replace_all(count, "\\*", NA_character_)) %>%
    mutate(count = str_replace_all(count, "\\.", NA_character_)) %>%
    mutate(count = as.integer(count))

usethis::use_data(unemploymentCountsCategories, overwrite = TRUE)


unemployed_percentages <- unemployed[, c(1:3, 11:ncol(unemployed))]

unemployedPercentagesCategories <- unemployed_percentages %>%
    pivot_longer(-c(year, AGS, name), names_to = "grouping", values_to = "percent") %>%
    mutate(grouping = str_replace(grouping, "Arbeitslosenquote ", "")) %>%
    separate(grouping, into = c("group", "category"), sep = " - ") %>%
    filter(nchar(AGS) > 2) %>%
    mutate(category = case_when(
        category == "Männer" ~ "male",
        category == "Frauen" ~ "female",
        category == "Ausländer" ~ "foreigner",
        category == "15 bis unter 25 Jahre" ~ "15_to_less_than_25_years",
        TRUE ~ category
    )) %>%
    filter(group != "bez. abh. zivile Erwerbspers.") %>%
    select(-group) %>%
    mutate(percent = str_replace_all(percent, "^-$", NA_character_)) %>%
    mutate(percent = str_replace_all(percent, "^x$", NA_character_)) %>%
    mutate(percent = str_replace_all(percent, "^\\.$", NA_character_)) %>%
    mutate(percent = str_replace_all(percent, ",", ".")) %>%
    mutate(percent = as.numeric(percent))

usethis::use_data(unemployedPercentagesCategories, overwrite = TRUE)

