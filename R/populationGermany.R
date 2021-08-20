#' Population numbers regarding every county in Germany from 2015 to 2020.
#'
#' This dataset contains population numbers from all German counties over the
#' years 2015 to 2020, splitted into age groups and for both genders (i.e.,
#' female and male).
#'
#' @format A \code{tibble} with 81838 rows and six columns:
#' \describe{
#'   \item{\code{year}}{A string with values "2015", "2016", "2017", "2018", "2019"
#'       and "2020", indicating to which year the data belongs. Every year is
#'       reported on the last day of the year, i.e., the 31st of December each
#'       year.}
#'   \item{\code{AGS}}{This character string comprises the "Amtliche Gemeindeschluessel"
#'       (AGS) for each county, where the first and second character represents
#'       the state, the third character the district and the fourth and fifth
#'       character represents the county.}
#'   \item{\code{name}}{A character value with the name of the respective county.}
#'   \item{\code{gender}}{A character value with either "female" or "male".}
#'   \item{\code{ageGroup}}{A character value indicating the age group the data belongs to.
#'       Categories are:
#'
#'       \itemize{
#'           \item{younger_than_3_years}
#'           \item{3_<=_x_<_6_years}
#'           \item{6_<=_x_<_10_years}
#'           \item{10_<=_x_<_15_years}
#'           \item{15_<=_x_<_18_years}
#'           \item{18_<=_x_<_20_years}
#'           \item{20_<=_x_<_25_years}
#'           \item{25_<=_x_<_30_years}
#'           \item{30_<=_x_<_35_years}
#'           \item{35_<=_x_<_40_years}
#'           \item{40_<=_x_<_45_years}
#'           \item{45_<=_x_<_50_years}
#'           \item{50_<=_x_<_55_years}
#'           \item{55_<=_x_<_60_years}
#'           \item{60_<=_x_<_65_years}
#'           \item{65_<=_x_<_75_years}
#'           \item{75_and_older}
#'       }
#'   }
#'   \item{\code{count}}{An integer value with the population size.}
#' }
#'
#' @source Obtained from the \emph{Destatis Genesis Online} data base:
#'
#'     \href{https://www-genesis.destatis.de/genesis/online?operation=find&suchanweisung_language=de&query=12411-0018}{Table "12411-0018 - Bevölkerung: Kreise, Stichtag, Geschlecht, Altersgruppen"}
#'
#'     \emph{Copyright:} "Statistisches Bundesamt (Destatis), 2021,
#'     Dieses Werk ist lizenziert unter der Datenlizenz Deutschland - Namensnennung -
#'     Version 2.0."
#'
#'     \emph{Licence:} \url{www.govdata.de/dl-de/by-2-0}
#'
#'     Obtained on the 17.08.2021 at 13:26:54.
#'
"populationGermany"
