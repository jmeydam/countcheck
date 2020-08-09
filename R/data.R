# str(d)
# example_01 <- d[, c("unit", "n", "y", "n_new", "y_new")]
# usethis::use_data(example_01)

#' Simulated data without anomalies
#'
#' The first five columns of data frame created with
#' countcheck(random_seed = 200807)
#'
#' @format A data frame with 1000 rows and 5 variables:
#' \itemize{
#' \item \emph{unit}:            ID for unit
#' \item \emph{n}:               previous reference count values (measure of
#'                                 exposure), must at least be 1
#' \item \emph{y}:               previous count values of interest
#' \item \emph{n_new}:           new reference count values (measure of
#'                                 exposure), must at least be 1
#' \item \emph{y_new}:           new count values of interest
#' }
"example_01"
