#' Calculate upper control limit (UCL)
#'
#' Basic formula for UCL:
#' \emph{estimated mean + 3 * estimated standard deviation}
#'
#' In this case, assuming a Poisson distribution, both the estimated mean
#' and the estimated variance are
#' \emph{lambda_hat = theta_hat * n_new}.
#'
#' Rounds the result to the nearest integer.
#'
#' Adds 0.5, so that count values are either above or below the UCL
#' (as in Wheeler & Chambers [1992]).
#'
#' @export
#' @param theta_hat Estimate (unless known) of rate parameter \emph{theta}
#' @param n_new New value for exposure (reference counts), must at least be 1
#' @param factor_sd Factor multiplying standard deviation (default: 3)
#' @return UCLs
ucl <- function(theta_hat, n_new, factor_sd = 3) {
  # check arguments
  stopifnot(
    # theta_hat must be non-negative or NA
    sum(theta_hat < 0) == 0 | sum(! is.na(theta_hat)) == 0,
    # n_new must be 1 or greater
    sum(n_new < 1) == 0,
    # theta_hat and n_new must be vectors of same length
    length(theta_hat) == length(n_new),
    # factor_sd must be non-negative
    factor_sd >= 0
  )
  lambda_hat <- theta_hat * n_new
  # Parameter lambda is both mean and variance of Poisson distribution
  round(lambda_hat + factor_sd * sqrt(lambda_hat)) + 0.5
}

#' Calculate by how many standard deviations \emph{y_new} exceeds upper
#' control limit (UCL)
#'
#' Calculates factor \emph{f}, with observed \emph{y_new} exceeding UCL by
#' \emph{f * sd(y_new)}. Returns negative value if observed \emph{y_new}
#' is lower than \emph{ucl}. Returns Inf if \emph{theta_hat} is 0.
#'
#' Assuming a Poisson distribution with
#' \emph{lambda_hat = theta_hat * n_new},
#' the estimated standard deviation of \emph{y_new}
#' is \emph{sqrt(lambda_hat)}.
#'
#' @export
#' @param theta_hat Estimate (unless known) of rate parameter \emph{theta}
#' @param n_new New value for exposure (reference counts), must at least be 1
#' @param y_new New count values of interest
#' @param ucl Upper control limit (UCL), must be greater than 0
#' @return Factor \emph{f}, with observed \emph{y_new} exceeding UCL by
#'   \emph{f * sd(y_new)}
factor_exceeding <- function(theta_hat, n_new, y_new, ucl) {
  # check arguments
  stopifnot(
    # theta_hat must be non-negative or NA
    sum(theta_hat < 0) == 0 | sum(! is.na(theta_hat)) == 0,
    # n_new must be 1 or greater
    sum(n_new < 1) == 0,
    # y_new must be non-negative
    sum(y_new < 0) == 0,
    # ucl must be greater than 0 or NA
    sum(ucl <= 0) == 0 | sum(! is.na(ucl)) == 0,
    # theta_hat and n_new must be vectors of same length
    length(theta_hat) == length(n_new),
    # y_new and n_new must be vectors of same length
    length(y_new) == length(n_new),
    # ucl and n_new must be vectors of same length
    length(ucl) == length(n_new)
  )
  lambda_hat <- theta_hat * n_new
  # Parameter lambda is both mean and variance of Poisson distribution
  sd_hat <- sqrt(lambda_hat)
  ifelse(sd_hat > 0,
         (y_new - ucl) / sd_hat,
         Inf)
}

#' Add "true" UCL to data frame
#'
#' Adds UCL based on \emph{n_new} and true value of \emph{theta} to
#' data frame.
#'
#' @keywords internal
#' @param d Initialized data frame
#' @param factor_sd Factor multiplying standard deviation (default: 3)
#' @return Data frame with values for \emph{ucl_true_theta}
add_ucl_true_theta <- function(d, factor_sd = 3) {
  d$ucl_true_theta <- ucl(d$true_theta, d$n_new, factor_sd)
  d
}

#' Add no-pooling UCL to data frame
#'
#' Adds UCL based on \emph{n_new} and no-pooling estimate of \emph{theta}
#' to data frame.
#'
#' @keywords internal
#' @param d Initialized data frame
#' @param factor_sd Factor multiplying standard deviation (default: 3)
#' @return Data frame with values for \emph{ucl_nopool}
add_ucl_nopool <- function(d, factor_sd = 3) {
  d$ucl_nopool <- ucl(d$theta_nopool, d$n_new, factor_sd)
  d
}

