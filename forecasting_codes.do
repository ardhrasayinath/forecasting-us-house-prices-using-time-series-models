*code for forecasting,granger casuality,diebold marino test
clear
cd "/Users/ardhra/Desktop/"
import excel "ASPUS1.xls", sheet("ASPUS1") cellrange(A11:D147) firstrow
gen t = qofd(observation_date)
format t %tq
label variable t "date" 
drop observation_date
rename ASPUS houseprice
label variable houseprice " $"
rename S210400 propertytax
label variable propertytax "Millions $ "
rename DRC delinquencyrate
label variable delinquencyrate " percentage"
tsset t



gen ln_hp = log(houseprice)
gen gr_hp = d.ln_hp 
gen gr_pt = d.propertytax 
gen gr_del = d.delinquencyrate

* ARMA (0,0)--------------------------------------------------------------------
* 1. estimate arma(0,0) using estimation sample
arima ln_hp if t<q(2015.q2), arima(0,1,0) 
* I am estimating D.ln_price instead of gret because I want to forecast price level
* 2. check residuals
predict r, r
*twoway (line r date),
wntestq r
display "adj p-valu = " chi2tail(r(df)-0,r(stat))
* cannot reject that residuals are WN - good
* 3. do not have to check roots because there are none
* estat aroots
* 4. construct forecast
predict f, y
* transform from logs to price level 
gen fp = exp(f+1/2*e(sigma)^2)
* keep only forecasting sample 440-549
replace fp = . if t<q(2015.q2)
* check actual vs predicted using graph
* line (gprice fp t) if t>439
* generate D1 fp>p(t) 
gen D1 = 0
replace D1 = 1 if fp > L.houseprice
replace D1 = . if t<q(2015.q2)
* generate D2 p(t+1) > p(t) 
gen D2 = 0
replace D2 = 1 if houseprice > L.houseprice
replace D2 = . if t<q(2015.q2)
* generate D3 p(t+1) < p(t) 
gen D3 = 0
replace D3 = 1 if houseprice < L.houseprice
replace D3 = . if t<q(2015.q2)
* generate D4 fp<p(t) 
gen D4 = 0
replace D4 = 1 if fp < L.houseprice
replace D4 = . if t<q(2015.q2)
* generate loss
gen loss = -(D1*D2*(houseprice - L.houseprice))+D1*D3*(L.houseprice - houseprice)+D4*D2*(houseprice-L.houseprice)+D4*D3*0
gen lossss = -(D1*D2*(351145.94 - L.houseprice))+D1*D3*(L.houseprice - 351145.94)+D4*D2*(351145.94-L.houseprice)+D4*D3*0

gen losss = -(D1*D2*(351146.06 - L.houseprice))+D1*D3*(L.houseprice - 351146.06)+D4*D2*(351146.06-L.houseprice)+D4*D3*0
*-D(pf>pt)D(pt+1>pt)(pt+1-pt) D(pf>pt)D(pt+1<pt)(pt-pt+1) D(pt>pf)D(pt+1>pt)(pt+1-pt) D(pt>pf)*0*D(pt+1<pt)
* compute average loss
mean lossss if t>q(2015.q1)
* average Loss =  -5529.63 
* clean up
drop  f fp D3 D4 D1 D2 
drop r 

