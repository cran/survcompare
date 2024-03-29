% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/surv_SRF.R
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
  inner_cv = 3,
  randomseed = NULL,
  srf_tuning = list(),
  fast_version = TRUE,
  oob = TRUE,
  verbose = FALSE
)
}
\arguments{
\item{df_train}{data, "time" and "event" should describe survival outcome}

\item{predict.factors}{list of the column names to be used as predictors}

\item{fixed_time}{time at which performance is maximized}

\item{inner_cv}{k in k-fold CV for model tuning}

\item{randomseed}{random seed}

\item{srf_tuning}{list of mtry, nodedepth and nodesize, default is NULL}

\item{fast_version}{TRUE/FALSE, TRUE by default}

\item{oob}{TRUE/FALSE use out-of-bag predictions while tuning SRF instead of cross-validation, default is TRUE and is faster}

\item{verbose}{TRUE/FALSE, FALSE by default}
}
\value{
output = list(beststats, allstats, model)
}
\description{
Fits randomForestSRC, with tuning by mtry, nodedepth, and nodesize.
Underlying model is by Ishwaran et al(2008)
https://www.randomforestsrc.org/articles/survival.html
Ishwaran H, Kogalur UB, Blackstone EH, Lauer MS. Random survival forests.
The Annals of Applied Statistics. 2008;2:841–60.
}
