# R/algorithm_registry.R
#
# Algorithm Registry
#
# The single source of truth for which algorithms exist in the app.
# Each entry owns:
#   - ui:   function(ns) -> tagList  (parameter inputs for the sidebar)
#   - args: function(input) -> list  (argument list for the runner)
#
# To add a new algorithm:
#   1. Create R/algo_newname.R with newname_param_ui() and newname_args()
#   2. Add one entry here
#   3. Nothing else needs to change
#
# The registry is a plain named list (not reactive) — it is built once at
# package load time and shared across all sessions.
# Note that the list of algorithms depends on the ShortForm package!

#' @noRd
ALGORITHM_REGISTRY <- list(

  "Ant Colony Optimization" = list(
    ui   = aco_param_ui,
    args = aco_args
  ),

  "Simulated Annealing" = list(
    ui   = sa_param_ui,
    args = sa_args
  ),

  "Tabu Search" = list(
    ui   = tabu_param_ui,
    args = tabu_args
  )

)

#' Retrieve the UI function for a given algorithm
#'
#' @param algorithm Character. Must be a key in ALGORITHM_REGISTRY.
#' @return A function(ns) -> tagList.
#' @noRd
registry_ui <- function(algorithm) {
  entry <- ALGORITHM_REGISTRY[[algorithm]]
  if (is.null(entry)) stop("Unknown algorithm: ", algorithm)
  entry$ui
}

#' Retrieve the arguments builder for a given algorithm
#'
#' @param algorithm Character. Must be a key in ALGORITHM_REGISTRY.
#' @return A function(input) -> list | NULL.
#' @noRd
registry_args <- function(algorithm) {
  entry <- ALGORITHM_REGISTRY[[algorithm]]
  if (is.null(entry)) stop("Unknown algorithm: ", algorithm)
  entry$args
}

#' All registered algorithm names, in display order
#'
#' @return Character vector.
#' @noRd
registry_names <- function() names(ALGORITHM_REGISTRY)
