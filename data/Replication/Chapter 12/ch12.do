# delimit ;
set more off;
set linesize 200;
clear all;
*************************************************************;
* Replication program for Chapter 12 in SW 4E
*************************************************************;
log using ch12.log,replace;
***********************************;
* Read In Data; 
* (Note: Change path name so that it is appropriate for your computer);
use "/Users/mwatson/Dropbox/TB/4E/WebSupplements/ForStudents/SW_4E_ReplicationFiles/Replication_Data/cig_ch12.dta";
sort state year;
************************************************************;
gen ravgprs = avgprs/cpi;
 label var ravgpr "real average price during fiscal year, including sales taxes";
gen rtax = tax/cpi;
 label var rtax "real average Cig specifice tax during fiscal year";
gen rtaxs = taxs/cpi;
 label var rtaxs "real average total tax during fiscal year,including sales taxes";
gen rtaxso = rtaxs-rtax;
 label var rtaxso "real average sales tax per pack during fiscal year";
gen lpackpc = log(packpc);
gen lravgprs = log(ravgprs);
*;
* ---- Real Percapita State Income ;
gen perinc = income/(pop*cpi);
gen lperinc = log(perinc);
encode state, gen(snum);
* 10-year differences;
gen ltpackpc = log(packpc/packpc[_n-1]);
gen ltavgprs = log(ravgprs/ravgprs[_n-1]);
gen ltperinc = log(perinc/perinc[_n-1]);
gen dtrtaxs  = rtaxs-rtaxs[_n-1];
gen dtrtax   = rtax-rtax[_n-1];
gen dtrtaxso = rtaxso-rtaxso[_n-1];
keep if year==1995;
************************************************************;
* OLS and IV estimation - cross section -- 1995;
************************************************************;
* -- Equation (12.9);
reg lravgprs rtaxso, r;
* -- Equation (12.10) and (12.11);
* -- OLS -- Not Reported;
reg lpackpc lravgprs, r;
* -- IV -- Reported;
ivreg lpackpc (lravgprs = rtaxso), r;
* -- Equation (12.15) IV;
ivreg lpackpc (lravgprs = rtaxso) lperinc, r;
* -- Equation (12.16) IV;
ivreg lpackpc (lravgprs = rtaxso rtaxs) lperinc, r;
************************************************************;
* OLS and IV estimation - Differences 1995-1985;
* Table 12.1
************************************************************;
* -- OLS -- Not Reported;
reg ltpackpc ltavgprs ltperinc,r;
* col(1);
* -- IV -- Reported;
ivreg ltpackpc (ltavgprs = dtrtaxso)  ltperinc, r;
reg ltavgprs dtrtaxso ltperinc, r;
test dtrtaxso;
* -- IV -- Reported;
ivreg ltpackpc (ltavgprs = dtrtax)  ltperinc, r;
reg ltavgprs dtrtax ltperinc, r;
test dtrtax;
* -- IV -- Reported;
ivreg ltpackpc (ltavgprs = dtrtax dtrtaxso) ltperinc, r;
predict e, resid;
 reg e dtrtaxso dtrtax ltperinc; drop e;
 qui test dtrtaxso dtrtax;
    dis "---- OverID stat:  " r(df)*r(F)
     _skip(10) "p-value:  "  chiprob(r(df)-1,r(df)*r(F)) " -----";
reg ltavgprs dtrtax dtrtaxso ltperinc, r;
test dtrtax dtrtaxso;
log close;
