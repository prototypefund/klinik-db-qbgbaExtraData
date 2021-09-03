library(tidyverse)
library(sf)
library(qbgbaExtraData)

unzip(zipfile = "./data-raw/Maps/All_shapes.zip")

# Hospitals ---------------------------------------------------------------

AllHospitals <- AllHospitals %>%
    mutate(type = factor(type)) %>%
    mutate(type = fct_collapse(type,
                               privat = c("privat",
                                          "GmbH",
                                          "Milde Stiftung privaten Rechts",
                                          "Sana Kliniken Duisburg GmbH",
                                          "Stiftung privaten Rechts",
                                          "Privat",
                                          "Ab 01.11.2019 erfolgte die betriebliche Änderung mit neuem Träger, der CCare AG Darmstadt, und der neuen Bezeichnung: Klinik Ingelheim GmbH.  Bis zum 31.10.2019 war der Träger zu 90% die Universitätsmedizin Mainz und zu 10% die Stadt Ingelheim am Rhein. Der Name der Einrichtung lautete bis dahin Krankenhaus Ingelheim der Universitätsmedizin Mainz GmbH.\r\n"),
                               oeffentlich = c("freigemeinnützig",
                                               "öffentlich",
                                               "öffentlich-rechtlich",
                                               "öffentlich - Rechtlich",
                                               "Öffentlich-rechtlich",
                                               "gemeinnützig",
                                               "kommunal",
                                               "in öffentlich-rechtlicher Trägerschaft",
                                               "freigemeinnützig und öffentlich",
                                               "freigemeinnützig / kirchlich",
                                               "Anstalt öffentlichen Rechts",
                                               "gemeinnütziger Trägerverein",
                                               "öffentlich, gGmbH",
                                               "gemeinützig",
                                               "Körperschaft des öffentlichen Rechts (K.d.ö.R.)",
                                               "e. V.",
                                               "öffentlich-rechtliche Trägerschaft",
                                               "gemeinnützige GmbH",
                                               "Rechtsfähige Stiftung des bürgerlichen Rechts",
                                               "freigemeinnützig/kirchlich",
                                               "Landesgesellschaft"),
                               unbekannt = c("-",
                                             "0",
                                             "Maximalversorger",
                                             "nicht vorhanden",
                                             "2 Standorte",
                                             "zu 50% in öffentlicher und zu 50% in privater Trägerschaft",
                                             "MusterArt",
                                             "Grund- und Regelversorgung",
                                             "m")))


sf_clinics = st_as_sf(AllHospitals, coords = c("lon", "lat"), crs = 4326)


# Counties ----------------------------------------------------------------

map_kreise <- sf::read_sf("./data-raw/Maps/VG250_KRS.shp")

populationGermany_noAge <- populationGermany %>%
    filter(year != "2020") %>%
    group_by(year, AGS, name, gender) %>%
    summarize(Residents = sum(count), .groups = "keep")

map_kreise_EW <- populationGermany_noAge %>%
    ungroup() %>%
    pivot_wider(id_cols = c(year, AGS, name),
                names_from = gender,
                values_from = Residents) %>%
    left_join(map_kreise, by = "AGS") %>%
    rename("female" = weiblich,
           "male" = männlich) %>%
    distinct(year, AGS, name, male, female, GEN, BEZ, .keep_all = TRUE)

map_kreise_EW_Reste <- map_kreise_EW %>%
    filter(!AGS %in% names(which(table(map_kreise_EW$AGS) != 5)))

map_kreise_EW_Osterode <- map_kreise_EW %>%
    filter(AGS %in% names(which(table(map_kreise_EW$AGS) != 5)))

map_kreise_EW_Osterode_fixed <- map_kreise_EW_Osterode %>%
    fill(ADE:geometry, .direction = "up") %>%
    mutate(male = case_when(
        year == "2015" ~ sum(.data$male[.data$year == "2015"]),
        TRUE ~ male
    )) %>%
    mutate(female = case_when(
        year == "2015" ~ sum(.data$female[.data$year == "2015"]),
        TRUE ~ female
    )) %>%
    mutate(AGS = case_when(
        AGS == "03152" ~ "03159",
        AGS == "03156" ~ "03159",
        TRUE ~ AGS
    )) %>%
    mutate(name = "Göttingen, Landkreis") %>%
    distinct()
map_kreise_EW_Osterode_fixed[1, "geometry"] <- map_kreise_EW_Osterode_fixed[2, "geometry"]

map_kreise_EW_fixed <- bind_rows(map_kreise_EW_Reste,
                                 map_kreise_EW_Osterode_fixed) %>%
    arrange(AGS)

map_kreise_EW_fixed <- st_as_sf(map_kreise_EW_fixed)
map_kreise_EW2 <- st_transform(map_kreise_EW_fixed, 4326)

rm(map_kreise,
   map_kreise_EW,
   map_kreise_EW_Reste,
   map_kreise_EW_Osterode,
   map_kreise_EW_Osterode_fixed,
   map_kreise_EW_fixed)

