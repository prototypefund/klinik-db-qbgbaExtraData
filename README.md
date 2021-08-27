
<!-- README.md is generated from README.Rmd. Please edit that file -->

# qbgbaExtraData <img src='man/figures/logo.png' align="right" height="139" />

<!-- badges: start -->
<!-- badges: end -->

The goal of qbgbaExtraData is to provide several datasets that can be
used in conjunction with the data from the “Qualitaetsberichte der
Krankenhaeuser”, which are puplished by the “Gemeinsamer
Bundesausschuss” (GBA) on a yearly basis. To serve this purpose, a tiny
excerpt of these is also included into this package, see `AllHospitals`.

## Installation

You can install qbgbaExtraData from
[Gitlab](https://gitlab.com/klinik-db/qbgbaExtraData) with:

``` r
devtools::install_gitlab("klinik-db/qbgbaExtraData")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(qbgbaExtraData)
suppressPackageStartupMessages(library(dplyr))

data(populationGermany)

populationGermany %>% 
    group_by(year) %>% 
    summarize(Population = sum(count))
#> # A tibble: 6 x 2
#>   year  Population
#>   <chr>      <int>
#> 1 2015    82175684
#> 2 2016    82521653
#> 3 2017    82792351
#> 4 2018    83019213
#> 5 2019    83166711
#> 6 2020    83155031
```

## Funding

Sponsored through the Prototype Fund by the German Federal Ministry of
Education and Research from March 2021 to August 2021.

<a href='https://klinik-db.de'><img src='man/figures/BMBF_eng.png' align="left" height="139" /></a>
