## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  rf_user <- rfcores_old <- options()$rf.cores,
  options(rf.cores = 1)
)

## ----setup--------------------------------------------------------------------
# install.packages("devtools")
# devtools::install_github("dianashams/survcompare")
library(survcompare)


## ----example_simulated_1------------------------------------------------------

mydata <- simulate_linear()
mypredictors <- names(mydata)[1:4]

compare_models <- survcompare(mydata, mypredictors)
summary(compare_models)

# Other objects in the output object
names(compare_models)

## ----example_simulated_2------------------------------------------------------

mydata2 <- simulate_crossterms()
mypredictors2 <- names(mydata)[1:4]

compare_models2 <- survcompare(mydata2,mypredictors2)
summary(compare_models2)

## -----------------------------------------------------------------------------
# Test performance of the ensemble:
print(round(compare_models2$test$SRF_ensemble,4))

# Mean test performance of the Cox-PH and SRF ensemble:
print(round(compare_models2$results_mean,4))

# Main stats 
 round(compare_models2$main_stats,4)


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
#  survcompare(mygbsg, myfactors, randomseed = 42, repeat_cv = 5)
#  
#  # [1] "Cross-validating Cox PH model using 5 repeat(s), 3 outer, 3 inner loops)"
#  #   |===============================================================| 100%
#  # Time difference of 1.142473 secs
#  # [1] "Cross-validating CoxPH and SRF Ensemble using 5 repeat(s), 3 outer, 3 inner loops)"
#  #   |===============================================================| 100%
#  # Time difference of 49.34405 secs
#  #
#  # Internally validated test performance of CoxPH     and Survival Random Forest ensemble:
#  #                   T C_score AUCROC      BS BS_scaled Calib_slope
#  # CoxPH        4.1797  0.6751 0.7203  0.2182    0.1489      1.2529
#  # SRF_Ensemble 4.1797  0.6938 0.7279  0.2162    0.1567      1.3961
#  # Diff         0.0000  0.0187 0.0076 -0.0020    0.0078      0.1432
#  # pvalue          NaN  0.0000 0.0744  0.4534    0.0919      0.0229
#  #              Calib_alpha   sec
#  # CoxPH             0.4193  1.14
#  # SRF_Ensemble      0.4186 49.34
#  # Diff             -0.0007 48.20
#  # pvalue            0.5410   NaN
#  

## ----include = FALSE----------------------------------------------------------
# reinstating the value for rf.cores back to default/user-defined value
options(rf.cores = rfcores_old)


