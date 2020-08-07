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

test_that("factor_exceeding() calculates factor as expected", {
  expect_equal(
    # ucl =  4 + 3 * sqrt(4) + 0.5 = 10.5
    factor_exceeding(theta_hat = 0.5, n_new = 8, y_new = 14.5, ucl = 10.5),
    2
  )
  expect_equal(
    # ucl =  4 + 3 * sqrt(4) + 0.5 = 10.5
    factor_exceeding(theta_hat = 0.5, n_new = 8, y_new = 12.5, ucl = 10.5),
    1
  )
  expect_equal(
    # ucl =  4 + 3 * sqrt(4) + 0.5 = 10.5
    factor_exceeding(theta_hat = 0.5, n_new = 8, y_new = 11.5, ucl = 10.5),
    0.5
  )
  expect_equal(
    # ucl =  4 + 3 * sqrt(4) + 0.5 = 10.5
    factor_exceeding(theta_hat = 0.5, n_new = 8, y_new = 10.5, ucl = 10.5),
    0
  )
  expect_equal(
    # ucl =  4 + 3 * sqrt(4) + 0.5 = 10.5
    factor_exceeding(theta_hat = 0.5, n_new = 8, y_new = 9.5, ucl = 10.5),
    -0.5
  )
  expect_equal(
    # ucl =  4 + 3 * sqrt(4) + 0.5 = 10.5
    factor_exceeding(theta_hat = 0.5, n_new = 8, y_new = 0, ucl = 10.5),
    -5.25
  )
})
