# R/algo_tabu.R
#
# Tabu Search — UI and args builder

# ---------------------------------------------------------------------------
# UI
# ---------------------------------------------------------------------------

#' Parameter UI for Tabu Search
#'
#' @param ns The namespace function from the parent module.
#' @return A tagList of inputs.
#' @noRd
tabu_param_ui <- function(ns) {
  tagList(
    h5("Tabu Search", class = "text-muted mt-2"),
    numericInput(
      ns("tabu_niter"), "Tabu Iterations",
      value = 5, min = 1, max = 50, step = 1
    ),
    numericInput(
      ns("tabu_size"), "Tabu List Size",
      value = 5, min = 1, max = 10, step = 1
    ),
    h6("Items to Retain per Factor"),
    fluidRow(
      column(4, numericInput(ns("tabu_numItems1"), "F1", 5, min = 2, max = 9)),
      column(4, numericInput(ns("tabu_numItems2"), "F2", 5, min = 2, max = 9)),
      column(4, numericInput(ns("tabu_numItems3"), "F3", 5, min = 2, max = 9))
    )
  )
}

# ---------------------------------------------------------------------------
# Arguments builder
# ---------------------------------------------------------------------------

#' Build the argument list for Tabu Search
#'
#' @param input The Shiny input object (or a plain list for testing).
#' @return A named list of arguments for \code{ShortForm::tabuShortForm()},
#'   or \code{NULL} if required inputs are not yet available.
#' @noRd
tabu_args <- function(input) {
  required <- list(
    input$tabu_niter, input$tabu_size,
    input$tabu_numItems1, input$tabu_numItems2, input$tabu_numItems3
  )
  if (any(vapply(required, is.null, logical(1)))) return(NULL)

  list(
    # User-controlled
    numItems   = c(input$tabu_numItems1, input$tabu_numItems2, input$tabu_numItems3),
    niter      = input$tabu_niter,
    tabu.size  = input$tabu_size,
    # Fixed lavaan model specs
    lavaan.model.specs = list(
      int.ov.free    = TRUE,
      int.lv.free    = FALSE,
      std.lv         = TRUE,
      auto.fix.first = FALSE,
      auto.fix.single= TRUE,
      auto.var       = TRUE,
      auto.cov.lv.x  = TRUE,
      auto.th        = TRUE,
      auto.delta     = TRUE,
      auto.cov.y     = TRUE,
      ordered        = TRUE,
      model.type     = "cfa",
      estimator      = "wlsmv"
    ),
    parallel = FALSE
  )
}
