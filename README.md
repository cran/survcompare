# R package "survcompare": 

**Comparing linear (Cox Proportionate Hazards model) and non-linear (Survival Random Forest) survival models to quantify predictive value of non-linear and interaction terms in the data.**

![image](https://github.com/dianashams/ensemble-methods-for-survival-analysis/blob/gh-pages/survcompare_cartoon.png)
### Method: 
The primary goal is to assist researchers in making informed decisions regarding whether they should choose a flexible yet less transparent machine learning approach or a traditional linear method. This is achieved by examining the presence of non-linear and interaction terms within the data and quantifying their impact on the models' performance. Using repeated nested cross-validation, the package:
  * Validates Cox Proportionate Hazards model, or Cox Lasso depending on the user's input. The underlying models are 'survival::coxph()' [1,2] or 'glmnet::glmnet(..., family="cox")'[3].
  * Validates Survival Random Forest ensembled with the baseline Cox model. The underlying Survival Random Forest model is 'randomForestSRC::rfsrc()' [4].
  * Performs statistical testing of whether the ensemble has outperformed the Cox model.

The performance metrics include [5]:
 * Discrimination measures: Harrell's concordance index, time-dependent AUCROC.
 * Calibration measures: calibration slope, calibration alpha.
 * Overall fit: Brier score, Scaled Brier score. 

NB: Survcompare is the first ensemble method described in https://dianashams.github.io/ensemble-methods-for-survival-analysis/ as published in Shamsutdinova, Stamate, Roberts, & Stahl (2022, June) [6]. 

### Getting started 
You can install the package from CRAN as `install.packages("survcompare")`, or from its github directory by running the `devtools::install_github("dianashams/survcompare")` command. The main function to use is `survcompare(data, predictors)`. The data should be in a form of a data frame, with "time" and "event" columns defining the survival outcome. A list of column names corresponding to the predictors to be used should also be supplied.

#### FAQ1: Why these (CoxPH and SRF) models? 
CoxPH model is a widely used survival model proved to be robust and easy to interprete. It assumes linear dependency of the log-hazards on the predictors; in its classical form, the effect of predictors is time-invariant which underlies the proportionality assumption. This  means that models' estimates are the averaged over time effects of predictors on the instant chances of survival. 

SRF is a machine learning algorithm that recursively splits the data into the sub-samples with similar survival profiles. It can deal with non-proportionate hazards and automatically captures non-linear and interaction terms, on top of the linear dependencies that CoxPH handles. However, it tends to overfit, and interpretation of radom forests' predictions is not straightforward especially for the survival data.

Given these qualities, SRF vs CoxPH's comparison is indicative of compex data dependencies, and quantifies the cost of using a simpler CoxPH model versus more flexible alternatives.

#### FAQ2: Why the ensemble and not just SRF? 
The ensemble of Cox and SRF takes the predictions of the Cox model and adds to the list of predictors to train SRF. This way, we make sure that linearity is captured by SRF at least as good as in the Cox model, and hence the marginal outperformance of the ensemble over the Cox model can be fully attributed to the qualities of SRF that Cox does not have, that is, data complexity.

#### FAQ3: How do I interpret and use the results? 
First, try to run sufficient number of repetitions (repeat_cv), at least 5, ideally 20-50 depending on the data heterogeneity and size.
There are two possible outcomes: "Survival Random Forest ensemble has outperformed CoxPH by ... in C-index", or "Survival Random Forest ensemble has NOT outperformed CoxPH". 
  * If there is **no outperformance**, this result can justify the employment of CoxPH model and indicate a negligible advantage of using a more flexible model such as Survival Random Forest.
  * In the case of **outperformance**, a researcher can 1) decide to go for a more complex model, 2) look for the interaction and non-linear terms that could be added to the CoxPH and re-run the test again, or 3) consider still using the CoxPH model if the difference is not large in the context of the performed task, or not enough to sacrifice model interpretability.

