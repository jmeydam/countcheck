library(countcheck)

# Generate data

d <- countcheck(random_seed = 200807)
str(d)


# Create file report_test_input__d.txt

dput(d[d$y_new - d$ucl_partpool > -0.1, ],
     file = "tests/data/report_test_input__d.txt")
dget(file = "tests/data/report_test_input__d.txt")


# Create file report_test_input__y_new.txt

r <- d[d$y_new - d$ucl_partpool > 0,
        c("unit", "n", "y", "n_new", "y_new",
          "ucl_partpool", "fe_partpool")]

r <- r[order(-r$fe_partpool), ]

r <- r[, c("y_new", "ucl_partpool", "unit")]
row.names(r) <- NULL
r

# dput(r)
# tmp_r <- eval(dput(r))
# tmp_r
# str(tmp_r)

dput(r, file = "tests/data/report_test_input__y_new.txt")
dget(file = "tests/data/report_test_input__y_new.txt")


# Create file report_test_input__unit.txt

sort(unique(r$unit))
units_tmp <- sort(unique(r$unit))
rep(1:3, length.out = length(units_tmp))

unit_df <- data.frame(
  unit = units_tmp,
  unit_group_name = paste("Group",
                          rep(1:3,
                              length.out = length(units_tmp))),
  unit_name = paste("Unit",
                    units_tmp)
)
str(unit_df)

dput(unit_df, file = "tests/data/report_test_input__unit.txt")
dget(file = "tests/data/report_test_input__unit.txt")


# Create objects for interactive tests

d_df_tmp <- dget(file = "tests/data/report_test_input__d.txt")
y_new_df_tmp <- dget(file = "tests/data/report_test_input__y_new.txt")
unit_df_tmp <- dget(file = "tests/data/report_test_input__unit.txt")
