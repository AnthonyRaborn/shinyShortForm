#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  observeEvent(input$dark_mode, {
    new_theme <- if (input$dark_mode == "light") {
      bslib::bs_theme() |> 
        bslib::bs_add_rules(sass::sass_file(app_sys("app/www/theme-light.scss")))
    } else {
      bslib::bs_theme() |> 
        bslib::bs_add_rules(sass::sass_file(app_sys("app/www/theme-dark.scss")))
    }
    session$setCurrentTheme(new_theme)
  })
  
  mod_demo_server("demo")
  mod_data_upload_server("your_data")
}
