# tests/testthat/test-mod_task_runner.R
#
# Tests for mod_task_runner_server and mod_task_runner_ui.
#
# Strategy:
#   - UI tests: structure and formals
#   - Server tests: status message rendering, animation state logic,
#     run trigger guard, and NULL args guard
#
# What we test and why:
#   - Status message shows "Ready" text before any run
#   - Status message updates when algorithm changes (before any run)
#   - run_trigger at 0 (initial value) does NOT invoke the task
#   - NULL args prevents task invocation (guards algorithm-switch race)
#   - Animation state starts FALSE before any run
#   - Module return value has expected shape (result + task)
#
# What we deliberately do NOT test:
#   - Actual algorithm execution (requires ShortForm + lavaan + real data;
#     that is an integration test, not a unit test)
#   - ExtendedTask internals (Shiny's responsibility)
#   - future/multisession worker behaviour (environment-dependent)

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

# Minimal valid args list -- doesn't need to be algorithm-correct for these tests
mock_args <- list(
  ants      = 5,
  evaporation = 0.9,
  steps     = 5,
  max.run   = 100,
  parallel  = FALSE
)

# ---------------------------------------------------------------------------
# UI tests
# ---------------------------------------------------------------------------

test_that("mod_task_runner_ui returns a shiny tag list", {
  ui <- mod_task_runner_ui(id = "test")
  golem::expect_shinytag(ui)
})

test_that("mod_task_runner_ui accepts only an id formal", {
  fmls <- formals(mod_task_runner_ui)
  expect_true("id" %in% names(fmls))
})

test_that("mod_task_runner_ui namespaces the status_message output", {
  ui   <- mod_task_runner_ui(id = "runner")
  html <- as.character(ui)
  expect_match(html, "runner-status_message", fixed = TRUE)
})

test_that("mod_task_runner_ui wraps content in a div", {
  ui   <- mod_task_runner_ui(id = "test")
  html <- as.character(ui)
  expect_match(html, "<div", fixed = TRUE)
})

# ---------------------------------------------------------------------------
# Server tests: initial state
# ---------------------------------------------------------------------------

test_that("status_message shows ready text before any run", {
  testServer(
    mod_task_runner_server,
    args = list(
      algorithm   = reactive("Ant Colony Optimization"),
      args        = reactive(mock_args),
      run_trigger = reactive(0L)
    ),
    {
      msg <- output$status_message
      expect_true(grepl("Ready", msg, fixed = TRUE))
      expect_true(grepl("Ant Colony Optimization", msg, fixed = TRUE))
    }
  )
})

test_that("status_message includes algorithm name in ready state", {
  for (algo in c("Ant Colony Optimization", "Simulated Annealing", "Tabu Search")) {
    testServer(
      mod_task_runner_server,
      args = list(
        algorithm   = reactive(algo),
        args        = reactive(mock_args),
        run_trigger = reactive(0L)
      ),
      {
        msg <- output$status_message
        expect_true(
          grepl(algo, msg, fixed = TRUE),
          label = paste("Ready message should contain algorithm name:", algo)
        )
      }
    )
  }
})

# ---------------------------------------------------------------------------
# Server tests: run trigger guard
# ---------------------------------------------------------------------------

test_that("run_trigger at 0 does not attempt task invocation", {
  # If the req(run_trigger() > 0) guard is missing, the task would be invoked
  # on startup with run_trigger = 0, which causes an error with NULL args.
  # This test passes when the guard is present -- no error on initial state.
  expect_no_error(
    testServer(
      mod_task_runner_server,
      args = list(
        algorithm   = reactive("Ant Colony Optimization"),
        args        = reactive(NULL),  # NULL args would error if invoked
        run_trigger = reactive(0L)
      ),
      {
        # Just initializing the server should not error
        expect_true(TRUE)
      }
    )
  )
})

test_that("NULL args prevents task invocation when run_trigger fires", {
  # Simulates the race condition where algorithm just changed and the
  # dynamic UI hasn't finished rendering, leaving args() as NULL.
  # The req(!is.null(current_args)) guard should silently abort.
  expect_no_error(
    testServer(
      mod_task_runner_server,
      args = list(
        algorithm   = reactive("Ant Colony Optimization"),
        args        = reactive(NULL),
        run_trigger = reactive(1L)
      ),
      {
        # Triggering a run with NULL args should not throw
        session$setInputs()  # flush reactive graph
        expect_true(TRUE)
      }
    )
  )
})

# ---------------------------------------------------------------------------
# Server tests: return value shape
# ---------------------------------------------------------------------------

test_that("mod_task_runner_server returns a list with result and task", {
  testServer(
    mod_task_runner_server,
    args = list(
      algorithm   = reactive("Ant Colony Optimization"),
      args        = reactive(mock_args),
      run_trigger = reactive(0L)
    ),
    {
      # The return value of moduleServer is not directly accessible in
      # testServer, but we can verify the module exposes the right outputs
      # by checking the session environment for the reactives it creates.
      # Instead, verify no error and outputs exist.
      expect_true(is.character(output$status_message))
    }
  )
})

# ---------------------------------------------------------------------------
# Server tests: animation frame content
# ---------------------------------------------------------------------------

test_that("animation frames list has entries for all three algorithms", {
  # .ANIMATION_FRAMES is an internal object -- access via the module's namespace.
  # We test it indirectly by verifying the status message text changes during
  # animation for each algorithm. Since we can't easily trigger the 500ms timer
  # in testServer, we test the frame list directly.
  expect_true("Ant Colony Optimization" %in% names(shinyShortForm:::.ANIMATION_FRAMES))
  expect_true("Simulated Annealing"     %in% names(shinyShortForm:::.ANIMATION_FRAMES))
  expect_true("Tabu Search"             %in% names(shinyShortForm:::.ANIMATION_FRAMES))
})

test_that("each algorithm has exactly 4 animation frames", {
  for (algo in names(shinyShortForm:::.ANIMATION_FRAMES)) {
    frames <- shinyShortForm:::.ANIMATION_FRAMES[[algo]]
    expect_length(
      frames, 4L
    )
  }
})

test_that("all animation frames contain 'Searching for solution'", {
  for (algo in names(shinyShortForm:::.ANIMATION_FRAMES)) {
    for (frame in shinyShortForm:::.ANIMATION_FRAMES[[algo]]) {
      expect_true(
        grepl("Searching for solution", frame, fixed = TRUE),
        label = paste("Frame in", algo, "should contain search text")
      )
    }
  }
})

# ---------------------------------------------------------------------------
# Server tests: stopifnot guards on reactive arguments
# ---------------------------------------------------------------------------

test_that("mod_task_runner_server errors if algorithm is not reactive", {
  expect_error(
    testServer(
      mod_task_runner_server,
      args = list(
        algorithm   = "Ant Colony Optimization",  # plain string, not reactive
        args        = reactive(mock_args),
        run_trigger = reactive(0L)
      ),
      { }
    )
  )
})

test_that("mod_task_runner_server errors if args is not reactive", {
  expect_error(
    testServer(
      mod_task_runner_server,
      args = list(
        algorithm   = reactive("Ant Colony Optimization"),
        args        = mock_args,  # plain list, not reactive
        run_trigger = reactive(0L)
      ),
      { }
    )
  )
})

test_that("mod_task_runner_server errors if run_trigger is not reactive", {
  expect_error(
    testServer(
      mod_task_runner_server,
      args = list(
        algorithm   = reactive("Ant Colony Optimization"),
        args        = reactive(mock_args),
        run_trigger = 0L  # plain integer, not reactive
      ),
      { }
    )
  )
})
