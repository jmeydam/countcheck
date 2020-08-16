devtools::install_github("https://github.com/jmeydam/countcheck.git", build_vignettes = TRUE)
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

# HTML Report ###############################################################

# Select data from data frame d for the report
countcheck_df <- select_for_report(d)
str(countcheck_df)

# We also need a data frame with unit master data
# Here, we just simulate data
units_tmp <- sort(unique(countcheck_df$unit))
unit_df <- data.frame(
  unit = units_tmp,
  unit_name = paste("Unit",
                    units_tmp),
  unit_url = paste0("http://domain/units/",
                    units_tmp,
                    ".html"),
  unit_group_name = paste("Group",
                          rep(1:5,
                              length.out = length(units_tmp)))
)
str(unit_df)

# Generate report as R string
report <- html_report(
  countcheck_list = list(
    list(df = countcheck_df, caption = "KPI 1")
  ),
  unit_df = unit_df,
  title = "Report",
  table_width_px = 500,
  column_headers = c(
    group = "Group",
    count = "Count",
    ucl = "UCL",
    unit = "Unit",
    name = "Name"),
  charset = "utf-8",
  lang = "en",
  home_url = "https://github.com/jmeydam/countcheck")

# Example code for saving HTML report to disk
sink("report.html")
cat(report)
sink()
