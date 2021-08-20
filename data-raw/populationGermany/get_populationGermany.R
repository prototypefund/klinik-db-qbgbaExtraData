# Population - populationGermany

population <- read_delim("./data-raw/populationGermany/12411-0018.csv",
                         delim = ";", escape_double = FALSE, col_names = FALSE,
                         locale = locale(date_names = "de", encoding = "ISO-8859-1"),
                         trim_ws = TRUE, skip = 4, col_types = "c", lazy = FALSE)
population <- population[1:(nrow(population) - 4),]

colnames(population) <- c("date", "AGS", "name",
                          paste0(population[1, 4:ncol(population)], " - ", population[2, 4:ncol(population)]))
population <- population[3:nrow(population), ]
populationGermany <- population %>%
    pivot_longer(-c(date, AGS, name), names_to = "GES_Altersgruppe", values_to = "count") %>%
    separate(GES_Altersgruppe, into = c("gender", "ageGroup"), sep = " - ") %>%
    mutate(year = str_extract(date, "[0-9]{4,4}$")) %>%
    select(year, AGS, name, gender, ageGroup, count) %>%
    mutate(count = as.integer(count)) %>%
    mutate(ageGroup = case_when(
        ageGroup == "unter 3 Jahre" ~ "younger_than_3_years",
        ageGroup == "3 bis unter 6 Jahre" ~ "3_<=_x_<_6_years",
        ageGroup == "6 bis unter 10 Jahre" ~ "6_<=_x_<_10_years",
        ageGroup == "10 bis unter 15 Jahre" ~ "10_<=_x_<_15_years",
        ageGroup == "15 bis unter 18 Jahre" ~ "15_<=_x_<_18_years",
        ageGroup == "18 bis unter 20 Jahre" ~ "18_<=_x_<_20_years",
        ageGroup == "20 bis unter 25 Jahre" ~ "20_<=_x_<_25_years",
        ageGroup == "25 bis unter 30 Jahre" ~ "25_<=_x_<_30_years",
        ageGroup == "30 bis unter 35 Jahre" ~ "30_<=_x_<_35_years",
        ageGroup == "35 bis unter 40 Jahre" ~ "35_<=_x_<_40_years",
        ageGroup == "40 bis unter 45 Jahre" ~ "40_<=_x_<_45_years",
        ageGroup == "45 bis unter 50 Jahre" ~ "45_<=_x_<_50_years",
        ageGroup == "50 bis unter 55 Jahre" ~ "50_<=_x_<_55_years",
        ageGroup == "55 bis unter 60 Jahre" ~ "55_<=_x_<_60_years",
        ageGroup == "60 bis unter 65 Jahre" ~ "60_<=_x_<_65_years",
        ageGroup == "65 bis unter 75 Jahre" ~ "65_<=_x_<_75_years",
        ageGroup == "75 Jahre und mehr" ~ "75_and_older"
    ))

usethis::use_data(populationGermany, overwrite = TRUE)
