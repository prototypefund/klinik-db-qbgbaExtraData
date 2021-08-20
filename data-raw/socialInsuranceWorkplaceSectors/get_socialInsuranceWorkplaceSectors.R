# SozVers_Arbeitsort_Wirtschaftszweige ------------------------------------

SozVers_Arbeitsort_Wirtschaftszweige_2015 <- read_delim("./data-raw/socialInsuranceWorkplaceSectors/13111-07-05-4_2015.csv",
                                                        delim = ";", escape_double = FALSE, col_names = FALSE,
                                                        locale = locale(date_names = "de", encoding = "ISO-8859-1"),
                                                        trim_ws = TRUE, skip = 1, lazy = FALSE, col_types = "c")
SozVers_Arbeitsort_Wirtschaftszweige_2015 <- SozVers_Arbeitsort_Wirtschaftszweige_2015[1:(nrow(SozVers_Arbeitsort_Wirtschaftszweige_2015) - 4), ]
colnames(SozVers_Arbeitsort_Wirtschaftszweige_2015) <- c("AGS", "name", "sector",
                                                         paste0(SozVers_Arbeitsort_Wirtschaftszweige_2015[7, 4:ncol(SozVers_Arbeitsort_Wirtschaftszweige_2015)], " ",
                                                                SozVers_Arbeitsort_Wirtschaftszweige_2015[8, 4:ncol(SozVers_Arbeitsort_Wirtschaftszweige_2015)], " ",
                                                                SozVers_Arbeitsort_Wirtschaftszweige_2015[9, 4:ncol(SozVers_Arbeitsort_Wirtschaftszweige_2015)], " ",
                                                                SozVers_Arbeitsort_Wirtschaftszweige_2015[10, 4:ncol(SozVers_Arbeitsort_Wirtschaftszweige_2015)]))
SozVers_Arbeitsort_Wirtschaftszweige_2015 <- SozVers_Arbeitsort_Wirtschaftszweige_2015[11:nrow(SozVers_Arbeitsort_Wirtschaftszweige_2015), ]

SozVers1 <- SozVers_Arbeitsort_Wirtschaftszweige_2015[, c(1:3, 5:6)]
colnames(SozVers1) <- str_replace(colnames(SozVers1), "Nationalität Insgesamt Geschlecht ", "")
colnames(SozVers1) <- str_replace(colnames(SozVers1), "männlich", "male")
colnames(SozVers1) <- str_replace(colnames(SozVers1), "weiblich", "female")
SozVers1 <- SozVers1 %>%
    pivot_longer(-c("AGS", "name", "sector"), names_to = "sex", values_to = "count") %>%
    mutate(nationality = "total")

SozVers2 <- SozVers_Arbeitsort_Wirtschaftszweige_2015[, c(1:3, 8:9)]
colnames(SozVers2) <- str_replace(colnames(SozVers2), "Nationalität Ausländer\\(innen\\) Geschlecht ", "")
colnames(SozVers2) <- str_replace(colnames(SozVers2), "männlich", "male")
colnames(SozVers2) <- str_replace(colnames(SozVers2), "weiblich", "female")
SozVers2 <- SozVers2 %>%
    pivot_longer(-c("AGS", "name", "sector"), names_to = "sex", values_to = "count") %>%
    mutate(nationality = "foreigner")

SozVers_2015 <- bind_rows(SozVers1, SozVers2) %>%
    mutate(year = "2015") %>%
    select(year, AGS, name, sector, nationality, sex, count) %>%
    filter(nchar(AGS) > 2)

rm(SozVers1, SozVers2, SozVers_Arbeitsort_Wirtschaftszweige_2015)


SozVers_Arbeitsort_Wirtschaftszweige_2016 <- read_delim("./data-raw/socialInsuranceWorkplaceSectors/13111-07-05-4_2016.csv",
                                                        delim = ";", escape_double = FALSE, col_names = FALSE,
                                                        locale = locale(date_names = "de", encoding = "ISO-8859-1"),
                                                        trim_ws = TRUE, skip = 1, lazy = FALSE, col_types = "c")
