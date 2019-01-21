**produces the numbers that, with some final manipulation by hand, go into tables 2 and 3
version 13.1
#delimit ;
clear;
set logtype text;
cap log close;
tempfile temp;
log using tables_2_3, replace;

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
**which has GBR as numeraire, renormalized in Table 2 to be the ring as a whole

gen dlncpi_icp=log(pli2011/pli2005)+log(xr2011/xr2005);
gen dlncpi=log(cpi_2011/cpi_2005);

gen ppp2005_table=ppp_uk2005;
gen ppp2011_table=ppp_uk;


list isocode ppp2005_table ppp2011_table xr2005 xr2011 dlncpi;



summ dlncpi if isocode=="GBR";
replace dlncpi=dlncpi-r(mean);

gen lnppp2011=log(ppp2011_table);
gen lnppp2005=log(ppp2005_table);

**converting currencies that changed;
replace lnppp2011=lnppp2011+log(15.6466) if isocode=="EST";
replace lnppp2011=lnppp2011+log(239.640) if isocode=="SVN";

gen dlnppp=lnppp2011-lnppp2005;
gen dlnp_icp=dlnppp;

gen c_key=0;
replace c_key=1 if isocode=="JPN"|isocode=="CHL"|isocode=="HKG"|isocode=="GBR"|isocode=="BRA"|isocode=="ZAF"|
	isocode=="EST"|isocode=="SVN";
table isocode, c(mean c_key);

regress dlnp_icp dlncpi if c_key==1;
predict phat1;
regress dlnp_icp dlncpi if c_key==0;
predict phat0;
gen dhat=phat1-phat0;
summ dhat;
drop phat1 phat0 dhat;

regress dlnp_icp dlncpi i.c_key;

replace c_key=0 if isocode=="ZAF";
regress dlnp_icp dlncpi if c_key==1;
predict phat1;
regress dlnp_icp dlncpi if c_key==0;
predict phat0;
gen dhat=phat1-phat0;
summ dhat;
drop phat1 phat0 dhat;

**Regression results appear in Table 3;


regress dlnp_icp dlncpi i.c_key;


regress dlnp_icp dlncpi if isocode=="JPN"|isocode=="CHL"|isocode=="HKG"|isocode=="GBR"|isocode=="BRA"|
	isocode=="ZAF"|isocode=="EST"|isocode=="SVN";
matrix b=e(b);
gen p_hat_1=b[1,1]*dlncpi+b[1,2];
regress dlnp_icp dlncpi if isocode~="JPN"&isocode~="CHL"&isocode~="HKG"&isocode~="GBR"&isocode~="BRA"
	&isocode~="ZAF"&isocode~="EST"&isocode~="SVN";
matrix b=e(b);
gen p_hat_2=b[1,1]*dlncpi+b[1,2];
replace p_hat_1=. if dlncpi >=0.5;


gen ccd=2;
replace ccd=1 if isocode=="JPN"|isocode=="CHL"|isocode=="HKG"|isocode=="GBR"|isocode=="BRA"|isocode=="ZAF"|isocode=="EST"|isocode=="SVN";

regress dlnp_icp dlncpi i.ccd;

log close;
