#delimit ;
clear ;
set more 1;
set linesize 200;
*************************************************************;
* Replication program for Chapter 2 in SW4e;
* Bad Day on Wall Street Box;
*;
*************************************************************;
log using ch2_4e_djia_box.log, replace;
use "/Users/mwatson/Dropbox/TB/4E/WebSupplements/ForStudents/SW_4E_ReplicationFiles/Replication_Data/djia_daily.dta";
tsset date; sort date;
desc;
*************************;
* transformations;
*************************;
gen dpctchg = 100*(djia[_n]-djia[_n-1])/djia[_n-1];
************;
* tabulate extremes;
su dpctchg if tin(01jan1980,29sep2017);
sca vv = r(Var);
sca ss = sqrt(vv);
sca mm = r(mean);
gen dpctchg_std = (dpctchg-mm)/ss;
gen pnorm = 2*normal(-abs(dpctchg_std));
gen pnorm_app = exp(ln(2/sqrt(2*3.1416)) + (-0.5*dpctchg_std*dpctchg_std-ln(abs(dpctchg_std))));
sort pnorm;
list date djia dpctchg dpctchg_std pnorm pnorm_app in 1/100;
preserve;
 format date %tdMonthDDCCYY;
 format dpctchg dpctchg_std %9.1f;
 format pnorm %9.1e;
 list date dpctchg dpctchg_std pnorm in 1/10, noobs;
restore;
sort date;
*************************;
format date %tdCCYY;
twoway tsline dpctchg if tin(01jan1980,29sep2017),
    ylabel(-25(5)10)
    tlabel(01jan1980 01jan1985 01jan1990 01jan1995 01jan2000 01jan2005 
           01jan2010 01jan2015)
    ytitle("Daily percent change") ttitle("Year")
    s(.) c(l) saving(f2_7.gph,replace);
************************************************************;
log close;
clear;
