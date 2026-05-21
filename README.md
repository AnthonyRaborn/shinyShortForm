
<!-- README.md is generated from README.Rmd. Please edit that file -->

# `{shinyShortForm}`

<!-- badges: start -->

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
#> [1] "2026-05-21 13:12:33 EDT"
```

Here are the tests results and package coverage:

``` r
devtools::check(quiet = TRUE)
#> ══ Documenting ═════════════════════════════════════════════════════════════════
#> ℹ Installed roxygen2 version (8.0.0) doesn't match declared (7.1.1)
#> ✖ `check()` will not re-document this package.
#> ℹ Do you need to re-run `document()`?
#> ── R CMD check results ────────────────────────── shinyShortForm 0.0.0.9000 ────
#> Duration: 8.6s
#> 
#> ❯ checking tests ...
#>   See below...
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
#> ── Test failures ───────────────────────────────────────────────── testthat ────
#> 
#> > # This file is part of the standard setup for testthat.
#> > # It is recommended that you do not modify it.
#> > #
#> > # Where should you do additional test configuration?
#> > # Learn more about the roles of various files in:
#> > # * https://r-pkgs.org/testing-design.html#sec-tests-files-overview
#> > # * https://testthat.r-lib.org/articles/special-files.html
#> > 
#> > library(testthat)
#> > library(shinyShortForm)
#> > 
#> > test_check("shinyShortForm")
#> Error in `test_dir()`:
#> ! No test files found.
#> Backtrace:
#>     ▆
#>  1. └─testthat::test_check("shinyShortForm")
#>  2.   └─testthat::test_dir("testthat", package = package, reporter = reporter, ..., load_package = "installed")
#>  3.     └─cli::cli_abort("No test files found.")
#>  4.       └─rlang::abort(...)
#> Execution halted
#> 
#> 1 error ✖ | 0 warnings ✔ | 3 notes ✖
#> Error:
#> ! R CMD check found ERRORs
```

``` r
covr::package_coverage()
#> Error in `loadNamespace()`:
#> ! there is no package called 'covr'
```
