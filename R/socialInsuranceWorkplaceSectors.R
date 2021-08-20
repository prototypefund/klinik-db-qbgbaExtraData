#' Numbers of people in every county in Germany from 2015 to 2020 that are employed
#' and have social insurance.
#'
#' This dataset contains counts of people in a socially insured employment from all
#' German counties over the years 2015 to 2020, grouped by gender.
#'
#' @format A \code{tibble} with 162,552 rows and seven columns:
#' \describe{
#'   \item{\code{year}}{A string with values "2015", "2016", "2017", "2018", "2019"
#'       and "2020", indicating to which year the data belongs. Every year is
#'       reported on the middle day of the year, i.e., the 30st of June each
#'       year.}
#'   \item{\code{AGS}}{This character string comprises the "Amtliche Gemeindeschluessel"
#'       (AGS) for each county, where the first and second character represents
#'       the state, the third character the district and the fourth and fifth
#'       character represents the county.}
#'   \item{\code{name}}{A character value with the name of the respective county.}
#'   \item{\code{sector}}{A character value indicating the sector in which the people
#'       are employed. These are not translated into German because they represent
#'       certain groups specific to German regulatory nomenclatura:
#'
#'       \itemize{
#'           \item{Land- und Forstwirtschaft, Fischerei (A)}
#'           \item{Produzierendes Gewerbe (B-F)}
#'           \item{Produzierendes Gewerbe ohne Baugewerbe (B-E)}
#'           \item{Verarbeitendes Gewerbe (C)}
#'           \item{Baugewerbe (F)}
#'           \item{Dienstleistungsbereiche (G-U)}
#'           \item{Handel, Gastgewerbe, Verkehr (G-I)}
#'           \item{Information und Kommunikation (J)}
#'           \item{Erbringung von Finanz- und Vers.leistungen (K)}
#'           \item{Grundstücks- und Wohnungswesen (L)}
#'           \item{Freiberufl,wissenschaftl. techn. Dienstl.,sonst.DL}
#'           \item{Öff.Verw.,Verteidig.,Sozialvers.,Erz.-u.Unterricht}
#'           \item{Kunst, Unterhaltung, Erholung, Priv. Haush.,usw."}
#'       }
#'   }
#'   \item{\code{gender}}{A character value with either "female" or "male".}
#'   \item{\code{nationality}}{A character value with either "total" or "foreigner".}
#'   \item{\code{count}}{An integer value with the count of employed people with
#'       social insurance.}
#' }
#'
#' @source Obtained from the \emph{Regionalstatistik} data base:
#'
#'     \href{https://www.regionalstatistik.de/genesis/online?operation=find&suchanweisung_language=de&query=13111-07-05-4}{Table "13111-07-05-4 - Sozialversicherungspflichtig Beschäftigte am Arbeitsort nach Geschlecht, Nationalität und Wirtschaftszweigen"}
#'
#'     \emph{Copyright:} "Statistische Aemter des Bundes und der Laender, Deutschland, 2021.
#'     Dieses Werk ist lizenziert unter der Datenlizenz Deutschland - Namensnennung -
#'     Version 2.0."
#'
#'     \emph{Licence:} \url{www.govdata.de/dl-de/by-2-0}
#'
#'     Obtained on the 17.08.2021 at 20:27:28.
#'
"socialInsuranceWorkplaceSectors"
