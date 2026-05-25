# R/app_ui.R
#
# Top-level UI function.
# Called by golem::run_app() via inst/app/app.R.
#
# Add new pages here as bslib::nav_panel() entries.
# Each page delegates entirely to its own mod_*_ui() function.

#' @import shiny
#' @import bslib
#' @noRd
app_ui <- function(request) {
  tagList(
    # golem external resources (favicon, custom CSS/JS if any)
    golem_add_external_resources(),

    bslib::page_navbar(
      title  = "shinyShortForm",
      id     = "navbar",
      theme  = bslib::bs_theme(
        version   = 5,
        bootswatch = "flatly"
      ),
      window_title = "shinyShortForm",

      # -- Pages -----------------------------------------------------------

      bslib::nav_panel(
        title = "Demo",
        icon  = shiny::icon("flask"),
        mod_demo_ui("demo")
      ),

      # Placeholder panels -- uncomment and build as you go
      # bslib::nav_panel(
      #   title = "Your Data",
      #   icon  = shiny::icon("upload"),
      #   mod_your_data_ui("your_data")
      # ),

      # -- Right-side nav items --------------------------------------------
      bslib::nav_spacer(),

      bslib::nav_item(
        tags$a(
          href   = "https://github.com/AnthonyRaborn/shinyShortForm",
          target = "_blank",
          rel    = "noopener noreferrer",
          shiny::icon("github"),
          "Source"
        )
      ),

      bslib::nav_item(
        tags$a(
          href   = "https://cran.r-project.org/package=ShortForm",
          target = "_blank",
          rel    = "noopener noreferrer",
          shiny::icon("box-open"),
          "ShortForm on CRAN"
        )
      )
    )
  )
}

#' Add External Resources to the UI
#'
#' @import shiny
#' @noRd
golem_add_external_resources <- function() {
  addResourcePath(
    "www",
    app_sys("app/www")
  )
  tags$head(
    golem::favicon(),
    golem::bundle_resources(
      path = app_sys("app/www"),
      app_title = "shinyShortForm"
    )
  )
}
