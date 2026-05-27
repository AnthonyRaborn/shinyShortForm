# tests/testthat/test-algo-args.R
#
# Unit tests for algorithm args builders.
#
# Because the builders are plain functions that take a list and return a list,
# these tests run instantly with no Shiny session, no browser, and no future
# workers. This is the main payoff of the registry pattern.

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

# Minimal valid input lists for each algorithm.
# These mirror the default values set in the UI functions.

mock_aco_input <- list(
  aco_ants        = 5,
  aco_evaporation = 0.9,
  aco_steps       = 5,
  aco_maxrun      = 100,
  aco_pheromone   = "gamma",
  aco_plot_choice = "all",
  aco_iperf1      = 5,
  aco_iperf2      = 5,
  aco_iperf3      = 5
)

mock_sa_input <- list(
  sa_maxSteps       = 50,
  sa_maxChanges     = 2,
  sa_maxConsecutive = 5,
  sa_temperature    = "linear",
  sa_maxItems1      = 5,
  sa_maxItems2      = 5,
  sa_maxItems3      = 5
)

mock_tabu_input <- list(
  tabu_niter     = 5,
  tabu_size      = 5,
  tabu_numItems1 = 5,
  tabu_numItems2 = 5,
  tabu_numItems3 = 5
)

# ---------------------------------------------------------------------------
# ACO args
# ---------------------------------------------------------------------------

test_that("aco_args returns NULL when inputs are missing", {
  expect_null(aco_args(list()))
  expect_null(aco_args(list(aco_ants = 5)))  # only one input present
})

test_that("aco_args returns a named list with all required keys", {
  result <- aco_args(mock_aco_input)
  expect_type(result, "list")
  expect_named(result, c(
    "ants", "evaporation", "steps", "max.run", "pheromone.calculation",
    "plot_choice", "i.per.f", "list.items", "full", "factors",
    "fit.indices", "fit.statistics.test", "lavaan.model.specs", "parallel"
  ), ignore.order = TRUE)
})

test_that("aco_args maps input values correctly", {
  result <- aco_args(mock_aco_input)
  expect_equal(result$ants, 5)
  expect_equal(result$evaporation, 0.9)
  expect_equal(result$i.per.f, c(5, 5, 5))
  expect_equal(result$pheromone.calculation, "gamma")
  expect_false(result$parallel)
})

test_that("aco_args fixed args are correct", {
  result <- aco_args(mock_aco_input)
  expect_equal(result$fit.indices, "cfi")
  expect_equal(result$full, N_ITEMS)
  expect_equal(result$factors, FACTOR_NAMES)
})

# ---------------------------------------------------------------------------
# SA args
# ---------------------------------------------------------------------------

test_that("sa_args returns NULL when inputs are missing", {
  expect_null(sa_args(list()))
})

test_that("sa_args returns a named list with all required keys", {
  result <- sa_args(mock_sa_input)
  expect_type(result, "list")
  expect_named(result, c(
    "maxSteps", "maxChanges", "maximumConsecutive", "temperature",
    "maxItems", "items", "setChains", "parallel"
  ), ignore.order = TRUE)
})

test_that("sa_args maps input values correctly", {
  result <- sa_args(mock_sa_input)
  expect_equal(result$maxSteps, 50)
  expect_equal(result$temperature, "linear")
  expect_equal(result$maxItems, c(5, 5, 5))
  expect_equal(result$setChains, 1L)
  expect_false(result$parallel)
})

test_that("sa_args items vector matches N_ITEMS", {
  result <- sa_args(mock_sa_input)
  expect_length(result$items, N_ITEMS)
  expect_equal(result$items[[1]], "x1")
  expect_equal(result$items[[N_ITEMS]], paste0("x", N_ITEMS))
})

# ---------------------------------------------------------------------------
# Tabu args
# ---------------------------------------------------------------------------

test_that("tabu_args returns NULL when inputs are missing", {
  expect_null(tabu_args(list()))
})

test_that("tabu_args returns a named list with all required keys", {
  result <- tabu_args(mock_tabu_input)
  expect_type(result, "list")
  expect_named(result, c(
    "numItems", "niter", "tabu.size", "lavaan.model.specs", "parallel"
  ), ignore.order = TRUE)
})

test_that("tabu_args maps input values correctly", {
  result <- tabu_args(mock_tabu_input)
  expect_equal(result$numItems, c(5, 5, 5))
  expect_equal(result$niter, 5)
  expect_equal(result$tabu.size, 5)
  expect_false(result$parallel)
})

test_that("tabu_args lavaan.model.specs has correct estimator", {
  result <- tabu_args(mock_tabu_input)
  expect_equal(result$lavaan.model.specs$estimator, "wlsmv")
  expect_true(result$lavaan.model.specs$ordered)
})

# ---------------------------------------------------------------------------
# Registry
# ---------------------------------------------------------------------------

test_that("registry_names returns all three algorithm names", {
  expect_setequal(
    registry_names(),
    c("Ant Colony Optimization", "Simulated Annealing", "Tabu Search")
  )
})

test_that("registry_ui returns a function for each algorithm", {
  for (algo in registry_names()) {
    expect_type(registry_ui(algo), "closure")
  }
})

test_that("registry_args returns a function for each algorithm", {
  for (algo in registry_names()) {
    expect_type(registry_args(algo), "closure")
  }
})

test_that("registry_ui errors on unknown algorithm", {
  expect_error(registry_ui("Not A Real Algorithm"), "Unknown algorithm")
})

test_that("registry_args errors on unknown algorithm", {
  expect_error(registry_args("Not A Real Algorithm"), "Unknown algorithm")
})
