library(tidyverse)
# library(httr)
# library(htmltools)
# library(jsonlite)
# library(wiesbaden)

# keyring::key_set(service = "genesis.destatis.de",
#                  username = "DEAA198797")

# keyring::key_set(service = "regionalstatistik.de",
#                  username = "RE007158")
#
#
# save_credentials("de",
#                  keyring::key_list("genesis.destatis.de")[1,2],
#                  keyring::key_get("genesis.destatis.de", keyring::key_list("genesis.destatis.de")[1,2]))
# save_credentials("regio",
#                  keyring::key_list("regionalstatistik.de")[1,2],
#                  keyring::key_get("regionalstatistik.de", keyring::key_list("regionalstatistik.de")[1,2]))
#
# test_login(genesis = c(db = 'de'))
# test_login(genesis = c(db = 'regio'))
#
#
# retrieve_data("22111", genesis=c(db="de"))


# Read CSV files ----------------------------------------------------------

# Population and Employment -----------------------------------------------

population_employment_2011 <- read_delim("./00-data/CSVs/12111-11-01-4.csv",
                                         delim = ";", escape_double = FALSE, col_names = FALSE,
                                         locale = locale(date_names = "de", encoding = "ISO-8859-1"),
                                         trim_ws = TRUE, skip = 6, col_types = "c", lazy = FALSE)
population_employment_2011 <- population_employment_2011[1:(nrow(population_employment_2011) - 3), ]

colnames(population_employment_2011) <- c("id", "name", "type",
                                          paste0(population_employment_2011[1, 4:ncol(population_employment_2011)],
                                                 " - ",
                                                 population_employment_2011[2, 4:ncol(population_employment_2011)]))
population_employment_2011 <- population_employment_2011[4:nrow(population_employment_2011),]

colnames(population_employment_2011) <- str_replace(colnames(population_employment_2011), " - NA", " - total")

colnames(population_employment_2011) <- str_replace(colnames(population_employment_2011), "Bevölkerung nach Erwerbsstatus - ", "")

colnames(population_employment_2011) <- str_replace(colnames(population_employment_2011), "männlich", "male")
colnames(population_employment_2011) <- str_replace(colnames(population_employment_2011), "weiblich", "female")
colnames(population_employment_2011) <- str_replace(colnames(population_employment_2011), "Deutsche", "German")
colnames(population_employment_2011) <- str_replace(colnames(population_employment_2011), "Ausländer\\(innen\\)", "foreigner")


# https://www.statistischebibliothek.de/mir/receive/DESerie_mods_00000993

