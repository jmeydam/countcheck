context("UCLs")
library(countcheck)

test_that("ucl() rejects arguments that are not plausible", {
  expect_error(
    ucl(theta_hat = -0.5, n_new = 1),
    "sum(theta_hat < 0) == 0 | sum(!is.na(theta_hat)) == 0 is not TRUE",
    fixed = TRUE
  )
  expect_error(
    ucl(theta_hat = 0.5, n_new = 0),
    "sum(n_new < 1) == 0 is not TRUE",
    fixed = TRUE
  )
  expect_error(
    ucl(theta_hat = c(0.5, 0.6), n_new = c(1, 2, 3)),
    "length(theta_hat) == length(n_new) is not TRUE",
    fixed = TRUE
  )
  expect_error(
    ucl(theta_hat = 0.5, n_new = 1, factor_sd = -1),
    "factor_sd >= 0 is not TRUE",
    fixed = TRUE
  )
})

test_that("ucl() calculates UCLs as expected", {
  expect_equal(
    ucl(theta_hat = 0.5, n_new = 8),
    4 + 3 * sqrt(4) + 0.5
  )
  expect_true(
    is.na(ucl(theta_hat = NA, n_new = 8))
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

test_that("factor_exceeding() rejects arguments that are not plausible", {
  expect_error(
    factor_exceeding(
      theta_hat = -0.5,
      n_new = 8,
      y_new = 14,
      ucl = 10.5
    ),
    "sum(theta_hat < 0) == 0 | sum(!is.na(theta_hat)) == 0 is not TRUE",
    fixed = TRUE
  )
  expect_error(
    factor_exceeding(
      theta_hat = 0.5,
      n_new = 0,
      y_new = 14,
      ucl = 10.5
    ),
    "sum(n_new < 1) == 0 is not TRUE",
    fixed = TRUE
  )
  expect_error(
    factor_exceeding(
      theta_hat = 0.5,
      n_new = 8,
      y_new = -1,
      ucl = 10.5
    ),
    "sum(y_new < 0) == 0 is not TRUE",
    fixed = TRUE
  )
  expect_error(
    factor_exceeding(
      theta_hat = 0.5,
      n_new = 8,
      y_new = 14,
      ucl = 0
    ),
    "sum(ucl <= 0) == 0 | sum(!is.na(ucl)) == 0 is not TRUE",
    fixed = TRUE
  )
  expect_error(
    factor_exceeding(
      theta_hat = 0.5,
      n_new = c(8, 9),
      y_new = c(1, 2),
      ucl = c(10.5, 11.5)
    ),
    "length(theta_hat) == length(n_new) is not TRUE",
    fixed = TRUE
  )
  expect_error(
    factor_exceeding(
      theta_hat = c(0.5, 0.6),
      n_new = c(8, 9),
      y_new = 1,
      ucl = c(10.5, 11.5)
    ),
    "length(y_new) == length(n_new) is not TRUE",
    fixed = TRUE
  )
  expect_error(
    factor_exceeding(
      theta_hat = c(0.5, 0.6),
      n_new = c(8, 9),
      y_new = c(1, 2),
      ucl = 10.5
    ),
    "length(ucl) == length(n_new) is not TRUE",
    fixed = TRUE
  )
})

test_that("factor_exceeding() calculates factor as expected", {
  # ucl =  4 + 3 * sqrt(4) + 0.5 = 10.5
  expect_equal(
    factor_exceeding(
      theta_hat = 0.5,
      n_new = 8,
      y_new = 14,
      ucl = 10.5
    ),
    1.75
  )
  expect_true(is.na(
    factor_exceeding(
      theta_hat = NA,
      n_new = 8,
      y_new = 14,
      ucl = 10.5
    )
  ))
  expect_true(is.na(
    factor_exceeding(
      theta_hat = 0.5,
      n_new = 8,
      y_new = 14,
      ucl = NA
    )
  ))
  expect_equal(
    factor_exceeding(
      theta_hat = 0,
      n_new = 8,
      y_new = 14,
      ucl = 10.5
    ),
    Inf
  )
  expect_equal(
    factor_exceeding(
      theta_hat = 0.5,
      n_new = 8,
      y_new = 12,
      ucl = 10.5
    ),
    0.75
  )
  expect_equal(
    factor_exceeding(
      theta_hat = 0.5,
      n_new = 8,
      y_new = 11,
      ucl = 10.5
    ),
    0.25
  )
  expect_equal(
    factor_exceeding(
      theta_hat = 0.5,
      n_new = 8,
      y_new = 10.5,
      ucl = 10.5
    ),
    0
  )
  expect_equal(
    factor_exceeding(
      theta_hat = 0.5,
      n_new = 8,
      y_new = 10,
      ucl = 10.5
    ),
    -0.25
  )
  expect_equal(
    factor_exceeding(
      theta_hat = 0.5,
      n_new = 8,
      y_new = 0,
      ucl = 10.5
    ),
    -5.25
  )
})