map_kreise_EW2 <- map_kreise_EW2 %>%
    select(year, male, female, AGS, GEN, BEZ, name)

map_kreise_EW2_clinics <- st_join(map_kreise_EW2, sf_clinics,
                                  join = st_contains, left = TRUE)

map_kreise_EW2_clinics <- map_kreise_EW2_clinics %>%
    filter(year.x == year.y) %>%
    rename("year" = year.x) %>%
    select(year, male, female, AGS, GEN, BEZ, name, type,
           academicTeachingHospital, universityClinic,
           psychiatricHospital, psychiatricDutyToSupply,
           quantityBeds, quantityCasesFull, quantityCasesPartial,
           quantityCasesOutpatient, ExternalAttendingDoctors,
           Doctors, AttendingDoctors, Nurses,
           tariffWeeklyWorkingHoursDoctors, tariffWeeklyWorkingHoursNurses)

df_tmp <- map_kreise_EW2_clinics

st_geometry(df_tmp) <- NULL
map_kreise_EW2_clinics_summarized <- df_tmp %>%
    group_by(year, AGS, GEN, BEZ, name) %>%
    summarize(male = male,
              female = female,
              numberHospitals = n(),
              typeRatioPrivat = sum(type == "privat") / n(),
              typeRatioOeffentlich = sum(type == "oeffentlich") / n(),
              typeRatioUnknown = sum(type == "unbekannt") / n(),
              academicTeachingHospitalRatio = sum(academicTeachingHospital, na.rm = TRUE) / n(),
              universityClinicRatio = sum(universityClinic, na.rm = TRUE) / n(),
              psychiatricHospitalRatio = sum(psychiatricHospital, na.rm = TRUE) / n(),
              psychiatricDutyToSupplyRatio = sum(psychiatricDutyToSupply, na.rm = TRUE) / n(),
              quantityBedsSum = sum(quantityBeds, na.rm = TRUE),
              quantityCasesFullSum = sum(quantityCasesFull, na.rm = TRUE),
              quantityCasesPartialSum = sum(quantityCasesPartial, na.rm = TRUE),
              quantityCasesOutpatientSum = sum(quantityCasesOutpatient, na.rm = TRUE),
              quantityCasesOutpatientSum = sum(quantityCasesOutpatient, na.rm = TRUE),
              ExternalAttendingDoctorsSum = sum(ExternalAttendingDoctors, na.rm = TRUE),
              DoctorsSum = sum(Doctors, na.rm = TRUE),
              AttendingDoctorsSum = sum(AttendingDoctors, na.rm = TRUE),
              NursesSum = sum(Nurses, na.rm = TRUE),
              weeklyWH_doctors_mean = mean(tariffWeeklyWorkingHoursDoctors, na.rm = TRUE),
              weeklyWH_nurses_mean = mean(tariffWeeklyWorkingHoursNurses, na.rm = TRUE), .groups = "keep") %>%
    distinct(year, AGS, name, .keep_all = TRUE) %>%
    arrange(AGS) %>%
    ungroup() %>%
    right_join(map_kreise_EW2, by = c("year", "AGS", "GEN", "BEZ", "name", "male", "female"))

# map_kreise_EW2_clinics_summarized %>%
#     filter(AGS %in% c("03401", "16056"))
#
# map_kreise_EW2_clinics_summarized %>%
#     filter(is.na(numberHospitals)) %>% pull(geometry)

# all(table(map_kreise_EW2_clinics_summarized$AGS) == 5)


map_kreise_EW2_clinics_summarized <- st_as_sf(map_kreise_EW2_clinics_summarized,
                                              sf_column_name = "geometry", crs = 4326)
rm(df_tmp, map_kreise_EW2_clinics, map_kreise_EW2)


# States ------------------------------------------------------------------

map_land <- sf::read_sf("./data-raw/Maps/VG250_LAN.shp")

populationGermany_noAge_Land <- populationGermany_noAge %>%
    ungroup() %>%
    pivot_wider(id_cols = c(year, AGS, name),
                names_from = gender,
                values_from = Residents) %>%
    rename("female" = weiblich,
           "male" = männlich) %>%
    mutate(AGS_Land = str_extract(AGS, "^[0-9]{2,2}")) %>%
    group_by(year, AGS_Land) %>%
    summarize(male_Land = sum(male),
              female_Land = sum(female), .groups = "keep") %>%
    rename("AGS" = AGS_Land,
           "male" = male_Land,
           "female" = female_Land)

map_land_EW <- populationGermany_noAge_Land %>%
    left_join(map_land %>% filter(GF == "4"), by = "AGS")

map_land_EW2 <- st_as_sf(map_land_EW)
map_land_EW2 <- st_transform(map_land_EW2, 4326)
map_land_EW2 <- map_land_EW2 %>%
    select(year, male, female, AGS, GEN, BEZ, everything())

