context("Report")
library(countcheck)

test_that("select_for_report() rejects arguments that are not plausible", {
  d_df <- dget(file = "../data/test_d.txt")
  countcheck_df <- dget(file = "../data/test_countcheck.txt")
  expect_error(
    select_for_report(d = "x"),
    "is.data.frame(d) is not TRUE",
    fixed = TRUE
  )
  expect_error(
    select_for_report(d = d_df, min_y_new = -1),
    "min_y_new >= 0 is not TRUE",
    fixed = TRUE
  )
})

test_that("select_for_report() works as expected", {
  d_df <- dget(file = "../data/test_d.txt")
  countcheck_df <- dget(file = "../data/test_countcheck.txt")
  expect_equal(
    select_for_report(d = d_df),
    countcheck_df
  )
  expect_equal(
    nrow(select_for_report(d = d_df, min_y_new = 8)),
    nrow(countcheck_df[countcheck_df$y_new >= 8, ])
  )
  expect_equal(
    nrow(select_for_report(d = d_df, min_diff = 3)),
    nrow(
      countcheck_df[countcheck_df$y_new - countcheck_df$ucl_partpool >= 3, ]
    )
  )
})

test_that("html_table() rejects arguments that are not plausible", {
  countcheck_df <- dget(file = "../data/test_countcheck.txt")
  unit_df <- dget(file = "../data/test_unit.txt")
  expect_error(
    html_table(
      countcheck_df = 1,
      unit_df = unit_df,
      caption = "KPI",
    ),
    "is.data.frame(countcheck_df) is not TRUE",
    fixed = TRUE
  )
  expect_error(
    html_table(
      countcheck_df = countcheck_df,
      unit_df = "A",
      caption = "KPI",
    ),
    "is.data.frame(unit_df) is not TRUE",
    fixed = TRUE
  )
  expect_error(
    html_table(
      countcheck_df = countcheck_df[1 == 2, ],
      unit_df = unit_df,
      caption = "KPI",
    ),
    "nrow(countcheck_df) > 0 is not TRUE",
    fixed = TRUE
  )
  expect_error(
    html_table(
      countcheck_df = countcheck_df,
      unit_df = unit_df[1 == 2, ],
      caption = "KPI",
    ),
    "nrow(unit_df) > 0 is not TRUE",
    fixed = TRUE
  )
  expect_error(
    html_table(
      countcheck_df = data.frame(
        a = c("x", "y", "z"),
        b = c(1, 2, 3)
      ),
      unit_df = unit_df,
      caption = "KPI",
    ),
    "ncol(countcheck_df) == 3 is not TRUE",
    fixed = TRUE
  )
  expect_error(
    html_table(
      countcheck_df = countcheck_df,
      unit_df = data.frame(
        a = c("x", "y", "z"),
        b = c(1, 2, 3)
      ),
      caption = "KPI",
    ),
    "ncol(unit_df) == 4 is not TRUE",
    fixed = TRUE
  )
  expect_error(
    html_table(
      countcheck_df = data.frame(
        a = c("x", "y", "z"),
        b = c(1, 2, 3),
        c = c(1, 2, 3)
      ),
      unit_df = unit_df,
      caption = "KPI",
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
      ),
      caption = "KPI",
    ),
    "colnames(unit_df) == c(\"unit\", \"unit_name\", \"unit_url\", \"unit_group_name\") are not all TRUE",
    fixed = TRUE
  )
  expect_error(
    html_table(
      countcheck_df = countcheck_df,
      unit_df = unit_df,
      caption = "KPI",
      headers = c(
        x = "Group",
        count = "Count",
        ucl = "UCL",
        unit = "Unit",
        name = "Name"
      )
    ),
    "names(headers) == c(\"group\", \"count\", \"ucl\", \"unit\", \"name\") are not all TRUE",
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

test_that("HTML is valid (check generated HTML file manually)", {
  countcheck_df <- dget(file = "../data/test_countcheck.txt")
  unit_df <- dget(file = "../data/test_unit.txt")
  report <- html_report(
    countcheck_list = list(
      list(df = countcheck_df, caption = "KPI 1"),
      list(df = countcheck_df, caption = "KPI 2"),
      list(df = countcheck_df, caption = "KPI 3")
    ),
    unit_df = unit_df,
    title = "Report",
    column_headers = c(
      group = "Group",
      count = "Count",
      ucl = "UCL",
      unit = "Unit",
      name = "Name"),
    charset = "utf-8",
    lang = "en",
    home_url = "../index.html",
    style = NULL)
    # style = ".header h1 {margin: 0px; color: blue; font-size: xx-large;}\n")
  dput(report, file = "../data/report_tmp.txt")
  sink("../data/report_tmp.html")
  cat(dget(file = "../data/report_tmp.txt"))
  sink()
  # Dummy test
  expect_equal(1, 1)
})
