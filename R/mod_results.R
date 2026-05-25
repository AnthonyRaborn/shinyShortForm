# R/mod_results.R
#
# Module: Results Display
#
# Three tabs matching the qmd layout:
#   - "Algorithm Output"  -> status message + verbatim summary (verbatimTextOutput)
#   - "Algorithm Plot"    -> plotOutput
#   - "Algorithm Manual"  -> rendered help page (uiOutput)
#
# The plot_choice for ACO comes from the args list built by aco_args(), not
# from a separate input here. This matches the qmd behaviour where plot_choice
# was passed as part of args and consumed in the render.

# ---------------------------------------------------------------------------
# UI
# ---------------------------------------------------------------------------

#' Results Module - UI Side
#'
#' @param id Module namespace ID.
#' @noRd
mod_results_ui <- function(id) {
  ns <- NS(id)
  bslib::navset_card_tab(
    bslib::nav_panel(
      title = "Algorithm Output",
      icon  = shiny::icon("table-list"),
      verbatimTextOutput(ns("algorithm_result"))
    ),
    bslib::nav_panel(
      title = "Algorithm Plot",
      icon  = shiny::icon("chart-line"),
      plotOutput(ns("algorithm_plot"), height = "400px")
    ),
    bslib::nav_panel(
      title = "Algorithm Manual",
      icon  = shiny::icon("book"),
      uiOutput(ns("algorithm_help"))
    )
  )
}

# ---------------------------------------------------------------------------
# Server
# ---------------------------------------------------------------------------

#' Results Module - Server Side
#'
#' @param id Module namespace ID.
#' @param result Reactive returning the algorithm result object, or NULL.
#' @param algorithm Reactive string: selected algorithm name.
#' @param args Reactive named list of algorithm arguments. Used to extract
#'   plot_choice for ACO without needing a separate input.
#' @noRd
mod_results_server <- function(id, result, algorithm, args) {
  stopifnot(is.reactive(result))
  stopifnot(is.reactive(algorithm))
  stopifnot(is.reactive(args))

  moduleServer(id, function(input, output, session) {

    # -- Help page ----------------------------------------------------------
    # Matches the qmd algorithm_help chunk exactly.
    output$algorithm_help <- renderUI({
      req(algorithm())

      help_file <- switch(
        algorithm(),
        "Ant Colony Optimization" = utils::help(antcolony.lavaan,   package = "ShortForm"),
        "Simulated Annealing"     = utils::help(simulatedAnnealing, package = "ShortForm"),
        "Tabu Search"             = utils::help(tabuShortForm,      package = "ShortForm")
      )

      if (length(help_file) == 0) {
        return(p("Help page not found.", style = "color: red;"))
      }

      html_file <- tempfile(fileext = ".html")
      tools::Rd2HTML(utils:::.getHelpFile(help_file), out = html_file)
      HTML(paste(readLines(html_file, warn = FALSE), collapse = "\n"))
    })

    # -- Summary output -----------------------------------------------------
    # Matches the qmd algorithm_result renderPrint.
    output$algorithm_result <- renderPrint({
      res <- result()
      req(!is.null(res))
      summary(res)
    })

    # -- Plot output --------------------------------------------------------
    # plot_choice is embedded in the ACO args list.
    # For SA and Tabu, plot() is called with no type argument.
    output$algorithm_plot <- renderPlot({
      res <- result()
      req(!is.null(res))

      if (algorithm() == "Ant Colony Optimization") {
        current_args <- args()
        plot_type    <- if (!is.null(current_args)) current_args$plot_choice else "all"
        plot(res, type = plot_type)
      } else {
        plot(res)
      }
    })
  })
}
