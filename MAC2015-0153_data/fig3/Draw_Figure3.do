**this draws Figure 3 in the paper, the CPI IPD comparison

version 13.1
#delimit ;
clear;
set logtype text;
cap log close;
log using Draw_figure3, replace;

use ipd_cpi;
drop if del==.;
count if del > 0;
count if del < 0;
list isocode lnp_cpi lnp_ipd del if del > 0.5;
list isocode lnp_cpi lnp_ipd del if del < -0.5;
list isocode lnp_cpi lnp_ipd del if isocode=="CHN"|isocode=="IND"|isocode=="IDN"|isocode=="NGA";

drop if del > 0.5;
drop if del < -0.5;

scatter del lny, ml(isocode)||scatter del lny if isocode=="IND", mc(gs4) msiz(huge)||scatter del lny if isocode=="CHN", mc(gs10) msiz(huge) saving(Figure3, replace) legend(off);


log close;
