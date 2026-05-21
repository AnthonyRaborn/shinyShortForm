
<!-- README.md is generated from README.Rmd. Please edit that file -->

# `{shinyShortForm}`

<!-- badges: start -->

[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![Codecov test
coverage](https://codecov.io/gh/AnthonyRaborn/shinyShortForm/graph/badge.svg)](https://app.codecov.io/gh/AnthonyRaborn/shinyShortForm)
<!-- badges: end -->

## Installation

You can install the development version of `{shinyShortForm}` like so:

``` r
# FILL THIS IN! HOW CAN PEOPLE INSTALL YOUR DEV PACKAGE?
```

## Run

You can launch the application by running:

``` r
shinyShortForm::run_app()
```

## About

You are reading the doc about version : 0.0.0.9000

This README has been compiled on the

``` r
Sys.time()
#> [1] "2026-05-21 16:22:53 EDT"
```

Here are the tests results and package coverage:

``` r
devtools::check(quiet = TRUE)
#> ── R CMD check results ───────────────────────────────── shinyShortForm 0.0.0.9000 ────
#> Duration: 11.3s
#> 
#> ❯ checking for portable file names ... NOTE
#>   Found the following non-portable file paths:
#>     shinyShortForm/shinyShortForm_files/libs/bootstrap/bootstrap-6a298fde403041579a69b2204f21ed52.min.css
#>     shinyShortForm/shinyShortForm_files/libs/bootstrap/bootstrap-dark-6a298fde403041579a69b2204f21ed52.min.css
#>     shinyShortForm/shinyShortForm_files/libs/quarto-html/quarto-syntax-highlighting-7f8f88aac4f3542376d5c11b86a4c14d.css
#>     shinyShortForm/shinyShortForm_files/libs/quarto-html/quarto-syntax-highlighting-dark-d0ae9245876894da5ac7e18953ecc5cc.css
#>   
#>   Tarballs are only required to store paths of up to 100 bytes and cannot
#>   store those of more than 256 bytes, with restrictions including to 100
#>   bytes for the final component.
#>   See section ‘Package structure’ in the ‘Writing R Extensions’ manual.
#> 
#> ❯ checking top-level files ... NOTE
#>   Non-standard files/directories found at top level:
#>     ‘assets’ ‘rsconnect’ ‘shinyShortForm.html’ ‘shinyShortForm.qmd’
#>     ‘shinyShortForm_files’
#> 
#> ❯ checking package subdirectories ... NOTE
#>   Problems with news in ‘NEWS.md’:
#>   No news entries found.
#> 
#> 0 errors ✔ | 0 warnings ✔ | 3 notes ✖
```

``` r
covr::package_coverage()
#> shinyShortForm Coverage: 8.53%
#> R/app_config.R: 0.00%
#> R/app_ui.R: 0.00%
#> R/global.R: 0.00%
#> R/golem_utils_server.R: 0.00%
#> R/golem_utils_ui.R: 0.00%
#> R/run_app.R: 0.00%
#> R/mod_algorithm_ui.R: 100.00%
#> R/mod_results.R: 100.00%
#> R/mod_task_runner.R: 100.00%
```