* ARMA (0,1)--------------------------------------------------------------------
* 1. estimate arma(0,1) using estimation sample
arima ln_hp if t<q(2015.q2), arima(0,1,1) 
predict r, r
*twoway (line r date),
wntestq r
display "adj p-valu = " chi2tail(r(df)-0,r(stat))
* cannot reject that residuals are WN - good
* 3. do not have to check roots because there are none
*estat aroots
* 4. construct forecast
predict f, y
* transform from logs to price level 
gen fp = exp(f+1/2*e(sigma)^2)
* keep only forecasting sample 440-549
replace fp = . if t<q(2015.q2)
* check actual vs predicted using graph
* line (gprice fp t) if t>439
* generate D1 fp>p(t) 
gen D1 = 0
replace D1 = 1 if fp > L.houseprice
replace D1 = . if t<q(2015.q2)
* generate D2 p(t+1) > p(t) 
gen D2 = 0
replace D2 = 1 if houseprice > L.houseprice
replace D2 = . if t<q(2015.q2)
* generate D3 p(t+1) < p(t) 
gen D3 = 0
replace D3 = 1 if houseprice < L.houseprice
replace D3 = . if t<q(2015.q2)
* generate D4 fp<p(t) 
gen D4 = 0
replace D4 = 1 if fp < L.houseprice
replace D4 = . if t<q(2015.q2)
* generate loss
gen loss1 = -(D1*D2*(houseprice - L.houseprice))+D1*D3*(L.houseprice - houseprice)+D4*D2*(houseprice-L.houseprice)+D4*D3*0
*-D(pf>pt)D(pt+1>pt)(pt+1-pt) D(pf>pt)D(pt+1<pt)(pt-pt+1) D(pt>pf)D(pt+1>pt)(pt+1-pt) D(pt>pf)*0*D(pt+1<pt)
* compute average loss
mean loss1 if t>q(2015.q1)
* average Loss = -2166.667 
* clean up
drop  r f fp D3 D4 D1 D2 

* ARMA (1,0)--------------------------------------------------------------------
* 1. estimate arma(1,0) using estimation sample
arima ln_hp if t<q(2015.q2), arima(1,1,0) 
* I am estimating D.ln_price instead of gret because I want to forecast price level
* 2. check residuals
predict r, r
*twoway (line r date),
wntestq r
display "adj p-valu = " chi2tail(r(df)-0,r(stat))
* cannot reject that residuals are WN - good
* 3. do not have to check roots because there are none
estat aroots
* 4. construct forecast
predict f, y
* transform from logs to price level 
gen fp = exp(f+1/2*e(sigma)^2)
* keep only forecasting sample 440-549
replace fp = . if t<q(2015.q2)
* check actual vs predicted using graph
* line (gprice fp t) if t>439
* generate D1 fp>p(t) 
gen D1 = 0
replace D1 = 1 if fp > L.houseprice
replace D1 = . if t<q(2015.q2)
* generate D2 p(t+1) > p(t) 
gen D2 = 0
replace D2 = 1 if houseprice > L.houseprice
replace D2 = . if t<q(2015.q2)
* generate D3 p(t+1) < p(t) 
gen D3 = 0
replace D3 = 1 if houseprice < L.houseprice
replace D3 = . if t<q(2015.q2)
* generate D4 fp<p(t) 
gen D4 = 0
replace D4 = 1 if fp < L.houseprice
replace D4 = . if t<q(2015.q2)
* generate loss
gen loss2 = -(D1*D2*(houseprice - L.houseprice))+D1*D3*(L.houseprice - houseprice)+D4*D2*(houseprice-L.houseprice)+D4*D3*0
*-D(pf>pt)D(pt+1>pt)(pt+1-pt) D(pf>pt)D(pt+1<pt)(pt-pt+1) D(pt>pf)D(pt+1>pt)(pt+1-pt) D(pt>pf)*0*D(pt+1<pt)
* compute average loss
mean loss2 if t>q(2015.q1)
* average Loss =  -2166.667 
* clean up
drop r f fp D3 D4 D1 D2 
drop r

