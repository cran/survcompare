## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  rf_user <- rfcores_old <- options()$rf.cores,
  warnings_user<- options()$warn,
  scipen_user<- options()$scipen,
  digits_user<- options()$digits,
  options(rf.cores = 1),
  options(warn = -1),
  options(scipen = 100, digits = 4)
)


## ----setup--------------------------------------------------------------------
# For the main version:

# install.packages("devtools")
# devtools::install_github("dianashams/survcompare")

# DeepHit Extension:
# devtools::install_github("dianashams/survcompare", ref = "DeepHit")
library(survcompare)


## ----example_simulated_1------------------------------------------------------

mydata <- simulate_linear(200)
mypredictors <- names(mydata)[1:4]
survcompare(mydata, mypredictors, randomseed = 100)


## ----example_simulated_alternative, eval = FALSE------------------------------
#  #cross-validate CoxPH
#   cv1<- survcox_cv(mydata, mypredictors, randomseed = 100)
#  #cross-validate Survival Random Forests ensemble
#   cv2<- survsrfens_cv(mydata, mypredictors, randomseed = 100)
#  #compare the models
#   survcompare2(cv1, cv2)

## ----example_simulated_2------------------------------------------------------

mydata2 <- simulate_crossterms(200)
mypredictors2 <- names(mydata2)[1:4]

#cross-validate CoxPH
cv1 <- survcox_cv(mydata2, mypredictors2, randomseed = 100, repeat_cv = 3, useCoxLasso = TRUE)
# cross-validate Survival Random Forests ensemble
cv2 <- survsrf_cv(mydata2, mypredictors2, randomseed = 100, repeat_cv = 3)
# compare the models 
compare_nonl <- survcompare2(cv1, cv2)
compare_nonl

## -----------------------------------------------------------------------------
# Main stats 
compare_nonl$main_stats_pooled

# More information, including Brier Scores, Calibration slope and alphas can be seen in the
# compare_models_1$results_mean. These are averaged performance metrics on the test sets.
compare_nonl$results_mean


## ----example_simulated_alternative2-------------------------------------------
#cross-validate CoxPH
cv3<- survsrfstack_cv(mydata2, mypredictors2, randomseed = 100, repeat_cv = 3)
 
survcompare2(cv1, cv3)

## ----example_simulated_alternative3-------------------------------------------
# all tuned params
cv3$bestparams

lambdas <- unlist(cv3$bestparams$lambda)
print("Mean lambda in the stacked ensemble of the SRF and CoxPH, indicating the share of SRF predictions in the meta-learner:") 
print(mean(lambdas))

plot(lambdas)
abline(h=mean(lambdas), col = "blue")


## ----example_3_gbsg, eval = FALSE---------------------------------------------
#  library(survival)
#  
#  #prepare the data
#  mygbsg <- gbsg
#  mygbsg$time <- gbsg$rfstime / 365
#  mygbsg$event <- gbsg$status
#  myfactors <-
#    c("age", "meno", "size", "grade", "nodes", "pgr", "er", "hormon")
#  mygbsg <- mygbsg[c("time", "event", myfactors)]
#  sum(is.na(mygbsg[myfactors])) #check if any missing data
#  
#  # run survcompare
#  cv1<- survcox_cv(mygbsg, myfactors, randomseed = 42, repeat_cv = 3)
#  cv2<- survsrfens_cv(mygbsg, myfactors, randomseed = 42, repeat_cv = 3)
#  survcompare2(cv1, cv2)
#  

## ----include = FALSE----------------------------------------------------------
# reinstating the value for rf.cores back to default/user-defined value
options(rf.cores = rfcores_old)
options(warn = warnings_user)
options(digits = digits_user)
options(scipen = scipen_user)


