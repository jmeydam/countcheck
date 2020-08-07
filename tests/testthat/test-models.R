context("Models")
library(countcheck)

test_that("models reject arguments that are not plausible", {
  # theta_nopool
  expect_error(
    theta_nopool(n = c(1, 2, 0), y = c(1, 2, 3)),
    "sum(n < 1) == 0 is not TRUE",
    fixed = TRUE
  )
  expect_error(
    theta_nopool(n = c(1, 2, 0.5), y = c(1, 2, 3)),
    "sum(n < 1) == 0 is not TRUE",
    fixed = TRUE
  )
  expect_error(
    theta_nopool(n = c(1, 2, 3), y = c(1, 2, -1)),
    "sum(y < 0) == 0 is not TRUE",
    fixed = TRUE
  )
  expect_error(
    theta_nopool(n = c(1, 2, 3), y = c(1, 2)),
    "length(n) == length(y) is not TRUE",
    fixed = TRUE
  )
  # theta_complpool
  expect_error(
    theta_complpool(n = c(1, 2, 0), y = c(1, 2, 3)),
    "sum(n < 1) == 0 is not TRUE",
    fixed = TRUE
  )
  expect_error(
    theta_complpool(n = c(1, 2, 0.5), y = c(1, 2, 3)),
    "sum(n < 1) == 0 is not TRUE",
    fixed = TRUE
  )
  expect_error(
    theta_complpool(n = c(1, 2, 3), y = c(1, 2, -1)),
    "sum(y < 0) == 0 is not TRUE",
    fixed = TRUE
  )
  expect_error(
    theta_complpool(n = c(1, 2, 3), y = c(1, 2)),
    "length(n) == length(y) is not TRUE",
    fixed = TRUE
  )
  # theta_partpool
  expect_error(
    theta_partpool(n = c(1, 2, 0), y = c(1, 2, 3), random_seed = 1),
    "sum(n < 1) == 0 is not TRUE",
    fixed = TRUE
  )
  expect_error(
    theta_partpool(n = c(1, 2, 0.5), y = c(1, 2, 3), random_seed = 1),
    "sum(n < 1) == 0 is not TRUE",
    fixed = TRUE
  )
  expect_error(
    theta_partpool(n = c(1, 2, 3), y = c(1, 2, -1), random_seed = 1),
    "sum(y < 0) == 0 is not TRUE",
    fixed = TRUE
  )
  expect_error(
    theta_partpool(n = c(1, 2, 3), y = c(1, 2), random_seed = 1),
    "length(n) == length(y) is not TRUE",
    fixed = TRUE
  )
})
