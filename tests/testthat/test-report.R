context("Report")
library(countcheck)

test_that("select_for_report() works as expected", {
  d_df <- dget(file = "../data/test_d.txt")
  countcheck_df <- dget(file = "../data/test_countcheck.txt")
  expect_equal(
    select_for_report(d = d_df),
    countcheck_df
  )
})

test_that("html_table() rejects arguments that are not plausible", {
  countcheck_df <- dget(file = "../data/test_countcheck.txt")
  unit_df <- dget(file = "../data/test_unit.txt")
  expect_error(
    html_table(
      countcheck_df = 1,
      unit_df = unit_df
    ),
    "is.data.frame(countcheck_df) is not TRUE",
    fixed = TRUE
  )
  expect_error(
    html_table(
      countcheck_df = countcheck_df,
      unit_df = "A"
    ),
    "is.data.frame(unit_df) is not TRUE",
    fixed = TRUE
  )
  expect_error(
    html_table(
      countcheck_df = countcheck_df[1 == 2, ],
      unit_df = unit_df
    ),
    "nrow(countcheck_df) > 0 is not TRUE",
    fixed = TRUE
  )
  expect_error(
    html_table(
      countcheck_df = countcheck_df,
      unit_df = unit_df[1 == 2, ]
    ),
    "nrow(unit_df) > 0 is not TRUE",
    fixed = TRUE
  )
  expect_error(
    html_table(
      countcheck_df = data.frame(
        a = c("x", "y", "z"),
        b = c(1, 2, 3)),
      unit_df = unit_df
    ),
    "ncol(countcheck_df) == 3 is not TRUE",
    fixed = TRUE
  )
  expect_error(
    html_table(
      countcheck_df = countcheck_df,
      unit_df = data.frame(
        a = c("x", "y", "z"),
        b = c(1, 2, 3))
    ),
    "ncol(unit_df) == 4 is not TRUE",
    fixed = TRUE
  )
  expect_error(
    html_table(
      countcheck_df = data.frame(
        a = c("x", "y", "z"),
        b = c(1, 2, 3),
        c = c(1, 2, 3)),
      unit_df = unit_df
    ),
    "colnames(countcheck_df) == c(\"y_new\", \"ucl_partpool\", \"unit\") are not all TRUE",
    fixed = TRUE
  )
  expect_error(
    html_table(
      countcheck_df = countcheck_df,
      unit_df = data.frame(
        a = c("x", "y", "z"),
        b = c(1, 2, 3),
        c = c(1, 2, 3),
        d = c(1, 2, 3)
      )
    ),
    "colnames(unit_df) == c(\"unit\", \"unit_group_name\", \"unit_name\",  .... are not all TRUE",
    fixed = TRUE
  )
})

test_that("escape() works as expected", {
  expect_equal(
    escape("abc"),
    "abc"
  )
  expect_equal(
    escape("<abc>xyz</abc>"),
    "&lt;abc&gt;xyz&lt;/abc&gt;",
  )
  expect_equal(
    escape("&\"'"),
    "&amp;&quot;&#39;",
  )
})
