library(survival)
library(ggplot2)
library(ggpubr)
library(survminer)
library(dplyr)
library(Rcpp)

group1 <- read.csv('/home/srijan/srijan_ds/Sem3/BDA_TSA/SurvivalAnalysis/Survival-Project/Project files/data/first_group.csv')
View(group1)

# Cox PH model assumptions

## checking proportional hazard assumption (Schoenfeld Test)

SurvObject <- Surv(group1$time_to_first_event,group1$delta)
cox.mod <- coxph(SurvObject ~ number + size, data = group1)     # Build the coxph model
cox.zph(cox.mod)
ggcoxzph(cox.zph(cox.mod))

# Cox PH model

## placebo
placebo <- group1[group1$treatment == "placebo", ]
SurvObject_placebo <- Surv(placebo$time_to_first_event,placebo$delta)
cox.mod_placebo <- coxph(SurvObject_placebo ~ number + size, data = placebo)     # Build the coxph model
summary(cox.mod_placebo)

ggsurvplot(survfit(cox.mod_placebo,data = placebo), legend.labs=c("placebo"),
           color = 'brown3', surv.median.line = "hv",ggtheme = theme_minimal()) 

## pyridoxine
pyridoxine <- group1[group1$treatment == "pyridoxine", ]
SurvObject_pyridoxine <- Surv(pyridoxine$time_to_first_event, pyridoxine$delta)
cox.mod_pyridoxine <- coxph(SurvObject_pyridoxine ~ number + size, data = pyridoxine)     # Build the coxph model
summary(cox.mod_pyridoxine)

ggsurvplot(survfit(cox.mod_pyridoxine,data = pyridoxine), legend.labs=c("pyridoxine"),
           color = 'royalblue4', surv.median.line = "hv",ggtheme = theme_minimal())

## thiotepa
thiotepa <- group1[group1$treatment == "thiotepa", ]
SurvObject_thiotepa <- Surv(thiotepa$time_to_first_event,thiotepa$delta)
cox.mod_thiotepa <- coxph(SurvObject_thiotepa ~ number + size, data = thiotepa)     # Build the coxph model
summary(cox.mod_thiotepa)

ggsurvplot(survfit(cox.mod_thiotepa,data = thiotepa), legend.labs=c("thiotepa"),
           color = 'limegreen', surv.median.line = "hv",ggtheme = theme_minimal())

# baseline hazard
BaselineHazard=basehaz(cox.mod)
plot(BaselineHazard$time,BaselineHazard$hazard,type='s',xlab='Time',ylab='Baseline Hazard')
