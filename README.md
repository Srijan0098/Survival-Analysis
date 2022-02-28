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

We have made use of the Python library **lifelines** and the R packages **survival** and **frailtyEM** for our work, along with other necessary libraries for data analysis and visualisation.

## Basic Exploratory Data Analysis :

<p align="center">
  <img width="200" height="200"src="/plots/pie.png">
  <img width="300" height="200"src="/plots/bar1.png">
  <img width="250" height="200"src="/plots/box1.png"><br>
</p>
<p align="center">
  <img width="400" height="300"src="/plots/bar2.png"> <br>
</p>

Since some of the patients have suffered multiple recurrences, the original data has been divided in 2 parts to deal with single recurrences and multiple recurrences separately :
- 118 patients with only their first event/censoring times (independent time-to-event)
- the same 118 patients with all recurrence times (dependent time-to-event)

## First group analysis

### Kaplan-Meier Estimator :

The Kaplan–Meier estimator is a non-parametric statistic used to estimate the survival function from time-to-event data. The following is the Kaplan-Meier estimator of the patients grouped by the 3 treatment methods mentioned before. <br>
From the graph, we can conclude that 
1. the group on Pyridoxine has the highest median survival time among all patients
2. patients on Pyridoxine have a median survival time approximately 4 times greater than the patients on placebo
<p align="center">
  <img width="700" height="450"src="/plots/KM1.png"> <br>
</p>


Log-rank test is a a non-parametric test where the null hypothesis is that the hazard functions of the groups are similar in nature, against the alternate hypothesis that they are different.
The pairwise log-rank test between these 3 groups yield the following results:

| Log-Rank test between treatments | Test Statistic | p-value |
|----------|---------|-------|
| Placebo & Pyridoxine | 1.326279 | 0.249468 | 
| Placebo & Thiotepa | 1.520945 | 0.217477 |
| Pyridoxine & Thiotepa  | 0.001407 | 0.970077 |

The high p-value from the log-rank test between Pyridoxine and Thiotepa is indicative of the fact that their survival curves are not quite dissimilar, which is also clear from the graph above. The low p-value between placebo and the other 2 groups supports the fact that their survival curves deviate completely in later time points. <br>

Next we have thresholded on the number and size of tumours respectively, setting the threshold on the value for which the pairwise log-rank test gives the lowest p-value, which indicates that the two groups (post threshold) are the most dissimilar in terms of survival and hazard functions. The following are the Kaplan-Meier estimators of the patients grouped by the thresholded number and size of tumours respectively. From the graphs below, we can conclude that 
1. patients with less than 4 tumours have a median survival time approximately 7 times greater than those with greater than or equal to 4 tumours
2. patients whose size of the largest initial tumour was less than 6 cm have a median survival time approximately 4 times greater than the other group

<p align="left">
  <img width="400" height="250"src="/plots/KM2.png">
  <img width="400" height="250"src="/plots/KM3.png"> <br>
</p>

### Cox Proportional Hazard model :

In the previous section we have worked with the Kaplan-Meier estimator which does not take any covariates into consideration. In this section, we shall be modelling the survival functions by taking into account the 2 covariates - number and size of tumour into the model itself.

#### Cox proportional hazards assumptions:

Before modelling, we must check whether the covariates follow the Cox proportional hazard assumptions - that the hazards are proportional. This is achieved with the Schoenfeld residuals test, which plots the residual values of the covariates against time to look for time dependency.

<p align="center">
  <img width="550" height="400"src="/plots/coxph_assumption.png"> <br>
</p>

As we can clearly see, the covariate residuals do not exhibit any pattern, and are completely random, ie, time independent. Also, the p-values for both the covariates are greater than 0.05, hence both the covariates satisfy the proportional hazard assumption, and we can go ahead with modelling. 

#### Modelling the hazard functions :

<p align="left">
  <img width="250" height="200"src="/plots/placebo.png">
  <img width="250" height="200"src="/plots/pyridoxine.png">
  <img width="250" height="200"src="/plots/thietepa.png">
</p>
<p>&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; Placebo 
 &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; Pyridoxine 
 &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; Thiotepa</p>
 
 ## Second group analysis

Unlike the first group, the second group contains all recurrence times for individual patients with multiple recurrences.
<p align="center">
  <img width="600" height="400"src="/plots/group2.png"> <br>
</p>

### Frailty Modelling :

Cox proportional Hazard models are unable to capture the dependencies between the times-to-event (here, different recurrence times of the same patient). So, the Shared Frailty model has been used to model the hazard function of different treatment groups here. It has been assumed that the random variable Z follows Gamma Distribution with finite variance and mean 1, as we have used the multiplicative frailty modeling technique. <br>
<p align="center">
  <img width="600" height="500"src="/plots/gamma_frailty_summary.png"> <br>
</p>
<br>
Here we can see the summary of the fitted gamma shared frailty model. <br>

From the first part i.e. Regression Coefficients , we can conclude that

1. Keeping all other covariates unchanged, unit increase in the number of tumours and the maximum size of the tumours in the patient increases the hazard 1.3745 times and 1.0456 times respectively.
2. A patient with a constant number of tumours with constant maximum size is 1.0965 times as likely to die in Pyridoxine treatment as the same in Placebo treatment.
3.  A patient with a constant number of tumours with constant maximum size is 0.5115 times as likely to die in Thiotepa treatment as the same in Placebo treatment.

<p align="center">
  <img width="900" height="500"src="/plots/frailty_wrt_trt_both.png"> <br>
</p>
<p>&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; Placebo 
 &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; Pyridoxine 
 &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; Thiotepa</p>

These are the conditional and marginal survival curves (i.e. the expected survival over Z), predicted by the fitted gamma shared frailty model, for an individual with 1 tumour of size 1 cm with respect to all three different treatments. We can instantly conclude :

1. Median survival time for the patient under Placebo treatment : 20 months (approx)
2. Median survival time for the patient under Pyridoxine treatment : 18 months (approx)
3. Median survival time for the patient under Thiotepa treatment : 40 months (approx)

These values correspond to the exponential of coefficients, and this leads us to the conclusion that *“The treatment Thiotepa is almost 2 times more effective for Bladder cancer patients than Pyridoxine or Placebo.”* 
