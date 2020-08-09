devtools::load_all()

random_seed <- 200807

d <- simulate_data(units = 1000, random_seed = random_seed)

# Add no-pooling estimate of theta to data frame
d <- add_theta_nopool(d)

# Add complete-pooling estimate of theta to data frame
d <- add_theta_complpool(d)

# Add partial-pooling estimate of theta to data frame
# (based on Bayesian hierarchical model)
d <- add_theta_partpool(d, random_seed = random_seed)

# Add "true" UCL to data frame
d <- add_ucl_true_theta(d)

# Add no-pooling UCL to data frame
d <- add_ucl_nopool(d)

# Add complete-pooling UCL to data frame
d <- add_ucl_complpool(d)

# Add partial-pooling UCL to data frame
# (based on Bayesian hierarchical model)
d <- add_ucl_partpool(d)

# Add fe (factor_exceeding) based on "true" UCL to data frame
d <- add_fe_true_theta(d)

# Add fe (factor_exceeding) based on no-pooling UCL to data frame
d <- add_fe_nopool(d)

# Add fe (factor_exceeding) based on complete-pooling UCL to data frame
d <- add_fe_complpool(d)

# Add fe (factor_exceeding) based on partial-pooling UCL to data frame
d <- add_fe_partpool(d)

str(d)
