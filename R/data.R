# str(d)
# example_01 <- d[, c("unit", "n", "y", "n_new", "y_new")]
# usethis::use_data(example_01)

#' Simulated data without anomalies
#'
#' The first five columns of data frame created with
#' countcheck(random_seed = 200807)
#'
#' @format A data frame with 1000 rows and 5 variables:
#' \describe{
#' \item{unit}{ID for unit}
#' \item{n}{previous reference count values (measure of exposure)}
#' \item{y}{previous count values of interest}
#' \item{n_new}{new reference count values (measure of exposure)}
#' \item{y_new}{new count values of interest}
#' }
"example_01"