#' Add complete-pooling UCL to data frame
#'
#' Adds UCL based on \emph{n_new} and complete-pooling estimate of \emph{theta}
#' to data frame.
#'
#' @keywords internal
#' @param d Initialized data frame
#' @param factor_sd Factor multiplying standard deviation (default: 3)
#' @return Data frame with values for \emph{ucl_complpool}
add_ucl_complpool <- function(d, factor_sd = 3) {
  d$ucl_complpool <- ucl(d$theta_complpool, d$n_new, factor_sd)
  d
}

#' Add partial-pooling UCL to data frame
#'
#' Adds UCL based on \emph{n_new} and partial-pooling estimate of \emph{theta}
#' to data frame.
#'
#' @keywords internal
#' @param d Initialized data frame
#' @param factor_sd Factor multiplying standard deviation (default: 3)
#' @return Data frame with values for \emph{ucl_partpool}
add_ucl_partpool <- function(d, factor_sd = 3) {
  d$ucl_partpool <- ucl(d$theta_partpool, d$n_new, factor_sd)
  d
}

#' Add fe (factor_exceeding) based on "true" UCL to data frame
#'
#' Adds fe (factor_exceeding) based on true UCL to data frame, given
#' \emph{n_new} and true value of \emph{theta}.
#'
#' \emph{fe_true_theta}: factor \emph{f}, with observed \emph{y_new}
#' exceeding true-theta UCL by \emph{f * sd(y_new)},
#' given \emph{n_new} and true value of \emph{theta} (if known)
#'
#' @keywords internal
#' @param d Initialized data frame with UCLs
#' @return Data frame with values for \emph{fe_true_theta}
add_fe_true_theta <- function(d) {
  d$fe_true_theta <- factor_exceeding(
    theta_hat = d$true_theta,
    n_new = d$n_new,
    y_new = d$y_new,
    ucl = d$ucl_true_theta
  )
  d
}

#' Add fe (factor_exceeding) based on no-pooling UCL to data frame
#'
#' Adds fe (factor_exceeding) based on no-pooling UCL to data frame, given
#' \emph{n_new} and no-pooling estimate of \emph{theta}.
#'
#' \emph{fe_nopool}: factor \emph{f}, with observed \emph{y_new}
#' exceeding no-pooling UCL by \emph{f * sd(y_new)},
#' given \emph{n_new} and no-pooling estimate of \emph{theta}
#'
#' @keywords internal
#' @param d Initialized data frame with UCLs
#' @return Data frame with values for \emph{fe_nopool}
add_fe_nopool <- function(d) {
  d$fe_nopool <- factor_exceeding(
    theta_hat = d$theta_nopool,
    n_new = d$n_new,
    y_new = d$y_new,
    ucl = d$ucl_nopool
  )
  d
}

#' Add fe (factor_exceeding) based on complete-pooling UCL to data frame
#'
#' Adds fe (factor_exceeding) based on complete-pooling UCL to data frame,
#' given \emph{n_new} and complete-pooling estimate of \emph{theta}.
#'
#' \emph{fe_complpool}: factor \emph{f}, with observed \emph{y_new}
#' exceeding complete-pooling UCL by \emph{f * sd(y_new)},
#' given \emph{n_new} and complete-pooling estimate of \emph{theta}
#'
#' @keywords internal
#' @param d Initialized data frame with UCLs
#' @return Data frame with values for \emph{fe_complpool}
add_fe_complpool <- function(d) {
  d$fe_complpool <- factor_exceeding(
    theta_hat = d$theta_complpool,
    n_new = d$n_new,
    y_new = d$y_new,
    ucl = d$ucl_complpool
  )
  d
}

#' Add fe (factor_exceeding) based on partial-pooling UCL to data frame
#'
#' Adds fe (factor_exceeding) based on partial-pooling UCL to data frame,
#' given \emph{n_new} and partial-pooling estimate of \emph{theta}.
#'
#' \emph{fe_partpool}: factor \emph{f}, with observed \emph{y_new}
#' exceeding partial-pooling UCL by \emph{f * sd(y_new)},
#' given \emph{n_new} and partial-pooling estimate of \emph{theta}
#'
#' @keywords internal
#' @param d Initialized data frame with UCLs
#' @return Data frame with values for \emph{fe_partpool}
add_fe_partpool <- function(d) {
  d$fe_partpool <- factor_exceeding(
    theta_hat = d$theta_partpool,
    n_new = d$n_new,
    y_new = d$y_new,
    ucl = d$ucl_partpool
  )
  d
}
