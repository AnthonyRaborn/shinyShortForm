# R/mod_results.R
#
# Module: Results Display
#
# ShortForm (>= 0.5.0) returns S4 objects: ACO, SA, TS.
# S4 dispatch rules:
#   - summary(res) -> works via S4 summary,<class>-method, but renderPrint
#     captures print output, not the invisible return value, so we use
#     methods::show() which is the S4 print method for these classes.
#   - plot(res)    -> base plot() does NOT dispatch S4 methods; must use
#     methods::getMethod("plot", ...) or the explicit S4 signature call.
#   - help pages   -> use fetchRdDB() with function topic names, not class names.

# ---------------------------------------------------------------------------
# Internal helpers
# ---------------------------------------------------------------------------
# Suppress R CMD CHECK note for tools:::fetchRdDB.
# This internal function is the only reliable way to retrieve compiled Rd
# objects from an installed package's help database at runtime.
# See: https://github.com/wch/r-source/blob/trunk/src/library/tools/R/Rd.R
utils::globalVariables("fetchRdDB")
# Map from algorithm display name to S4 class name.
# Used to dispatch S4 methods correctly.
.ALGO_CLASS <- c(
  "Ant Colony Optimization" = "ACO",
  "Simulated Annealing"     = "SA",
  "Tabu Search"             = "TS"
)

# Map from algorithm display name to help topic (function name in ShortForm).
.ALGO_HELP_TOPIC <- c(
  "Ant Colony Optimization" = "antcolony.lavaan",
  "Simulated Annealing"     = "simulatedAnnealing",
  "Tabu Search"             = "tabuShortForm"
)

#' Render an S4 ShortForm result object via its show() method
#' @noRd
.show_result <- function(res) {
  methods::show(res)
}

#' Call the S4 plot method for a ShortForm result object
#' @noRd
.plot_result <- function(res, plot_type = NULL) {
  s4_class <- class(res)
  plot_method <- tryCatch(
    methods::getMethod("plot", signature(s4_class, "ANY")),
    error = function(e) NULL
  )
  if (is.null(plot_method)) {
    # Fallback: try without second signature arg
    plot_method <- tryCatch(
      methods::getMethod("plot", signature(s4_class)),
      error = function(e) NULL
    )
  }
  if (is.null(plot_method)) {
    stop("No S4 plot method found for class: ", s4_class)
  }
  if (!is.null(plot_type)) {
    plot_method(res, plot_type)
  } else {
    plot_method(res)
  }
}

#' Render a ShortForm function help page as HTML
#' @noRd
.render_help_html <- function(topic) {
  help_dir <- system.file("help", package = "ShortForm")
  if (!nzchar(help_dir)) return(NULL)

  db_path <- file.path(help_dir, "ShortForm")

  rd <- tryCatch(
    tools:::fetchRdDB(db_path, key = topic),
    error = function(e) NULL
  )
  if (is.null(rd)) return(NULL)

  html_file <- tempfile(fileext = ".html")
  tools::Rd2HTML(rd, out = html_file)
  paste(readLines(html_file, warn = FALSE), collapse = "\n")
}

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
#' @param result Reactive returning the S4 algorithm result object, or NULL.
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
    # Rendered whenever the algorithm selection changes, not on result.
    # Uses fetchRdDB() to avoid utils:::.getHelpFile and the CMD CHECK warning.
    output$algorithm_help <- renderUI({
      req(algorithm())
      topic <- .ALGO_HELP_TOPIC[[algorithm()]]
      html  <- .render_help_html(topic)

      if (is.null(html)) {
        p(
          "Help page could not be rendered. View it at: ",
          tags$a(
            href   = paste0("https://rdrr.io/cran/ShortForm/man/", topic, ".html"),
            target = "_blank",
            rel    = "noopener noreferrer",
            paste0("rdrr.io/cran/ShortForm/man/", topic)
          )
        )
      } else {
        HTML(html)
      }
    })

    # -- Summary output -----------------------------------------------------
    # Uses S4 show() method, which is the correct print dispatch for ACO/SA/TS.
    output$algorithm_result <- renderPrint({
      res <- result()
      req(!is.null(res))
      .show_result(res)
    })

    # -- Plot output --------------------------------------------------------
    # Uses S4 plot method via getMethod() to avoid base plot.default dispatch.
    # plot_choice for ACO comes from args, not a separate input.
    output$algorithm_plot <- renderPlot({
      res <- result()
      req(!is.null(res))

      plot_type <- if (algorithm() == "Ant Colony Optimization") {
        current_args <- args()
        if (!is.null(current_args)) current_args$plot_choice else "all"
      } else {
        NULL
      }

      tryCatch(
        .plot_result(res, plot_type),
        error = function(e) {
          plot.new()
          text(0.5, 0.5, paste("Plot error:", e$message), cex = 0.9)
        }
      )
    })
  })
}
