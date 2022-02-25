# Survival Analysis of Patients with Recurrent Bladder Cancer

This repository contains the data and our code files related to a project we have worked on, titled **"Survival Analysis of Patients with Recurrent Bladder Cancer"**.
 <br />   <br />
 The data comprised of 118 patients with bladder cancer, who have entered a study where they received 3 different kinds of treatments : 
 - placebo
 - pyridoxine
 - thiotepa
 
 Further down the study, some of them have observed multiple recurrences (upto 9), some have died,  and the rest have been censored.
  <br /> In this project, our main objectives have been :
 - Estimating the survival and hazard funtions 
   - without considering covariates (Kaplan-Meier estimator)
   - considering covariates (Cox Proportional Hazard estimator)
 - Frailty modelling (dealing with recurrent and hence, dependent survival times) 

We have made use of the Python library **lifelines** and the R package **survival** for our work, along with other necessary libraries for data analysis and visualisation.
