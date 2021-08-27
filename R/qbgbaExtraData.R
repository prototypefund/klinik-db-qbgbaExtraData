#' qbgbaExtraData: A data package complementing the "Qualitaetsberichte" for
#' German hospitals.
#'
#' This package aims at bundling not only key variables from the reports published by
#' the "Gemeinsamer Bundesausschuss" (GBA) but also several supplementary datasets that
#' can be used in conjunction with these.
#'
#'
#' @docType package
#' @name qbgbaExtraData
#'
#' @importFrom tibble tibble
#' @importFrom dplyr bind_rows
#' @importFrom dplyr bind_cols
#' @importFrom dplyr select
#' @importFrom dplyr mutate
#' @importFrom dplyr group_by
#' @importFrom dplyr ungroup
#' @importFrom dplyr case_when
#' @importFrom dplyr filter
#' @importFrom dplyr distinct
#' @importFrom dplyr arrange
#' @importFrom dplyr n
#' @importFrom dplyr if_any
#' @importFrom dplyr left_join
#' @importFrom dplyr full_join
#' @importFrom dplyr across
#' @importFrom dplyr rename
#' @importFrom dplyr if_else
#' @importFrom tidyr nest
#' @importFrom tidyr unnest
#' @importFrom tidyr fill
#' @importFrom tidyr pivot_longer
#' @importFrom tidyselect all_of
#' @importFrom tidyselect starts_with
#' @importFrom stringr str_replace_all
#' @importFrom stringr str_replace
#' @importFrom stringr str_detect
#' @importFrom stringr str_extract
#' @importFrom stringr str_extract_all
#' @importFrom purrr map
#' @importFrom purrr map_dfc
#' @importFrom purrr map_dfr
#' @importFrom purrr map_dbl
#' @importFrom purrr map_chr
#' @importFrom purrr map_lgl
#' @importFrom purrr map2_dfc
#' @importFrom purrr map2_chr
#' @importFrom purrr pmap_dfr
#' @importFrom purrr pluck
#' @importFrom purrr possibly
#' @importFrom purrr safely
#' @importFrom rlang is_empty
#' @importFrom rlang .data
#' @importFrom rlang :=
#' @importFrom readxl excel_sheets
#' @importFrom readxl read_excel
#' @importFrom utils data
#'
NULL
utils::globalVariables("where")
utils::globalVariables("last_col")
utils::globalVariables("everything")

