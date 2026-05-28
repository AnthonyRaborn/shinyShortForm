#' R/mod_data_upload.R
#' 
#' Module: Data Upload
#' 
#' Owns the mod_data_upload_ui and mod_data_upload_server 
#' modules, which handle data upload and verification for
#' using the ShortForm algorithms within the app.
#' 
#' data_upload UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList
mod_data_upload_ui <- function(id) {
  ns <- NS(id)
  tagList(
    fileInput(
      ns("upload"),
      "Upload Dataset (.csv, .dat, .rds, .xlsx)",
      accept = c(".csv", ".dat", ".rds", ".xlsx")
    ) 
  )
}
    
#' data_upload Server Functions
#'
#' @noRd 
#'  
#' @importFrom readr read_csv read_delim
#' @importFrom readxl read_xlsx
mod_data_upload_server <- function(id){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    # Reactive value to store the dataset
    user_data <- reactiveVal(NULL)
    
    # Initialize pipeline reactive value
    pipeline <- reactiveVal(character(0))
    
    # Store original filename
    original_filename <- reactiveVal("")
    
    # Load dataset
    observeEvent(input$upload, {
      req(input$upload)
      
      ext <- tolower(tools::file_ext(input$upload$name))
      original_filename(input$upload$name)
      
      df <- tryCatch({
        if (ext == "csv") {
          result <- readr::read_csv(input$upload$datapath)
          pipeline(c(
            "# Load data",
            paste0('df <- readr::read_csv("', input$upload$name, '")')
          ))
          result
        } else if (ext %in% c("dat")) {
          result <- readr::read_delim(input$upload$datapath)
          pipeline(c(
            "# Load data",
            paste0('df <- readr::read_delim("', input$upload$name, '")')
          ))
          result
        } else if (ext %in% c("rds")) {
          result <- base::readRDS(input$upload$datapath)
          pipeline(c(
            "# Load data",
            paste0('df <- base::readRDS("', input$upload$name, '")')
          ))
          result
        } else if (ext == "xlsx") {
          result <- readxl::read_xlsx(input$upload$datapath)
          pipeline(c(
            "# Load data",
            paste0('df <- readxl::read_xlsx("', input$upload$name, '")')
          ))
          result
        }
      }, error = function(e) {
        showNotification(paste("Error loading file:", e$message), type = "error")
        NULL
      })
      
      if (!is.null(df)) {
        # Ensure it's a data frame
        if (!is.data.frame(df)) {
          df <- tryCatch({
            as.data.frame(df)
          }, error = function(e) {
            showNotification("Could not convert to data frame", type = "error")
            return(NULL)
          })
        }
        # Ensure it has more than 0 rows
        if (nrow(df) == 0) {
          showNotification("Data has no observations! Check your file and try again.", type = "error")
          return(null)
        }
        
        if (!is.null(df)) {
          user_data(df)
          showNotification(paste0("Data loaded successfully with ", nrow(df), "rows and ", ncol(df), "columns."), type = "message")
        }
      }
    })
  return(
    list(
      user_data = user_data,
      pipeline = pipeline,
      original_filename = original_filename
    )
    )
  })
}
    
## To be copied in the UI
# mod_data_upload_ui("data_upload_1")
    
## To be copied in the server
# mod_data_upload_server("data_upload_1")
