# delimit ;
set more off;
set linesize 200;
clear all;
*************************************************************;
log using ch6_7_ex1_4.log,replace;
***********************************;
* Read In Data; 
use "/Users/mwatson/Dropbox/TB/4E/WebSupplements/ForStudents/SW_4E_ReplicationFiles/Replication_Data/cps15_ex_ch6_ch7.dta";
*;
*;
gen Northeast = (gereg == 1);
gen Midwest = (gereg == 2);
gen South = (gereg == 3);
gen West = (gereg == 4);
desc;
sum;
reg ahe bachelor female, robust;
dis "Adjusted Rsquared = " _result(8);
reg ahe bachelor female age, robust;
dis "Adjusted Rsquared = " _result(8);
reg ahe bachelor female age Northeast Midwest South, robust;
dis "Adjusted Rsquared = " _result(8);
test Northeast Midwest South;