* ARMA (1,1)--------------------------------------------------------------------
* 1. estimate arma(0,0) using estimation sample
arima ln_hp if t<q(2015.q2), arima(1,1,1) 
* I am estimating D.ln_price instead of gret because I want to forecast price level
* 2. check residuals
predict r, r
*twoway (line r date),
wntestq r
display "adj p-valu = " chi2tail(r(df)-0,r(stat))
* cannot reject that residuals are WN - good
* 3. do not have to check roots because there are none
*estat aroots
* 4. construct forecast
predict f, y
* transform from logs to price level 
gen fp = exp(f+1/2*e(sigma)^2)
* keep only forecasting sample 440-549
replace fp = . if t<q(2015.q2)
* check actual vs predicted using graph
* line (gprice fp t) if t>439
* generate D1 fp>p(t) 
gen D1 = 0
replace D1 = 1 if fp > L.houseprice
replace D1 = . if t<q(2015.q2)
* generate D2 p(t+1) > p(t) 
gen D2 = 0
replace D2 = 1 if houseprice > L.houseprice
replace D2 = . if t<q(2015.q2)
* generate D3 p(t+1) < p(t) 
gen D3 = 0
replace D3 = 1 if houseprice < L.houseprice
replace D3 = . if t<q(2015.q2)
* generate D4 fp<p(t) 
gen D4 = 0
replace D4 = 1 if fp < L.houseprice
replace D4 = . if t<q(2015.q2)
* generate loss
gen loss3 = -(D1*D2*(houseprice - L.houseprice))+D1*D3*(L.houseprice - houseprice)+D4*D2*(houseprice-L.houseprice)+D4*D3*0
*-D(pf>pt)D(pt+1>pt)(pt+1-pt) D(pf>pt)D(pt+1<pt)(pt-pt+1) D(pt>pf)D(pt+1>pt)(pt+1-pt) D(pt>pf)*0*D(pt+1<pt)
* compute average loss
mean loss3 if t>q(2015.q1)
* average Loss = -1862.963 
* clean up
drop  f fp D3 D4 D1 D2 
drop r

* ARMA (2,0)--------------------------------------------------------------------
* 1. estimate arma(0,0) using estimation sample
arima ln_hp if t<q(2015.q2), arima(2,1,0) 
* I am estimating D.ln_price instead of gret because I want to forecast price level
* 2. check residuals
predict r, r
*twoway (line r date),
wntestq r
display "adj p-valu = " chi2tail(r(df)-0,r(stat))
* cannot reject that residuals are WN - good
* 3. do not have to check roots because there are none
*estat aroots
* 4. construct forecast
predict f, y
* transform from logs to price level 
gen fp = exp(f+1/2*e(sigma)^2)
* keep only forecasting sample 440-549
replace fp = . if t<q(2015.q2)
* check actual vs predicted using graph
* line (gprice fp t) if t>439
* generate D1 fp>p(t) 
gen D1 = 0
replace D1 = 1 if fp > L.houseprice
replace D1 = . if t<q(2015.q2)
* generate D2 p(t+1) > p(t) 
gen D2 = 0
replace D2 = 1 if houseprice > L.houseprice
replace D2 = . if t<q(2015.q2)
* generate D3 p(t+1) < p(t) 
gen D3 = 0
replace D3 = 1 if houseprice < L.houseprice
replace D3 = . if t<q(2015.q2)
* generate D4 fp<p(t) 
gen D4 = 0
replace D4 = 1 if fp < L.houseprice
replace D4 = . if t<q(2015.q2)
* generate loss
gen loss4 = -(D1*D2*(houseprice - L.houseprice))+D1*D3*(L.houseprice - houseprice)+D4*D2*(houseprice-L.houseprice)+D4*D3*0
*-D(pf>pt)D(pt+1>pt)(pt+1-pt) D(pf>pt)D(pt+1<pt)(pt-pt+1) D(pt>pf)D(pt+1>pt)(pt+1-pt) D(pt>pf)*0*D(pt+1<pt)
* compute average loss
mean loss4 if t>q(2015.q1)
* average Loss =  -3503.704 
* clean up
drop f fp D3 D4 D1 D2 
drop r

