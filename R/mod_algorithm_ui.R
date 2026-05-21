#' algorithm_ui UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_algorithm_ui_ui <- function(id) {
  ns <- NS(id)
  tagList(
 
  )
}
    
#' algorithm_ui Server Functions
#'
#' @noRd 
mod_algorithm_ui_server <- function(id){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_algorithm_ui_ui("algorithm_ui_1")
    
## To be copied in the server
# mod_algorithm_ui_server("algorithm_ui_1")
