# d <- countcheck(random_seed = 200807)
# str(d)
# simdat <- d[, c("unit", "n", "y", "n_new", "y_new", "true_theta")]
# usethis::use_data(simdat, overwrite = TRUE)

#' Simulated data without anomalies
#'
#' The first six columns of data frame created with
#' \emph{countcheck(random_seed = 200807)}
#'
#' @format A data frame with 1000 rows and 6 variables:
#' \itemize{
#' \item \emph{unit}:            ID for unit
#' \item \emph{n}:               previous reference count values (measure of
#'                                 exposure), must at least be 1
#' \item \emph{y}:               previous count values of interest
#' \item \emph{n_new}:           new reference count values (measure of
#'                                 exposure), must at least be 1
#' \item \emph{y_new}:           new count values of interest
#' \item \emph{true_theta}:      true value of theta (if known)
#' }
"simdat"
