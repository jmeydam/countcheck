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

  units <- length(n)

  # Optional: true_theta
  if (is.null(true_theta)) {
    true_theta <- rep(NA, units)
  }

  data.frame(
    unit = 1:units,
    n = n,
    y = y,
    n_new = n_new,
    y_new = y_new,
    true_theta = true_theta,
    theta_nopool = rep(NA, units),
    theta_complpool = rep(NA, units),
    theta_partpool = rep(NA, units),
    ucl_true_theta = rep(NA, units),
    ucl_nopool = rep(NA, units),
    ucl_complpool = rep(NA, units),
    ucl_partpool = rep(NA, units)
  )

}