SozVers_Arbeitsort_Wirtschaftszweige_2016 <- SozVers_Arbeitsort_Wirtschaftszweige_2016[1:(nrow(SozVers_Arbeitsort_Wirtschaftszweige_2016) - 4), ]
colnames(SozVers_Arbeitsort_Wirtschaftszweige_2016) <- c("AGS", "name", "sector",
                                                         paste0(SozVers_Arbeitsort_Wirtschaftszweige_2016[7, 4:ncol(SozVers_Arbeitsort_Wirtschaftszweige_2016)], " ",
                                                                SozVers_Arbeitsort_Wirtschaftszweige_2016[8, 4:ncol(SozVers_Arbeitsort_Wirtschaftszweige_2016)], " ",
                                                                SozVers_Arbeitsort_Wirtschaftszweige_2016[9, 4:ncol(SozVers_Arbeitsort_Wirtschaftszweige_2016)], " ",
                                                                SozVers_Arbeitsort_Wirtschaftszweige_2016[10, 4:ncol(SozVers_Arbeitsort_Wirtschaftszweige_2016)]))
SozVers_Arbeitsort_Wirtschaftszweige_2016 <- SozVers_Arbeitsort_Wirtschaftszweige_2016[11:nrow(SozVers_Arbeitsort_Wirtschaftszweige_2016), ]

SozVers1 <- SozVers_Arbeitsort_Wirtschaftszweige_2016[, c(1:3, 5:6)]
colnames(SozVers1) <- str_replace(colnames(SozVers1), "Nationalität Insgesamt Geschlecht ", "")
colnames(SozVers1) <- str_replace(colnames(SozVers1), "männlich", "male")
colnames(SozVers1) <- str_replace(colnames(SozVers1), "weiblich", "female")
SozVers1 <- SozVers1 %>%
    pivot_longer(-c("AGS", "name", "sector"), names_to = "sex", values_to = "count") %>%
    mutate(nationality = "total")

SozVers2 <- SozVers_Arbeitsort_Wirtschaftszweige_2016[, c(1:3, 8:9)]
colnames(SozVers2) <- str_replace(colnames(SozVers2), "Nationalität Ausländer\\(innen\\) Geschlecht ", "")
colnames(SozVers2) <- str_replace(colnames(SozVers2), "männlich", "male")
colnames(SozVers2) <- str_replace(colnames(SozVers2), "weiblich", "female")
SozVers2 <- SozVers2 %>%
    pivot_longer(-c("AGS", "name", "sector"), names_to = "sex", values_to = "count") %>%
    mutate(nationality = "foreigner")

SozVers_2016 <- bind_rows(SozVers1, SozVers2) %>%
    mutate(year = "2016") %>%
    select(year, AGS, name, sector, nationality, sex, count) %>%
    filter(nchar(AGS) > 2)

rm(SozVers1, SozVers2, SozVers_Arbeitsort_Wirtschaftszweige_2016)



SozVers_Arbeitsort_Wirtschaftszweige_2017 <- read_delim("./data-raw/socialInsuranceWorkplaceSectors/13111-07-05-4_2017.csv",
                                                        delim = ";", escape_double = FALSE, col_names = FALSE,
                                                        locale = locale(date_names = "de", encoding = "ISO-8859-1"),
                                                        trim_ws = TRUE, skip = 1, lazy = FALSE, col_types = "c")
SozVers_Arbeitsort_Wirtschaftszweige_2017 <- SozVers_Arbeitsort_Wirtschaftszweige_2017[1:(nrow(SozVers_Arbeitsort_Wirtschaftszweige_2017) - 4), ]
colnames(SozVers_Arbeitsort_Wirtschaftszweige_2017) <- c("AGS", "name", "sector",
                                                         paste0(SozVers_Arbeitsort_Wirtschaftszweige_2017[7, 4:ncol(SozVers_Arbeitsort_Wirtschaftszweige_2017)], " ",
                                                                SozVers_Arbeitsort_Wirtschaftszweige_2017[8, 4:ncol(SozVers_Arbeitsort_Wirtschaftszweige_2017)], " ",
                                                                SozVers_Arbeitsort_Wirtschaftszweige_2017[9, 4:ncol(SozVers_Arbeitsort_Wirtschaftszweige_2017)], " ",
                                                                SozVers_Arbeitsort_Wirtschaftszweige_2017[10, 4:ncol(SozVers_Arbeitsort_Wirtschaftszweige_2017)]))
