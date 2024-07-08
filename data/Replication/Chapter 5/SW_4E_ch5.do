#delimit ;
clear ;
set more off;
set linesize 200;
*************************************************************;
* Replication program for Chapter 5 in Stock-Watson 4E
*************************************************************;
log using SW_4E_ch5.log,replace;
***********************************;
* Read In Data; 
* (Note: Change path name so that it is appropriate for your computer);
use "/Users/mwatson/Dropbox/TB/4E/WebSupplements/ForStudents/SW_4E_ReplicationFiles/Replication_Data/caschool.dta";
*;
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
* clw_pct -- Percent qualifying for CalWorks;
* aving -- district average income (in $1000's);

**************************************************************;
***** Equation 5.8 ******
**************************************************************;
reg testscr str, r;
**************************************************************;
***** Equation 5.18 ******
**************************************************************;
gen d = (str<20);
reg testscr d, r;
log close;
clear;