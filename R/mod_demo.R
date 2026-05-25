# R/mod_demo.R
#
# Module: Demo Page
#
# Composes mod_algorithm_ui, mod_task_runner, and mod_results into the
# sidebar + main panel layout that matches the original qmd dashboard.
#
# This module's only job is layout and wiring. No reactive logic lives here.

# ---------------------------------------------------------------------------
# UI
# ---------------------------------------------------------------------------

#' Demo Page Module - UI Side
#'
#' @param id Module namespace ID.
#' @noRd
mod_demo_ui <- function(id) {
  ns <- NS(id)
  bslib::layout_sidebar(
    sidebar = bslib::sidebar(
      width = 320,
      tagList(
        mod_algorithm_ui_ui(ns("algo")),
        hr(),
        mod_task_runner_ui(ns("runner"))
      )
    ),
    mod_results_ui(ns("results"))
  )
}

# ---------------------------------------------------------------------------
# Server
# ---------------------------------------------------------------------------

#' Demo Page Module - Server Side
#'
#' Wires algorithm selection -> task runner -> results display.
#'
#' @param id Module namespace ID.
#' @noRd
mod_demo_server <- function(id) {
  moduleServer(id, function(input, output, session) {

    # Algorithm selection: provides algorithm name, args, and run trigger
    algo <- mod_algorithm_ui_server("algo")

    # Task runner: receives algorithm + args + trigger, returns result
    runner <- mod_task_runner_server(
      id          = "runner",
      algorithm   = algo$algorithm,
      args        = algo$args,
      run_trigger = algo$run_trigger
    )

    # Results display: receives result + algorithm name + args (for plot_choice)
    mod_results_server(
      id        = "results",
      result    = runner$result,
      algorithm = algo$algorithm,
      args      = algo$args
    )
  })
}
