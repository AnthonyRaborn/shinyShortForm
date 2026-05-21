#' results UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_results_ui <- function(id) {
  ns <- NS(id)
  tagList(
 
  )
}
    
#' results Server Functions
#'
#' @noRd 
mod_results_server <- function(id){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_results_ui("results_1")
    
## To be copied in the server
# mod_results_server("results_1")
