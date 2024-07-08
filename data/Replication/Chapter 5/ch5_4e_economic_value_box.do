#delimit ;
clear ;
set more off;
set linesize 200;
*************************************************************;
* Replication program for Chapter 5 in SW4E;
* Economic Value of Year of Education;
*;
*************************************************************;
log using ch5_4e_economic_value_box.log,replace;
set more 1;
***********************************;
* Read In Data; 
* (Note: Change path name so that it is appropriate for your computer);
use "/Users/mwatson/Dropbox/TB/4E/WebSupplements/ForStudents/SW_4E_ReplicationFiles/Replication_Data/ch5_cps_box";
*;
desc;
summ ahe, detail;
summ yrseduc, detail;
reg ahe yrseduc, robust;
predict t5;
predict u5, residual;
summ u5 if yrseduc==10;
summ u5 if yrseduc==12;
summ u5 if yrseduc==16;
scatter ahe yrseduc || lfit ahe yrseduc, ytitle("Average Hourly Earnings") xtitle("Years of Education");
*************************************************************;
* Save these data for plotting, etc.;
keep yrseduc ahe t5 ;
export excel figure_5_3.xlsx, firstrow(var) replace;
log close;
clear;