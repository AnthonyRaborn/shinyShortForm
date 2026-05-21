# R/global.R
# Objects defined here are created once when the app starts and shared
# across all sessions. Keep this to truly static, session-independent data.

#' @importFrom future plan multisession
#' @importFrom psych sim.rasch
NULL

# ---------------------------------------------------------------------------
# Simulated data (shared across sessions -- read-only)
# ---------------------------------------------------------------------------

#' Simulated three-factor binary response data for demonstration
#'
#' 30 items across three factors, each factor having 10 items, simulated
#' using a Rasch model via psych::sim.rasch(). Used as the default dataset
#' in the app when no user data is supplied.
#'
#' @format A numeric matrix with N rows and 30 columns (x1 through x30).
#' @noRd
make_sim_data <- function(seed = 20240101) {
  set.seed(seed)
  data <- cbind(
    psych::sim.rasch(nvar = 10)$items,
    psych::sim.rasch(nvar = 10)$items,
    psych::sim.rasch(nvar = 10)$items
  )
  colnames(data) <- paste0("x", 1:30)
  data
}

SIM_DATA <- make_sim_data()

#' CFA model specification for the simulated three-factor structure
#'
#' @noRd
SIM_MODEL <- "
  f1 =~ x1  + x2  + x3  + x4  + x5  + x6  + x7  + x8  + x9  + x10
  f2 =~ x11 + x12 + x13 + x14 + x15 + x16 + x17 + x18 + x19 + x20
  f3 =~ x21 + x22 + x23 + x24 + x25 + x26 + x27 + x28 + x29 + x30
"

#' Factor-to-item mappings for ACO and related algorithms
#'
#' @noRd
FACTOR_ITEM_LIST <- list(
  paste0("x", 1:10),
  paste0("x", 11:20),
  paste0("x", 21:30)
)

FACTOR_NAMES <- c("f1", "f2", "f3")
N_FACTORS    <- 3L
N_ITEMS      <- 30L
