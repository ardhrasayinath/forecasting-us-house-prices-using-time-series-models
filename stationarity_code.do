*code for checking data&stationarity 
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

line (houseprice t),title("house price")
gen ln_hp = log(houseprice)
line ln_hp t,title("log house price")
ac ln_hp
pac ln_hp

dfuller ln_hp, trend regress lags(8)
dfuller ln_hp, trend regress lags(5)
* let's take difference instead (explore 2)
gen gr_hp = ln_hp-L.ln_hp
twoway tsline gr_hp,title("Difference house price")
* process is not as slow as it was
ac gr_hp,title("house price")
pac gr_hp,title("house price")
* both ac and pac decline quite fast, pac(1) is not 1
dfuller gr_hp, trend regress lags(8)
dfuller gr_hp, trend regress lags(1)

line propertytax t,title("propertytax")
ac propertytax,title("propertytax")
pac propertytax,title("propertytax")

dfuller propertytax, trend regress lags(8)
dfuller propertytax, trend regress lags(5)
* let's take difference instead (explore 2)
gen gr_prop = propertytax-L.propertytax
twoway tsline gr_prop,title("propertytax")
ac gr_prop,title("propertytax")
pac gr_prop,title("propertytax")
* both ac and pac decline quite fast, pac(1) is not 1
dfuller gr_prop, trend regress lags(8)
dfuller gr_prop, trend regress lags(4)

line delinquencyrate t,title("delinquencyrate")
ac delinquencyrate ,title("delinquencyrate")
pac delinquencyrate,title("delinquencyrate")

dfuller delinquencyrate,noconstant regress lags(8)
dfuller delinquencyrate,noconstant regress lags(6)
* let's take difference instead (explore 2)
gen gr_delin = delinquencyrate-L.delinquencyrate
twoway tsline gr_delin,title("Difference delinquencyrate")
ac gr_delin,title("delinquencyrate")
pac gr_delin,title("delinquencyrate")
* both ac and pac decline quite fast, pac(1) is not 1
dfuller gr_delin, noconstant regress lags(8)
dfuller gr_delin, noconstant regress lags(5)


