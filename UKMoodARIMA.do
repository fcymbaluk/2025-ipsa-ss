* In this example we load in a data set and build ARIMA models of each of the variables.
* The two variables in this data set are:
* cgewap  which is a measure of civilian government employment as a percentage of the 
* working age population from the Comparative Welfare States data set.
* The second is a public opinion measure developed by Jim Stimson and his co-authors of 
* Left-Right Mood in the UK.
clear
cd "C:\Users\55119\Desktop\2025 Brazil TS and TSCS Instructors Folder\Module 1 TS TSCS\Labs\Day 3"
use "UKMood.dta"

tsset year

label variable cgewap "Civilian Government Employment %"

* We're going to set the scheme for graphs to s2 mono in order to better see the results
set scheme s2mono

* Let's start with cgewap.

* We'll begin with a graph:
twoway scatter cgewap year
tsline cgewap
* Did that look stationary to you?  Let's see what the Dickey-Fuller test says:
dfuller cgewap
dfuller cgewap, drift

* Let's look at the differenced series:
twoway scatter d.cgewap year, yline(0)
tsline d.cgewap, yline(0)

* Clearly this was a non-stationary process.  Let's see if the differenced series is stationary:
dfuller d.cgewap

* We are right on the borderline in the previous dfuller test.  Let's try a double difference:
dfuller d2.cgewap

tsline cgewap d.cgewap d2.cgewap, yline(0) legend(col(1))
tsline d.cgewap d2.cgewap, yline(0) legend(col(1))

* So, moving forward we have two rival models.  Let's look at how they each perform going forward.

* If we start with the first differenced series, we have a pdq of (?,1,?))
ac d.cgewap
pac d.cgewap
corrgram d.cgewap
* What do you see?  

* Starting with the double differenced series, we have a pdq of (?,2,?)
ac d2.cgewap
pac d2.cgewap

corrgram d2.cgewap

* Let's try a (1,1,0)
arima cgewap, arima(1,1,0) 

predict cgewap110_res, res
corrgram cgewap110_res

* One way to evaluate any time series model is to look at how good a job it does forecasting.
* Our first forecast is one where we use a single lag:
predict cgewap110_oneahead, y
label var cgewap110_oneahead "One-step prediction using (1,1,0) model"

* Another way to go about this is to do a forecast where we stop use the forecast values going forward:
predict cgewap110_dy1980, dynamic(1980) y
label var cgewap110_dy1980 "Dynamic Forecast from 1980 using (1,1,0) model"


twoway line cgewap year || line cgewap110_oneahead year || line cgewap110_dy1980 year, legend(col(1))


arima cgewap, arima(0,2,0) 

* Unfortunately we can't use the AIC or the BIC since our models have different numbers of observations. 
* In order to compare them, as with R-squared, we need to have the same n and the same dependent variable
* values.

predict cgewap020_res, res
corrgram cgewap020_res


* Let's look at forecasts:
predict cgewap020_oneahead, y
label var cgewap020_oneahead "One-step prediction using (0,2,0) model"

predict cgewap020_dy1980, dynamic(1980) y
label var cgewap020_dy1980 "Dynamic Forecast from 1980 using (0,2,0) model"

twoway line cgewap year || line cgewap020_oneahead year || line cgewap020_dy1980 year, legend(col(1))



* Now comparing the two one-step forecasts:
twoway line cgewap year || line cgewap110_oneahead year || line cgewap020_oneahead year, legend(col(1))

* and the two dynamic forecasts:
twoway line cgewap year || line cgewap110_dy1980 year || line cgewap020_dy1980 year, legend(col(1))

* Now it's your turn, let's see what you can do with the UK mood variable.
