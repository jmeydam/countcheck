devtools::install_github("https://github.com/jmeydam/countcheck.git")
library(countcheck)

# Example 1 #################################################################

d <- countcheck(random_seed = 200807)

# Counts exceeding UCLs
# *********************
# ucl_true_theta:
sum(d$y_new - d$ucl_true_theta > 0)
# ucl_nopool:
sum(d$y_new - d$ucl_nopool > 0)
# ucl_complpool:
sum(d$y_new - d$ucl_complpool > 0)
# ucl_partpool:
sum(d$y_new - d$ucl_partpool > 0)

d[d$y_new - d$ucl_partpool > 0,
  c("n", "y", "n_new", "y_new",
    "true_theta", "theta_partpool",
    "ucl_true_theta", "ucl_partpool", "fe_partpool")]

e <- example_01
d1 <- countcheck(unit = e$unit,
                 n = e$n,
                 y = e$y,
                 n_new = e$n_new,
                 y_new = e$y_new,
                 random_seed = 200807)
