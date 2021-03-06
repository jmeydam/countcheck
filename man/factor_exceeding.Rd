% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ucls.R
\name{factor_exceeding}
\alias{factor_exceeding}
\title{Calculate by how many standard deviations \emph{y_new} exceeds upper
control limit (UCL)}
\usage{
factor_exceeding(theta_hat, n_new, y_new, ucl)
}
\arguments{
\item{theta_hat}{Estimate (unless known) of rate parameter \emph{theta}}

\item{n_new}{New value for exposure (reference counts), must at least be 1}

\item{y_new}{New count values of interest}

\item{ucl}{Upper control limit (UCL), must be greater than 0}
}
\value{
Factor \emph{f}, with observed \emph{y_new} exceeding UCL by
  \emph{f * sd(y_new)}
}
\description{
Calculates factor \emph{f}, with observed \emph{y_new} exceeding UCL by
\emph{f * sd(y_new)}. Returns negative value if observed \emph{y_new}
is lower than \emph{ucl}. Returns Inf if \emph{theta_hat} is 0.
}
\details{
Assuming a Poisson distribution with
\emph{lambda_hat = theta_hat * n_new},
the estimated standard deviation of \emph{y_new}
is \emph{sqrt(lambda_hat)}.
}
