**Draws Figure 1 in the paper

version 10.1
#delimit ;
clear;
set logtype text;
cap log close;
log using draw_figure1, replace;

use ppp_1993_2005;
keep isocode ppp_c_2005 c_name;
sort isocode;
merge isocode using ppp_private_cons_wdi2008, unique;
keep if _m==3;
drop _m;

sort isocode;

gen rat=ppp_c_wdi2008/ppp_c_2005;
merge isocode using wdi2008_gdp, unique;
tab _m;
keep if _m==3;
drop _m;

drop gdp_2004 gdp_2006;

gen lny=log(real(gdp_2005));

scatter rat lny, ml("isocode") yline(1, lc(black)) xlabel(6(1)12) saving(Figure1, replace) legend(off);

log close;
