library(survival)
library(ggplot2)
library(ggpubr)
library(survminer)
library(dplyr)
library(frailtyEM)
library(egg)

group2 <- read.csv("/home/srijan/srijan_ds/Sem3/BDA_TSA/SurvivalAnalysis/Survival-Project/Project files/data/new_bladder1.csv")
View(group2)

# Basic Cleaning 

boxplot(size~treatment, data=group2, col="gold", main="size of the tumor w.r.t. treatment")
boxplot(number~treatment, data=group2, col="red", main="number of tumors w.r.t. treatment")

boxplot(group2$size, col="gold", main="size of the tumor")
boxplot(group2$number, col="red", main="number of the tumors")

remove_outlier <- function(data, col){
  Q <- quantile(col, probs=c(.25, .75), na.rm = FALSE)
  iqr <- IQR(col)
  up <-  Q[2]+1.5*iqr  # Upper Range  
  low<- Q[1]-1.5*iqr   # Lower Range
  eliminated<- subset(data, col > (Q[1] - 1.5*iqr) & col < (Q[2]+1.5*iqr))
  return(eliminated)
}

group21 <- remove_outlier(group2, group2$size)
group22 <- remove_outlier(group21, group21$number)

# Creating the survival object 

survobj <- with(group2, Surv(survtime, delta))
survobj1 <- with(group22, Surv(survtime, delta))

head(survobj1,80)

# Commenges-Andersen test for heterogeneity 

cox <- coxph(survobj1 ~ treatment + number + size + cluster(id), group22, model=TRUE, x=TRUE)
ca_test(cox)

# Shared frailty modelling for hidden dependencies 

gam <- emfrail(Surv(start, stop, delta) ~ number + size + treatment + cluster(id), 
               data = group22)
summary(gam)


p1 <- autoplot(gam, type = "pred", quantity = "survival", newdata = data.frame(treatment="placebo", number=median(bladder1$number), size=median(bladder1$size))) + ggtitle(paste0("placebo treated patient with ",median(group22$number, na.rm = TRUE)," tumors of highest size ",median(group22$size, na.rm = TRUE))) + guides(colour=FALSE)
p2 <- autoplot(gam, type = "pred", quantity = "survival", newdata = data.frame(treatment="pyridoxine", number=median(bladder1$number), size=median(bladder1$size))) + ggtitle(paste0("pyridoxine treated patient with ",median(group22$number, na.rm = TRUE)," tumors of highest size ",median(group22$size, na.rm = TRUE))) + guides(colour=FALSE)
p3 <- autoplot(gam, type = "pred", quantity = "survival", newdata = data.frame(treatment="thiotepa", number=median(bladder1$number), size=median(bladder1$size))) + ggtitle(paste0("thiotepa treated patient with ",median(group22$number, na.rm = TRUE)," tumors of highest size ",median(group22$size, na.rm = TRUE)))

pp <- ggarrange(p1,p2,p3, nrow = 1)


p1 <- autoplot(gam, type = "pred", type_pred = "marginal", quantity = "survival", newdata = data.frame(treatment="placebo", number=median(bladder1$number), size=median(bladder1$size))) + ggtitle(paste0("placebo treated patient with ",median(group22$number, na.rm = TRUE)," tumors of highest size ",median(group22$size, na.rm = TRUE))) + guides(colour=FALSE)
p2 <- autoplot(gam, type = "pred", type_pred = "marginal", quantity = "survival", newdata = data.frame(treatment="pyridoxine", number=median(bladder1$number), size=median(bladder1$size))) + ggtitle(paste0("pyridoxine treated patient with ",median(group22$number, na.rm = TRUE)," tumors of highest size ",median(group22$size, na.rm = TRUE))) + guides(colour=FALSE)
p3 <- autoplot(gam, type = "pred", type_pred = "marginal", quantity = "survival", newdata = data.frame(treatment="thiotepa", number=median(bladder1$number), size=median(bladder1$size))) + ggtitle(paste0("thiotepa treated patient with ",median(group22$number, na.rm = TRUE)," tumors of highest size ",median(group22$size, na.rm = TRUE)))

pp <- ggarrange(p1,p2,p3, nrow = 1)

# Predictions

dat_pred_pp <- data.frame(treatment = c("placebo", "pyridoxine"),
                         number=rep(median(bladder1$number),2), 
                         size=rep(median(bladder1$size), 2),
                         start = c(0, 10), stop = c(20, Inf))

dat_pred_pt <- data.frame(treatment = c("placebo", "thiotepa"),
                          number=rep(median(bladder1$number),2), 
                          size=rep(median(bladder1$size), 2),
                          start = c(0, 10), stop = c(20, Inf))

dat_pred_pt1 <- data.frame(treatment = c("placebo", "thiotepa"),
                          number=c(2,0), 
                          size=c(3,0),
                          start = c(0, 10), stop = c(20, Inf))
dat_pred_pp1 <- data.frame(treatment = c("placebo", "pyridoxine"),
                           number=c(2,0), 
                           size=c(3,0),
                           start = c(0, 10), stop = c(20, Inf))



autoplot(gam, type = "pred", quantity = "survival", newdata = dat_pred_pp)# + guides(colour=FALSE)
autoplot(gam, type = "pred", quantity = "survival", newdata = dat_pred_pt)# + guides(colour=FALSE)


autoplot(gam, type = "pred", newdata = dat_pred_pp, individual = TRUE)
autoplot(gam, type = "pred", newdata = dat_pred_pt, individual = TRUE)
autoplot(gam, type = "pred", quantity = "survival", newdata = dat_pred_pt1, individual = TRUE)
autoplot(gam, type = "pred", quantity = "survival", newdata = dat_pred_pp1, individual = TRUE)


newdata = data.frame(treatment="placebo", number=median(bladder1$number), size=median(bladder1$size))
predict(gam, newdata)

plot(predict(gam, newdata)$survival)
