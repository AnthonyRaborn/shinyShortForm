Tests and Coverage
================
21 May, 2026 16:17:42

- [Coverage](#coverage)
- [Unit Tests](#unit-tests)

This output is created by
[covrpage](https://github.com/yonicd/covrpage).

## Coverage

Coverage summary is created using the
[covr](https://github.com/r-lib/covr) package.

| Object                                              | Coverage (%) |
|:----------------------------------------------------|:------------:|
| shinyShortForm                                      |     8.53     |
| [R/app_config.R](../R/app_config.R)                 |     0.00     |
| [R/app_ui.R](../R/app_ui.R)                         |     0.00     |
| [R/global.R](../R/global.R)                         |     0.00     |
| [R/golem_utils_server.R](../R/golem_utils_server.R) |     0.00     |
| [R/golem_utils_ui.R](../R/golem_utils_ui.R)         |     0.00     |
| [R/run_app.R](../R/run_app.R)                       |     0.00     |
| [R/mod_algorithm_ui.R](../R/mod_algorithm_ui.R)     |    100.00    |
| [R/mod_results.R](../R/mod_results.R)               |    100.00    |
| [R/mod_task_runner.R](../R/mod_task_runner.R)       |    100.00    |

<br>

## Unit Tests

Unit Test summary is created using the
[testthat](https://github.com/r-lib/testthat) package.

| file | n | time | error | failed | skipped | warning |
|:---|---:|---:|---:|---:|---:|---:|
| [test-app.R](testthat/test-app.R) | 1 | 0.011 | 0 | 0 | 0 | 0 |
| [test-fct_helpers.R](testthat/test-fct_helpers.R) | 1 | 0.004 | 0 | 0 | 0 | 0 |
| [test-mod_algorithm_ui.R](testthat/test-mod_algorithm_ui.R) | 2 | 0.003 | 0 | 0 | 0 | 0 |
| [test-mod_results.R](testthat/test-mod_results.R) | 2 | 0.003 | 0 | 0 | 0 | 0 |
| [test-mod_task_runner.R](testthat/test-mod_task_runner.R) | 2 | 0.002 | 0 | 0 | 0 | 0 |
| [test-utils_helpers.R](testthat/test-utils_helpers.R) | 1 | 0.001 | 0 | 0 | 0 | 0 |

<details closed>

<summary>

Show Detailed Test Results
</summary>

| file | context | test | status | n | time |
|:---|:---|:---|:---|---:|---:|
| [test-app.R](testthat/test-app.R#L2) | app | multiplication works | PASS | 1 | 0.011 |
| [test-fct_helpers.R](testthat/test-fct_helpers.R#L2) | fct_helpers | multiplication works | PASS | 1 | 0.004 |
| [test-mod_algorithm_ui.R](testthat/test-mod_algorithm_ui.R#L31) | mod_algorithm_ui | module ui works | PASS | 2 | 0.003 |
| [test-mod_results.R](testthat/test-mod_results.R#L31) | mod_results | module ui works | PASS | 2 | 0.003 |
| [test-mod_task_runner.R](testthat/test-mod_task_runner.R#L31) | mod_task_runner | module ui works | PASS | 2 | 0.002 |
| [test-utils_helpers.R](testthat/test-utils_helpers.R#L2) | utils_helpers | multiplication works | PASS | 1 | 0.001 |

</details>

<details>

<summary>

Session Info
</summary>

| Field    | Value                        |
|:---------|:-----------------------------|
| Version  | R version 4.6.0 (2026-04-24) |
| Platform | aarch64-apple-darwin23       |
| Running  | macOS Tahoe 26.5             |
| Language | en_US                        |
| Timezone | America/New_York             |

| Package  | Version |
|:---------|:--------|
| testthat | 3.3.2   |
| covr     | 3.6.5   |
| covrpage | 0.2     |

</details>

<!--- Final Status : pass --->
