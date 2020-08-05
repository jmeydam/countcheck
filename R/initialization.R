#' Initialize data frame
#'
#' Construct data frame with these fields:
#' \itemize{
#' \item \emph{unit}:            index for unit
#' \item \emph{n}:               previous reference count values
#'                               (measure of exposure)
#' \item \emph{y}:               previous count values of interest
#' \item \emph{n_new}:           new reference count values
#' \item \emph{y_new}:           new count values of interest
#' \item \emph{true_theta}:      true value of theta (if known)
#' \item \emph{theta_nopool}:    no-pooling estimate of theta
#' \item \emph{theta_complpool}: complete-pooling estimate of theta
#' \item \emph{theta_partpool}:  partial-pooling estimate of theta
#' \item \emph{ucl_true_theta}:  UCL based on n_new and true value of theta
#'                               (if known)
#' \item \emph{ucl_nopool}:      UCL based on n_new and no-pooling estimate
#'                               of theta
#' \item \emph{ucl_complpool}:   UCL based on n_new and complete-pooling
#'                               estimate of theta
#' \item \emph{ucl_partpool}:    UCL based on n_new and partial-pooling
#'                               estimate of theta
#' }
#' Input vectors must be of equal length, with length >= 3.
#' \emph{unit} is initialized based on the length of \code{n}.
#' \emph{n}, \emph{y}, \emph{n_new}, \emph{y_new}, and \emph{true_theta}
#' (if known) are initialized using the corresponding parameters.
#' The other fields are initialized with NA.
#'
#' @param n Previous reference count values (measure of exposure)
#' @param y Previous count values of interest
#' @param n_new New reference count values
#' @param y_new New count values of interest
#' @param true_theta True value of theta (if known; optional)
#' @return Initialized data frame
initialize <- function(n, y, n_new, y_new, true_theta = NULL) {

  # check arguments
  stopifnot(
    # length of n >= 3
    length(n) >= 3,
    # length of mandatory arguments is the same
    length(y) == length(n),
    length(n_new) == length(n),
    length(y_new) == length(n),
    # length of optional argument, if present, is the same
    ifelse(is.null(true_theta), length(n), length(true_theta)) == length(n),
    # counts are integers
    n == as.integer(n),
    y == as.integer(y),
    n_new == as.integer(n_new),
    y_new == as.integer(y_new),
    # true_theta, if present, is numeric
    ifelse(is.null(true_theta), TRUE, is.numeric(true_theta))
  )

  units <- length(n)

  # Optional: true_theta
  if (is.null(true_theta)) {
    true_theta <- rep(NA, units)
  }

  data.frame(
    unit = 1:units,
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
