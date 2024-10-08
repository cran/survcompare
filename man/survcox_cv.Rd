% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/survCoxPH.R
\name{survcox_cv}
\alias{survcox_cv}
\title{Cross-validates Cox or CoxLasso model}
\usage{
survcox_cv(
  df,
  predict.factors,
  fixed_time = NaN,
  outer_cv = 3,
  repeat_cv = 2,
  randomseed = NaN,
  return_models = FALSE,
  inner_cv = 3,
  useCoxLasso = FALSE,
  suppresswarn = TRUE
)
}
\arguments{
\item{df}{data frame with the data, "time" and "event" for survival outcome}

\item{predict.factors}{list of predictor names}

\item{fixed_time}{at which performance metrics are computed}

\item{outer_cv}{k in k-fold CV, default 3}

\item{repeat_cv}{if NULL, runs once, otherwise repeats CV}

\item{randomseed}{random seed}

\item{return_models}{TRUE/FALSE, if TRUE returns all CV objects}

\item{inner_cv}{k in the inner loop of k-fold CV, default is 3; only used if CoxLasso is TRUE}

\item{useCoxLasso}{TRUE/FALSE, FALSE by default}

\item{suppresswarn}{TRUE/FALSE, TRUE by default}
}
\value{
list of outputs
}
\description{
Cross-validates Cox or CoxLasso model
}
\examples{
\donttest{
df <- simulate_nonlinear()
coxph_cv <- survcox_cv(df, names(df)[1:4])
summary(coxph_cv)
}
}
