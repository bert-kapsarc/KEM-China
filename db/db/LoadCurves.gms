*$INCLUDE ACCESS_sets.gms
*$INCLUDE ACCESS_HLC.gms

$include sort_lc_params.gms


$gdxin db\load.gdx
$load HLCmonths
$gdxin


set east(r);
        east('east')=yes;

parameter ELtransD(ELt,r,rr) existing transmission capacity in GW;


$ontext
* restructure Hourly load curves for a day in each month into a scalar array
* where all hours are represented in a single column
* also save the number of days corresponding to each hour
loop(month,loop(j$(ord(j)<=days(month)),loop(hrs24,

HLC(r,i)$(ord(i)=card(hrs24)*days_acc(month)+card(hrs24)*(ord(j)-1)+ord(hrs24)) = HLCmonths(r,hrs24,month) ;
day_hrs(i)$(ord(i)=card(hrs24)*days_acc(month)+card(hrs24)*(ord(j)-1)+ord(hrs24)) = days(month);
);
););
$offtext


$gdxin db\LDC.gdx
$load HLC day_hrs
$gdxin

$gdxin db\power.gdx
$load ELtransD
$gdxin

loop(r,
*$east(r),

*initiate load curve for sort_lc routine
sort_lc_input(hrs) = HLC(r,hrs)
$include rank_lc.gms
HLC_rank(r,hrs) = hrs_rank(hrs);
$include discretize_lc.gms
ELlcgw(r,ELl) =  sorted(ELl);

*abort ELlcgw, HLC_rank,sort_lc_input;

);

loop(r,
         loop(rr$(smax(ELt,ELtransD(ELt,r,rr))>0 and ord(r)<>ord(rr)),
$include ELtranscoef.gms

         );
);

Eltranscoef(ELl,ELl,r,r) = 1;

* !!! rescale LDC to GW from MW
         ELlcgw(r,ELl) = ELlcgw(r,ELl)

execute_unload "db\LDC.gdx", ELlcgw, HLC, day_hrs, days, days_acc, ELlchours, HLC_rank, UBELl, LBELl, ELtranscoef;