* ARMA (0,2)--------------------------------------------------------------------
* 1. estimate arma(0,0) using estimation sample
arima ln_hp if t<q(2015.q2), arima(0,1,2) 
* I am estimating D.ln_price instead of gret because I want to forecast price level
* 2. check residuals
predict r, r
*twoway (line r date),
wntestq r
display "adj p-valu = " chi2tail(r(df)-0,r(stat))
* cannot reject that residuals are WN - good
* 3. do not have to check roots because there are none
*estat aroots
* 4. construct forecast
predict f, y
* transform from logs to price level 
gen fp = exp(f+1/2*e(sigma)^2)
* keep only forecasting sample 440-549
replace fp = . if t<q(2015.q2)
* check actual vs predicted using graph
* line (gprice fp t) if t>439
* generate D1 fp>p(t) 
gen D1 = 0
replace D1 = 1 if fp > L.houseprice
replace D1 = . if t<q(2015.q2)
* generate D2 p(t+1) > p(t) 
gen D2 = 0
replace D2 = 1 if houseprice > L.houseprice
replace D2 = . if t<q(2015.q2)
* generate D3 p(t+1) < p(t) 
gen D3 = 0
replace D3 = 1 if houseprice < L.houseprice
replace D3 = . if t<q(2015.q2)
* generate D4 fp<p(t) 
gen D4 = 0
replace D4 = 1 if fp < L.houseprice
replace D4 = . if t<q(2015.q2)
* generate loss
gen loss5 = -(D1*D2*(houseprice - L.houseprice))+D1*D3*(L.houseprice - houseprice)+D4*D2*(houseprice-L.houseprice)+D4*D3*0
*-D(pf>pt)D(pt+1>pt)(pt+1-pt) D(pf>pt)D(pt+1<pt)(pt-pt+1) D(pt>pf)D(pt+1>pt)(pt+1-pt) D(pt>pf)*0*D(pt+1<pt)
* compute average loss
mean loss5 if t>q(2015.q1)
* average Loss = -3466.667 
* clean up
drop f fp D3 D4 D1 D2 
drop r

* ARMA (2,2)--------------------------------------------------------------------
* 1. estimate arma(0,0) using estimation sample
arima ln_hp if t<q(2015.q2), arima(2,1,2) 
* I am estimating D.ln_price instead of gret because I want to forecast price level
* 2. check residuals
predict r, r
*twoway (line r date),
wntestq r
display "adj p-valu = " chi2tail(r(df)-0,r(stat))
* cannot reject that residuals are WN - good
* 3. do not have to check roots because there are none
*estat aroots
* 4. construct forecast
predict f, y
* transform from logs to price level 
gen fp = exp(f+1/2*e(sigma)^2)
* keep only forecasting sample 440-549
replace fp = . if t<q(2015.q2)
* check actual vs predicted using graph
* line (gprice fp t) if t>439
* generate D1 fp>p(t) 
gen D1 = 0
replace D1 = 1 if fp > L.houseprice
replace D1 = . if t<q(2015.q2)
* generate D2 p(t+1) > p(t) 
gen D2 = 0
replace D2 = 1 if houseprice > L.houseprice
replace D2 = . if t<q(2015.q2)
* generate D3 p(t+1) < p(t) 
gen D3 = 0
replace D3 = 1 if houseprice < L.houseprice
replace D3 = . if t<q(2015.q2)
* generate D4 fp<p(t) 
gen D4 = 0
replace D4 = 1 if fp < L.houseprice
replace D4 = . if t<q(2015.q2)
* generate loss
gen loss6 = -(D1*D2*(houseprice - L.houseprice))+D1*D3*(L.houseprice - houseprice)+D4*D2*(houseprice-L.houseprice)+D4*D3*0
*-D(pf>pt)D(pt+1>pt)(pt+1-pt) D(pf>pt)D(pt+1<pt)(pt-pt+1) D(pt>pf)D(pt+1>pt)(pt+1-pt) D(pt>pf)*0*D(pt+1<pt)
* compute average loss
mean loss6 if t>q(2015.q1)
* average Loss = -1185.185 
* clean up
drop f fp D3 D4 D1 D2 
drop r

