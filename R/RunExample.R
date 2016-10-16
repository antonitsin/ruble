#' Example of rent_or_buy computation
#' Runs the simulation on whats better: renting or buying
#' @keywords arith
#' @export

runExample <- function() {
  appDir <- system.file("shiny-examples", "rent_or_buy", package = "Ruble")
  if (appDir == "") {
    stop("Could not find example directory. Try re-installing `mypackage`.", call. = FALSE)
  }
  
  shiny::runApp(appDir, display.mode = "normal")
}
