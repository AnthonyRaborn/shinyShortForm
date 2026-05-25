# R/mod_algorithm_ui.R
#
# Module: Algorithm Selection & Parameter Controls
#
# This module:
#   - Renders the algorithm selector (populated from the registry)
#   - Delegates UI rendering to registry_ui()
#   - Delegates args building to registry_args()
#   - Returns algorithm, args, and run_trigger to the parent app
#
# It contains zero algorithm-specific logic. All of that lives in the
# algo_*.R files and is wired together in algorithm_registry.R.

# ---------------------------------------------------------------------------
# UI
# ---------------------------------------------------------------------------

#' Algorithm UI Module - UI Side
#'
#' @param id Module namespace ID.
#' @noRd
mod_algorithm_ui_ui <- function(id) {
  ns <- NS(id)
  tagList(
    actionButton(
      ns("information"),
      label = "App Information",
      icon  = icon("circle-info"),
      class = "btn-outline-secondary btn-sm mb-3 w-100"
    ),
    h4("Algorithm Options"),
    selectInput(
      inputId  = ns("algorithm"),
      label    = "Select Algorithm",
      choices  = registry_names()   # pulled from algorithm_registry.R
    ),
    uiOutput(ns("param_ui")),
    hr(),
    bslib::input_task_button(
      id    = ns("run"),
      label = "Run Algorithm",
      icon  = icon("hourglass-start"),
      class = "btn-primary w-100"
    )
  )
}

# ---------------------------------------------------------------------------
# Server
# ---------------------------------------------------------------------------

#' Algorithm UI Module - Server Side
#'
#' @param id Module namespace ID.
#'
#' @return A list with:
#'   \describe{
#'     \item{algorithm}{Reactive string: selected algorithm name.}
#'     \item{args}{Reactive named list of algorithm arguments, or NULL while
#'       the dynamic UI is still rendering.}
#'     \item{run_trigger}{Reactive integer: increments on each button press.}
#'   }
#' @noRd
mod_algorithm_ui_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # -- Information modal --------------------------------------------------
    observeEvent(input$information, {
      showModal(modalDialog(
        title = "About shinyShortForm",
        tagList(
          p(
            "This app provides an interactive interface for the ",
            tags$a(
              href   = "https://cran.r-project.org/package=ShortForm",
              target = "_blank",
              rel    = "noopener noreferrer",
              "ShortForm R package"
            ),
            ", which implements metaheuristic algorithms for scale short-form",
            " development."
          ),
          p(
            "Demo results use simulated three-factor binary response data (30 items,",
            " Rasch model). Default parameters are set for a quick demonstration;",
            " changing these defaults may improve solution quality at the",
            " cost of runtime."
          ),
          p(
            "Source: ",
            tags$a(
              href   = "https://github.com/AnthonyRaborn/shinyShortForm",
              target = "_blank",
              rel    = "noopener noreferrer",
              "github.com/AnthonyRaborn/shinyShortForm"
            )
          )
        ),
        easyClose = TRUE,
        footer    = modalButton("Close")
      ))
    })

    # -- Dynamic parameter UI -----------------------------------------------
    # registry_ui() returns the right ui function for the selected algorithm.
    # That function receives ns so its input IDs are namespaced correctly.
    output$param_ui <- renderUI({
      registry_ui(input$algorithm)(ns)
    })

    # -- Reactive args list -------------------------------------------------
    # registry_args() returns the right args builder for the selected algorithm.
    # The builder returns NULL if its inputs haven't rendered yet (algorithm
    # just changed), so downstream consumers should req() the result.
    args <- reactive({
      builder <- registry_args(input$algorithm)
      builder(input)
    })

    # -- Return interface ---------------------------------------------------
    list(
      algorithm   = reactive(input$algorithm),
      args        = args,
      run_trigger = reactive(input$run)
    )
  })
}
