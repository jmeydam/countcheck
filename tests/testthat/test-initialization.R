context("Initialization")
library(countcheck)

test_that("initialize() rejects arguments that are not plausible", {
  expect_error(
    initialize(
      n = c(1, 2),
      y = c(1, 2),
      n_new = c(1, 2),
      y_new = c(1, 2),
      true_theta = NULL
    ),
    "length(n) >= 3 is not TRUE",
    fixed = TRUE
  )
  expect_error(
    initialize(
      n = c(1, 2, 3),
      y = c(1, 2, 3),
      n_new = c(1, 2, 3),
      y_new = c(1, 2, 3),
      true_theta = 1
    ),
    "ifelse(is.null(true_theta), length(n), length(true_theta)) == ",
    fixed = TRUE
  )
  expect_error(
    initialize(
      n = c(1, 2, 3),
      y = c(1, 2, 3),
      n_new = 1,
      y_new = 1,
      true_theta = NULL
    ),
    "length(n_new) == length(n) is not TRUE",
    fixed = TRUE
  )
  expect_error(
    initialize(
      n = c(1, 2, 3),
      y = c(1, 2, 3),
      n_new = NULL,
      y_new = NULL,
      true_theta = NULL
    ),
    "length(n_new) == length(n) is not TRUE",
    fixed = TRUE
  )
  expect_error(
    initialize(
      n = c(1.1, 2.2, 3.3),
      y = c(1, 2, 3),
      n_new = c(1, 2, 3),
      y_new = c(1, 2, 3),
      true_theta = NULL
    ),
    "n == as.integer(n) are not all TRUE",
    fixed = TRUE
  )
  expect_error(suppressWarnings(initialize(
    n = c("A", "B", "C"),
    y = c(1, 2, 3),
    n_new = c(1, 2, 3),
    y_new = c(1, 2, 3),
    true_theta = NULL
  )),
  "n == as.integer(n) are not all TRUE",
  fixed = TRUE)
  expect_error(
    suppressWarnings(initialize(
      n = c(1, 2, 3),
      y = c(1, 2, 3),
      n_new = c(1, 2, 3),
      y_new = c(1, 2, 3),
      true_theta = c("A", "B", "C")
    )),
    "ifelse(is.null(true_theta), TRUE, is.numeric(true_theta)) is not TRUE",
    fixed = TRUE
  )
})

test_that("initialize() returns a plausible data frame", {
  expect_equal(nrow(initialize(
    n = c(1, 2, 3),
    y = c(1, 2, 3),
    n_new = c(1, 1, 1),
    y_new = c(1, 1, 1),
    true_theta = NULL
  )), 3)
  expect_equal(nrow(initialize(
    n = c(1, 2, 3),
    y = c(1, 2, 3),
    n_new = c(1, 1, 1),
    y_new = c(1, 1, 1),
    true_theta = c(0.1, 0.1, 0.1)
  )), 3)
})
