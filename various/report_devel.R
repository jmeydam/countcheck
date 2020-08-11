library(countcheck)

# Generate data #############################################################

d <- countcheck(random_seed = 200807)
str(d)

# Create file test_d.txt ####################################################

dput(d[d$y_new - d$ucl_partpool > -0.1, ],
     file = "tests/data/test_d.txt")
dget(file = "tests/data/test_d.txt")

# Create file test_countcheck.txt ###########################################

r <- d[d$y_new - d$ucl_partpool > 0,
        c("unit", "n", "y", "n_new", "y_new",
          "ucl_partpool", "fe_partpool")]

r <- r[order(-r$fe_partpool), ]

r <- r[, c("y_new", "ucl_partpool", "unit")]
row.names(r) <- NULL

dput(r, file = "tests/data/test_countcheck.txt")
dget(file = "tests/data/test_countcheck.txt")

# Create file test_unit.txt #################################################

units_tmp <- sort(unique(r$unit))

unit_df <- data.frame(
  unit = units_tmp,
  unit_name = paste("Unit",
                    units_tmp),
  unit_url = paste0("http://units/",
                    units_tmp,
                    ".html"),
  unit_group_name = paste("Group",
                          rep(1:5,
                              length.out = length(units_tmp)))
)

dput(unit_df, file = "tests/data/test_unit.txt")
dget(file = "tests/data/test_unit.txt")

# Create objects for interactive tests ######################################

d_df_tmp <- dget(file = "tests/data/test_d.txt")
countcheck_df_tmp <- dget(file = "tests/data/test_countcheck.txt")
unit_df_tmp <- dget(file = "tests/data/test_unit.txt")
