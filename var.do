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
