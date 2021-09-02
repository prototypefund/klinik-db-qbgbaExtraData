#' A SpatialPolygonsDataFrame comprising all German counties enriched
#' with hospital and population data.
#'
#' This dataset contains the geometric information to plot the shapes of all
#' German counties together with aggregated data about the hospitals from the
#' "Qualitaetsberichte der Krankenhaeuser" as a \code{SpatialPolygonsDataFrame}.
#'
#' @format A \code{SpatialPolygonsDataFrame} with 3.962 entries and 27 columns of
#'     additional data.
#' \describe{
#'   \item{\code{year}}{The year of the data entry, between 2015 and 2019.}
#'   \item{\code{Residents}}{How many residents lived in the respective area?}
#'   \item{\code{gender}}{Does the data entry focus on female or male persons?}
#'   \item{\code{AGS_1}}{This character string comprises the "Amtliche Gemeindeschluessel"
#'       (AGS) for each state, where the first and second character represents
#'       the state.}
#'   \item{\code{GEN_1}}{Contains the name of the respective state.}
#'   \item{\code{BEZ_1}}{Defines the type of geometric entity. Here, every entry is
#'       a "Land".}
#'   \item{\code{AGS_2}}{This character string comprises the "Amtliche Gemeindeschluessel"
#'       (AGS) for each county, where the first and second character represents
#'       the state (as in \code{AGS_1}), the third character the district and the fourth
#'       and fifth character represents the county.}
#'   \item{\code{GEN_2}}{Contains the name of the respective county.}
#'   \item{\code{BEZ_2}}{Defines the type of geometric entity, i.e., one of "Kreisfreie
#'       Stadt", "Kreis", "Landkreis" or "Stadtkreis".}
#'   \item{\code{numberHospitals}}{How many hospitals were counted in this area?}
#'   \item{\code{typeRatioPrivat}}{Ratio of privately owned hospitals in this area.}
#'   \item{\code{typeRatioOeffentlich}}{Ratio of publicly owned hospitals in this area.}
#'   \item{\code{typeRatioUnknown}}{Ratio of hospitals in this area where the type of
#'       owner is unknown.}
#'   \item{\code{academicTeachingHospitalRatio}}{Ratio of hospitals in this area that
#'       are academic teaching hospitals.}
#'   \item{\code{universityClinicRatio}}{Ratio of hospitals in this area that
#'       are university hospitals.}
#'   \item{\code{psychiatricHospitalRatio}}{Ratio of hospitals in this area that
#'       have psychiatric wards.}
#'   \item{\code{psychiatricDutyToSupplyRatio}}{Ratio of hospitals in this area that
#'       have a duty to supply psychiatric care in their area.}
#'   \item{\code{quantityBedsSum}}{Sum of beds in this area.}
#'   \item{\code{quantityCasesFullSum}}{Sum of inpatients in this area.}
#'   \item{\code{quantityCasesPartialSum}}{Sum of day care inpatients in this area.}
#'   \item{\code{quantityCasesOutpatientSum}}{Sum of outpatients in this area.}
#'   \item{\code{ExternalAttendingDoctorsSum}}{Sum of external attending doctors
#'       in this area.}
#'   \item{\code{DoctorsSum}}{Sum of doctors over all hospitals in this area.}
#'   \item{\code{AttendingDoctorsSum}}{Sum of attending doctors over all hospitals
#'       in this area.}
#'   \item{\code{NursesSum}}{Sum of nurses over all hospitals in this area.}
#'   \item{\code{weeklyWH_doctors_mean}}{Average weekly hours for doctors in this area.}
#'   \item{\code{weeklyWH_nurses_mean}}{Average weekly hours for nurses in this area.}
#' }
#'
#' @source Obtained from \emph{GeoBasis-DE}:
#'
#'     \href{https://gdz.bkg.bund.de/index.php/default/verwaltungsgebiete-1-250-000-ebenen-stand-31-12-vg250-ebenen-31-12.html}{Verwaltungsgebiete 1:250 000 (Ebenen), Stand 31.12. (VG250 31.12.)}
#'
#'     \emph{Copyright:} "Bundesamt fuer Kartographie und Geodaesie (\url{http://www.bkg.bund.de}),
#'         Deutschland, 2021.
#'
#'         Dieses Werk ist lizenziert unter der Datenlizenz Deutschland - Namensnennung - Version 2.0."
#'
#'     \emph{Licence:} \url{www.govdata.de/dl-de/by-2-0}
#'
#'     \emph{Obtained:} 02.07.2021 at 11:52:45.
#'
#'
#' @source
#'
"mapBRDCounties"

