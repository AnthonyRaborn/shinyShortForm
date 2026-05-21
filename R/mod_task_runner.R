#' task_runner UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_task_runner_ui <- function(id) {
  ns <- NS(id)
  tagList(
 
  )
}
    
#' task_runner Server Functions
#'
#' @noRd 
mod_task_runner_server <- function(id){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_task_runner_ui("task_runner_1")
    
## To be copied in the server
# mod_task_runner_server("task_runner_1")
