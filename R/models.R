#' No-pooling model
#'
#' For the no-pooling model we estimate \emph{theta_i} using only the observed
#' counts of observational unit \emph{i}. For each unit \emph{i} our no-pooling
#' estimate of \emph{theta_i} is the ratio of the observed count values of
#' interest \emph{y_i} to the reference count values \emph{n_i}.
#'
#' @export
#' @param n Previous reference count values (measure of exposure),
#'   must at least be 1
#' @param y Previous count values of interest
#' @return No-pooling estimates of \emph{theta}
theta_nopool <- function(n, y) {
  # check arguments
  stopifnot(
    # denominator must not be 0
    # n must be 1 or greater
    sum(n < 1) == 0,
    # y must be non-negative
    sum(y < 0) == 0,
    # n and y must be vectors of same length
    length(n) == length(y)
  )
  y / n
}

#' Complete-pooling model
#'
#' For the complete-pooling model we consider \emph{theta_i} to be the same
#' for all observational units. We assume that observed data can be
#' treated as coming from a homogeneous source. For all units \emph{i} our
#' complete-pooling estimate of \emph{theta_i} is the ratio of the sum of
#' the observed count values of interest \emph{y_i} to the sum of the
#' reference count values \emph{n_i}.
#'
#' @export
#' @param n Previous reference count values (measure of exposure),
#'   must at least be 1
#' @param y Previous count values of interest
#' @return Complete-pooling estimates of \emph{theta}
theta_complpool <- function(n, y) {
  # check arguments
  stopifnot(
    # n must be 1 or greater
    # (then always sum(n) > 0, so denominator cannot be 0)
    sum(n < 1) == 0,
    # y must be non-negative
    sum(y < 0) == 0,
    # n and y must be vectors of same length
    length(n) == length(y)
  )
  rep(sum(y) / sum(n), length(n))
}

#' Partial-pooling model (Bayesian hierarchical model)
#'
#' The partial-pooling model can be seen as a compromise between the extremes
#' of the no-pooling and partial-pooling models. We do not treat all observed
#' data as coming from a homogeneous source, but we do assume that information
#' on other units can be useful for estimating \emph{theta_i} of a particular
#' unit \emph{i}, especially when there is little information for a particular
#' unit \emph{i}.
#'
#' The partial-pooling model uses a hierarchical structure of probability
#' distributions. We will use the same types of distributions for this model
#' that we used for simulating the data.
#'
#' In particular, we assume that each observational unit \emph{i} has a Poisson
#' distribution with parameter \emph{lambda_i}. \emph{lambda_i} is a product of
#' a rate parameter \emph{theta_i} and the exposure \emph{n_i}.
#'
#' We use a half-normal distribution with a parameter \emph{alpha} for the rate
#' parameters \emph{theta_i}. This time, \emph{alpha} itself is also assumed to
#' have a probability distribution. We choose a half-normal distribution with
#' a parameter \emph{beta}. By default, \emph{beta} is set to 0.376, so that the
#' expected value of \emph{alpha} is 0.3.
#'
#' Note that when simulating the data we set \emph{alpha} to 0.05. The "true"
#' value of \emph{alpha} is substantially lower than the default value
#' initially assumed by our model.
#'
#' Given data in the form of reference counts \emph{n_i} (exposure) and count
#' values of interest \emph{y_i}, our model will allow us to determine a
#' posterior probability distribution both for the parameter \emph{alpha} and
#' for the rate parameters \emph{theta_i}.
#'
#' We will use the mean of the \emph{theta} samples drawn from the posterior
#' distribution as the partial pooling estimate for \emph{theta}.
#'
#' This function prints diagnostic information as a side effect.
#'
#' @export
#' @param n Previous reference count values (measure of exposure),
#'   must at least be 1
#' @param y Previous count values of interest
#' @param beta Parameter for half-normal distribution of alpha
#'   (default: 0.376, so that the expected value of alpha is 0.3)
#' @param random_seed Seed value for Stan (default: 200731)
#' @return Partial-pooling estimates of \emph{theta}
theta_partpool <- function(n,
                           y,
                           beta = 0.376,
                           random_seed = 200731) {
  # check arguments
  stopifnot(
    # n must be 1 or greater
    sum(n < 1) == 0,
    # y must be non-negative
    sum(y < 0) == 0,
    # n and y must be vectors of same length
    length(n) == length(y),
    # beta must be greater than 0
    beta > 0,
    # random_seed must be greater than 0
    random_seed > 0
  )
  # Four chains with 4000 iterations each, of which half are used for
  # warm-up, giving 8000 samples for each of the parameters.
  d <- list(units = length(n), n = n, y = y, beta = beta)
  stan_model_file <- system.file("stan",
                                 "partpool.stan",
                                 package = "countcheck")
  model <- cmdstanr::cmdstan_model(stan_file = stan_model_file)
  fit <- model$sample(data = d,
                      chains = 4,
                      iter_sampling = 2000,
                      iter_warmup = 2000,
                      seed = random_seed)
  draws <- fit$draws()
  post_theta_means <- numeric(length(n))
  for (i in 1:length(n)) {
    post_theta_means[i] <- mean(draws[, , paste0("theta[", i, "]")])
  }
  # We will use the sample means as point estimates.
  post_theta_means
}

#' Add no-pooling estimate of \emph{theta} to data frame
#'
#' Adds no-pooling estimate of \emph{theta} to data frame.
#'
#' @keywords internal
#' @param d Initialized data frame
#' @return Data frame with values for \emph{theta_nopool}
add_theta_nopool <- function(d) {
  d$theta_nopool <- theta_nopool(d$n, d$y)
  d
}

#' Add complete-pooling estimate of \emph{theta} to data frame
#'
#' Adds complete-pooling estimate of \emph{theta} to data frame.
#'
#' @keywords internal
#' @param d Initialized data frame
#' @return Data frame with values for \emph{theta_complpool}
add_theta_complpool <- function(d) {
  d$theta_complpool <- theta_complpool(d$n, d$y)
  d
}

#' Add partial-pooling estimate of \emph{theta} to data frame
#'
#' Adds partial-pooling estimate of \emph{theta} (based on Bayesian
#' hierarchical model) to data frame.
#'
#' @keywords internal
#' @param d Initialized data frame
#' @param beta Parameter for half-normal distribution of alpha
#'   (default: 0.376, so that the expected value of alpha is 0.3)
#' @param random_seed Seed value for Stan (default: 200731)
#' @param precis_depth Depth parameter for rethinking::precis() (default: 1)
#' @return Data frame with values for \emph{theta_partpool}
add_theta_partpool <- function(d,
                               beta = 0.376,
                               random_seed = 200731) {
  d$theta_partpool <- theta_partpool(
    d$n,
    d$y,
    beta = beta,
    random_seed = random_seed
  )
  d
}
