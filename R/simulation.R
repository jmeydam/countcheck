#' Simulate data for use in examples
#'
#' The distributions and parameters in this simulation have been chosen
#' so that the generated data is roughly comparable to certain data of
#' interest.
#'
#' @export
#' @param units Number of observational units (default: 1000)
#' @param random_seed Seed value (optional)
#' @return Data frame initialized with simulated data
simulate_data <- function(units = 1000, random_seed = NULL) {

  # Optional: set random seed
  if (! is.null(random_seed)) {
    set.seed(random_seed)
  }

  # First, simulate values of a previous period, including true_theta.

  # We assume a Pareto distribution for the exposure of observational
  # units. We use reference counts n as an approximate measure of exposure.

  # Draw values from a Pareto distribution with suitable parameters
  v <- actuar::rpareto2(units, min = 0, shape = 5, scale = 1000)
  # Transform to discrete values for count data
  n <- ceiling(v)
  # n must never be 0 (and will not, since v will never be exactly 0)
  n[n == 0] <- 1
  # Sort values to facilitate visualization
  n <- sort(n)
  # Convert to integer
  n <- as.integer(n)

  # We assume Poisson distributions for the count values of interest.

  # Each observational unit i has a Poisson distribution with parameter
  # lambda_i, which is equal to both the mean and the variance. lambda_i
  # is a product of a rate parameter theta_i and the exposure n_i.

  # We use a half-normal distribution with a suitable parameter alpha
  # for the rate parameters theta_i.

  # Set "true" value of alpha, the parameter determining the distribution
  # of theta in the simulated data.
  alpha <- 0.05

  # Set "true" value of theta for each unit by drawing from a half-normal
  # distribution with parameter alpha.
  true_theta <- extraDistr::rhnorm(units, alpha)

  # Given the reference counts (exposure) n_i and the rate parameters theta_i
  # we can now draw count values of interest y_i from Poisson distributions.
  y <- rpois(units, lambda = n * true_theta)

  # Second, simulate values of a new period. true_theta remains unchanged.

  # We assume new data from a subsequent period of about half the length of
  # the original period, and, in proportion, about half of n as new reference
  # counts.
  n_new <- as.integer(ceiling(n / 2))

  # The values of y_new are drawn from a Poisson distribution with parameter
  # lambda equaling the product of n_new and the true_theta.
  y_new <- rpois(units, lambda = n_new * true_theta)

  initialize(unit = 1:length(n), n, y, n_new, y_new, true_theta)
}
