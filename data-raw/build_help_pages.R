# data-raw/build_help_pages.R
# must be run manually

build_shortform_help <- function(functions = NULL) {
  out_dir <- here::here("inst/app/www/help")
  dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
  
  pkg_path <- find.package("ShortForm")
  db_path <- file.path(pkg_path, "help", "ShortForm")  # no extension
  
  rd_db <- tools:::fetchRdDB(db_path)
  
  names_to_build <- if (!is.null(functions)) {
    intersect(names(rd_db), functions)
  } else {
    names(rd_db)
  }
  
  purrr::walk(names_to_build, function(nm) {
    out_file <- file.path(out_dir, paste0(nm, ".html"))
    tryCatch({
      tools::Rd2HTML(rd_db[[nm]], out = out_file, package = "ShortForm")
      message("Built: ", nm)
    }, error = function(e) warning("Failed on ", nm, ": ", e$message))
  })
}

build_shortform_help(
  functions = c("tabuShortForm", "antcolony.lavaan", "simulatedAnnealing")  # or NULL for all
)