SozVers_Arbeitsort_Wirtschaftszweige_2017 <- SozVers_Arbeitsort_Wirtschaftszweige_2017[11:nrow(SozVers_Arbeitsort_Wirtschaftszweige_2017), ]

SozVers1 <- SozVers_Arbeitsort_Wirtschaftszweige_2017[, c(1:3, 5:6)]
colnames(SozVers1) <- str_replace(colnames(SozVers1), "Nationalität Insgesamt Geschlecht ", "")
colnames(SozVers1) <- str_replace(colnames(SozVers1), "männlich", "male")
colnames(SozVers1) <- str_replace(colnames(SozVers1), "weiblich", "female")
SozVers1 <- SozVers1 %>%
    pivot_longer(-c("AGS", "name", "sector"), names_to = "sex", values_to = "count") %>%
    mutate(nationality = "total")

SozVers2 <- SozVers_Arbeitsort_Wirtschaftszweige_2017[, c(1:3, 8:9)]
colnames(SozVers2) <- str_replace(colnames(SozVers2), "Nationalität Ausländer\\(innen\\) Geschlecht ", "")
colnames(SozVers2) <- str_replace(colnames(SozVers2), "männlich", "male")
colnames(SozVers2) <- str_replace(colnames(SozVers2), "weiblich", "female")
SozVers2 <- SozVers2 %>%
    pivot_longer(-c("AGS", "name", "sector"), names_to = "sex", values_to = "count") %>%
    mutate(nationality = "foreigner")

SozVers_2017 <- bind_rows(SozVers1, SozVers2) %>%
    mutate(year = "2017") %>%
    select(year, AGS, name, sector, nationality, sex, count) %>%
    filter(nchar(AGS) > 2)

rm(SozVers1, SozVers2, SozVers_Arbeitsort_Wirtschaftszweige_2017)


SozVers_Arbeitsort_Wirtschaftszweige_2018 <- read_delim("./data-raw/socialInsuranceWorkplaceSectors/13111-07-05-4_2018.csv",
                                                        delim = ";", escape_double = FALSE, col_names = FALSE,
                                                        locale = locale(date_names = "de", encoding = "ISO-8859-1"),
                                                        trim_ws = TRUE, skip = 1, lazy = FALSE, col_types = "c")
SozVers_Arbeitsort_Wirtschaftszweige_2018 <- SozVers_Arbeitsort_Wirtschaftszweige_2018[1:(nrow(SozVers_Arbeitsort_Wirtschaftszweige_2018) - 4), ]
colnames(SozVers_Arbeitsort_Wirtschaftszweige_2018) <- c("AGS", "name", "sector",
                                                         paste0(SozVers_Arbeitsort_Wirtschaftszweige_2018[7, 4:ncol(SozVers_Arbeitsort_Wirtschaftszweige_2018)], " ",
                                                                SozVers_Arbeitsort_Wirtschaftszweige_2018[8, 4:ncol(SozVers_Arbeitsort_Wirtschaftszweige_2018)], " ",
                                                                SozVers_Arbeitsort_Wirtschaftszweige_2018[9, 4:ncol(SozVers_Arbeitsort_Wirtschaftszweige_2018)], " ",
                                                                SozVers_Arbeitsort_Wirtschaftszweige_2018[10, 4:ncol(SozVers_Arbeitsort_Wirtschaftszweige_2018)]))
SozVers_Arbeitsort_Wirtschaftszweige_2018 <- SozVers_Arbeitsort_Wirtschaftszweige_2018[11:nrow(SozVers_Arbeitsort_Wirtschaftszweige_2018), ]

SozVers1 <- SozVers_Arbeitsort_Wirtschaftszweige_2018[, c(1:3, 5:6)]
colnames(SozVers1) <- str_replace(colnames(SozVers1), "Nationalität Insgesamt Geschlecht ", "")
colnames(SozVers1) <- str_replace(colnames(SozVers1), "männlich", "male")
colnames(SozVers1) <- str_replace(colnames(SozVers1), "weiblich", "female")
SozVers1 <- SozVers1 %>%
    pivot_longer(-c("AGS", "name", "sector"), names_to = "sex", values_to = "count") %>%
    mutate(nationality = "total")

