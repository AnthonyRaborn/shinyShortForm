# R/algo_aco.R
#
# Ant Colony Optimization — UI and args builder
#
# Both functions live here so that input IDs are defined and consumed
# in the same file. Adding or renaming a parameter means editing only
# this file.

# ---------------------------------------------------------------------------
# UI
# ---------------------------------------------------------------------------

#' Parameter UI for Ant Colony Optimization
#'
#' @param ns The namespace function from the parent module.
#' @return A tagList of inputs.
#' @noRd
aco_param_ui <- function(ns) {
  tagList(
    h5("Ant Colony Optimization", class = "text-muted mt-2"),
    numericInput(
      ns("aco_ants"), "Number of Ants",
      value = 5, min = 5, max = 100, step = 5
    ),
    numericInput(
      ns("aco_evaporation"), "Evaporation Rate (0 - 1)",
      value = 0.9, min = 0, max = 1, step = 0.01
    ),
    numericInput(
      ns("aco_steps"), "Steps (stopping rule)",
      value = 5, min = 1, max = 50, step = 1
    ),
    numericInput(
      ns("aco_maxrun"), "Maximum Runs",
      value = 100, min = 1, max = 100000, step = 1
    ),
    selectInput(
      ns("aco_pheromone"), "Pheromone Type",
      choices  = c("gamma", "beta", "regression", "variance"),
      selected = "gamma"
    ),
    selectInput(
      ns("aco_plot_choice"), "Plot to Display",
      choices  = c("all", "pheromone", "gamma", "beta", "variance"),
      selected = "all"
    ),
    h6("Max Items per Factor"),
    fluidRow(
      column(4, numericInput(ns("aco_iperf1"), "F1", 5, min = 2, max = 9)),
      column(4, numericInput(ns("aco_iperf2"), "F2", 5, min = 2, max = 9)),
      column(4, numericInput(ns("aco_iperf3"), "F3", 5, min = 2, max = 9))
    )
  )
}

# ---------------------------------------------------------------------------
# Argumentss builder
# ---------------------------------------------------------------------------

#' Build the argument list for Ant Colony Optimization
#'
#' A plain function — no reactives, no Shiny session required.
#' This makes it independently unit-testable with a mock input list.
#'
#' @param input The Shiny input object (or a plain list for testing).
#' @return A named list of arguments for \code{ShortForm::antcolony.lavaan()},
#'   or \code{NULL} if required inputs are not yet available.
#' @noRd
aco_args <- function(input) {
  # Guard: if the dynamic UI hasn't rendered yet, these will be NULL.
  # Return NULL so the caller can req() or Filter() as appropriate.
  required <- list(
    input$aco_ants, input$aco_evaporation, input$aco_steps,
    input$aco_maxrun, input$aco_pheromone,
    input$aco_iperf1, input$aco_iperf2, input$aco_iperf3
  )
  if (any(vapply(required, is.null, logical(1)))) return(NULL)

  list(
    # User-controlled
    ants                  = input$aco_ants,
    evaporation           = input$aco_evaporation,
    steps                 = input$aco_steps,
    max.run               = input$aco_maxrun,
    pheromone.calculation = input$aco_pheromone,
    plot_choice           = input$aco_plot_choice,
    i.per.f               = c(input$aco_iperf1, input$aco_iperf2, input$aco_iperf3),
    # Fixed / derived — pulled from global.R
    list.items            = FACTOR_ITEM_LIST,
    full                  = N_ITEMS,
    factors               = FACTOR_NAMES,
    fit.indices           = "cfi",
    fit.statistics.test   = "(cfi > 0.90)",
    lavaan.model.specs    = list(estimator = "wlsmv", ordered = TRUE),
    parallel              = FALSE
  )
}