* ARMA (3,0)--------------------------------------------------------------------
* 1. estimate arma(0,0) using estimation sample
arima ln_hp if t<q(2015.q2), arima(3,1,0) 
* I am estimating D.ln_price instead of gret because I want to forecast price level
* 2. check residuals
predict r, r
*twoway (line r date),
wntestq r
display "adj p-valu = " chi2tail(r(df)-0,r(stat))
* cannot reject that residuals are WN - good
* 3. do not have to check roots because there are none
*estat aroots
* 4. construct forecast
predict f, y
* transform from logs to price level 
gen fp = exp(f+1/2*e(sigma)^2)
* keep only forecasting sample 440-549
replace fp = . if t<q(2015.q2)
* check actual vs predicted using graph
* line (gprice fp t) if t>439
* generate D1 fp>p(t) 
gen D1 = 0
replace D1 = 1 if fp > L.houseprice
replace D1 = . if t<q(2015.q2)
* generate D2 p(t+1) > p(t) 
gen D2 = 0
replace D2 = 1 if houseprice > L.houseprice
replace D2 = . if t<q(2015.q2)
* generate D3 p(t+1) < p(t) 
gen D3 = 0
replace D3 = 1 if houseprice < L.houseprice
replace D3 = . if t<q(2015.q2)
* generate D4 fp<p(t) 
gen D4 = 0
replace D4 = 1 if fp < L.houseprice
replace D4 = . if t<q(2015.q2)
* generate loss
gen loss7 = -(D1*D2*(houseprice - L.houseprice))+D1*D3*(L.houseprice - houseprice)+D4*D2*(houseprice-L.houseprice)+D4*D3*0
*-D(pf>pt)D(pt+1>pt)(pt+1-pt) D(pf>pt)D(pt+1<pt)(pt-pt+1) D(pt>pf)D(pt+1>pt)(pt+1-pt) D(pt>pf)*0*D(pt+1<pt)
* compute average loss
mean loss7 if t>q(2015.q1)
* average Loss =  -4192.593
* clean up
drop f fp D3 D4 D1 D2 
drop r
* ARMA (0,0) is my best model--------------------------------------------------------------------
* 1. estimate arma(0,0) using estimation sample
arima ln_hp if t<q(2015.q2), arima(0,1,0) 
predict r, r
* 4. construct forecast
predict f, y
* transform from logs to price level 
gen fp = exp(f+1/2*e(sigma)^2)
* keep only forecasting sample 440-549
replace fp = . if t<q(2015.q2)
* generate D1 fp>p(t) 
gen D1 = 0
replace D1 = 1 if fp > L.houseprice
replace D1 = . if t<q(2015.q2)
* generate D2 p(t+1) > p(t) 
gen D2 = 0
replace D2 = 1 if houseprice > L.houseprice
replace D2 = . if t<q(2015.q2)
* generate D3 p(t+1) < p(t) 
gen D3 = 0
replace D3 = 1 if houseprice < L.houseprice
replace D3 = . if t<q(2015.q2)
* generate D4 fp<p(t) 
gen D4 = 0
replace D4 = 1 if fp < L.houseprice
replace D4 = . if t<q(2015.q2)
* generate loss
gen loss = -(D1*D2*(houseprice - L.houseprice))+D1*D3*(L.houseprice - houseprice)+D4*D2*(houseprice-L.houseprice)+D4*D3*0
* compute average loss
mean loss if t>q(2015.q1)
* average Loss =  -5529.63 


*=================================================================================
*                       Granger Causality      
*=================================================================================
* reduced form model
var gr_hp gr_pt gr_del if t<q(2015.q2), lags(1/6)
vargranger
*========================================================================
*========================================================================
* VAR
*========================================================================
* 0. choose lags
varsoc gr_hp gr_pt gr_del if t<q(2015.q2),  maxlag(6) 