SozVers2 <- SozVers_Arbeitsort_Wirtschaftszweige_2018[, c(1:3, 8:9)]
colnames(SozVers2) <- str_replace(colnames(SozVers2), "Nationalität Ausländer\\(innen\\) Geschlecht ", "")
colnames(SozVers2) <- str_replace(colnames(SozVers2), "männlich", "male")
colnames(SozVers2) <- str_replace(colnames(SozVers2), "weiblich", "female")
SozVers2 <- SozVers2 %>%
    pivot_longer(-c("AGS", "name", "sector"), names_to = "sex", values_to = "count") %>%
    mutate(nationality = "foreigner")

SozVers_2018 <- bind_rows(SozVers1, SozVers2) %>%
    mutate(year = "2018") %>%
    select(year, AGS, name, sector, nationality, sex, count) %>%
    filter(nchar(AGS) > 2)

rm(SozVers1, SozVers2, SozVers_Arbeitsort_Wirtschaftszweige_2018)


SozVers_Arbeitsort_Wirtschaftszweige_2019 <- read_delim("./data-raw/socialInsuranceWorkplaceSectors/13111-07-05-4_2019.csv",
                                                        delim = ";", escape_double = FALSE, col_names = FALSE,
                                                        locale = locale(date_names = "de", encoding = "ISO-8859-1"),
                                                        trim_ws = TRUE, skip = 1, lazy = FALSE, col_types = "c")
SozVers_Arbeitsort_Wirtschaftszweige_2019 <- SozVers_Arbeitsort_Wirtschaftszweige_2019[11:nrow(SozVers_Arbeitsort_Wirtschaftszweige_2019), ]
colnames(SozVers_Arbeitsort_Wirtschaftszweige_2019) <- c("AGS", "name", "sector",
                                                         paste0(SozVers_Arbeitsort_Wirtschaftszweige_2019[7, 4:ncol(SozVers_Arbeitsort_Wirtschaftszweige_2019)], " ",
                                                                SozVers_Arbeitsort_Wirtschaftszweige_2019[8, 4:ncol(SozVers_Arbeitsort_Wirtschaftszweige_2019)], " ",
                                                                SozVers_Arbeitsort_Wirtschaftszweige_2019[9, 4:ncol(SozVers_Arbeitsort_Wirtschaftszweige_2019)], " ",
                                                                SozVers_Arbeitsort_Wirtschaftszweige_2019[10, 4:ncol(SozVers_Arbeitsort_Wirtschaftszweige_2019)]))

SozVers1 <- SozVers_Arbeitsort_Wirtschaftszweige_2019[, c(1:3, 5:6)]
colnames(SozVers1) <- str_replace(colnames(SozVers1), "Nationalität Insgesamt Geschlecht ", "")
colnames(SozVers1) <- str_replace(colnames(SozVers1), "männlich", "male")
colnames(SozVers1) <- str_replace(colnames(SozVers1), "weiblich", "female")
SozVers1 <- SozVers1 %>%
    pivot_longer(-c("AGS", "name", "sector"), names_to = "sex", values_to = "count") %>%
    mutate(nationality = "total")

SozVers2 <- SozVers_Arbeitsort_Wirtschaftszweige_2019[, c(1:3, 8:9)]
colnames(SozVers2) <- str_replace(colnames(SozVers2), "Nationalität Ausländer\\(innen\\) Geschlecht ", "")
colnames(SozVers2) <- str_replace(colnames(SozVers2), "männlich", "male")
colnames(SozVers2) <- str_replace(colnames(SozVers2), "weiblich", "female")
SozVers2 <- SozVers2 %>%
    pivot_longer(-c("AGS", "name", "sector"), names_to = "sex", values_to = "count") %>%
    mutate(nationality = "foreigner")

SozVers_2019 <- bind_rows(SozVers1, SozVers2) %>%
    mutate(year = "2019") %>%
    select(year, AGS, name, sector, nationality, sex, count) %>%
    filter(nchar(AGS) > 2)

