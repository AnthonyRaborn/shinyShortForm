# R/algo_sa.R
#
# Simulated Annealing — UI and args builder

# ---------------------------------------------------------------------------
# UI
# ---------------------------------------------------------------------------

#' Parameter UI for Simulated Annealing
#'
#' @param ns The namespace function from the parent module.
#' @return A tagList of inputs.
#' @noRd
sa_param_ui <- function(ns) {
  tagList(
    h5("Simulated Annealing", class = "text-muted mt-2"),
    numericInput(
      ns("sa_maxSteps"), "Maximum Steps",
      value = 50, min = 1, max = 10000, step = 1
    ),
    numericInput(
      ns("sa_maxChanges"), "Max Model Changes per Step",
      value = 2, min = 2, max = 10, step = 1
    ),
    numericInput(
      ns("sa_maxConsecutive"), "Max Consecutive Same-Model Steps",
      value = 5, min = 1, max = 100, step = 1
    ),
    selectInput(
      ns("sa_temperature"), "Temperature Function",
      choices  = c("linear", "quadratic", "logistic"),
      selected = "linear"
    ),
    h6("Max Items per Factor"),
    fluidRow(
      column(4, numericInput(ns("sa_maxItems1"), "F1", 5, min = 2, max = 9)),
      column(4, numericInput(ns("sa_maxItems2"), "F2", 5, min = 2, max = 9)),
      column(4, numericInput(ns("sa_maxItems3"), "F3", 5, min = 2, max = 9))
    )
  )
}

# ---------------------------------------------------------------------------
# Arguments builder
# ---------------------------------------------------------------------------

#' Build the argument list for Simulated Annealing
#'
#' @param input The Shiny input object (or a plain list for testing).
#' @return A named list of arguments for \code{ShortForm::simulatedAnnealing()},
#'   or \code{NULL} if required inputs are not yet available.
#' @noRd
sa_args <- function(input) {
  required <- list(
    input$sa_maxSteps, input$sa_maxChanges,
    input$sa_maxConsecutive, input$sa_temperature,
    input$sa_maxItems1, input$sa_maxItems2, input$sa_maxItems3
  )
  if (any(vapply(required, is.null, logical(1)))) return(NULL)

  list(
    # User-controlled
    maxSteps           = input$sa_maxSteps,
    maxChanges         = input$sa_maxChanges,
    maximumConsecutive = input$sa_maxConsecutive,
    temperature        = input$sa_temperature,
    maxItems           = c(input$sa_maxItems1, input$sa_maxItems2, input$sa_maxItems3),
    # Fixed / derived
    items              = paste0("x", seq_len(N_ITEMS)),
    setChains          = 1L,
    parallel           = FALSE
  )
}
