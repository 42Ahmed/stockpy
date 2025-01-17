# delimit ;
set more off;
set linesize 200;
clear all;
*************************************************************;
* Returns to Education Box in Chapter 8;
*************************************************************;
log using returns_to_education_box.log,replace;
***********************************;
* Read In Data; 
* (Note: Change path name so that it is appropriate for your computer);
use "/Users/mwatson/Dropbox/TB/4E/WebSupplements/ForStudents/SW_4E_ReplicationFiles/Replication_Data/ch8_cps.dta";
*;
keep if (age >= 30) & (age <= 64);
desc;
summarize ahe;
summarize age;
summarize yrseduc;
*;
gen lahe = ln(ahe);
gen fem_yrse = female*yrseduc;
gen male = 1-female;
gen male_yrse = male*yrseduc;
gen pexp = age - (yrseduc+6);
gen pexp_2 = pexp*pexp;
* Box in Chapter 8;
reg lahe yrseduc, robust;
dis "Adjusted Rsquared = " _result(8);
*;
reg lahe female yrseduc, robust;
dis "Adjusted Rsquared = " _result(8);
*;
reg lahe female yrseduc fem_yrse, robust;
dis "Adjusted Rsquared = " _result(8);
 test yrseduc fem_yrse;
*;
reg lahe male yrseduc male_yrse, robust;
*;
reg lahe female yrseduc fem_yrse pexp pexp_2
        midwest south west, robust;
dis "Adjusted Rsquared = " _result(8);
 test yrseduc fem_yrse;
 test pexp pexp_2;
*;
reg lahe male yrseduc male_yrse pexp pexp_2
        midwest south west, robust;
*************************************************************;
log close;
