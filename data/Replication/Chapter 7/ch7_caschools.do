# delimit ;
set more off;
set linesize 200;
clear all;
*************************************************************;
*Replication program for Chapter 7 in SW 4E
* Caschool.do;
*************************************************************;
log using ch7_caschools.log,replace;
***********************************;
* Read In Data; 
use "/Users/mwatson/Dropbox/TB/4E/WebSupplements/ForStudents/SW_4E_ReplicationFiles/Replication_Data/caschool.dta";
*;
* Decription of Data;
* dist_code -- district Code;
* Read_scr  -- avg Reading Score;
* Math_scr  -- avg Math Score;
* County   --  county;
* District -- District;
* gr_span -- grade span of district;
* enrl_tot -- total enrollment;
* teachers -- number of teachers;
* computer -- number of computers;
* testscr -- avg test score (= (read_scr+math_scr)/2 );
* comp_stu -- computers per student ( = computer/enrl_tot);
* expn_stu -- expentitures per student;
* str -- student teacher ration (teachers/enrl_tot);
* el_pct -- percent of English Learners;
* Meal_pct -- Percent qualifying for reduced-price lunch;
* calw_pct -- Percent qualifying for CalWorks;
* avginc -- district average income (in $1000's);
**************************************************************;
***** Eq 7.5 ******
**************************************************************;
reg testscr str el_pct, r;
**************************************************************;
***** Eq 7.6 ******
**************************************************************;
replace expn_stu = expn_stu/1000;
reg testscr str expn_stu el_pct, r;
* Diplay Covariance Matrix;
vce;
* F-test reported in text;
test str expn_stu;
**************************************************************;
***** Eq 7.15 ******
**************************************************************;
reg testscr el_pct, r;
*************************************************************;
******* Correlations reported in text;
*************************************************************;
cor testscr str expn_stu el_pct meal_pct calw_pct;
*************************************************************;
******* Table 7.1;
*************************************************************;
* Column (1);
reg testscr str, r;
dis "Adjusted Rsquared = " _result(8);
* Column (2);
reg testscr str el_pct, r;
dis "Adjusted Rsquared = " _result(8);
* Column (3);
reg testscr str el_pct meal_pct, r;
dis "Adjusted Rsquared = " _result(8);
* Column (4);
reg testscr str el_pct calw_pct, r;
dis "Adjusted Rsquared = " _result(8);
* Column (5);
reg testscr str el_pct meal_pct calw_pct, r;
dis "Adjusted Rsquared = " _result(8);
*;
*************************************************************;
log close;
clear;