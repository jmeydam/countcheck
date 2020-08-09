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

e <- simdat
d1 <- countcheck(unit = e$unit,
                 n = e$n,
                 y = e$y,
                 n_new = e$n_new,
                 y_new = e$y_new,
                 random_seed = 200807)

str(d1)

sum(d1$unit == d$unit)
sum(d1$n == d$n)
sum(d1$y == d$y)
sum(d1$n_new == d$n_new)
sum(d1$y_new == d$y_new)
sum(d1$theta_nopool == d$theta_nopool)
sum(d1$theta_complpool == d$theta_complpool)
sum(d1$theta_partpool == d$theta_partpool)
d[d1$theta_partpool != d$theta_partpool, ]
d1[d1$theta_partpool != d$theta_partpool, ]
sum(d1$ucl_nopool == d$ucl_nopool)
sum(d1$ucl_complpool == d$ucl_complpool)
sum(d1$ucl_partpool == d$ucl_partpool)
sum(d1$fe_nopool == d$fe_nopool)
sum(d1$fe_complpool == d$fe_complpool)
sum(d1$fe_partpool == d$fe_partpool)

d1[d1$y_new - d1$ucl_partpool > 0,
   c("n", "y", "n_new", "y_new",
     "true_theta", "theta_partpool",
     "ucl_true_theta", "ucl_partpool", "fe_partpool")]


# Example 2 #################################################################

d2 <- countcheck(unit = e$unit,
                 n = e$n,
                 y = e$y,
                 n_new = e$n_new,
                 y_new = round(2 * ceiling(e$n_new * e$true_theta)),
                 true_theta = e$true_theta,
                 random_seed = 200807)

# Counts exceeding UCLs
# *********************
# ucl_true_theta:
sum(d2$y_new - d2$ucl_true_theta > 0)
# ucl_nopool:
sum(d2$y_new - d2$ucl_nopool > 0)
# ucl_complpool:
sum(d2$y_new - d2$ucl_complpool > 0)
# ucl_partpool:
sum(d2$y_new - d2$ucl_partpool > 0)

head(
d2[d2$y_new - d2$ucl_partpool > 0,
   c("n", "y", "n_new", "y_new",
     "true_theta", "theta_partpool",
     "ucl_true_theta", "ucl_partpool", "fe_partpool")]
)

tail(
  d2[d2$y_new - d2$ucl_partpool > 0,
     c("n", "y", "n_new", "y_new",
       "true_theta", "theta_partpool",
       "ucl_true_theta", "ucl_partpool", "fe_partpool")]
)
