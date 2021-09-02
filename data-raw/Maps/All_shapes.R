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

map_kreise_EW <- map_kreise %>%
    right_join(populationGermany_noAge, by = c("AGS")) %>%
    select(Residents, year, gender, everything())

map_kreise_EW2 <- st_transform(map_kreise_EW, 4326)
map_kreise_EW2 <- map_kreise_EW2 %>%
    select(Residents, year, gender, AGS, GEN, BEZ, name)

map_kreise_EW2_clinics <- st_join(map_kreise_EW2, sf_clinics, join = st_contains)
map_kreise_EW2_clinics <- map_kreise_EW2_clinics %>%
    filter(year.x == year.y) %>%
    rename("year" = year.x) %>%
    select(Residents, year, gender, AGS, GEN, BEZ, name, type,
           academicTeachingHospital, universityClinic,
           psychiatricHospital, psychiatricDutyToSupply,
           quantityBeds, quantityCasesFull, quantityCasesPartial,
           quantityCasesOutpatient, ExternalAttendingDoctors,
           Doctors, AttendingDoctors, Nurses,
           tariffWeeklyWorkingHoursDoctors, tariffWeeklyWorkingHoursNurses) %>%
    mutate(ID = 1:n())

df_tmp <- map_kreise_EW2_clinics

st_geometry(df_tmp) <- NULL

map_kreise_EW2_clinics_summarized <- df_tmp %>%
    group_by(year, gender, AGS, GEN, BEZ, name) %>%
    mutate(numberHospitals = n(),
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
           weeklyWH_nurses_mean = mean(tariffWeeklyWorkingHoursNurses, na.rm = TRUE)) %>%
    distinct(year, gender, AGS, .keep_all = TRUE) %>%
    select(-academicTeachingHospital, -universityClinic, -type,
           -psychiatricHospital, -psychiatricDutyToSupply,
           -quantityBeds, -quantityCasesFull, -quantityCasesPartial,
           -quantityCasesOutpatient, -ExternalAttendingDoctors,
           -Doctors, -AttendingDoctors, -Nurses,
           -tariffWeeklyWorkingHoursDoctors, -tariffWeeklyWorkingHoursNurses) %>%
    select(ID, everything()) %>%
    left_join(map_kreise_EW2_clinics %>% select(ID), by = "ID")

map_kreise_EW2_clinics_summarized <- st_as_sf(map_kreise_EW2_clinics_summarized,
                                              sf_column_name = "geometry", crs = 4326)
rm(df_tmp, map_kreise_EW2_clinics, map_kreise_EW2, map_kreise_EW, map_kreise)


# States ------------------------------------------------------------------

map_land <- sf::read_sf("./data-raw/Maps/VG250_LAN.shp")

populationGermany_noAge_Land <- populationGermany_noAge %>%
    mutate(AGS_Land = str_extract(AGS, "^[0-9]{2,2}")) %>%
    group_by(year, AGS_Land, gender) %>%
    summarize(Residents_Land = sum(Residents), .groups = "keep") %>%
    rename("AGS" = AGS_Land,
           "Residents" = Residents_Land)

map_land_EW <- map_land %>%
    right_join(populationGermany_noAge_Land, by = "AGS") %>%
    select(Residents, year, gender, everything())

map_land_EW2 <- st_transform(map_land_EW, 4326)
map_land_EW2 <- map_land_EW2 %>%
    select(Residents, year, gender, AGS, GEN, BEZ)

map_land_EW2 <- st_make_valid(map_land_EW2)
map_land_EW2_clinics <- st_join(map_land_EW2, sf_clinics, join = st_contains)
map_land_EW2_clinics <- map_land_EW2_clinics %>%
    filter(year.x == year.y) %>%
    rename("year" = year.x) %>%
    select(Residents, year, gender, AGS, GEN, BEZ, type,
           academicTeachingHospital, universityClinic,
           psychiatricHospital, psychiatricDutyToSupply,
           quantityBeds, quantityCasesFull, quantityCasesPartial,
           quantityCasesOutpatient, ExternalAttendingDoctors,
           Doctors, AttendingDoctors, Nurses,
           tariffWeeklyWorkingHoursDoctors, tariffWeeklyWorkingHoursNurses) %>%
    mutate(ID = 1:n())

df_tmp <- map_land_EW2_clinics

st_geometry(df_tmp) <- NULL

map_land_EW2_clinics_summarized <- df_tmp %>%
    group_by(year, gender, AGS, GEN, BEZ) %>%
    mutate(numberHospitals = n(),
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
           weeklyWH_nurses_mean = mean(tariffWeeklyWorkingHoursNurses, na.rm = TRUE)) %>%
    distinct(year, gender, AGS, .keep_all = TRUE) %>%
    select(-academicTeachingHospital, -universityClinic, -type,
           -psychiatricHospital, -psychiatricDutyToSupply,
           -quantityBeds, -quantityCasesFull, -quantityCasesPartial,
           -quantityCasesOutpatient, -ExternalAttendingDoctors,
           -Doctors, -AttendingDoctors, -Nurses,
           -tariffWeeklyWorkingHoursDoctors, -tariffWeeklyWorkingHoursNurses) %>%
    select(ID, everything()) %>%
    left_join(map_land_EW2_clinics %>% select(ID), by = "ID")

map_land_EW2_clinics_summarized <- st_as_sf(map_land_EW2_clinics_summarized,
                                            sf_column_name = "geometry", crs = 4326)
rm(df_tmp, map_land_EW2_clinics, map_land_EW2, map_land_EW, map_land)


# Store data --------------------------------------------------------------


df_tmp <- map_land_EW2_clinics_summarized %>%
    ungroup() %>%
    rename("AGS_1" = AGS,
           "GEN_1" = GEN,
           "BEZ_1" = BEZ) %>%
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
    select(ID, Residents, year, gender,
           AGS_1, GEN_1, BEZ_1, AGS_2, GEN_2, BEZ_2, everything())
rm(df_tmp)


mapBRDStates <- as_Spatial(map_land_EW2_clinics_summarized %>% select(-ID) %>% select(year, everything()))

usethis::use_data(mapBRDStates, overwrite = TRUE)

mapBRDCounties <- as_Spatial(map_kreise_EW2_clinics_summarized %>% select(-ID, -name) %>% select(year, everything()))

usethis::use_data(mapBRDCounties, overwrite = TRUE)

zip(zipfile = "./data-raw/Maps/All_shapes.zip",
    list.files(path = "./data-raw/Maps/", pattern = "^VG", full.names = TRUE))
file.remove(list.files(path = "./data-raw/Maps/", pattern = "^VG", full.names = TRUE))

