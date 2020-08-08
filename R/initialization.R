#' Initialize data frame
#'
#' Construct data frame with these fields:
#' \itemize{
#' \item \emph{unit}:            ID for unit
#' \item \emph{n}:               previous reference count values (measure of
#'                                 exposure), must at least be 1
#' \item \emph{y}:               previous count values of interest
#' \item \emph{n_new}:           new reference count values (measure of
#'                                 exposure), must at least be 1
#' \item \emph{y_new}:           new count values of interest
#' \item \emph{true_theta}:      true value of theta (if known)
#' \item \emph{theta_nopool}:    no-pooling estimate of theta
#' \item \emph{theta_complpool}: complete-pooling estimate of theta
#' \item \emph{theta_partpool}:  partial-pooling estimate of theta
#' \item \emph{ucl_true_theta}:  UCL based on n_new and true value of theta
#'                                 (if known)
#' \item \emph{ucl_nopool}:      UCL based on n_new and no-pooling estimate
#'                                 of theta
#' \item \emph{ucl_complpool}:   UCL based on n_new and complete-pooling
#'                                 estimate of theta
#' \item \emph{ucl_partpool}:    UCL based on n_new and partial-pooling
#'                                 estimate of theta
#' }
#' Input vectors must be of equal length, with length >= 3.
#' \emph{unit}, \emph{n}, \emph{y}, \emph{n_new}, \emph{y_new},
#' and \emph{true_theta} (if known) are initialized using the
#' corresponding parameters. The other fields (and \emph{true_theta},
#' if not known) are initialized with NA.
#'
#' @export
#' @param unit ID for unit
#' @param n Previous reference count values (measure of exposure),
#'   must at least be 1
#' @param y Previous count values of interest
#' @param n_new New reference count values (measure of exposure),
#'   must at least be 1
#' @param y_new New count values of interest
#' @param true_theta True value of theta (if known; optional)
#' @return Initialized data frame
initialize <- function(unit, n, y, n_new, y_new, true_theta = NULL) {

  # check arguments
  stopifnot(
    # length of unit >= 3
    length(unit) >= 3,
    # length of mandatory arguments is the same
    length(n) == length(unit),
    length(y) == length(unit),
    length(n_new) == length(unit),
    length(y_new) == length(unit),
    # length of optional argument, if present, is the same
    ifelse(is.null(true_theta),
           length(unit),
           length(true_theta)) == length(unit),
    # IDs are integers
    unit == as.integer(unit),
    # counts are integers
    n == as.integer(n),
    y == as.integer(y),
    n_new == as.integer(n_new),
    y_new == as.integer(y_new),
    # n must be 1 or greater
    sum(n < 1) == 0,
    # y must be non-negative
    sum(y < 0) == 0,
    # n_new must be 1 or greater
    sum(n_new < 1) == 0,
    # y_new must be non-negative
    sum(y_new < 0) == 0,
    # true_theta, if present, is numeric
    ifelse(is.null(true_theta),
           TRUE,
           is.numeric(true_theta))
  )

  units <- length(unit)
  # Optional: true_theta
  if (is.null(true_theta)) {
    true_theta <- rep(NA, units)
  }

  data.frame(
    unit = as.integer(unit),
    n = as.integer(n),
    y = as.integer(y),
    n_new = as.integer(n_new),
    y_new = as.integer(y_new),
    true_theta = as.numeric(true_theta),
    theta_nopool = as.numeric(rep(NA, units)),
    theta_complpool = as.numeric(rep(NA, units)),
    theta_partpool = as.numeric(rep(NA, units)),
    ucl_true_theta = as.numeric(rep(NA, units)),
    ucl_nopool = as.numeric(rep(NA, units)),
    ucl_complpool = as.numeric(rep(NA, units)),
    ucl_partpool = as.numeric(rep(NA, units))
  )

}
