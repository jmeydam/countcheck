#' Return data frame combining data and results
#'
#' Constructs data frame with these fields:
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
#' \item \emph{fe_true_theta}:   factor \emph{f}, with observed y_new
#'                                 exceeding true-theta UCL by
#'                                 \emph{f * sd(y_new)},
#'                                 given n_new and true value of theta
#'                                 (if known)
#' \item \emph{fe_nopool}:       factor \emph{f}, with observed y_new
#'                                 exceeding no-pooling UCL by
#'                                 \emph{f * sd(y_new)},
#'                                 given n_new and no-pooling estimate
#'                                 of theta
#' \item \emph{fe_complpool}:    factor \emph{f}, with observed y_new
#'                                 exceeding complete-pooling UCL by
#'                                 \emph{f * sd(y_new)},
#'                                 given n_new and complete-pooling estimate
#'                                 of theta
#' \item \emph{fe_partpool}:     factor \emph{f}, with observed y_new
#'                                 exceeding partial-pooling UCL by
#'                                 \emph{f * sd(y_new)},
#'                                 given n_new and partial-pooling estimate
#'                                 of theta
#' }
#' If data is provided via parameters, vectors must be of equal length,
#' with length >= 3. If \emph{unit} is NULL, all data vectors passed
#' to this function are ignored, and the complete data set is generated
#' in a simulation run.
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
#' @param random_seed Seed value (default: 200731) - used in simulation and
#'   by Stan
#' @param factor_sd Factor multiplying standard deviation (default: 3) - used
#'   in calculation of UCLs
#' @return Data frame with all columns populated
countcheck <- function(unit = NULL,
                       n = NULL,
                       y = NULL,
                       n_new = NULL,
                       y_new = NULL,
                       true_theta = NULL,
                       random_seed = 200731,
                       factor_sd = 3) {

  # If unit is NULL, all data vectors passed to function are ignored,
  # and simulation is used to generate data
  simulation <- is.null(unit)

  if (simulation) {
    # Simulate data for use in examples, demos, ...
    d <- simulate_data(units = 1000, random_seed = random_seed)
  } else {
    # Use data passed to function
    # (length of vectors must match and data must be reasonable,
    # otherwise initialize() will abort)
    d <- initialize(unit = unit,
                    n = n,
                    y = y,
                    n_new = n_new,
                    y_new = y_new,
                    true_theta = true_theta)
  }

  # Add no-pooling estimate of theta to data frame
  d <- add_theta_nopool(d)

  # Add complete-pooling estimate of theta to data frame
  d <- add_theta_complpool(d)

  # Add partial-pooling estimate of theta to data frame
  # (based on Bayesian hierarchical model)
  d <- add_theta_partpool(d, random_seed = random_seed)

  # Add "true" UCL to data frame
  d <- add_ucl_true_theta(d, factor_sd = factor_sd)

  # Add no-pooling UCL to data frame
  d <- add_ucl_nopool(d, factor_sd = factor_sd)

  # Add complete-pooling UCL to data frame
  d <- add_ucl_complpool(d, factor_sd = factor_sd)

  # Add partial-pooling UCL to data frame
  # (based on Bayesian hierarchical model)
  d <- add_ucl_partpool(d, factor_sd = factor_sd)

  # Add fe (factor_exceeding) based on "true" UCL to data frame
  d <- add_fe_true_theta(d)

  # Add fe (factor_exceeding) based on no-pooling UCL to data frame
  d <- add_fe_nopool(d)

  # Add fe (factor_exceeding) based on complete-pooling UCL to data frame
  d <- add_fe_complpool(d)

  # Add fe (factor_exceeding) based on partial-pooling UCL to data frame
  d <- add_fe_partpool(d)

  d
}
