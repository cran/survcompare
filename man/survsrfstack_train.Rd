% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/survSRF_stack.R
\name{survsrfstack_train}
\alias{survsrfstack_train}
\title{Trains the stacked ensemble of the CoxPH and Survival Random Forest}
\usage{
survsrfstack_train(
  df_train,
  predict.factors,
  fixed_time = NaN,
  inner_cv = 3,
  randomseed = NaN,
  useCoxLasso = FALSE,
  tuningparams = list(),
  max_grid_size = 10,
  verbose = FALSE
)
}
\arguments{
\item{df_train}{data, "time" and "event" should describe survival outcome}

\item{predict.factors}{list of predictor names}

\item{fixed_time}{time at which performance is maximized}

\item{inner_cv}{number of cross-validation folds for hyperparameters' tuning}

\item{randomseed}{random seed to control tuning including data splits}

\item{useCoxLasso}{if CoxLasso is used (TRUE) or not (FALSE, default)}

\item{tuningparams}{if given, list of hyperparameters, list(mtry=c(), nodedepth=c(),nodesize=c()), otherwise a wide default grid is used}

\item{max_grid_size}{number of random grid searches for model tuning}

\item{verbose}{FALSE(default)/TRUE}
}
\value{
output = list(bestparams, allstats, model)
}
\description{
Trains the stacked ensemble of the CoxPH and Survival Random Forest
}
\examples{
d <-simulate_nonlinear(100)
p<- names(d)[1:4]
tuningparams = list(
 "mtry" = c(5,10,15),
 "nodedepth" = c(5,10,15,20),
 "nodesize" =    c(20,30,50)
)
m_srf<- survsrf_train(d,p,tuningparams=tuningparams)
}
