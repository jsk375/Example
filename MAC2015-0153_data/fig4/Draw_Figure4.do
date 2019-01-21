**For Figure 4 in the paper

version 13.1
#delimit ;
clear;
set logtype text;
cap log close;
tempfile temp;
log using Draw_Figure4, replace;

use icp_ring_cpi_xr;
keep isocode cpi_2011 cpi_2005;
sort isocode;
merge 1:1 isocode using world2011;
keep if _m==3;
drop _m;



**converting currencies that changed using the official factors at time of Euro adoption;

local fix_EST=15.6466;
local fix_SVN=239.640;

replace xr2011=xr2011*`fix_EST' if isocode=="EST";
replace xr2011=xr2011*`fix_SVN' if isocode=="SVN";

gen pli2011=ppp_uk/xr2011;
gen pli2005=ppp_uk2005/xr2005;


**First redoing the original analysis;

gen dlncpi_icp=log(pli2011/pli2005)+log(xr2011/xr2005);
gen dlncpi=log(cpi_2011/cpi_2005);

gen ppp2005_table=ppp_uk2005;
gen ppp2011_table=ppp_uk;

qui summ dlncpi if isocode=="GBR";
replace dlncpi=dlncpi-r(mean);

gen lnppp2011=log(ppp2011_table);
gen lnppp2005=log(ppp2005_table);

**converting currencies that changed;
replace lnppp2011=lnppp2011+log(15.6466) if isocode=="EST";
replace lnppp2011=lnppp2011+log(239.640) if isocode=="SVN";

gen dlnppp=lnppp2011-lnppp2005;
gen dlnp_icp=dlnppp;
gen lnppp_ex=lnppp2005+dlncpi;
gen del=lnppp2011-lnppp_ex;
sort del;

gen lnpli2011=log(pli2011);

gen lnpli_ex=lnppp_ex-log(xr2011);

sort isocode;
merge 1:1 isocode using WDI2007_PY_PCGDP;
keep if _m==3;
gen lny=ln(pc_GDP);

scatter del lny, ml(isocode);

regress del lny;
matrix b=e(b);
gen del_hat=b[1,1]*lny+b[1,2];
scatter del lny, ml(isocode)||line del_hat lny, lc(black) legend(off) saving(Figure4, replace);

log close;
