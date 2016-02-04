*$INCLUDE ACCESS_HLC.gms

$include sort_lc_params.gms

parameter
         ELdiffGW(wstep,ELl,r) load difference due to introduction of wind capacity
         ELwindcap(wstep) regional wind capacity steps in GW
;

scalar delta_GW_wind size of wind capacity increment in GW /1/;
       ELwindcap(wstep) = delta_GW_wind*(ord(wstep));

$gdxin db\load.gdx
$load WRCFmonths
$load WRCFmonthavgon
$load WRCFmonthavgoff
$gdxin


WRCFmonths("GZ",hrs24,month) = WRCFmonths("GD",hrs24,month);
WRCFmonths("SC",hrs24,month) = WRCFmonths("GS",hrs24,month);
WRCFmonths("SD",hrs24,month) = WRCFmonths("JS",hrs24,month);
WRCFmonths("HA",hrs24,month) = WRCFmonths("HE",hrs24,month);

* no wind profile for central china!!!
WRCFmonths("HN",hrs24,month) = WRCFmonths("HE",hrs24,month);

* does nothing ....
*loop(r,
*         WRCFmonths(GB,hrs24,month)$(WRCFmonths(GB,hrs24,month)=0 and
*                 regions(r,GB) and WRCFmonths(r,hrs24,month)>0) =
*         WRCFmonths(r,hrs24,month);
*);


* aggregate capacity to new regional specifications
loop(GB,
WRCFmonths(r,hrs24,month)$(regions(r,GB) and WRCFmonths(GB,hrs24,month)>0)  = WRCFmonths(GB,hrs24,month);
WRCFmonthavgon(r,month)$(regions(r,GB) and smax(hrs24,WRCFmonths(GB,hrs24,month))>0)  = WRCFmonthavgon(GB,month);
WRCFmonthavgoff(r,month)$(regions(r,GB) and smax(hrs24,WRCFmonths(GB,hrs24,month))>0)  = WRCFmonthavgoff(GB,month);
);






$ontext

* rescale montly PROVINCIAL wind profiles to monthly averages from
* Gang He, Daniel M. Kammen - Where, when and how much wind is available? A provincial-scale wind resource assessment for China
* onshore averages

loop(month,loop(j$(ord(j)<=days(month)),loop(hrs24,

WRCFon(r,i)$(ord(i)=card(hrs24)*days_acc(month)+card(hrs24)*(ord(j)-1)+ord(hrs24)) =
         WRCFmonths(r,hrs24,month)/(sum((hhrs24),WRCFmonths(r,hhrs24,month))/card(hrs24))*WRCFmonthavgon(r,month);

);
););

$offtext



$ontext
loop(month,loop(hrs24,
WRCFon(r,i)$(ord(i)=(ord(month)-1)*card(hrs24)+ord(hrs24)) =
         WRCFmonths(r,hrs24,month)/(sum((hhrs24),WRCFmonths(r,hhrs24,month))/card(hrs24))*WRCFmonthavgon(r,month); ;
););
*$offtext

* offshore averages
loop(month,loop(hrs24,
WRCFoff(r,i)$(ord(i)=(ord(month)-1)*card(hrs24)+ord(hrs24)) =
         WRCFmonths(r,hrs24,month)/(sum((hhrs24),WRCFmonths(r,hhrs24,month))/card(hrs24))*WRCFmonthavgoff(r,month);
););
$offtext


$gdxin db\wind.gdx
$load WRCFon
$gdxin


* These values represent the r-specific LDCs.
parameter HLCi(i) initial regional load duration curve in GW for each load segment
          HLCf(i) final regional load duration curve in GW for each load segment
          HLCshift(r,wstep,i) final regional load duration curve in GW for each load segment
          HLCshift_rank(r,wstep,i) final regional load duration curve in GW for each load segment

          HLCi_rank(i)
          HLCf_rank(i)

          LDCi(ELl)
          LDCf(ELl)
          LDC2(r,wstep,ELl)
;

$gdxin db\LDC.gdx
$load HLC day_hrs
$gdxin


set ELren(r,wstep,wwstep) subsets to use for renewable equations in LDC shift equation;



loop(r,
*$Xinjiang(r)
*initialize original hourly load curve for sort_lc routine




         sort_lc_input(hrs) = HLC(r,hrs);
$include rank_lc.gms
$INCLUDE discretize_lc.gms
         LDCi(ELl) = sorted(ELl);
         HLCi_rank(rank) = hrs_rank(rank);

         HLCi(hrs + (hrs_rank(hrs)- ord(hrs))) =sort_lc_input(hrs);




*loop(wwstep$(ord(wwstep)=1 or smax(hrs,WRCFoff(r,hrs))>0),

loop(wstep$(smax(hrs,WRCFon(r,hrs))>0),
* only continue the loop if there is an onshore wind profile

         HLCshift(r,wstep,i) = HLCi(i);
         HLCshift_rank(r,wstep,i) = HLCi_rank(i);
         LDC2(r,wstep,ELl) = LDCi(ELl);


*         ELren(r,wstep,wwstep) = yes;
* subtract wind energy profiles from original HLC and sort
         sort_lc_input(hrs) = HLC(r,hrs) - WRCFon(r,hrs)*ELwindcap(wstep);
$INCLUDE rank_lc.gms
$INCLUDE discretize_lc.gms
         LDCf(ELl) = sorted(ELl);

         HLCf_rank(rank) = hrs_rank(rank);
         HLCf(hrs + (hrs_rank(hrs)- ord(hrs)))=sort_lc_input(hrs);


$ontext
*-WRCFoff(r,hrs)*ELwindcap('Windoff',wwstep);
*         sort_lc_input(hrs) = WRCFon(r,hrs)*ELwindcap('Windon',wstep)+WRCFoff(r,hrs)*ELwindcap('Windoff',wwstep);


loop(rank,
sort_lc_input(hrs)$(HLCi(hrs)>0) = HLCi(hrs)
         -HLCf(rank)$(HLCf_rank(rank)=HLCi_rank(hrs));
);

$offtext
if(smin(hrs,HLCf(hrs))>=0,
         sort_lc_input(hrs)$(HLCi(hrs)>0) = HLCi(hrs)-HLCf(hrs);
         hrs_rank(hrs) = ord(hrs);
$INCLUDE discretize_lc.gms
*         ELdiffGW(wstep,ELl,r) = (LDCi(ELl)-LDCf(ELl))*(1-(ord(wstep)-1)*1e-3)
         ELdiffGW(wstep,ELl,r) = sorted(ELl)*(1-(ord(wstep)-1)*1e-4);
else
         ELdiffGW(wstep,ELl,r) = 0;
);



*abort ELdiffGW, LDCi, LDCf;

*replace initial LDC with final LDC before next wind capacity increment
if( ord(wstep) < card(wstep),
         HLCi(hrs) = HLCf(hrs);
         HLCi_rank(hrs) = HLCf_rank(hrs);
         LDCi(ELl) = LDCf(ELl);
);


);
* close wstep loop

);
* close regional loop;


execute_unload "db\wind.gdx", ELdiffGW, WRCFon, WRCFoff;


*$offtext






