#' Calculate upper control limit (UCL)
#'
#' Basic formula for UCL:
#' \eqn{estimated mean + 3 * estimated standard deviation}
#'
#' In this case, assuming a Poisson distribution, both the estimated mean
#' and the estimated variance are
#' \deqn{lambda_hat = theta_hat * n_new}
#'
#' Rounds the result to the nearest integer.
#'
#' Adds 0.5, so that count values are either above or below the UCL
#' (as in Wheeler & Chambers [1992]).
#'
#' @export
#' @param theta_hat Estimate (unless known) of rate parameter \emph{theta}
#' @param n_new New value for exposure (reference counts)
#' @param factor_sd Factor multiplying standard deviation (default: 3)
#' @return UCLs
ucl <- function(theta_hat, n_new, factor_sd = 3) {
  lambda_hat <- theta_hat * n_new
  # Parameter lambda is both mean and variance of Poisson distribution
  round(lambda_hat + factor_sd * sqrt(lambda_hat)) + 0.5
}

#' Calculate by how many standard deviations y_new exceeds upper
#' control limit (UCL)
#'
#' Calculates factor \emph{e}, with observed \emph{y_new} exceeding UCL by
#'   \eqn{e * sd(y_new)}.
#'
#' Assuming a Poisson distribution with
#' \deqn{lambda_hat = theta_hat * n_new}
#' the estimated standard deviation of \emph{y_new}
#' is
#' \deqn{sqrt(lambda_hat)}
#'
#' @export
#' @param theta_hat Estimate (unless known) of rate parameter \emph{theta}
#' @param n_new New value for exposure (reference counts)
#' @param y_new New count values of interest
#' @param ucl Upper control limit (UCL)
#' @return Factor \emph{e}, with observed \emph{y_new} exceeding UCL by
#'   \eqn{e * sd(y_new)}
factor_exceeding <- function(theta_hat, n_new, y_new, ucl) {
  lambda_hat <- theta_hat * n_new
  # Parameter lambda is both mean and variance of Poisson distribution
  sd_hat <- sqrt(lambda_hat)
  ifelse(sd_hat > 0,
         (y_new - ucl) / sd_hat,
         Inf)
}

#' Add "true" UCL to data frame
#'
#' Add UCL based on \emph{n_new} and true value of \emph{theta} to
#' data frame.
#'
#' @export
#' @param d Initialized data frame
#' @param factor_sd Factor multiplying standard deviation (default: 3)
#' @return Data frame with values for \emph{ucl_true_theta}
add_ucl_true_theta <- function(d, factor_sd = 3) {
  d$ucl_true_theta <- ucl(d$true_theta, d$n_new, factor_sd)
  d
}

#' Add no-pooling UCL to data frame
#'
#' Add UCL based on \emph{n_new} and no-pooling estimate of \emph{theta}
#' to data frame.
#'
#' @export
#' @param d Initialized data frame
#' @param factor_sd Factor multiplying standard deviation (default: 3)
#' @return Data frame with values for \emph{ucl_nopool}
add_ucl_nopool <- function(d, factor_sd = 3) {
  d$ucl_nopool <- ucl(d$theta_nopool, d$n_new, factor_sd)
  d
}

#' Add complete-pooling UCL to data frame
#'
#' Add UCL based on \emph{n_new} and complete-pooling estimate of \emph{theta}
#' to data frame.
#'
#' @export
#' @param d Initialized data frame
#' @param factor_sd Factor multiplying standard deviation (default: 3)
#' @return Data frame with values for \emph{ucl_complpool}
add_ucl_complpool <- function(d, factor_sd = 3) {
  d$ucl_complpool <- ucl(d$theta_complpool, d$n_new, factor_sd)
  d
}

#' Add partial-pooling UCL to data frame
#'
#' Add UCL based on \emph{n_new} and partial-pooling estimate of \emph{theta}
#' to data frame.
#'
#' @export
#' @param d Initialized data frame
#' @param factor_sd Factor multiplying standard deviation (default: 3)
#' @return Data frame with values for \emph{ucl_partpool}
add_ucl_partpool <- function(d, factor_sd = 3) {
  d$ucl_partpool <- ucl(d$theta_partpool, d$n_new, factor_sd)
  d
}
