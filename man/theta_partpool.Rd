% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/models.R
\name{theta_partpool}
\alias{theta_partpool}
\title{Partial-pooling model (Bayesian hierarchical model)}
\usage{
theta_partpool(n, y, beta = 0.376, random_seed = 200731)
}
\arguments{
\item{n}{Previous reference count values (measure of exposure),
must at least be 1}

\item{y}{Previous count values of interest}

\item{beta}{Parameter for half-normal distribution of alpha
(default: 0.376, so that the expected value of alpha is 0.3)}

\item{random_seed}{Seed value for Stan (default: 200731)}
}
\value{
Partial-pooling estimates of \emph{theta}
}
\description{
The partial-pooling model can be seen as a compromise between the extremes
of the no-pooling and partial-pooling models. We do not treat all observed
data as coming from a homogeneous source, but we do assume that information
on other units can be useful for estimating \emph{theta_i} of a particular
unit \emph{i}, especially when there is little information for a particular
unit \emph{i}.
}
\details{
The partial-pooling model uses a hierarchical structure of probability
distributions. We will use the same types of distributions for this model
that we used for simulating the data.

In particular, we assume that each observational unit \emph{i} has a Poisson
distribution with parameter \emph{lambda_i}. \emph{lambda_i} is a product of
a rate parameter \emph{theta_i} and the exposure \emph{n_i}.

We use a half-normal distribution with a parameter \emph{alpha} for the rate
parameters \emph{theta_i}. This time, \emph{alpha} itself is also assumed to
have a probability distribution. We choose a half-normal distribution with
a parameter \emph{beta}. By default, \emph{beta} is set to 0.376, so that the
expected value of \emph{alpha} is 0.3.

Note that when simulating the data we set \emph{alpha} to 0.05. The "true"
value of \emph{alpha} is substantially lower than the default value
initially assumed by our model.

Given data in the form of reference counts \emph{n_i} (exposure) and count
values of interest \emph{y_i}, our model will allow us to determine a
posterior probability distribution both for the parameter \emph{alpha} and
for the rate parameters \emph{theta_i}.

We will use the mean of the \emph{theta} samples drawn from the posterior
distribution as the partial pooling estimate for \emph{theta}.

This function prints diagnostic information as a side effect.
}