rm(SozVers1, SozVers2, SozVers_Arbeitsort_Wirtschaftszweige_2019)


SozVers_Arbeitsort_Wirtschaftszweige_2020 <- read_delim("./data-raw/socialInsuranceWorkplaceSectors/13111-07-05-4_2020.csv",
                                                        delim = ";", escape_double = FALSE, col_names = FALSE,
                                                        locale = locale(date_names = "de", encoding = "ISO-8859-1"),
                                                        trim_ws = TRUE, skip = 1, lazy = FALSE, col_types = "c")
SozVers_Arbeitsort_Wirtschaftszweige_2020 <- SozVers_Arbeitsort_Wirtschaftszweige_2020[11:nrow(SozVers_Arbeitsort_Wirtschaftszweige_2020), ]
colnames(SozVers_Arbeitsort_Wirtschaftszweige_2020) <- c("AGS", "name", "sector",
                                                         paste0(SozVers_Arbeitsort_Wirtschaftszweige_2020[7, 4:ncol(SozVers_Arbeitsort_Wirtschaftszweige_2020)], " ",
                                                                SozVers_Arbeitsort_Wirtschaftszweige_2020[8, 4:ncol(SozVers_Arbeitsort_Wirtschaftszweige_2020)], " ",
                                                                SozVers_Arbeitsort_Wirtschaftszweige_2020[9, 4:ncol(SozVers_Arbeitsort_Wirtschaftszweige_2020)], " ",
                                                                SozVers_Arbeitsort_Wirtschaftszweige_2020[10, 4:ncol(SozVers_Arbeitsort_Wirtschaftszweige_2020)]))

SozVers1 <- SozVers_Arbeitsort_Wirtschaftszweige_2020[, c(1:3, 5:6)]
colnames(SozVers1) <- str_replace(colnames(SozVers1), "Nationalität Insgesamt Geschlecht ", "")
colnames(SozVers1) <- str_replace(colnames(SozVers1), "männlich", "male")
colnames(SozVers1) <- str_replace(colnames(SozVers1), "weiblich", "female")
SozVers1 <- SozVers1 %>%
    pivot_longer(-c("AGS", "name", "sector"), names_to = "sex", values_to = "count") %>%
    mutate(nationality = "total")

SozVers2 <- SozVers_Arbeitsort_Wirtschaftszweige_2020[, c(1:3, 8:9)]
colnames(SozVers2) <- str_replace(colnames(SozVers2), "Nationalität Ausländer\\(innen\\) Geschlecht ", "")
colnames(SozVers2) <- str_replace(colnames(SozVers2), "männlich", "male")
colnames(SozVers2) <- str_replace(colnames(SozVers2), "weiblich", "female")
SozVers2 <- SozVers2 %>%
    pivot_longer(-c("AGS", "name", "sector"), names_to = "sex", values_to = "count") %>%
    mutate(nationality = "foreigner")

SozVers_2020 <- bind_rows(SozVers1, SozVers2) %>%
    mutate(year = "2020") %>%
    select(year, AGS, name, sector, nationality, sex, count) %>%
    filter(nchar(AGS) > 2)

rm(SozVers1, SozVers2, SozVers_Arbeitsort_Wirtschaftszweige_2020)


SozVers_Arbeitsort_Wirtschaftszweige <- bind_rows(SozVers_2015,
                                                  SozVers_2016,
                                                  SozVers_2017,
                                                  SozVers_2018,
                                                  SozVers_2019,
                                                  SozVers_2020)
rm(SozVers_2015,
   SozVers_2016,
   SozVers_2017,
   SozVers_2018,
   SozVers_2019,
   SozVers_2020)

socialInsuranceWorkplaceSectors <- SozVers_Arbeitsort_Wirtschaftszweige %>%
    filter(sector != "Insgesamt") %>%
    mutate(count = str_replace(count, "-|\\.", NA_character_)) %>%
    mutate(count = as.integer(count))

# cat(unique(socialInsuranceWorkplaceSectors$count))

# unique(socialInsuranceWorkplaceSectors$sector)

usethis::use_data(socialInsuranceWorkplaceSectors, overwrite = TRUE)