### Example:
The files in the "Example/" folder illustrate `survcompare`'s  application to the simulated and GBSG2  (https://rdrr.io/cran/pec/man/GBSG2.html) datasets. The outputs contain  internally-validated performance metrics along with the results of the statistical testing of whether Survival Random Forest outperforms the Cox Proportionate Hazard model (or Cox Lasso).  
```R
mydata <- simulate_crossterms()
mypredictors <- names(mydata)[1:4]
compare_models <- survcompare(mydata, mypredictors, predict_t = 10)

# [1] "Cross-validating Survival Random Forest - Cox model ensemble ( 5 repeat(s), 5 outer, 3 inner loops)"
# |========================================================================================| 100%
# Time difference of 1.574276 secs
# [1] "Cross-validating Survival Random Forest - Cox model ensemble ( 5 repeat(s), 5 outer, 3 inner loops)"
# |========================================================================================| 100%
# Time difference of 27.41951 secs
# 
# Internally validated test performance of CoxPH     and Survival Random Forest ensemble:
#                T C_score AUCROC      BS BS_scaled Calib_slope Calib_alpha   sec
# CoxPH         10  0.5937 0.6043  0.1341    0.1529      0.8507      0.1528  1.57
# SRF_Ensemble  10  0.7362 0.7548  0.1143    0.2773      0.9432      0.2123 27.42
# Diff           0  0.1425 0.1505 -0.0198    0.1244      0.0925      0.0595 25.85
# pvalue       NaN  0.0000 0.0000  0.0848    0.0000      0.2785      0.0958   NaN
# 
# Survival Random Forest ensemble has outperformed CoxPH    by 0.1425 in C-index.
# The difference is statistically significant with the p-value 0***.
# The supplied data may contain non-linear or cross-term dependencies, 
# better captured by the Survival Random Forest.
# C-score: 
#   CoxPH      0.5937(95CI=0.4171-0.7671;SD=0.1026)
# SRF_Ensemble 0.7362(95CI=0.646-0.8731;SD=0.062)
# AUCROC:
#   CoxPH      0.6043(95CI=0.4114-0.8046;SD=0.113)
# SRF_Ensemble 0.7548(95CI=0.6431-0.8717;SD=0.0668)

compare_models$main_stats

#                           mean         sd   95CILow  95CIHigh
# C_score_CoxPH        0.5936962 0.10258552 0.4171451 0.7671053
# C_score_SRF_Ensemble 0.7361651 0.06201633 0.6460198 0.8730571
# AUCROC_CoxPH         0.6042905 0.11296335 0.4113758 0.8046243
# AUCROC_SRF_Ensemble  0.7547585 0.06677083 0.6431052 0.8716964
```

### If you use the package or its code, please cite:
Shamsutdinova, D., Stamate, D., Roberts, A., & Stahl, D. (2022). Combining Cox Model and Tree-Based Algorithms to Boost Performance and Preserve Interpretability for Health Outcomes. In IFIP International Conference on Artificial Intelligence Applications and Innovations (pp. 170-181). Springer, Cham.

### Support or Contact
If you have any comments, suggestions, corrections or enchancements, kindly submit an issue on the
<https://github.com/dianashams/survcompare/issues> or email to diana.shamsutdinova.github@gmail.com.

### Disclaimer
This R package is offered free and without warranty of any kind, either expressed or implied. The package authors will not be held liable to you for any damage arising out of the use, modification or inability to use this program. This R package can be used, redistributed and/or modified freely for non-commercial purposes subject to the original source being properly cited. Licensed under GPL-3.

The authors received financial support by the National Institute for Health Research (NIHR) Biomedical Research Centre at South London and Maudsley NHS Foundation Trust and King’s College London. The views expressed are those of the author(s) and not necessarily those of the NHS, the NIHR or the Department of Health.

### Links and references: 
##### References:

[1] Cox, D. R. (1972). Regression models and life‐tables. Journal of the Royal Statistical Society: Series B (Methodological), 34(2), 187-202.

[2] Therneau T (2023). *A Package for Survival Analysis in R*. R package version 3.5-7, <https://CRAN.R-project.org/package=survival>.

[3] Simon N, Friedman J, Tibshirani R, Hastie T (2011). "Regularization Paths for Cox's Proportional Hazards Model via Coordinate Descent." *Journal of Statistical Software, 39(5)*, 1--13. <doi:10.18637/jss.v039.i05>.

[4] Ishwaran H, Kogalur U (2023). *Fast Unified Random Forests for Survival, Regression, and Classification (RF-SRC).* R package version 3.2.2, <https://cran.r-project.org/package=randomForestSRC>

[5] Steyerberg EW, Vergouwe Y. (2014). Towards better clinical prediction models: seven steps for development and an ABCD for validation. *European heart journal, 35(29)*, 1925-1931 <https://doi.org/10.1093/eurheartj/ehu207>

[6] Shamsutdinova, D., Stamate, D., Roberts, A., & Stahl, D. (2022, June). Combining Cox Model and Tree-Based Algorithms to Boost Performance and Preserve Interpretability for Health Outcomes. In IFIP International Conference on Artificial Intelligence Applications and Innovations (pp. 170-181). Cham: Springer International Publishing.
