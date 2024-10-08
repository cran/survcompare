% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/survSRF.R
\name{survsrf_train}
\alias{survsrf_train}
\title{Fits randomForestSRC, with tuning by mtry, nodedepth, and nodesize.
Underlying model is by Ishwaran et al(2008)
https://www.randomforestsrc.org/articles/survival.html
Ishwaran H, Kogalur UB, Blackstone EH, Lauer MS. Random survival forests.
The Annals of Applied Statistics. 2008;2:841–60.}
\usage{
survsrf_train(
  df_train,
  predict.factors,
  fixed_time = NaN,
  tuningparams = list(),
  max_grid_size = 10,
  inner_cv = 3,
  randomseed = NaN,
  verbose = TRUE
)
}
\arguments{
\item{df_train}{data, "time" and "event" should describe survival outcome}

\item{predict.factors}{list of predictor names}

\item{fixed_time}{time at which performance is maximized}

\item{tuningparams}{if given, list of hyperparameters, list(mtry=c(), nodedepth=c(),nodesize=c()), otherwise a wide default grid is used}

\item{max_grid_size}{number of random grid searches for model tuning}

\item{inner_cv}{number of cross-validation folds for hyperparameters' tuning}

\item{randomseed}{random seed to control tuning including data splits}

\item{verbose}{TRUE/FALSE, FALSE by default}
}
\value{
output = list(bestparams, allstats, model)
}
\description{
Fits randomForestSRC, with tuning by mtry, nodedepth, and nodesize.
Underlying model is by Ishwaran et al(2008)
https://www.randomforestsrc.org/articles/survival.html
Ishwaran H, Kogalur UB, Blackstone EH, Lauer MS. Random survival forests.
The Annals of Applied Statistics. 2008;2:841–60.
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
