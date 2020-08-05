context("UCLs")
library(countcheck)

test_that("ucl() calculates UCLs according to formula", {
  expect_equal(
    ucl(theta_hat = 0.5, n_new = 8),
    4 + 3 * sqrt(4) + 0.5
  )
  expect_equal(
    ucl(theta_hat = 0.5, n_new = 8, factor_sd = 3),
    4 + 3 * sqrt(4) + 0.5
  )
  expect_equal(
    ucl(theta_hat = 0.5, n_new = 8, factor_sd = 2),
    4 + 2 * sqrt(4) + 0.5
  )
})
