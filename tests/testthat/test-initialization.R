context("Initialization")
library(countcheck)

test_that("initialize() rejects arguments that are not plausible", {
  expect_error(
    initialize(
      unit = c(1, 2),
      n = c(1, 2),
      y = c(1, 2),
      n_new = c(1, 2),
      y_new = c(1, 2),
      true_theta = NULL
    ),
    "length(unit) >= 3 is not TRUE",
    fixed = TRUE
  )
  expect_error(
    initialize(
      unit = c(1, 2, 3),
      n = c(1, 2, 3),
      y = c(1, 2, 3),
      n_new = c(1, 2, 3),
      y_new = c(1, 2, 3),
      true_theta = 0.9
    ),
    "ifelse(is.null(true_theta), length(unit), length(true_theta))",
    fixed = TRUE
  )
  expect_error(
    initialize(
      unit = c(1, 2, 3),
      n = c(1, 2, 3),
      y = c(1, 2, 3),
      n_new = 1,
      y_new = 1,
      true_theta = NULL
    ),
    "length(n_new) == length(unit) is not TRUE",
    fixed = TRUE
  )
  expect_error(
    initialize(
      unit = c(1, 2, 3),
      n = c(1, 2, 3),
      y = c(1, 2, 3),
      n_new = NULL,
      y_new = NULL,
      true_theta = NULL
    ),
    "length(n_new) == length(unit) is not TRUE",
    fixed = TRUE
  )
  expect_error(
    initialize(
      unit = c(1, 2, 3),
      n = c(1.1, 2.2, 3.3),
      y = c(1, 2, 3),
      n_new = c(1, 2, 3),
      y_new = c(1, 2, 3),
      true_theta = NULL
    ),
    "n == as.integer(n) are not all TRUE",
    fixed = TRUE
  )
  expect_error(
    suppressWarnings(initialize(
      unit = c(1, 2, 3),
      n = c("A", "B", "C"),
      y = c(1, 2, 3),
      n_new = c(1, 2, 3),
      y_new = c(1, 2, 3),
      true_theta = NULL
    )),
    "n == as.integer(n) are not all TRUE",
    fixed = TRUE
  )
  expect_error(
    initialize(
      unit = c(1, 2, 3),
      n = c(0, 2, 3),
      y = c(1, 2, 3),
      n_new = c(1, 2, 3),
      y_new = c(1, 2, 3),
      true_theta = NULL
    ),
    "sum(n < 1) == 0 is not TRUE",
    fixed = TRUE
  )
  expect_error(
    initialize(
      unit = c(1, 2, 3),
      n = c(1, 2, 3),
      y = c(-1, 2, 3),
      n_new = c(1, 2, 3),
      y_new = c(1, 2, 3),
      true_theta = NULL
    ),
    "sum(y < 0) == 0 is not TRUE",
    fixed = TRUE
  )
  expect_error(
    initialize(
      unit = c(1, 2, 3),
      n = c(1, 2, 3),
      y = c(1, 2, 3),
      n_new = c(0, 2, 3),
      y_new = c(1, 2, 3),
      true_theta = NULL
    ),
    "sum(n_new < 1) == 0 is not TRUE",
    fixed = TRUE
  )
  expect_error(
    initialize(
      unit = c(1, 2, 3),
      n = c(1, 2, 3),
      y = c(1, 2, 3),
      n_new = c(1, 2, 3),
      y_new = c(-1, 2, 3),
      true_theta = NULL
    ),
    "sum(y_new < 0) == 0 is not TRUE",
    fixed = TRUE
  )
  expect_error(
    suppressWarnings(initialize(
      unit = c(1, 2, 3),
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
  expect_equal(
    dim(initialize(
      unit = c(1, 2, 3),
      n = c(1, 2, 3),
      y = c(1, 2, 3),
      n_new = c(1, 1, 1),
      y_new = c(1, 1, 1),
      true_theta = NULL
    )),
    c(3, 13)
  )
  expect_equal(
    dim(initialize(
      unit = c(1, 2, 3),
      n = c(1, 2, 3),
      y = c(1, 2, 3),
      n_new = c(1, 1, 1),
      y_new = c(1, 1, 1),
      true_theta = c(0.9, 0.9, 0.9)
    )),
    c(3, 13)
  )
  expect_equal(
    colnames(initialize(
      unit = c(1, 2, 3),
      n = c(1, 2, 3),
      y = c(1, 2, 3),
      n_new = c(1, 1, 1),
      y_new = c(1, 1, 1),
      true_theta = NULL
    )),
    c(
      "unit",
      "n",
      "y",
      "n_new",
      "y_new",
      "true_theta",
      "theta_nopool",
      "theta_complpool",
      "theta_partpool",
      "ucl_true_theta",
      "ucl_nopool",
      "ucl_complpool",
      "ucl_partpool"
    )
  )
  expect_equal(
    unname(sapply(
      initialize(
        unit = c(1, 2, 3),
        n = c(1, 2, 3),
        y = c(1, 2, 3),
        n_new = c(1, 1, 1),
        y_new = c(1, 1, 1),
        true_theta = c(0.9, 0.9, 0.9)
      ),
      class
    )),
    c(
      "integer",
      "integer",
      "integer",
      "integer",
      "integer",
      "numeric",
      "numeric",
      "numeric",
      "numeric",
      "numeric",
      "numeric",
      "numeric",
      "numeric"
    )
  )
})
