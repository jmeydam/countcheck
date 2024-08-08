data {
  int units;
  array[units] int n;
  array[units] int y;
  real<lower=0> beta;
}

parameters {
  real<lower=0> alpha;
  vector<lower=0>[units] theta;
}

model {
  vector[units] lambda;
  alpha ~ normal(0, beta);
  theta[1:units] ~ normal(0, alpha);
  lambda[1:units] = [1:units] .* theta[1:units];
  y[1:units] ~ poisson(lambda[1:units]);
}