map_land_EW2 <- st_make_valid(map_land_EW2)
map_land_EW2_clinics <- st_join(map_land_EW2, sf_clinics, join = st_contains)
map_land_EW2_clinics <- map_land_EW2_clinics %>%
    filter(year.x == year.y) %>%
    rename("year" = year.x) %>%
    select(year, male, female, AGS, GEN, BEZ, type,
           academicTeachingHospital, universityClinic,
           psychiatricHospital, psychiatricDutyToSupply,
           quantityBeds, quantityCasesFull, quantityCasesPartial,
           quantityCasesOutpatient, ExternalAttendingDoctors,
           Doctors, AttendingDoctors, Nurses,
           tariffWeeklyWorkingHoursDoctors, tariffWeeklyWorkingHoursNurses)

df_tmp <- map_land_EW2_clinics

st_geometry(df_tmp) <- NULL

map_land_EW2_clinics_summarized <- df_tmp %>%
    group_by(year, AGS, GEN, BEZ) %>%
    summarize(male = male,
              female = female,
              numberHospitals = n(),
              typeRatioPrivat = sum(type == "privat") / n(),
              typeRatioOeffentlich = sum(type == "oeffentlich") / n(),
              typeRatioUnknown = sum(type == "unbekannt") / n(),
              academicTeachingHospitalRatio = sum(academicTeachingHospital, na.rm = TRUE) / n(),
              universityClinicRatio = sum(universityClinic, na.rm = TRUE) / n(),
              psychiatricHospitalRatio = sum(psychiatricHospital, na.rm = TRUE) / n(),
              psychiatricDutyToSupplyRatio = sum(psychiatricDutyToSupply, na.rm = TRUE) / n(),
              quantityBedsSum = sum(quantityBeds, na.rm = TRUE),
              quantityCasesFullSum = sum(quantityCasesFull, na.rm = TRUE),
              quantityCasesPartialSum = sum(quantityCasesPartial, na.rm = TRUE),
              quantityCasesOutpatientSum = sum(quantityCasesOutpatient, na.rm = TRUE),
              quantityCasesOutpatientSum = sum(quantityCasesOutpatient, na.rm = TRUE),
              ExternalAttendingDoctorsSum = sum(ExternalAttendingDoctors, na.rm = TRUE),
              DoctorsSum = sum(Doctors, na.rm = TRUE),
              AttendingDoctorsSum = sum(AttendingDoctors, na.rm = TRUE),
              NursesSum = sum(Nurses, na.rm = TRUE),
              weeklyWH_doctors_mean = mean(tariffWeeklyWorkingHoursDoctors, na.rm = TRUE),
              weeklyWH_nurses_mean = mean(tariffWeeklyWorkingHoursNurses, na.rm = TRUE), .groups = "keep") %>%
    distinct(year, AGS, .keep_all = TRUE) %>%
    arrange(AGS) %>%
    ungroup() %>%
    right_join(map_land_EW2, by = c("year", "AGS", "GEN", "BEZ", "male", "female"))

map_land_EW2_clinics_summarized <- st_as_sf(map_land_EW2_clinics_summarized,
                                            sf_column_name = "geometry", crs = 4326)
rm(df_tmp, map_land_EW2_clinics, map_land_EW2, map_land_EW, map_land)


# Store data --------------------------------------------------------------

map_land_EW2_clinics_summarized <- map_land_EW2_clinics_summarized %>%
    rename("AGS_1" = AGS,
           "GEN_1" = GEN,
           "BEZ_1" = BEZ)
df_tmp <- map_land_EW2_clinics_summarized %>%
    select(AGS_1, GEN_1, BEZ_1)
st_geometry(df_tmp) <- NULL
df_tmp <- df_tmp %>%
    distinct()
map_kreise_EW2_clinics_summarized <- map_kreise_EW2_clinics_summarized %>%
    rename("AGS_2" = AGS,
           "GEN_2" = GEN,
           "BEZ_2" = BEZ) %>%
    mutate(AGS_1 = str_extract(AGS_2, "^[0-9]{2,2}")) %>%
    left_join(df_tmp, by = "AGS_1") %>%
    select(year, male, female,
           AGS_1, GEN_1, BEZ_1, AGS_2, GEN_2, BEZ_2, everything())
rm(df_tmp)


mapBRDStates <- map_land_EW2_clinics_summarized %>%
    select(-(ADE:DEBKG_ID))

usethis::use_data(mapBRDStates, overwrite = TRUE)

mapBRDCounties <- map_kreise_EW2_clinics_summarized %>%
    select(year, AGS_1, GEN_1, BEZ_1, AGS_2, GEN_2, BEZ_2, name, male, female,
           everything()) %>%
    select(-name)

usethis::use_data(mapBRDCounties, overwrite = TRUE)

zip(zipfile = "./data-raw/Maps/All_shapes.zip",
    list.files(path = "./data-raw/Maps/", pattern = "^VG", full.names = TRUE))
file.remove(list.files(path = "./data-raw/Maps/", pattern = "^VG", full.names = TRUE))

