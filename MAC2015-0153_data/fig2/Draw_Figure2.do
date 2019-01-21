**this is to draw Figure 2 

version 13.1
#delimit ;
set logtype text;
clear;
cap log close;
log using Draw_Figure2, replace;

**data from ICP 2011 and from World Development Indicators;
use ICP2011_WDI_compare;
sort isocode;
by isocode: drop if _n>1;
**global_results_summary from zicP2011;

merge 1:1 isocode using global_results_summary;
drop _m;
gen lny=log(GDP_PC_PPP);

scatter rat_ICP_X lny if rat_ICP_X < 10 & isocode ~="LBR",  yline(1, lc(black)) ml(isocode) saving(Figure2, replace);


log close;
