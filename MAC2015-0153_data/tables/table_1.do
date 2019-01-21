**Table 1 in the paper
**this is to compare revisions in 2005 with revisions in 2011, country by country

version 13.1
#delimit ;
clear;
cap log close;
set logtype text;
cap log using table_1, replace;
tempfile temp;

use ppp_rats_1993_2005;
keep isocode rat;
sort isocode;
save `temp', replace;

use ICP2011_WDI_compare;
sort isocode;
by isocode: keep if _n==1;

merge 1:1 isocode using `temp';


gen lnrat_11=log(rat_ICP_X);
gen lnrat_05=log(rat);
save `temp', replace;

keep if _m==3;



drop if isocode=="MAC"|isocode=="ZMB"|isocode=="POL";

regress lnrat_11 lnrat_05;
predict x11;
regress lnrat_11 lnrat_05, nocons;
predict x12;

drop if region=="2005";

preserve;
drop if region=="CAR";
drop if region=="SIG";

table region, c(mean lnrat_05 mean lnrat_11 count lnrat_05 count lnrat_11), if lnrat_05~=. & lnrat_11~=.;

table region, c(sd lnrat_05 sd lnrat_11), if lnrat_05~=. & lnrat_11~=.;

restore;

corr lnrat_11 lnrat_05;
	
use `temp', clear;

table region, c(mean lnrat_05 mean lnrat_11 count lnrat_05 count lnrat_11), if lnrat_05~=. & lnrat_11~=.;

table region, c(sd lnrat_05 sd lnrat_11), if lnrat_05~=. & lnrat_11~=.;

	
	
log close;
