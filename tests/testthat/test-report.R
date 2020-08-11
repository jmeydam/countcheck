context("Report")
library(countcheck)

test_that("select_for_report() works as expected", {
  d_df <- dget(file = "../data/report_test_input__d.txt")
  y_new_df <- dget(file = "../data/report_test_input__y_new.txt")
  expect_equal(
    select_for_report(d = d_df),
    y_new_df
  )
})

test_that("html_report() rejects arguments that are not plausible", {
  y_new_df <- dget(file = "../data/report_test_input__y_new.txt")
  unit_df <- dget(file = "../data/report_test_input__unit.txt")
  expect_error(
    html_report(
      y_new_df = 1,
      unit_df = unit_df
    ),
    "is.data.frame(y_new_df) is not TRUE",
    fixed = TRUE
  )
  expect_error(
    html_report(
      y_new_df = y_new_df,
      unit_df = "A"
    ),
    "is.data.frame(unit_df) is not TRUE",
    fixed = TRUE
  )
  expect_error(
    html_report(
      y_new_df = data.frame(a = c("x", "y", "z"), b = c(1, 2, 3)),
      unit_df = unit_df
    ),
    "ncol(y_new_df) == 3 is not TRUE",
    fixed = TRUE
  )
  expect_error(
    html_report(
      y_new_df = y_new_df,
      unit_df = data.frame(a = c("x", "y", "z"), b = c(1, 2, 3))
    ),
    "ncol(unit_df) == 3 is not TRUE",
    fixed = TRUE
  )
  expect_error(
    html_report(
      y_new_df = data.frame(a = c("x", "y", "z"), b = c(1, 2, 3), c = c(1, 2, 3)),
      unit_df = unit_df
    ),
    "colnames(y_new_df) == c(\"y_new\", \"ucl_partpool\", \"unit\") are not all TRUE",
    fixed = TRUE
  )
  expect_error(
    html_report(
      y_new_df = y_new_df,
      unit_df = data.frame(a = c("x", "y", "z"), b = c(1, 2, 3), c = c(1, 2, 3))
    ),
    "colnames(unit_df) == c(\"unit\", \"unit_group_name\", \"unit_name\") are not all TRUE",
    fixed = TRUE
  )
  expect_error(
    html_report(
      y_new_df = y_new_df,
      unit_df = unit_df
    ),
    "colnames(unit_df) == c(\"unit\", \"unit_group_name\", \"unit_name\") are not all TRUE",
    fixed = TRUE
  )
})