* 1. estimation using training sample
var gr_hp gr_pt gr_del if t<q(2015.q2), lags(1/3)
* 2. stability check
*varstable, graph
* 3. constructing out-of-training-sample forecast
predict f2 if t>=q(2015.q2), xb equation(#1)
gen fp = L.houseprice*(1+f2)
line houseprice fp t
* keep only forecasting sample 110-136
replace fp = . if t<q(2015.q2)
* generate D1 fp>p(t) 
gen D1 = 0
replace D1 = 1 if fp > L.houseprice
replace D1 = . if t<q(2015.q2)
* generate D2 p(t+1) > p(t) 
gen D2 = 0
replace D2 = 1 if houseprice > L.houseprice
replace D2 = . if t<q(2015.q2)
* generate D3 p(t+1) < p(t) 
gen D3 = 0
replace D3 = 1 if houseprice < L.houseprice
replace D3 = . if t<q(2015.q2)
* generate D4 fp<p(t) 
gen D4 = 0
replace D4 = 1 if fp < L.houseprice
replace D4 = . if t<q(2015.q2)
* generate loss
gen lossv1 = -(D1*D2*(houseprice - L.houseprice))+D1*D3*(L.houseprice - houseprice)+D4*D2*(houseprice-L.houseprice)+D4*D3*0
mean lossv1 if t>q(2015.q1)
* average Loss =  -659.2593 
drop f2 fp D1 D2 D3 D4

* 1. estimation using training sample
var gr_hp gr_pt gr_del if t<q(2015.q2), lags(1/4)
* 2. stability check
*varstable, graph
* 3. constructing out-of-training-sample forecast
predict f2 if t>=q(2015.q2), xb equation(#1)
gen fp = L.houseprice*(1+f2)
line houseprice fp t
* keep only forecasting sample 110-136
replace fp = . if t<q(2015.q2)
* generate D1 fp>p(t) 
gen D1 = 0
replace D1 = 1 if fp > L.houseprice
replace D1 = . if t<q(2015.q2)
* generate D2 p(t+1) > p(t) 
gen D2 = 0
replace D2 = 1 if houseprice > L.houseprice
replace D2 = . if t<q(2015.q2)
* generate D3 p(t+1) < p(t) 
gen D3 = 0
replace D3 = 1 if houseprice < L.houseprice
replace D3 = . if t<q(2015.q2)
* generate D4 fp<p(t) 
gen D4 = 0
replace D4 = 1 if fp < L.houseprice
replace D4 = . if t<q(2015.q2)
* generate loss
gen lossv2 = -(D1*D2*(houseprice - L.houseprice))+D1*D3*(L.houseprice - houseprice)+D4*D2*(houseprice-L.houseprice)+D4*D3*0
mean lossv2 if t>q(2015.q1)
* average Loss =   -4488.889 
drop f2 fp D1 D2 D3 D4


* 1. estimation using training sample
var gr_hp gr_pt gr_del if t<q(2015.q2), lags(1/5)
* 2. stability check
*varstable, graph
* 3. constructing out-of-training-sample forecast
predict f2 if t>=q(2015.q2), xb equation(#1)
gen fp = L.houseprice*(1+f2)
line houseprice fp t
* keep only forecasting sample 110-136
replace fp = . if t<q(2015.q2)
* generate D1 fp>p(t) 
gen D1 = 0
replace D1 = 1 if fp > L.houseprice
replace D1 = . if t<q(2015.q2)
* generate D2 p(t+1) > p(t) 
gen D2 = 0
replace D2 = 1 if houseprice > L.houseprice
replace D2 = . if t<q(2015.q2)
* generate D3 p(t+1) < p(t) 
gen D3 = 0
replace D3 = 1 if houseprice < L.houseprice
replace D3 = . if t<q(2015.q2)
* generate D4 fp<p(t) 
gen D4 = 0
replace D4 = 1 if fp < L.houseprice
replace D4 = . if t<q(2015.q2)
* generate loss
gen lossv3 = -(D1*D2*(houseprice - L.houseprice))+D1*D3*(L.houseprice - houseprice)+D4*D2*(houseprice-L.houseprice)+D4*D3*0
mean lossv3 if t>q(2015.q1)
* average Loss =    -2992.593 
drop f2 fp D1 D2 D3 D4


* Diebold-Mariano Test 
*DM statistic
* 1. generate di
gen di =loss1- lossv2
* 2. check it's autocorrelation 
ac di
regress di
* t-stat is DM statistic with correct p-value  
* Conclusion:  VAR(3) is not statistically lower. 

drop di

* Diebold-Mariano Test 
*DM statistic
* 1. generate di
gen di =loss2- lossv2
* 2. check it's autocorrelation 
ac di
regress di
* t-stat is DM statistic with correct p-value  
* Conclusion:  VAR(3) is not statistically lower. 

drop di

* Diebold-Mariano Test 
*DM statistic
* 1. generate di
gen di =loss3- lossv2
* 2. check it's autocorrelation 
ac di
regress di
* t-stat is DM statistic with correct p-value   
drop di

* Diebold-Mariano Test 
*DM statistic
* 1. generate di
gen di =loss4- lossv2
* 2. check it's autocorrelation 
ac di
regress di
* t-stat is DM statistic with correct p-value   
drop di

* Diebold-Mariano Test 
*DM statistic
* 1. generate di
gen di =loss5- lossv2
* 2. check it's autocorrelation 
ac di
regress di
* t-stat is DM statistic with correct p-value   
drop di

* Diebold-Mariano Test 
*DM statistic
* 1. generate di
gen di =loss6- lossv2
* 2. check it's autocorrelation 
ac di
regress di
* t-stat is DM statistic with correct p-value   
drop di


* Diebold-Mariano Test 
*DM statistic
* 1. generate di
gen di =loss7- loss
* 2. check it's autocorrelation 
ac di
regress di
* t-stat is DM statistic with correct p-value   
drop di

* Diebold-Mariano Test 
*DM statistic
* 1. generate di
gen di =lossv1- loss
* 2. check it's autocorrelation 
ac di
regress di
* t-stat is DM statistic with correct p-value   
drop di

* Diebold-Mariano Test 
*DM statistic
* 1. generate di
gen di =lossv2- loss
* 2. check it's autocorrelation 
ac di
regress di
* t-stat is DM statistic with correct p-value   
drop di


* Diebold-Mariano Test 
*DM statistic
* 1. generate di
gen di =lossv3- loss
* 2. check it's autocorrelation 
ac di
regress di
* t-stat is DM statistic with correct p-value   
drop di

* Diebold-Mariano Test 
*DM statistic
* 1. generate di
gen di =lossa1- loss
* 2. check it's autocorrelation 
ac di
regress di
* t-stat is DM statistic with correct p-value   
drop di

* Diebold-Mariano Test 
*DM statistic
* 1. generate di
gen di =lossa3- loss
* 2. check it's autocorrelation 
ac di
regress di
* t-stat is DM statistic with correct p-value   
drop di

* ARMA (0,0)--------------------------------------------------------------------
* 1. estimate arma(0,0) using estimation sample
arima ln_hp if t<q(2015.q2), arima(0,1,0) 
gen se = e(sigma)
* I am estimating D.ln_price instead of gret because I want to forecast price level
* 2. check residuals
predict r, r
*twoway (line r date),
wntestq r
display "adj p-valu = " chi2tail(r(df)-0,r(stat))
* cannot reject that residuals are WN - good
* 3. do not have to check roots because there are none
* estat aroots
* 4. construct forecast
predict f, y
* transform from logs to price level 
gen fp = exp(f+1/2*e(sigma)^2)
* keep only forecasting sample 440-549
replace fp = . if t<q(2015.q2)
* produce 95% confidence intervals for one-step-ahead forecast
gen f_95l = fp-2*se
label variable f_95l "95% lower bound"

gen f_95u = fp+2*se
label variable f_95u "95% upper bound"

display "upper 95% bound =" f_95u[110]
display "lower 95% bound =" f_95l[110]




* check actual vs predicted using graph
* line (gprice fp t) if t>439
* generate D1 fp>p(t) 
gen D1 = 0
replace D1 = 1 if fp > L.houseprice
replace D1 = . if t<q(2015.q2)
* generate D2 p(t+1) > p(t) 
gen D2 = 0
replace D2 = 1 if houseprice > L.houseprice
replace D2 = . if t<q(2015.q2)
* generate D3 p(t+1) < p(t) 
gen D3 = 0
replace D3 = 1 if houseprice < L.houseprice
replace D3 = . if t<q(2015.q2)
* generate D4 fp<p(t) 
gen D4 = 0
replace D4 = 1 if fp < L.houseprice
replace D4 = . if t<q(2015.q2)
* generate loss
gen loss = -(D1*D2*(houseprice - L.houseprice))+D1*D3*(L.houseprice - houseprice)+D4*D2*(houseprice-L.houseprice)+D4*D3*0
*-D(pf>pt)D(pt+1>pt)(pt+1-pt) D(pf>pt)D(pt+1<pt)(pt-pt+1) D(pt>pf)D(pt+1>pt)(pt+1-pt) D(pt>pf)*0*D(pt+1<pt)
* compute average loss
mean loss if t>q(2015.q1)






























