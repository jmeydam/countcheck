#' No-pooling model
#'
#' For the no-pooling model we estimate theta_i using only the observed
#' counts of observational unit i. For each unit i our no-pooling estimate
#' of theta_i is the ratio of the observed count values of interest y_i to
#' the reference count values n_i.
#'
#' @param n Previous reference count values (measure of exposure)
#' @param y Previous count values of interest
#' @return No-pooling estimates of theta
theta_nopool <- function(n, y) {
  y / n
}

#' Complete-pooling model
#'
#' For the complete-pooling model we consider theta_i to be the same
#' for all observational units. We assume that observed data can be
#' treated as coming from a homogeneous source. For all units i our
#' complete-pooling estimate of theta_i is the ratio of the sum of
#' the observed count values of interest y_i to the sum of the
#' reference count values n_i.
#'
#' @param n Previous reference count values (measure of exposure)
#' @param y Previous count values of interest
#' @return Complete-pooling estimates of theta
theta_complpool <- function(n, y) {
  rep(sum(y) / sum(n), length(n))
}

#' Partial-pooling model (Bayesian hierarchical model)
#'
#' The partial-pooling model can be seen as a compromise between the
#' extremes of the no-pooling and partial-pooling models. We do not treat
#' all observed data as coming from a homogeneous source, but we do assume
#' that information on other units can be useful for estimating theta_i
#' of a particular unit i, especially when there is little information
#' for a particular unit i.
#'
#' The partial-pooling model uses a hierarchical structure of probability
#' distributions. We will use the same types of distributions for this model
#' that we used for simulating the data.
#'
#' In particular, we assume that each observational unit i has a Poisson
#' distribution with parameter lambda_i. lambda_i is a product
#' of a rate parameter theta_i and the exposure n_i.
#'
#' We use a half-normal distribution with a parameter alpha for the rate
#' parameters theta_i. This time, alpha itself is also assumed to have
#' a probability distribution. We choose a half-normal distribution with a
#' fixed parameter 0.376, so that the expected value of alpha is 0.3.
#'
#' Note that when simulating the data we set alpha to 0.05.
#' The "true" value of alpha is substantially lower than the value
#' initially assumed by our model.
#'
#' Given data in the form of reference counts n_i (exposure) and
#' count values of interest y_i, our model will allow us to determine
#' a posterior probability distribution both for the parameter alpha
#' and for the rate parameters theta_i.
#'
#' We will use the mean of the theta samples drawn from the posterior
#' distribution as the partial pooling estimate for theta.
#'
#' @param unit Index for units
#' @param n Previous reference count values (measure of exposure)
#' @param y Previous count values of interest
#' @param random_seed Seed value for Stan
#' @return Partial-pooling estimates of theta
theta_partpool <- function(unit, n, y, random_seed) {
  # The function ulam() returns samples drawn from the posterior
  # distribution of our model.
  # Four chains with 4000 iterations each, of which half are used for
  # warm-up, giving 8000 samples for each of the parameters.
  dat <- list(unit, n, y)
  m <- ulam(
    alist(
      y ~ dpois(lambda),
      lambda <- n * theta[unit],
      theta[unit] ~ dhalfnorm(0, alpha),
      alpha ~ dhalfnorm(0, 0.376)
    ),
    data = dat,
    chains = 4,
    iter = 4000,
    seed = random_seed)
  post <- extract.samples(m)
  post_theta_means <- apply(post$theta, 2, mean)
  # We will use the sample means as point estimates.
  post_theta_means
}

#' Add no-pooling estimate of theta to data frame
#'
#' @param d Initialized data frame
#' @return data frame with values for theta_nopool
add_theta_nopool <- function(d) {
  d$theta_nopool <- theta_nopool(d$n, d$y)
  d
}

#' Add complete-pooling estimate of theta to data frame
#'
#' @param d Initialized data frame
#' @return data frame with values for theta_complpool
add_theta_complpool <- function(d) {
  d$theta_complpool <- theta_complpool(d$n, d$y)
  d
}

#' Add partial-pooling estimate of theta (based on Bayesian hierarchical
#' model) to data frame
#'
#' @param d Initialized data frame
#' @param random_seed Seed value for Stan (default: 200731)
#' @return data frame with values for theta_partpool
add_theta_partpool <- function(d, random_seed = 200731) {
  d$theta_partpool <- theta_partpool(d$unit, d$n, d$y, random_seed)
  d
}
