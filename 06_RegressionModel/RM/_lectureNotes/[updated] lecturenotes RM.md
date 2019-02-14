# Regression Model

## Before you begin
1. Read your data in and plot the relationship:
1.1 Linear Relationship (`cor()`)
1.2 Any Outliers
    - If Outliers: Are they entry error or are they genuine outliers
    - Regression models can be sensitive to outliers
    - `boxplot()` or `hist()` to get a sense of whether outliers exist; Use data visualization to help identify potentially anomalous values
    - Points that are very far away from the mean is said to have high leverage. If the point "exercised" that leverage, then it is said to have high "influence"
    - High influence: inclusion of that point changes your coefficient in a quite significant manner
    - `plot(model)` will generate 4 plots, which you can use in your diagnostic process

2. Inspecting your plot visually (`plot()`), you should have an idea of what the intercept and slope should be?

## Model Construction and prediction

3. Building your regression model and using it for prediction:

```r
# correlation
cor(copiers$Profit, copiers$Sales)
# creating a linear model
model <- lm(formula=Profit ~ Sales,
                   data=copiers)

# predict using the model
predict(model, Sales_today)

# check the coefficients
# should return two values: Intercept and Slope
model$coefficients
coef(model)

# get a condensed view of residuals, r-squared, statistical significance
summary(model)

# your error (error=residuals)
residuals(model)
```

## Core concepts

- $\hat{y} = \beta_0 + \beta_1 * x_1$
- Outliers: Leverage vs influence
- R-squared (takes a value between 0 and 1; The closer to 1 the better)
- Optional: The slope can be estimated using the
    `cor(y,x) * sd(y)/sd(x)`
    Using the slope, you can plug it into the y=mx+c substituting y and x for their respective means and this would yield the estimated intercept
- Sometimes you need an interval, and you can call `predict(model, data, interval="confidence", level=0.95)`
- We can use multiple X (predictor, dependent variables, features) in a regression model; The predictors don't need to be numeric. 

### Day 3 Concepts
- Regression can take categorical or numeric predictors. When categorical, it will transform that variable to extended columns (one-hot encoding) with n-1 levels
- Example:
Profit ~ Sales + Ship.Mode  
Supposed Ship.Mode have four levels: First Class, Same Day, Second Class, and Standard Class, when we call `lm()`, it would return:
    - beta0 (intercept)
    - beta1 (coefficient for Sales)
    - beta2 (coefficient for Same Day)
    - beta3 (coefficient for Second Class)
    - beta4 (coefficient for Standard Class)
    - For a transaction amount of 500, and Same Day shipment mode:
    Rating = beta0 + beta1 * 500 + beta2 * 1 +  beta3 * 0 + beta4 * 0
    - For a transaction amount of 500, and First Class:
    Rating = beta0 + beta1 * 500 + beta2 * 0 +  beta3 * 0 + beta4 * 0

- R-squared increase as we add more predictors, even though those predictors may not actually be useful; So we use adjusted R-squared, which penalize the R-squared based on number of predictors

- Feature Selection
    - Examples: Stepwise regression, All-possible-subset
    
- Your job is not done after you achieve a good model performance. 
- Check your residuals plot
- Check the histogram (should see a distribution that approximate normal) of your residuals
- Key Assumptions:
    - Linearity Assumption (does y and x scale linearly?) 
        -> `ggcorr()` 
            (high correlation implies good connection between x and y)
    - Multicollinearity (x1, x2..., x4 should have low to no correlation between each other). 
        -> `vif(model1)` 
            (no variable is more than 10)
    - `gvlma::gvlma(model)` (Global validation of linear model assumption)
        -> Global Stat (Linearity Assumption) - Are the relationships between your X predictors and Y roughly linear?. Rejection of the null (p < .05) indicates a non-linear relationship between one or more of your X’s and Y
        -> Skewness (Normality Assumption) - Is your distribution skewed positively or negatively, necessitating a transformation to meet the assumption of normality? Rejection of the null (p < .05) indicates that you should likely transform your data.
        -> Kurtosis (Normality Assumption) - Is your distribution kurtotic (highly peaked or very shallowly peaked), necessitating a transformation to meet the assumption of normality? Rejection of the null (p < .05) indicates that you should likely transform your data.
        -> Link Function - Is your dependent variable truly continuous, or categorical? Rejection of the null (p < .05) indicates that you should use an alternative form of the generalized linear model (e.g. logistic or binomial regression).
        -> Heteroscedasticity - Is the variance of your model residuals constant across the range of X (assumption of homoscedastiity)? Rejection of the null (p < .05) indicates that your residuals are heteroscedastic, and thus non-constant across the range of X. Your model is better/worse at predicting for certain ranges of your X scales.
