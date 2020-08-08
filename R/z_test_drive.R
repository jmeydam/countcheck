test_drive <- FALSE

if (test_drive) {

  random_seed = 200807

  # Simulate data for use in examples
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

  print("Counts exceeding UCLs")
  print("*********************")
  print(paste("ucl_true_theta:", sum(d$y_new - d$ucl_true_theta > 0)))
  print(paste("ucl_nopool:    ", sum(d$y_new - d$ucl_nopool > 0)))
  print(paste("ucl_complpool: ", sum(d$y_new - d$ucl_complpool > 0)))
  print(paste("ucl_partpool:  ", sum(d$y_new - d$ucl_partpool > 0)))

  d$fe_partpool <- factor_exceeding(theta_hat = d$theta_partpool,
                                    n_new = d$n_new,
                                    y_new = d$y_new,
                                    ucl = d$ucl_partpool)
  str(d)
  print(summary(d$fe_partpool))
}
