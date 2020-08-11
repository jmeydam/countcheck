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

test_that("html_table() returns HTML as expected", {
  countcheck_df <- dget(file = "../data/test_countcheck.txt")
  unit_df <- dget(file = "../data/test_unit.txt")
  expect_equal(
    html_table(
      countcheck_df = countcheck_df[1:3, ],
      unit_df = unit_df
    ),
    paste0(
      "<table>\n<tr><th class=\"left\">y_new</th><th class=\"left\">",
      "ucl</th><th class=\"left\">group</th><th class=\"left\">unit</th>",
      "</tr>\n<tr><td class=\"y_new\">8</td><td class=\"ucl\">5.5</td>",
      "<td class=\"unit_group_name\">Group 3</td><td class=\"unit_name\">",
      "<a href=\"http://units/462.html\">462 - Unit 462</a></td></tr>\n<tr>",
      "<td class=\"y_new\">16</td><td class=\"ucl\">11.5</td><td class=",
      "\"unit_group_name\">Group 3</td><td class=\"unit_name\">",
      "<a href=\"http://units/698.html\">698 - Unit 698</a></td></tr>\n",
      "<tr><td class=\"y_new\">51</td><td class=\"ucl\">42.5</td><td ",
      "class=\"unit_group_name\">Group 1</td><td class=\"unit_name\">",
      "<a href=\"http://units/935.html\">935 - Unit 935</a></td></tr>\n",
      "</table>\n"
    )
  )
})

test_that("html_report() returns HTML as expected", {
  countcheck_df <- dget(file = "../data/test_countcheck.txt")
  unit_df <- dget(file = "../data/test_unit.txt")
  report <- html_report(
    countcheck_df = countcheck_df[1:3, ],
    unit_df = unit_df
  )
  dput(report, file = "../data/report_tmp.txt")
  expect_equal(
    html_report(
      countcheck_df = countcheck_df[1:3, ],
      unit_df = unit_df
    ),
    paste0("a")
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
