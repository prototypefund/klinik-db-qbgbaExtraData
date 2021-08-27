AllHospitals <- readr::read_delim("./data-raw/AllHospitals/AllHospitals.csv", lazy = FALSE, delim = ";",
                                  col_types = readr::cols(
                                      year = readr::col_character(),
                                      ID = readr::col_character(),
                                      idGlobalHospitalIdentifier = readr::col_integer(),
                                      idHospitalOperator = readr::col_integer(),
                                      HospitalOperatorName = readr::col_character(),
                                      type = readr::col_character(),
                                      idHospital = readr::col_integer(),
                                      HospitalName = readr::col_character(),
                                      ikNumber = readr::col_character(),
                                      locationNumberHospital = readr::col_character(),
                                      locationNumberSite = readr::col_character(),
                                      phoneHospital = readr::col_character(),
                                      urlHospital = readr::col_character(),
                                      urlAdditionalInformation = readr::col_character(),
                                      academicTeachingHospital = readr::col_integer(),
                                      universityClinic = readr::col_integer(),
                                      universityName = readr::col_character(),
                                      psychiatricHospital = readr::col_integer(),
                                      psychiatricDutyToSupply = readr::col_integer(),
                                      quantityBeds = readr::col_integer(),
                                      quantityCasesFull = readr::col_integer(),
                                      quantityCasesPartial = readr::col_integer(),
                                      quantityCasesOutpatient = readr::col_integer(),
                                      ExternalAttendingDoctors = readr::col_integer(),
                                      Doctors = readr::col_double(),
                                      AttendingDoctors = readr::col_double(),
                                      Nurses = readr::col_double(),
                                      tariffWeeklyWorkingHoursDoctors = readr::col_double(),
                                      tariffWeeklyWorkingHoursNurses = readr::col_double(),
                                      street = readr::col_character(),
                                      housenumber = readr::col_character(),
                                      zip = readr::col_character(),
                                      city = readr::col_character(),
                                      district = readr::col_character(),
                                      state = readr::col_character(),
                                      country = readr::col_character(),
                                      URL = readr::col_character(),
                                      lat = readr::col_double(),
                                      lon = readr::col_double()
                                  ))

AllHospitals$URL[is.na(AllHospitals$URL)] <- "No URL available"

AllHospitals <- AllHospitals %>%
    dplyr::mutate(locationNumberOverall = dplyr::case_when(
        is.na(.data$locationNumberSite) & !is.na(.data$locationNumberHospital) ~ .data$locationNumberHospital,
        !is.na(.data$locationNumberSite) & !is.na(.data$locationNumberHospital) ~ .data$locationNumberSite,
    ))

AllHospitals <- AllHospitals %>%
    select(.data$year, .data$ID, .data$idGlobalHospitalIdentifier, .data$idHospitalOperator, .data$HospitalOperatorName,
           .data$type, .data$idHospital, .data$HospitalName, .data$ikNumber, .data$locationNumberHospital, .data$locationNumberSite,
           .data$locationNumberOverall, .data$phoneHospital, .data$urlHospital, .data$urlAdditionalInformation,
           .data$academicTeachingHospital, .data$universityClinic, .data$universityName, .data$psychiatricHospital,
           .data$psychiatricDutyToSupply, .data$quantityBeds, .data$quantityCasesFull, .data$quantityCasesPartial,
           .data$quantityCasesOutpatient, .data$ExternalAttendingDoctors, .data$Doctors, .data$AttendingDoctors,
           .data$Nurses, .data$tariffWeeklyWorkingHoursDoctors, .data$tariffWeeklyWorkingHoursNurses,
           .data$street, .data$housenumber, .data$zip, .data$city, .data$district, .data$state, .data$country,
           .data$URL, .data$lat, .data$lon)

usethis::use_data(AllHospitals, overwrite = TRUE)
