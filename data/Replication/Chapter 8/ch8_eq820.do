# delimit ;
set more off;
set linesize 200;
clear all;
*************************************************************;
* Equation 8.20 in SW;
*************************************************************;
log using ch8_eq820.log,replace;
***********************************;
* Read In Data; 
use "/Users/mwatson/Dropbox/TB/4E/WebSupplements/ForStudents/SW_4E_ReplicationFiles/Replication_Data/ch8_cps.dta";
desc;
*************************************************************;
keep if (age >= 21) & (age <= 64);
keep if (yrseduc == 16);
gen lahe = ln(ahe);
summarize ahe age lahe, detail;
regress lahe age, robust;
dis "Adjusted Rsquared = " _result(8);
graph twoway scatter lahe age;
*************************************************************;
log close;
clear;