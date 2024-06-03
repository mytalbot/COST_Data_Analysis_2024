#########################################
# Analysis of artificial Open Field data
# COST TEATIME @BfR (Berlin) 2024
# by Steven R. Talbot
#########################################

# Specify required packages -----------------------------------------------
library(ggplot2)
library(car)
library(emmeans)

# Load data from data folder ----------------------------------------------
raw        <- read.table(file="./data/OF_sim_data.txt")
raw$strain <- factor(raw$strain, levels=c("B6", "AJ"))

# inspect the data
head(raw, n=6)


# Visualize ---------------------------------------------------------------
plot(raw$time, raw$distance, pch=19, col=factor(raw$group))

plot(raw$time, raw$distance, pch=19, col=factor(raw$strain))


# Checking Assumptions ----------------------------------------------------

# Normality
qqnorm(raw$distance)
qqline(raw$distance)

# Homoscedasticity
bartlett.test(raw$distance ~raw$group)


# Linear fit --------------------------------------------------------------

# Note: I'm using fit every time the model is calculated. This will overwrite
# the last calculation.

### regular linear fit - group w/ two levels (Control and Amphetamine)
fit <- lm(distance ~ group, data=raw)
summary(fit)

plot(fit, which=2) # check residuals

### Linear model with time
fit <- lm(distance ~ time, data=raw)
summary(fit)

### Linear model with time as a factor (discrete time variable)
fit <- lm(distance ~ factor(time), data=raw)
summary(fit)

### Linear model with time AND group
fit <- lm(distance ~ time + group, data=raw)
summary(fit)

### Linear model with time and group interaction
fit <- lm(distance ~ time * group, data=raw)
summary(fit)

### Full linear model with time, group and strain interaction
fit <- lm(distance ~ time + group + strain + (time * group * strain), data=raw)
summary(fit)

plot(fit, which=2) # check QQplot
plot(resid(fit))   # check residuals

### distance is non-normally distributed
hist(raw$distance)

# easy solution to address non-normal (mostly log-normal DVs): log-transform
fit <- lm(log(distance) ~ time + group + strain + (time * group * strain), data=raw)
summary(fit)

plot(fit, which=2) # check QQplot
plot(resid(fit))   # check residuals


# Transforming the result into ANOVA format -------------------------------
Anova(fit, type="III")


# Working on interpretability ---------------------------------------------

### Mean-centering covariates for better interpretability

# compare the estimates of this...
fit       <- lm(distance ~ time, data=raw)
summary(fit)

# to this
fit       <- lm(distance ~ scale(time, scale=FALSE), data=raw)
summary(fit)

# graphical representation depends on what you want to show
ggplot(raw, aes(x=group, y=(distance), color=group)) +
  # geom_point()   +
  geom_boxplot() +
  facet_wrap(.~ strain) +
  theme_bw()


# Post hoc tests: which contrasts are different? --------------------------

### we are using the full model
fit <- lm(log(distance) ~ time + group + strain + (time * group * strain), data=raw)
summary(fit)

## what differences are there between groups within strains?
# exp(estimate) gives the factor of difference not the absolute difference!
emmeans(fit, pairwise ~ group | strain)$contrasts
exp(0.5722)

# How does group in one strain compare to group another strain?
emmeans(fit, pairwise ~ group * strain)$contrasts


# if you are interested in within time contrasts, you'll need factored time
fit <- lm(log(distance) ~
            factor(time) + group + strain + (factor(time) * group * strain), data=raw)
summary(fit)

emmeans(fit, pairwise ~ group * strain  | time )$contrasts

emmeans(fit, pairwise ~ group  | time )$contrasts


# Treatment vs control contrasts are also possible
emmeans(fit, trt.vs.ctrl ~ time)$contrasts

emmeans(fit, trt.vs.ctrl ~ time | strain * group)$contrasts





