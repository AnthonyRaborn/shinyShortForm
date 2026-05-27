# R/mod_task_runner.R
#
# Module: Async Task Runner & Status Messaging
#
# Owns the ExtendedTask, animation loop, and status text.
# Returns the task result reactive for mod_results to consume.

# ---------------------------------------------------------------------------
# Animation frames -- matched to the original qmd
# ---------------------------------------------------------------------------

.ANIMATION_FRAMES <- list(
  "Ant Colony Optimization" = list(
    "\U0001F41C\u2192\u2192\u2192 \U0001F427 Searching for solution...",
    "\u2192\U0001F41C\u2192\u2192 \U0001F427 Searching for solution...",
    "\u2192\u2192\U0001F41C\u2192 \U0001F427 Searching for solution...",
    "\u2192\u2192\u2192\U0001F41C \U0001F427 Searching for solution..."
  ),
  "Simulated Annealing" = list(
    "\U0001F427\U0001F525\U0001F525\U0001F525 Searching for solution...",
    "\U0001F525\U0001F427\U0001F525\U0001F525 Searching for solution...",
    "\U0001F525\U0001F525\U0001F427\U0001F525 Searching for solution...",
    "\U0001F525\U0001F525\U0001F525\U0001F427 Searching for solution..."
  ),
  "Tabu Search" = list(
    "\u2717\U0001F427\U0001F427\U0001F427 Searching for solution...",
    "\U0001F427\u2717\U0001F427\U0001F427 Searching for solution...",
    "\U0001F427\U0001F427\u2717\U0001F427 Searching for solution...",
    "\U0001F427\U0001F427\U0001F427\u2717 Searching for solution..."
  )
)

# ---------------------------------------------------------------------------
# UI
# ---------------------------------------------------------------------------

#' Task Runner Module - UI Side
#'
#' Renders only the status message text. Place this inside the sidebar,
#' below mod_algorithm_ui_ui().
#'
#' @param id Module namespace ID.
#' @noRd
mod_task_runner_ui <- function(id) {
  ns <- NS(id)
  div(
    textOutput(ns("status_message"))
  )
}

# ---------------------------------------------------------------------------
# Server
# ---------------------------------------------------------------------------

#' Task Runner Module - Server Side
#'
#' @param id Module namespace ID.
#' @param algorithm Reactive string: selected algorithm name.
#' @param args Reactive named list of algorithm arguments (from registry_args).
#'   May return NULL while dynamic UI is rendering after an algorithm switch.
#' @param run_trigger Reactive integer that increments on each run button press.
#'
#' @return A list:
#'   \describe{
#'     \item{result}{Reactive returning the task result when complete, NULL otherwise.}
#'     \item{task}{The ExtendedTask object (for status checks if needed).}
#'   }
#' @noRd
mod_task_runner_server <- function(id, algorithm, args, run_trigger) {
  stopifnot(is.reactive(algorithm))
  stopifnot(is.reactive(args))
  stopifnot(is.reactive(run_trigger))

  moduleServer(id, function(input, output, session) {

    # -- Async future plan (session-scoped) ---------------------------------
    future::plan(future::multisession, workers = 2)

    # -- ExtendedTask -------------------------------------------------------
    # Receives plain values only -- no reactives cross the future boundary.
    algorithm_task <- ExtendedTask$new(function(choice, run_args, sim_data, sim_model) {
      future::future({
        result <- switch(
          choice,
          "Ant Colony Optimization" = ShortForm::antcolony.lavaan(
            data                  = sim_data,
            ants                  = run_args$ants,
            evaporation           = run_args$evaporation,
            antModel              = sim_model,
            list.items            = run_args$list.items,
            full                  = run_args$full,
            i.per.f               = run_args$i.per.f,
            factors               = run_args$factors,
            steps                 = run_args$steps,
            pheromone.calculation = run_args$pheromone.calculation,
            fit.indices           = run_args$fit.indices,
            fit.statistics.test   = run_args$fit.statistics.test,
            max.run               = run_args$max.run,
            parallel              = run_args$parallel
          ),
          "Simulated Annealing" = ShortForm::simulatedAnnealing(
            initialModel       = sim_model,
            originalData       = sim_data,
            setChains          = run_args$setChains,
            maxItems           = run_args$maxItems,
            items              = run_args$items,
            maxSteps           = run_args$maxSteps,
            temperature        = run_args$temperature,
            maxChanges         = run_args$maxChanges,
            parallel           = run_args$parallel
          ),
          "Tabu Search" = ShortForm::tabuShortForm(
            originalData       = sim_data,
            initialModel       = sim_model,
            numItems           = run_args$numItems,
            niter              = run_args$niter,
            tabu.size          = run_args$tabu.size,
            lavaan.model.specs = run_args$lavaan.model.specs,
            parallel           = FALSE
          )
        )
        result
      }, seed = TRUE)
    })

    # -- Animation state ----------------------------------------------------
    current_frame    <- reactiveVal(1L)
    animation_active <- reactiveVal(FALSE)

    observe({
      req(animation_active())
      invalidateLater(500)
      frames     <- .ANIMATION_FRAMES[[isolate(algorithm())]]
      next_frame <- isolate(current_frame()) %% length(frames) + 1L
      current_frame(next_frame)
      if (algorithm_task$status() %in% c("success", "error")) {
        animation_active(FALSE)
      }
    })

    # -- Run trigger --------------------------------------------------------
    observeEvent(run_trigger(), {
      # req() prevents firing on initial value (0)
      req(run_trigger() > 0)

      current_args <- args()
      req(!is.null(current_args))  # guard for NULL during algorithm switch

      animation_active(TRUE)
      current_frame(1L)

      tryCatch(
        algorithm_task$invoke(algorithm(), current_args, SIM_DATA, SIM_MODEL),
        error = function(e) {
          animation_active(FALSE)
          logger::log_error("Task invocation failed: {e$message}")
        }
      )
    })

    # -- Status message -----------------------------------------------------
    output$status_message <- renderText({
      status <- algorithm_task$status()
      if (animation_active()) {
        frames <- .ANIMATION_FRAMES[[algorithm()]]
        frames[[current_frame()]]
      } else if (status == "success") {
        paste0(algorithm(), " completed successfully!")
      } else if (status == "error") {
        paste0(algorithm(), " encountered an error. Check inputs and try again.")
      } else {
        paste0("Ready. Current algorithm: ", algorithm())
      }
    })

    # -- Return interface ---------------------------------------------------
    list(
      task   = algorithm_task,
      result = reactive({
        req(algorithm_task$status() == "success")
        algorithm_task$result()
      })
    )
  })
}
