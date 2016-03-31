* ELECTRICITY MODEL FOR CHINA
*use  gdx=ChinaPower   to write output to gdx file

$ontext
********************************************************************************
*$INCLUDE ACCESS_sets.gms
*$INCLUDE ACCESS_CO.gms
*$INCLUDE ACCESS_EL.gms
*$INCLUDE Macros.gms
*$INCLUDE SetsandVariables.gms
*$INCLUDE ScalarsandParameters.gms
*$INCLUDE RW_param.gms
*$INCLUDE coalsubmodel.gms
*$INCLUDE coaltranssubmodel.gms


*parameter ELCOconsump2(ELpd,cv,sulf,t,rr);
*Variables from other submodels that need to be exogenously fixed:
$gdxin integratedLP_p.gdx
*$load OTHERCOconsumpsulf coaluse COdem ELCOconsump2=ELCOconsump
*coalprod
$gdxin



********************************************************************************
*$offtext

*Variables from other submodels that have to be exogenously fixed:
$ontext
WAELsupply.fx(ELl,time,r)=0;
WAELpwrdemand.fx(time,r)=0;
WAELrsrvcontr.fx(time,r)=0;
WAELconsump.fx(ELl,time,r)=0;
RFELconsump.fx(ELl,time,r)=0;
CMELconsump.fx(ELlf,time,r)=0;
PCELconsump.fx(ELl,time,r)=0;
PCELpwrdemand.fx(time,r)=0;
$offtext


parameter ELfconsumpmax(ELf,time,rAll) fuel supply constraint;

$gdxin db\power.gdx
$load ELfconsumpmax
$gdxin

ELfconsumpmax(ELf,time,rAll) = ELfconsumpmax(ELf,'t12',rAll);

* Split  fuel allocation in western adn eastern Nei Mongol using GDP as weight
ELfconsumpmax(ELf,time,"NME") = ELfconsumpmax(ELf,time,"NM")*0.3;
ELfconsumpmax(ELf,time,"NM") =
         ELfconsumpmax(ELf,time,"NM")-
         ELfconsumpmax(ELf,time,"NME");

ELfconsumpmax(ELf,time,rAll) = ELfconsumpmax(ELf,time,rAll);

* Sum provinces into industrial regions
ELfconsumpmax(ELf,time,r)=sum(GB$regions(r,GB),
                        ELfconsumpmax(ELf,time,GB));

*        assume unlimited uranium supplies
         ELfconsumpmax('u-235',time,r)=50;

parameter ELAPf(f,fss,time,r) administered price of fuels;

*crude products in BBL (blue barrels, or 42 US gallons)
*refined products in tons
*methane in MMBTU
*coal in tons
*uranium in kg

         ELAPf('HFO',fss,time,r)=706;
         ELAPf('Diesel',fss,time,r)=845;
         ELAPf('lightcrude',fss,time,r)=100;

         ELAPf(f,fss,time,r) = ELAPf(f,fss,time,r)/RMBUSD('t12');

* nuclear fuel cost in 2012 RMB/g;
         ELAPf('u-235',fss,time,r) = 700;

* Gas fuel cost in 2012 RMB/MMBTU by regions
         ELAPf('Methane',fss,time,'North')= 89.52;
         ELAPf('Methane',fss,time,'COalC')= 79.00;
         ELAPf('Methane',fss,time,'Northeast')= 81.43;
         ELAPf('Methane',fss,time,'West')= 72.21;
         ELAPf('Methane',fss,time,'South')= 88.10;
         ELAPf('Methane',fss,time,'Southwest')= 81.43;
         ELAPf('Methane',fss,time,'East')= 94.00;
         ELAPf('Methane',fss,time,'Central')= 88.57;
         ELAPf('Methane',fss,time,'Sichuan')= 79.57;
         ELAPf('Methane',fss,time,'Henan')= 88.57;
         ELAPf('Methane',fss,time,'Shandong')= 89.14;
         ELAPf('Methane',fss,time,'Xinjiang')= 65.43;
         ELAPf('Methane',fss,time,'Tibet')= 83.79;

         ELAPf('Methane',fss0,time,'North')= 64.56;
         ELAPf('Methane',fss0,time,'COalC')= 54.75;
         ELAPf('Methane',fss0,time,'Northeast')= 54.45;
         ELAPf('Methane',fss0,time,'West')= 45.12;
         ELAPf('Methane',fss0,time,'South')= 73.88;
         ELAPf('Methane',fss0,time,'Southwest')= 56.29;
         ELAPf('Methane',fss0,time,'East')= 69.35;
         ELAPf('Methane',fss0,time,'Central')= 63.43;
         ELAPf('Methane',fss0,time,'Sichuan')= 55.10;
         ELAPf('Methane',fss0,time,'Henan')= 63.43;
         ELAPf('Methane',fss0,time,'Shandong')= 64;
         ELAPf('Methane',fss0,time,'Xinjiang')= 40.29;
         ELAPf('Methane',fss0,time,'Tibet')= 64.11;


Scalars
         ELreserve scale factor for reserve margin GW /1.1/
         ELwindspin fraction of wind gen defining spinning reserve  /0.2/
         ELusrfuelfrac ELfuelburn fraction for operating up spinning reserve /0.1/
         ELusomfrac cost fraction for operating up spinning reserve /0.1/
;

Parameter ELdiscfact(time) discount factors for electricity sector
          ELdiscoef1(ELp,trun), ELdiscoef2(trun);

*        Capital costs will be discounted at 6% annually.
         scalar ELdiscountrate discount rate for electricity sector /0.06/;
;

Parameter
         ELwindcap(wstep) regional wind capacity steps (in GW)
         ELdiffGW(wstep,ELl,r) load difference due to introduction of wind capacity
;


$gdxin db\wind.gdx
$load ELwindcap
$load ELdiffGW
$gdxin

Parameter ELhydhrs(r) Hydro operational hours calculated using 10 years of production and capacity data from IHS
         /
         North           353
         CoalC           1247
         Northeast       1619
         East            3352
         Central         4264
         Shandong        144
         Henan           2505
         South           3315
         Sichuan         5498
         Southwest       4035
         Tibet           4755
         West            3605
         Xinjiang        4264
         /
;

*$gdxin db\power.gdx
*$load ELhydhrs
*$gdxin

* !!!    rescale hours by 1000 to and output GWh to TWh
         ELhydhrs(r) = ELhydhrs(r)/1000;


parameter
         ELomcst(ELp,v,r) non-fuel variable O&M cost in RMB per MWh (2012);


         ELomcst(ELpcoal,v,r)    =24;
         ELomcst('Hydrolg',v,r)  =27;
         ELomcst('HydroROR',v,r) =27.36;
         ELomcst('HydroSto',v,r) =26;
         ELomcst('Nuclear','old',r) =56.8;
         ELomcst('Nuclear','new',r) =74.6;

         ELomcst('Nuclear','new',r) =38;

         ELomcst('windon','new',r) =24;
* !!!    Nuclear omcst from Yuan 38


         ELomcst('ST',v,r)       =15;
         ELomcst('GT',v,r)       =30;
         ELomcst('CC',v,r)       =26;
         ELomcst('CCcon',v,r)    =26;

parameter
         ELfixedOMcst(ELp) Fixed O&M cost RMB per KW (2012)
*        values from WEIO 2014
/

*         ST       25
*         GT       43.2
*         CC       26
*         GTtoCC   26
*         CCcon    26

         ST       110
         GT       110
         CC       115
         GTtoCC   115
         CCcon    115

         Windon   220
         Windoff  978

         SubcrSML    195
         SubcrLRG    130
         Superc      130
         Ultrsc      130

*         Subcr    388
*         Superc   391
*         Ultrsc   394


*        check these values with Yiyi
*         Nuclear  504.8
*         PV       115
*         Hydrolg  246.09
*         Hydrosto 258.71
*         HydroROR 265

* !!!    From Jiahai
         Hydrolg  332
         Hydrosto 93
         HydroROR 265
         Nuclear  457.2


         PV       115
/
;



parameter
         ELexist(ELp,v,size,chp,Rall) existing capacity in GW
         ELhydexist(ELp,r) existing hydro capacity by type from IHS GW
         ELwindexist(r) existing hydro capacity by type from IHS GW
         ELcapfac(Elp,v) observed capacity factor of power plants
         ELnoxexist(ELp,v,size,chp,Rall) nox existing capacity in GW
         ELfgdexist(ELp,v,size,chp,Rall) fgd existing capacity in GW
         ELhydroCEIC(rAll) existing hydro capacity by type from IHS GW


         ELcntrhrs(ELp,v,trun,r)
;
         ELcapfac(Elpd,v)=1;

*        Estimate from South China Grid 2011 Statistics report 79%
*        From IHS Electricity data
         ELcapfac(Elpnuc,v)=0.892;

*        Assumption on annual hydro maintenance down time
         ELcapfac(Elphyd,v)=0.94;

         ELcntrhrs(Elpcoal,v,trun,r) = 0;


$gdxin db\power.gdx
$load ELexist ELhydexist ELwindexist ELfgdexist ELnoxexist ELhydroCEIC
$gdxin






* !!!    aggregated provincial capacity to models grid regions
ELexist(Elp,v,size,chp,r) = sum(GB$regions(r,GB),ELexist(Elp,v,size,chp,GB));
ELhydroCEIC(r) = sum(GB$regions(r,GB),ELhydroCEIC(GB));
ELfgdexist(Elp,v,size,chp,r) = sum(GB$regions(r,GB),ELfgdexist(Elp,v,size,chp,GB));
ELnoxexist(Elp,v,size,chp,r) = sum(GB$regions(r,GB),ELnoxexist(Elp,v,size,chp,GB));


parameter ELcapital(ELp,r) Capital cost of equipment RMB per KW (2012);
*values from WEIO 2014 converted to RMB, inflated to 2012 (These values are
*from 2012, so no inflation conducted)

         ELcapital('ST',r)       =4750    ;
         ELcapital('GT',r)       =2210  ;
         ELcapital('CC',r)       =3470.5  ;
         ELcapital('GTtoCC',r)   =1200 ;


         ELcapital('CCcon',r)       =3410    ;
         Elcapital('SubcrLRG',r)    =4057  ;
         Elcapital('SubcrSML',r)    =4400  ;
         Elcapital('Subcr',r)       =4000  ;

         ELcapital('Superc',r)      =4417  ;
         ELcapital('Ultrsc',r)      =5048  ;

*         ELcapital('Windon',r)   =7500  ;
         ELcapital('Windon',r)   =8000  ;
         ELcapital('Windoff',r)  =28016.4  ;

         ELcapital('Hydrolg',r)  = 10727 ;
         ELcapital('HydroROR',r) = 13377.2  ;
*        Look into hydro storage capital costs for future development
         ELcapital('Hydrosto',r) = 4000 ;


*         ELcapital('Nuclear_G2',r) =14104.5 ;
*        Capital cost of generation three plant
         ELcapital('Nuclear',r) = 12600 ;
*         ELcapital('Nuclear',r) = 16000 ;

         parameter
         ELpurcst(ELp,trun,r) Cost of purchasing equipment USD per kW
         ELconstcst(ELp,trun,r) Local construction etc. costs USD per kW;

         ELpurcst(ELp,trun,r) = 0.8*ELcapital(ELp,r);
         ELconstcst(ELp,trun,r) = 0.2*ELcapital(ELp,r);
;

parameters ELlifetime(ELp) Lifetime of plant in units of t
/
         ST       20
         GT       20
         CC       20
         GTtoCC   20
         CCcon    20
         Nuclear  30
         PV       20
         Hydrolg  40
         Hydrosto 25
         HydroROR 40
         Windon   20
         Windoff  20
         Subcr 20
/
;
         ELlifetime(ELpcoal)=20;

parameter ELleadtime(ELp) Lead time for plant construction units of t
/
         ST       0
         GT       0
         CC       0
         GTtoCC   0
         CCcon    0
         Nuclear  0
         PV       0
         Hydrolg  0
         HydroROR 0
         Windon   0
         Windoff  0
/
;
         ELleadtime(ELpcoal) = 0;


parameter ELfgcleadtime(fgc)
/
         DeSOx    0
         DeNOx    0
/


         ELCOcvthreshold(Elpd) lower threshold on a coal plants blended CV. Calorific vaolue normalized to SCE
/
         Ultrsc   4000
/
;
         ELCOcvthreshold(Elpd) = ELCOcvthreshold(Elpd)/7000;



table ELcapadd(ELpp,ELp) a factor for adding capacity (only applicable to dispatchable tech)
*We estimate the conversion from GTtoCC adds 50% more capacity based on data on page 5-5 of KFUPM report.
                    GT     CCcon

         GTtoCC     -1     1.5
         ;

         ELcapadd(ELpd,ELpd)$( not ELpgttocc(ELpd)) = 1;
         ELcapadd('CCcon','CCcon') = 0;


$ontext
table ELfgcadd(ELpp,fgc) a factor for adding capacity (only applicable to dispatchable tech)
*We estimate the conversion from GTtoCC adds 50% more capacity based on data on page 5-5 of KFUPM report.
                   noDeSOx     DeSOx

         DeSOx     -1          1.5
         ;

         ELfgcadd(ELpp,ELpp)$( not ELpgttocc(ELpp)) = 1;
         ELfgcadd('CCcon','CCcon') = 0;
$offtext
parameter
         Eltransyield(ELt,r,rr) net of transmission and distribution losses
         ELtransexist(ELt,r,rr) existing transmission capacity in GW
         ELtranscoef(ELl,ELll,r,rr) load step coefficients for inter regional electricity transmission
         ELtransdata(time,r,rr) reported interregional transmission data
         ELtransD(ELt,r,rr) distance in KM of existing or proposed interregional lines

*ELtransconstcst and Eltranspurcst are discounted at 6% over a 30-year liftime.
         ELtransconstcst(ELt,time,r,rr) construction cost of transmission capacity in RMB per kW
         ELtranspurcst(ELt,time,r,rr) purchase cost of transmission capacity in RMB per kW
         ELtransomcst(ELt,r,rr)  oper. and maint. cost in RMB per MWH
         ELtransleadtime(r,rr)  lead time for building transmission cap
;

scalar ELhydstoeff efficiency of pumped hydro storage /0.9/
;


$gdxin db\power.gdx
$load ELtransexist ELtransdata ELtransD
$gdxin

$gdxin db\LDC.gdx
$load ELtranscoef
$gdxin

         ELtransdata('t12',r,rr) =ELtransdata('t11',r,rr);

*         ELtransexist('HVAC',r,rr)$(ELtransexist('HVAC',rr,r)>0)
*                 = ELtransexist('HVAC',rr,r);

         ELtransexist('HVAC',r,r) = 1e9;

         loop(rr,
                 ELtransD('UHVDC',r,rr)$(ELtransD('UHVDC',rr,r)>0) = 0
         );


         set ELtransr(ELt,r,rr);
          ELtransr(ELt,r,rr)$(ELtransD(ELt,r,rr)>0) = yes ;

         ELtransr('HVAC',r,r) = yes;

* !!! Approximate transmission losses of UHVDC lines at 10%/1000KM

         Eltransyield('HVAC',r,rr)$ELtransr('HVAC',r,rr) =
                 (1- 0.1/1000*ELtransD('HVAC',r,rr));

         Eltransyield('HVAC',r,r) = 0.94;
* !!!    Transmission loss data From Southern Power Grid yearbook 2012
*        Weighted average transmission loss rate in Guangdong and Guanxi
         Eltransyield('HVAC','South','South') = 0.95;
*        Weighted average transmission loss rate in Guizhou and Yunan
         Eltransyield('HVAC','Southwest','Southwest') = 0.93;

         Eltransyield('HVAC','central','east')=0.94;

* !!! Approximate transmission losses of UHVDC lines at 3.5%/1000KM
         Eltransyield('UHVDC',r,rr)$ELtransr('UHVDC',r,rr) =
                 1- 0.035/1000*ELtransD('UHVDC',r,rr);


*         execute_unload "db\ELtransyield.gdx", ELtransyield;

*         ELtranscoef(ELl,ELll,r,rr) = 0;
*         ELtranscoef(ELl,ELl,r,rr)$(smax(ELt,Eltransyield(Elt,r,rr))>0) = 1;


* !!!    update transmission costs
         ELtransconstcst('HVAC',time,r,rr)$ELtransr('HVAC',r,rr)=1757.9;
         ELtransconstcst('UHVDC',time,r,rr)$ELtransr('UHVDC',r,rr)=1600;


         ELtransconstcst(ELt,time,r,rr)$ELtransr(ELt,r,rr)=
                 ELtransconstcst(ELt,time,r,rr)*ELtransD(ELt,r,rr)/1e6;
         ELtranspurcst(ELt,time,r,rr)$ELtransr(ELt,r,rr)=0;


         ELtransomcst(ELt,r,r)=15;

* !!!    Scale interregional transmission costs based on approsx distances
*        Use as starting reference the tariff between Henan and Eastern region (
*        15 RMB/MWH over distance of 651 km

         ELtransomcst(ELt,r,rr)$(ord(r) <> ord(rr) and ELtransr(ELt,r,rr))=
                 ELtransomcst(ELt,r,r)+
                 (ELtransD(ELt,r,rr)-300)*(42-14)/
                 (3000-300)
*                 /651+ELtransomcst(ELt,rr,rr)
;


         ELtransleadtime(r,rr) = 0 ;
;

parameter
         Elpeff(ELp,v) fuel efficiency
         ELfuelburn(ELp,v,f,r) fuel required per MWh (coal ton - methane mmbtu - HFO&LFO ton)

         ELparasitic(Elp,v) net producton resulting from parasitic load for various generators

         ELpCOparas(Elp,v,sulf,sox,nox,r) parasitic load of operating fgc in MWh per metric ton of coal consumption in SCE
;

*        coal efficiency rate, from WEIO
         Elpeff('SubcrLRG',v)      = 0.37;
         Elpeff('SubcrSML',v)      = 0.32;
         Elpeff('Superc',v)        = 0.41;
         Elpeff('Ultrsc',v)        = 0.45;

* !!!    Efficiency penalty for older coal plants
*        Assume 1.5% heat rate degredation on old vintage plants
         ELpeff(ELpcoal,vo)         = ELpeff(ELpcoal,'new')*(1-0.015);

*        using 3.412 mmbtu/MWh and WEIO efficiencies for China
         ELfuelburn('ST',v,'methane',r)          = 8.949;
         ELfuelburn('GT',v,'methane',r)          = 9.222;
         ELfuelburn('CC',v,'methane',r)          = 5.883;
         ELfuelburn('CCcon',v,'methane',r)       = 6;

*        fuel efficiency of power plants
         Elpeff('ST',v)           = 0.38;
         Elpeff('GT',v)           = 0.37;
         Elpeff('CC',v)           = 0.58;
         Elpeff('CC',vo)          = 0.55;
         Elpeff('CCcon',v)        = 0.55;
*       Nuclear efficiency rate, from WEIO
         Elpeff(Elpnuc,v)       = 0.33;


*        24 MWH per gram u-235
         ELfuelburn('Nuclear',v,'u-235',r)       = 1/24;

*        c power planet gross therma efficiency rate from WEIO
         ELfuelburn(ELpcoal,v,ELfcoal,r) =
                 FuelperMWH(ELfcoal)/Elpeff(ELpcoal,v);

         ELfuelburn(ELpnuc,v,ELfnuclear,r) =
                 FuelperMWH(ELfnuclear)/Elpeff(ELpnuc,v);
*         ELfuelburn('GT',v,ELf,r)$(not ELfng(ELf))=0;
         ELfuelburn(ELpog,v,ELfref,r) =
                 FuelperMWH(ELfref)/Elpeff(ELpog,v);
         ELfuelburn(ELpog,v,'lightcrude',r) =
                 FuelperMWH('lightcrude')/Elpeff(ELpog,v);

*         ELfuelburn(ELpd,v,f,cv,r)=ELfuelburn(ELpd,v,f,cv,r);

*        remove plants with no fuelburn value from ELpELf and ELpfss union sets
         ELpELf(Elpd,ELf)$(smax((v,r),Elfuelburn(ELpd,v,ELf,r))<=0)= no;
         ELpfss(ELpd,ELf,fss)$(smax((v,r),Elfuelburn(ELpd,v,ELf,r))<=0) = no;


* !!!    Define parasitic loads
         ELparasitic(Elp,v)     = 1;
         ELparasitic(Elpcoal,v) = 1-0.02 ;
         ELparasitic('SubcrSML',v) = 1-0.07 ;
         ELparasitic(Elpog,v)   = 1-0.05 ;
         ELparasitic(Elphyd,v)  = 1-0.01;
         ELparasitic(Elpnuc,v)  = 1-0.05;

         ELpCOparas(Elpcoal,v,sulf,sox,nox,r)$(ELfuelburn(ELpcoal,v,'coal',r)>0) =
         EMfgcpower(sulf,sox,nox)/ELfuelburn(ELpcoal,v,'coal',r);


* !!!    Demand Data

* These values represent the r-specific LDCs.
parameters
         ELlcgw(rr,ELl) regional load in GW for each load segment in ELlchours
         ELlcgwsales(rr,ELl) regional load for grid sales in GW for each load segment in ELlchours
         ELlcgwonsite(rr,ELl) regional load for on site generation in GW for each load segment in ELlchours
         ELlcgwonsitebase(rr) regional baseload onsite site generation in GW
         ELdemandonsite(trun,r)
         ELdemand(trun,rr)  total power demand in each region (used to asses the onsite generation requirements)

/
         t12.North           467.45
         t12.CoalC           317.75
         t12.Northeast       396.98
         t12.East            1208.55
         t12.Central         372.07
         t12.Shandong        379.46
         t12.Henan           274.77
         t12.South           598.09
         t12.Sichuan         255.37
         t12.Southwest       236.26
         t12.Tibet           0
         t12.West            340.53
         t12.Xinjiang        109.08
/

         ELexistonsite(trun,r) percentage of onsite generation capacity
/
         t12.North           0.0197
         t12.CoalC           0.0422
         t12.Northeast       0.0464
         t12.East            0.0503
         t12.Central         0.0379
         t12.Shandong        0.1256
         t12.Henan           0.0380
         t12.South           0.0529
         t12.Sichuan         0.0192
         t12.Southwest       0.0006
         t12.Tibet           0
         t12.West            0.0750
         t12.Xinjiang        0.0606
/
;

$gdxin db\LDC.gdx
$load ELlcgw
$gdxin

*$INCLUDE flatten_peak.gms

         ELlcgwsales(r,ELl) = ELlcgw(r,ELl)
                 *4178/sum((rr,ELll),ELlcgw(rr,ELll)*ELlchours(ELll));


         ELlcgwonsite(r,ELl)$(sum(ELll,ELlcgw(r,ELll))>0) = (ELlcgw(r,ELl) - ELlcgwsales(r,ELl)/0.905)

*         375*
*                 1/sum(ELll,ELlchours(ELll))*
*                 sum((ELll),ELlcgw(r,ELll)*ELlchours(ELll))/sum((rr,ELll),ELlcgw(rr,ELll)*ELlchours(ELll))
*                 ELexistonsite('t12',r)/sum(rr,ELexistonsite('t12',rr))
*                 ELlcgw(r,ELl)/sum((ELll),ELlcgw(r,ELll)*ELlchours(ELll))
;
         ELlcgwonsitebase(r)= 0.3;

parameter
         ELdemgro(ELl,time,r) Electricity demand growth rate relative to initial condition  ;
         ELdemgro(ELl,time,r)=1$rdem_on(r);


* !!!     Fix intial cpaacpity levels.


         Elexistcp.up(ELpd,v,trun,r)$(ord(trun)=1 and not ELpcoal(Elpd))=
                 sum((chp,size),ELexist(ELpd,v,size,chp,r));


         Elexistcp.up(ELpog,v,trun,r)$(ord(trun)=1 and Xinjiang(r))=
                 sum((chp,size),ELexist(ELpog,v,size,chp,r))*1.6;

         Elexistcp.up('SubcrSML',v,trun,r)$(ord(trun)=1)=
                 sum((chp),ELexist('Subcr',v,'small',chp,r));
         Elexistcp.up('SubcrLRG',v,trun,r)$(ord(trun)=1)=
                 sum((chp),ELexist('Subcr',v,'large',chp,r));

         Elexistcp.up('Subcr',v,trun,r)$(ord(trun)=1)=
                 sum((size,chp),ELexist('Subcr',v,size,chp,r));

         Elexistcp.up('Superc',v,trun,r)$(ord(trun)=1)=
                 sum((chp,size),ELexist('Superc',v,size,chp,r));

         Elexistcp.up('Ultrsc',v,trun,r)$(ord(trun)=1)=
                 sum((chp,size),ELexist('Ultrsc',v,size,chp,r));

;

*        Using IHS stats
         ELhydexistcp.fx(ELphyd,v,trun,r)$(ord(trun)=1)=
                 (ELhydexist(ELphyd,r))$vo(v);

*        distibute total WEPP hydro plant capacity amongst differen plant types
*        (lg, ROR, sto) given by the IHS midstream database
         ELhydexistcp.fx('hydrolg',v,trun,r)$(ord(trun)=1 and vo(v))=
          ELhydexist('hydrolg',r)
         +ELhydroCEIC(r)
         -sum(ELphyd,ELhydexist(ELphyd,r));
*                 ELexist('hydrolg',v,'no_chp',r)-sum(ELphyd,ELhydexist(ELphyd,r));

*        No offshore wind represented in the model. Data taken from IHS
         ELwindexistcp.fx('windon',v,trun,r)$(ord(trun)=1)
                 =(ELwindexist(r))$vo(v);

*         ELwindexistcp.fx('windon','old',trun,r)$(ord(trun)=1)=ELexist('windon','no_chp',r)+ELexist('windoff','no_chp',r);


         ELtransexistcp.up(Elt,trun,r,rr)$(ord(trun)=1)
                 = ELtransexist(Elt,r,rr);


         ELfgcexistcp.fx(Elpcoal,v,DeSOx,trun,r)$(ord(trun)=1)=
                 sum((chp,size),ELfgdexist(Elpcoal,v,size,chp,r));
         ELfgcexistcp.fx('SubcrSML',v,DeSOx,trun,r)$(ord(trun)=1)=
                 sum((chp),ELfgdexist('Subcr',v,'small',chp,r));
         ELfgcexistcp.fx('SubcrLRG',v,DeSOx,trun,r)$(ord(trun)=1)=
                 sum((chp),ELfgdexist('Subcr',v,'large',chp,r));

         ELfgcexistcp.fx(Elpcoal,v,DeNOx,trun,r)$(ord(trun)=1)=
                 sum((chp,size),ELnoxexist(Elpcoal,v,size,chp,r));
         ELfgcexistcp.fx('SubcrSML',v,DeNOx,trun,r)$(ord(trun)=1)=
                 sum((chp),ELnoxexist('Subcr',v,'small',chp,r));
         ELfgcexistcp.fx('SubcrLRG',v,DeNOx,trun,r)$(ord(trun)=1)=
                 sum((chp),ELnoxexist('Subcr',v,'large',chp,r));


*!!!     Temporary fix for pumped hydro storage
*         ELhydop.fx(ELphydsto,v,ELl,trun,rr)=0;
*         ELhydopsto.fx(ELl,v,trun,rr)=0;


Equations
* ====================== Primal Relationships=================================*
         ELobjective

* CAPITAL COSTS
         ELpurchbal(trun)            acumulates all import purchases
         ELcnstrctbal(trun)          accumlates all construction activity
         ELopmaintbal(trun)          accumulates operations and maintenance costs
* FUELS
         ELfcons(ELp,v,ELf,trun,r)    supply of non coal fuel for power generation
         ELCOcons(ELp,v,gtyp,trun,r) supply of coal for power
         ELfavail(ELf,trun,r)        Available fuel constraint

* CAPACITIES (Dispatchable tech)
         ELcapbal(ELpd,v,trun,r) capacity balance constraint
         ELcaplim(ELpd,v,ELl,trun,r) electricity capacity constraint on the generators available or built cpacity
         ELcapcontr(ELpd,v,trun,r) lower bound represent existing capacity contracts
         ELgtconvlim(ELp,v,trun,r)  conversion limit for existing OCGT plants
         ELnucconstraint(ELl,trun,r)

* HYDRO
         ELhydcapbal(ELphyd,v,trun,r)   hydro capacity balance constraint
         ELhydcaplim(ELphyd,ELl,v,trun,r)  electricity capacity constraint for hydro
         ELhydutil(ELphyd,v,trun,r)       operation of hydro plants
         ELhydutilsto(v,trun,r)      operation of pumped hydro storage

* WIND
         ELwindcapbal(ELpw,v,trun,r) capacity balance for wind plants
         ELwindcaplim(ELpw,v,trun,r) capacity constraint for wind plants
         ELwindutil(ELpw,ELl,v,trun,r) measures the operate for wind plants
         ELwindcapsum(wstep,trun,r)      makes sure total wind capacity is within the steps
         ELwindcapsum2(wstep,trun,r)

         ELfitcap(Elpw,v,trun,r)



* SPINNING RESERVES
         ELupspinres(ELl,trun,r) up spinning reserve (in case of sudden drop in renewable gen)
*         ELdnspinres(ELpd,ELl,trun,r) down spinning reserve (in case of sudden rise in ren. gen.)

* ELECTRICITY SUPPLY AND DEMAND
         ELsup(ELl,trun,r)            electricity supply constraints
         ELdem(ELl,trun,r)            electricity demand constraints
         ELrsrvreq(trun,grid)            electricity reserve margin
         ELdemloc(trun,r)             local onsite electricity demand constraint
         ELdemlocbase(ELl,trun,r)             local onsite electricity demand constraint

* TRANSMISSION
         ELtranscapbal(ELt,trun,r,rr)     electricity transportation capacity balance
         ELtranscaplim(ELt,Ell,trun,r,rr) electricity transportation capacity constraint

* FGD
         ELfgccaplim(Elpd,v,fgc,trun,r) capacity limit on flu gas control
         ELfgccapmax(ELpd,v,fgc,trun,r) maximum installed capacity for fgc
         ELfgccapbal(ELpd,v,fgc,trun,r) FGD capacity balance equation GW

         ELprofit(ELc,v,trun,r) regional Profit constraint on each generator type

         ELprofitcoal(Elp,v,trun,r) regional Profit constraint aggregation of all coal power plants

         ELwindtarget(trun) national target for renewables
         ELfuelsublim(r,ELl,trun)
*         ELCOcvlim(Elpd,trun,r) constraint on the lowest belended calorific value permited for a coal plant

         ELtranslim(trun,r,rr)

* =================== Dual Relationships =====================================*
         DELImports(trun)             dual from imports
         DELConstruct(trun)           dual from construct
         DELOpandmaint(trun)          dual from opandmaint

         DELbld(ELpd,v,trun,r)         dual from Elbld
         DELwindbld(ELpw,v,trun,r)     dual from ELwindbld
         DELgttocc(Elp,v,trun,r)       dual from ELgttocc

         DELop(ELpd,v,ELl,ELf,trun,r) dual from ELop
         DELupspincap(ELpd,v,ELl,ELf,trun,r)  dual from ELupspincap
         DELwindop(ELpw,v,ELl,trun,r)  dual from ELwindop
         DELexistcp(ELpd,v,trun,r)     dual from ELexistcp
         DELwindexistcp(ELpw,v,trun,r) dual from ELwindexistcp
         DELwindoplevel(wstep,ELpw,v,trun,r) dual from ELwindoplevel

*         DELdnspincap(ELpd,v,ELl,trun,r)  dual from ELdnspincap

         DELtrans(ELt,ELl,trun,r,rr)      dual from ELtrans
         DELtransbld(ELt,trun,r,rr)       dual from ELtransbld
         DELtransexistcp(ELt,trun,r,rr)   dual from ELtransexistcp
         DELfconsump(ELpd,v,f,fss,trun,r)
         DELCOconsump(ELpcoal,v,gtyp,cv,sulf,sox,nox,trun,r)

         DELhydexistcp(ELphyd,v,trun,r)  dual of ELhydexistcp
         DELhydbld(ELphyd,v,trun,r)      dual of ELhydbld
         DELhydop(ELphyd,v,ELl,trun,r)   dual of ELhydop
         DELhydopsto(ELl,v,trun,r) dual of ELhydopsto

         DELfgcexistcp(ELpd,v,fgc,trun,r)    dual of ELfgcexistcp
         DELfgcbld(ELpd,v,fgc,trun,r)        dual of ELfgcbld

         DELoploc(ELp,v,ELl,ELf,trun,r) dual on ELoploc

         DElcapsub(Elp,v,trun,r)
         DELfuelsub(Elp,v,ELl,ELf,cv,sulf,trun,r)
         DELdeficit(ELp,v,trun,r)
         DELwinddeficit(ELp,v,trun,r)
         DELwindsub(ELpw,v,trun,r)
;


parameter
          ELpfixedcost(ELp,v,trun,r) Sum of all fixed costs capital and fixed o&m
          ELpsunkcost(ELp,v,trun,r) Sum of all sunk costs capital and fixed o&m
;
$offorder

ELobjective.. z=e=
  +sum(t,(ELImports(t)+ELConstruct(t)+ELOpandmaint(t))*ELdiscfact(t))

  +sum((ELpcoal,v,gtyp,cv,sulf,sox,nox,ELf,t,r)$ELpfgc(Elpcoal,cv,sulf,sox,nox),
*          CoalFuelPrice*
          ELCOconsump(ELpcoal,v,gtyp,cv,sulf,sox,nox,t,r))

  +sum((ELpd,v,ELf,fss,t,r)$(not ELfcoal(ELf) and not ELpcoal(Elpd)),
*         +OtherFuelPrices*
         ELfconsump(ELpd,v,ELf,fss,t,r))
;

* CAPITAL COSTS
* Equipment/capital purchase costs [USD]


ELpurchbal(t)..
   sum((ELpd,v,r)$ELpbld(ELpd,v),ELpurcst(ELpd,t,r)*ELbld(ELpd,v,t,r))
  +sum((ELt,r,rr), ELtranspurcst(ELt,t,r,rr)*ELtransbld(ELt,t,r,rr))
  +sum((ELpw,v,r)$vn(v), ELPurcst(ELpw,t,r)*ELwindbld(ELpw,v,t,r))
  +sum((ELphyd,v,r)$vn(v),ELpurcst(ELphyd,t,r)*ELhydbld(ELphyd,v,t,r))
  +sum((ELpcoal,v,fgc,r)$(DeSOx(fgc) or DeNOx(fgc)),
         ELfgcbld(ELpcoal,v,fgc,t,r)*EMfgccapexD(fgc,t) )

  -ELImports(t)=e=0;

* Construction costs for new capital/equipment and GTtoCC  [USD]
ELcnstrctbal(t)..
   sum((ELpd,v,r)$ELpbld(ELpd,v),ELconstcst(ELpd,t,r)*ELbld(ELpd,v,t,r))
  +sum((ELt,r,rr), ELtransconstcst(ELt,t,r,rr)*ELtransbld(ELt,t,r,rr))
  +sum((ELpw,v,r)$vn(v), ELconstcst(ELpw,t,r)*ELwindbld(ELpw,v,t,r))
  +sum((ELphyd,v,r)$vn(v), ELconstcst(ELphyd,t,r)*ELhydbld(ELphyd,v,t,r))

  -ELConstruct(t)=e=0;

* Operation and maintenance costs [USD]
ELopmaintbal(t)..

  +sum((Elpd,v,ELl,ELf,r)$ELpELf(ELpd,ELf),
         ELomcst(Elpd,v,r)*(
                 ELop(ELpd,v,ELl,ELf,t,r)
                 +ELusomfrac*ELlchours(ELl)*
                 ELupspincap(Elpd,v,ELl,ELf,t,r)$ELpspin(Elpd)
*                 +ELlchours(ELl)*
*                 ELoploc(ELpd,v,ELl,ELf,t,r)$(not ELpnuc(ELpd))
         )
  )

  +sum((ELpd,v,gtyp,cv,sulf,sox,nox,r)$(ELpcoal(ELpd) and
                                         ELpfgc(ELpd,cv,sulf,sox,nox)),
         (EMfgcomcst(sox)+EMfgcomcst(nox))*
         ELCOconsump(ELpd,v,gtyp,cv,sulf,sox,nox,t,r)*COcvSCE(cv)/
         ELfuelburn(ELpd,v,'coal',r)
  )

  +sum((ELpd,v,r)$ELpbld(ELpd,v),
         ELfixedOMcst(ELpd)*ELbld(ELpd,v,t-ELleadtime(ELpd),r))

  +sum((ELpcoal,v,fgc,r)$(DeSOx(fgc) or DeNOx(fgc)),
         ELfgcbld(ELpcoal,v,fgc,t,r)*EMfgcfixedOMcst(fgc) )

  +sum((ELpw,v,ELl,r),
         (ELomcst(ELpw,v,r))*ELwindop(ELpw,v,ELl,t,r))
  +sum((ELpw,v,r)$vn(v),ELfixedOMcst(ELpw)*ELwindbld(ELpw,v,t-ELleadtime(ELpw),r))

  +sum((ELphyd,v,ELl,r),
         ELomcst(ELphyd,v,r)*ELhydop(ELphyd,v,ELl,t,r))
  +sum((ELphyd,v,r)$vn(v),ELfixedOMcst(ELphyd)*ELhydbld(ELphyd,v,t-ELleadtime(ELphyd),r))

  +sum((ELt,ELl,r,rr)$ELtransr(ELt,r,rr),
         ELtransomcst(ELt,r,rr)*ELtrans(ELt,ELl,t,r,rr))
   -ELOpandmaint(t)=e=0
;


* FUELS
* fuel consumption
* fuel burning  is indepednadnt of sulfur content
* this needs to be updated!!!
ELfcons(ELpd,v,ELf,t,r)$(ELpELf(ELpd,ELf) and not Elpcoal(ELpd))..

  sum(fss$ELpfss(ELpd,ELf,fss),ELfconsump(ELpd,v,ELf,fss,t,r))

  -sum(ELl,ELfuelburn(ELpd,v,ELf,r)*
         (        ELop(ELpd,v,ELl,ELf,t,r)
                 +ELupspincap(Elpd,v,ELl,ELf,t,r)
                 *ELusrfuelfrac*ELlchours(ELl)$ELpspin(Elpd)
*                 +ELlchours(ELl)*
*                 ELoploc(ELpd,v,ELl,ELf,t,r)$(not ELpnuc(ELpd))
         )
   )
                         =g=0
;

ELCOcons(ELpcoal,v,gtyp,t,r)..
  +sum((cv,sulf,sox,nox)$ELpfgc(Elpcoal,cv,sulf,sox,nox),
         ELCOconsump(ELpcoal,v,gtyp,cv,sulf,sox,nox,t,r)*COcvSCE(cv))

  -sum((ELl,ELf)$ELpELf(ELpcoal,ELf),ELfuelburn(ELpcoal,v,ELf,r)*
         (        ELop(ELpcoal,v,ELl,ELf,t,r)$reg(gtyp)
                 +ELupspincap(Elpcoal,v,ELl,ELf,t,r)
                 *ELusrfuelfrac*ELlchours(ELl)$(ELpspin(Elpcoal) and spin(gtyp))
*                 +ELlchours(ELl)*
*                 ELoploc(ELpcoal,v,ELl,ELf,t,r)
         )
   )
                         =g=0
;



* supply of available fuel [units of fuel energy]
ELfavail(ELf,t,r)$(ELfog(ELf))..
  -sum((ELpd,v)$(not ELpcoal(Elpd) and ELpfss(ELpd,ELf,'ss0')),
         ELfconsump(ELpd,v,ELf,'ss0',t,r))
                 =g=0
  -ELfconsumpmax(ELf,t,r)
;

$ontext
ELCOcvlim(Elpd,t,r)$ELpcoal(ELpd)..
   +sum((v,ELl,ELf,cv,sulf,sox,nox)$(ELpELf(ELpd,Elf,cv,sulf,sox,nox)),
         Elfuelburn(ELpd,v,ELf,cv,r)*ELop(ELpd,v,ELl,ELf,cv,sulf,sox,nox,t,r)
                 *(COcvSCE(cv)-ELCOcvthreshold(Elpd)))
         =g=0;
$offtext


* NUCLEAR
* nuclear set as base load supplier [GWh]
ELnucconstraint(ELl,t,r)..
  -sum((ELpd,v,ELf)$(ELpnuc(ELpd) and ELpELf(ELpd,ELf)),
         ELop(ELpd,v,ELl,ELf,t,r))
  +sum((ELpd,v,ELll,ELf)$(ELpnuc(ELpd) and ELpELf(ELpd,ELf)),
         ELop(ELpd,v,ELll,ELf,t,r))*ELlcnorm(ELl) =e=0
;


* CAPACITIES
* balance of existing, additional, and future capacity [GW]
ELcapbal(ELpd,v,t,r).. ELexistcp(ELpd,v,t,r)
   +sum(Elppd$ELpbld(Elppd,v),ELcapadd(Elppd,ELpd)*
                                 ELbld(Elppd,v,t-ELleadtime(Elppd),r))
   -ELexistcp(ELpd,v,t+1,r)=g=0
;

ELcaplim(ELpd,v,ELl,t,r)..
   ELcapfac(ELpd,v)*ELlchours(ELl)*(
          ELexistcp(ELpd,v,t,r)
         +sum(Elppd$ELpbld(Elppd,v),
                 ELcapadd(Elppd,ELpd)*ELbld(Elppd,v,t-ELleadtime(Elppd),r))
   )

  -sum(ELf$ELpELf(ELpd,ELf),
          ELop(ELpd,v,ELl,ELf,t,r)
         +ELupspincap(Elpd,v,ELl,ELf,t,r)*ELlchours(ELl)$Elpspin(Elpd)
*         +ELlchours(ELl)*
*         ELoploc(ELpd,v,ELl,ELf,t,r)$(not ELpnuc(ELpd))
  )
                 =g=0
;

ELcapcontr(ELpd,v,t,r)$vo(v)..
  +sum((ELl,ELf)$ELpELf(ELpd,ELf),ELop(ELpd,v,ELl,ELf,t,r))
  -ELexistcp(ELpd,v,t,r)*ELcntrhrs(ELpd,v,t,r)=g= 0
;


*    To ensure that remaining convertible capacity can be positive in the last period [GW]
ELgtconvlim(ELpgttocc,vo,t,r)..
  -ELgttocc(ELpgttocc,vo,t+1,r)-ELbld(ELpgttocc,vo,t,r)
  +ELgttocc(ELpgttocc,vo,t,r)=g=0
;


* HYDRO
ELhydcapbal(ELphyd,v,t,r).. ELhydexistcp(ELphyd,v,t,r)
   +ELhydbld(ELphyd,v,t-ELleadtime(ELphyd),r)$vn(v)
   -ELhydexistcp(ELphyd,v,t+1,r)=g=0
;

ELhydcaplim(ELphyd,ELl,v,t,r)..
  (ELhydexistcp(ELphyd,v,t,r)+ELhydbld(ELphyd,v,t-ELleadtime(ELphyd),r)$vn(v))
         *ELcapfac(Elphyd,v)*ELlchours(ELl)
   -ELhydop(ELphyd,v,ELl,t,r)
*   -ELhydopsto(ELl,v,t,r)$ELphydsto(ELphyd)
                                                 =g=0
;

ELhydutil(ELphyd,v,t,r)$(not ELphydsto(ELphyd))..
  ELhydhrs(r)*ELcapfac(Elphyd,v)*(ELhydexistcp(ELphyd,v,t,r)
   +ELhydbld(ELphyd,v,t-ELleadtime(ELphyd),r)$vn(v))
   -sum(ELl,ELhydop(ELphyd,v,ELl,t,r))=g=0
*ELlchours(ELl)
;

ELhydutilsto(v,t,r)..
   sum(ELl,ELhydopsto(ELl,v,t,r))*ELhydstoeff
   -sum((Elphyd,ELl)$ELphydsto(ELphyd),
         ELhydop(ELphyd,v,ELl,t,r))=g=0
;

* WIND
ELwindcapbal(ELpw,v,t,r)..
   ELwindexistcp(ELpw,v,t,r)
  -ELwindexistcp(ELpw,v,t+1,r)
  +ELwindbld(ELpw,v,t-ELleadtime(ELpw),r)$vn(v)=g=0
;

ELwindcaplim(ELpw,v,t,r)..
  +ELwindexistcp(ELpw,v,t,r)
  +ELwindbld(ELpw,v,t-ELleadtime(ELpw),r)$vn(v)
  -sum((wstep),(ELwindcap(wstep)-ELwindcap(wstep-1))*
         ELdemgro('LS1',t,r)*ELwindoplevel(wstep,ELpw,v,t,r))=g=0
;

* Electricity produced by wind [GWh]
ELwindutil(ELpw,ELl,v,t,r)..

sum(wstep,ELdiffGW(wstep,ELl,r)*
    ELdemgro(ELl,t,r)*ELwindoplevel(wstep,ELpw,v,t,r))*ELlchours(ELl)
   -ELwindop(ELpw,v,ELl,t,r)
                 =g=0
;

ELwindcapsum(wstep,t,r).. -sum((ELpw,v),ELwindoplevel(wstep,ELpw,v,t,r))=g=-1;


* SPINNING RESERVES
ELupspinres(ELl,t,r)..
  -ELwindspin*sum((wstep,ELpw,v),
         ELdiffGW(wstep,ELl,r)*ELdemgro(ELl,t,r)*
         ELwindoplevel(wstep,ELpw,v,t,r)*ELparasitic(Elpw,v))
  +sum((ELpd,v,ELf)$(ELpELf(ELpd,ELf) and ELpspin(ELpd)),
         ELupspincap(ELpd,v,ELl,ELf,t,r)*ELparasitic(Elpd,v))
=g=0;

* ELECTRICITY SUPPLY AND DEMAND
ELsup(ELl,t,r)..
   sum((ELpd,v,ELf)$ELpELf(ELpd,ELf),
         ELop(ELpd,v,ELl,ELf,t,r)*ELparasitic(Elpd,v))
  -sum((ELpcoal,v,reg,cv,sulf,SOx,NOx)$(ELpfgc(Elpcoal,cv,sulf,SOx,NOx) and
                 (DeSOx(sox) or DeNOx(nox))),
         ELCOconsump(ELpcoal,v,reg,cv,sulf,SOx,NOx,t,r)*COcvSCE(cv)*
         ELpCOparas(Elpcoal,v,sulf,SOx,NOx,r))
  +sum((ELphyd,v),ELhydop(ELphyd,v,ELl,t,r)*ELparasitic(Elphyd,v))
  +sum((ELpw,v),ELwindop(ELpw,v,ELl,t,r)*ELparasitic(Elpw,v))

*  -sum((v),ELhydopsto(ELl,v,t,r))

  -sum((Elt,rr)$ELtransr(ELt,r,rr),
         ELtrans(ELt,ELl,t,r,rr))
                         =g=  0
  +ELlcgwonsite(r,ELl)*ELdemgro(ELl,t,r)*ELlchours(ELl)
;

ELdem(ELl,t,rr)..
   sum((ELt,ELll,r)$ELtransr(ELt,r,rr),
         Eltransyield(ELt,r,rr)*ELtranscoef(ELll,ELl,r,rr)*
         ELtrans(ELt,ELll,t,r,rr))
*ELlchours(ELll)
   -sum((v),ELhydopsto(ELl,v,t,rr))
*   -PCELconsump(ELl,t,rr)-RFELconsump(ELl,t,rr)
         =g=ELlcgwsales(rr,ELl)*ELdemgro(ELl,t,rr)*ELlchours(ELl);


ELdemlocbase(ELl,t,r)..
   sum((ELpd,v,ELf)$(ELpELf(ELpd,ELf)
         and not ELpnuc(ELpd)),ELoploc(ELpd,v,ELl,ELf,t,r))
                 =g= ELlcgwonsite(r,ELl)*ELlcgwonsitebase(r)*ELdemgro(ELl,t,r)
;


ELdemloc(t,r)..
   sum((ELpd,v,ELl,ELf)$(ELpELf(ELpd,ELf)
         and not ELpnuc(ELpd)),ELoploc(ELpd,v,ELl,ELf,t,r)*ELLchours(ELl))
                 =e= sum(ELl,(ELlcgwonsite(r,ELl))*ELLchours(ELl)*ELdemgro(ELl,t,r))
;

* WAELconsump (hybrid RO) is assumed to take directly from supply, bypassing the grid

ELrsrvreq(t,grid)..
sum(r$rgrid(r,grid),
   sum((ELpd,v), Elexistcp(ELpd,v,t,r))
  +sum((ELpd,v,Elppd)$ELpbld(Elppd,v),
     ELcapadd(Elppd,ELpd)*ELbld(Elppd,v,t-ELleadtime(Elppd),r))
  +sum((ELphyd,v),
     ELhydexistcp(ELphyd,v,t,r)+ELhydbld(ELphyd,v,t-ELleadtime(ELphyd),r)$vn(v))
)
         =g= sum(r$rgrid(r,grid),ELreserve*ELlcgw(r,'LS1')*ELdemgro('LS1',t,r));

* TRANSMISSION
* balance of transmission capacity [GW]
ELtranscapbal(ELt,t,r,rr).. ELtransexistcp(ELt,t,r,rr)
   +ELtransbld(ELt,t-ELtransleadtime(r,rr),r,rr)
   -ELtransexistcp(ELt,t+1,r,rr)=g=0;

* Transmission constraint [GWh]
ELtranscaplim(ELt,Ell,t,r,rr).. (ELtransexistcp(ELt,t,r,rr)
   +ELtransbld(ELt,t-ELtransleadtime(r,rr),r,rr))*ELlchours(ELl)
   -ELtrans(ELt,ELl,t,r,rr)$ELtransr(ELt,r,rr)=g= 0;

ELtranslim(t,r,rr)$(ord(r) <> ord(rr))..
  -sum((ELt,ELl)$ELtransr(ELt,r,rr),
         ELtrans(ELt,ELl,t,r,rr))
                 =g=-ELtransdata(t,r,rr)
;

*$ontext
*======== fgc constraints

* Capacity limit on the operation of FGD
ELfgccaplim(ELpd,v,fgc,t,r)$((DeSOx(fgc) or DeNOx(fgc)) and ELpcoal(ELpd))..
   ELcapfac(ELpd,v)*sum(ELl,ELlchours(ELl))*(
          ELfgcexistcp(ELpd,v,fgc,t,r)
         +ELfgcbld(ELpd,v,fgc,t-ELfgcleadtime(fgc),r)
   )

    -sum((gtyp,cv,sulf,nox)$(ELpfgc(Elpd,cv,sulf,fgc,nox)),
         ELCOconsump(ELpd,v,gtyp,cv,sulf,fgc,nox,t,r)*COcvSCE(cv)/ELfuelburn(ELpd,v,'coal',r)
    )$DeSOx(fgc)

    -sum((gtyp,cv,sulf,sox)$(ELpfgc(Elpd,cv,sulf,sox,fgc)),
         ELCOconsump(ELpd,v,gtyp,cv,sulf,sox,fgc,t,r)*COcvSCE(cv)/ELfuelburn(ELpd,v,'coal',r)
    )$DeNOx(fgc)
          =g= 0
;


ELfgccapmax(ELpd,v,fgc,t,r)$(ELpcoal(ELpd) and (DeSOx(fgc) or DeNOx(fgc)))..

   ELexistcp(ELpd,v,t,r)
  +ELbld(ELpd,v,t-ELleadtime(ELpd),r)$ELpbld(ELpd,v)
  -ELfgcexistcp(ELpd,v,fgc,t,r)
  -ELfgcbld(ELpd,v,fgc,t-ELfgcleadtime(fgc),r)
          =g= 0
;


* balance of existing, additional, and future capacity [GW]
ELfgccapbal(ELpd,v,fgc,t,r)$(ELpcoal(ELpd) and (DeSOx(fgc) or DeNOx(fgc)))..
   ELfgcexistcp(ELpd,v,fgc,t,r)
  +ELfgcbld(ELpd,v,fgc,t-ELfgcleadtime(fgc),r)
  -ELfgcexistcp(ELpd,v,fgc,t+1,r)=g=0
;

*$offtext


ELprofit(ELc,vv,t,r)$ELctariff(ELc,vv)..



+sum((ELp,v)$(ELptariff(ELp,v) and ELcELp(ELc,vv,ELp,v)),

  +ELdeficit(ELp,v,t,r)


  +sum((ELl,ELf)$(Elpd(ELp) and ELpELf(ELp,ELf)),
         +(ELtariffmax(ELp,r)*ELparasitic(ELp,v)-ELomcst(ELp,v,r))*
         ELop(ELp,v,ELl,ELf,t,r) )

  +sum(ELl,(ELtariffmax(ELp,r)*ELparasitic(ELp,v)-ELomcst(ELp,v,r))*
         ELhydop(ELp,v,ELl,t,r))$ELphyd(ELp)

  +sum((ELl),
         (ELtariffmax(ELp,r)*ELparasitic(ELp,v)-ELomcst(ELp,v,r))*
         ELwindop(ELp,v,ELl,t,r))$ELpw(ELp)

*  Generator tariffs and costs for operating flue gas control systems
  +sum((gtyp,ELfcoal,cv,sulf,sox,nox)$(ELpcoal(ELp) and ELpfgc(ELp,cv,sulf,sox,nox)),
         ( (ELfgctariff(sox)+ELfgctariff(nox))*
           (ELparasitic(Elp,v)-ELpCOparas(Elp,v,sulf,SOx,NOx,r)*ELfuelburn(ELp,v,ELfcoal,r))
          -(EMfgcomcst(sox) +EMfgcomcst(nox)) )*
         ELCOconsump(ELp,v,gtyp,cv,sulf,sox,nox,t,r)*COcvSCE(cv)/
         ELfuelburn(ELp,v,ELfcoal,r)
  )

*        subtract out parasitic load for DeNOX and DeSOx
  -sum((reg,cv,sulf,SOx,NOx)$(ELpcoal(ELp) and (DeSOx(sox) or DeNOx(nox)) and
                 ELpfgc(Elp,cv,sulf,SOx,NOx)),
         ELtariffmax(Elp,r)*
         ELCOconsump(ELp,v,reg,cv,sulf,SOx,NOx,t,r)*COcvSCE(cv)*
         ELpCOparas(Elp,v,sulf,SOx,NOx,r))

  -sum((ELl,ELf)$(ELpELf(ELp,ELf) and ELpspin(ELp)),ELomcst(ELp,v,r)*ELusomfrac*ELlchours(ELl)*
                 ELupspincap(ELp,v,ELl,ELf,t,r))
*$ontext
  -sum((cv,sulf)$ELfCV('coal',cv,sulf),
   ( DCOdem('coal',cv,sulf,'summ',t,r)
     -sum(rco$(rco_dem(rco,r) and not r(rco) and rcodem(rco)),
       DCOsuplim('coal',cv,sulf,'summ',t,rco)*Elsnorm('summ')/num_nodes_reg(r))
   )*(
*    DELCOcons(ELp,v,gtyp,t,r)*COcvSCE(cv)*(
       sum((gtyp,sox,nox)$ELpfgc(ELp,cv,sulf,sox,nox),ELCOconsump(ELp,v,gtyp,cv,sulf,sox,nox,t,r))
      -sum(ELl,ELfuelsub(ELp,v,ELl,'coal',cv,sulf,t,r))$vo(v) )
   )$ELpcoal(ELp)

  -sum((ELf,fss)$(ELpd(ELp) and not Elpcoal(ELp) and ELpfss(ELp,ELf,fss)),
         ELAPf(ELf,fss,t,r)*(
                 ELfconsump(ELp,v,ELf,fss,t,r)-
                 sum((ELl,cv,sulf)$ELfCV(ELf,cv,sulf),
                         ELfuelsub(ELp,v,ELl,ELf,cv,sulf,t,r))$(not ELpnuc(Elp) and vo(v)) )
  )

  -(  ELwindbld(ELp,v,t-ELleadtime(Elp),r)$(vn(v) and ELpw(ELp))
     +ELhydbld(ELp,v,t-ELleadtime(Elp),r)$(vn(v) and ELphyd(ELp))
     +sum(ELppd$ELpbld(ELppd,v),ELcapadd(Elppd,ELp)*
         ELbld(Elppd,v,t-ELleadtime(Elppd),r))$ELpd(ELp)
   )*ELpfixedcost(ELp,v,t,r)

   +ELcapsub(ELp,v,t,r)

  -(  ELwindexistcp(ELp,v,t,r)$(ELpw(ELp))
     +ELhydexistcp(ELp,v,t,r)$ELphyd(ELp)
     +Elexistcp(ELp,v,t,r)$ELpd(ELp)
  )*ELpsunkcost(ELp,v,t,r)

  -sum(fgc$((DeSOx(fgc) or DeNOx(fgc)) and ELpcoal(ELp)),
         (
           ELfgcexistcp(ELp,v,fgc,t,r)
          +ELfgcbld(ELp,v,fgc,t-ELfgcleadtime(fgc),r))*(EMfgccapexD(fgc,t)+EMfgcfixedOMcst(fgc))
  )

)
         =g= 0
;


ELfitcap(ELpw,v,t,r)$(ELpfit=1)..

*  -sum((ELl),ELwindop(ELpw,v,ELl,t,r))*(ELomcst(ELpw,v,r)+ELwindsub(Elpw,v,t,r)-ELtariffmax(Elpw,r))
  -sum((ELl),ELwindop(ELpw,v,ELl,t,r))*(ELomcst(ELpw,v,r)-ELtariffmax(Elpw,r))
  -ELwindsub(Elpw,v,t,r)
  -ELwindbld(ELpw,v,t-ELleadtime(Elpw),r)*ELpfixedcost(ELpw,v,t,r)$vn(v)
  -ELwindexistcp(ELpw,v,t,r)*ELpsunkcost(ELpw,v,t,r)

  +ELwinddeficit(ELpw,v,t,r)
         =g= 0
;
ELwindtarget(t)..

   sum((ELpw,v,r),ELwindbld(ELpw,v,t,r)$vn(v)
                 +ELwindexistcp(ELpw,v,t,r))
         =g= 0 +200$(EL2020=1)
;

ELfuelsublim(r,ELl,t)$ELrtariff(r)..
         -sum((ELpd,v,ELf,cv,sulf)$(ELpELf(Elpd,ELf) and ELfCV(ELf,cv,sulf) and ELptariff(Elpd,v) and vo(v) and not ELpnuc(ELpd)),
                 ELfuelsub(Elpd,v,ELl,ELf,cv,sulf,t,r)/ELfuelburn(ELpd,v,ELf,r)) =g=
                 -(ELlcgw(r,ELl)-Ellcgw(r,ELl+1))*ELlchours(ELl)$(ord(ELl)<=1);



* ==================== DUAL RELATIONSHIPS =====================================
*$ontext

DELimports(t)..  1*ELdiscfact(t)=g=-DELpurchbal(t);
DELConstruct(t).. 1*ELdiscfact(t)=g=-DELcnstrctbal(t);
DELOpandmaint(t).. 1*ELdiscfact(t)=g=-DELopmaintbal(t);


DELcapsub(ELp,v,t,r)$(ELptariff(ELp,v))..
* and ((ELpd(ELp) and vn(v)) or not ELpd(Elp))
         0=g=
*  +(  ELwindbld(ELp,v,t-ELleadtime(Elp),r)$(vn(v) and ELpw(ELp))
*     +ELhydbld(ELp,v,t-ELleadtime(Elp),r)$(vn(v) and ELphyd(ELp))
*     +sum(ELppd$ELpbld(ELppd,v),ELcapadd(Elppd,ELp)*
*         ELbld(Elppd,v,t-ELleadtime(Elppd),r))$ELpd(ELp)
*   )*ELpfixedcost(ELp,v,t,r)*sum((Elc,vv)$ELcELp(ELc,vv,ELp,v),DELprofit(ELc,vv,t,r))
*
*  +(  ELwindexistcp(ELp,v,t,r)$ELpw(ELp)
*     +ELhydexistcp(ELp,v,t,r)$ELphyd(ELp)
*     +Elexistcp(ELp,v,t,r)$ELpd(ELp)
*  )*ELpsunkcost(ELp,v,t,r)*

sum((Elc,vv)$ELcELp(ELc,vv,ELp,v),DELprofit(ELc,vv,t,r))$(ELptariff(ELp,v))
;

DELfuelsub(ELp,v,ELl,ELf,cv,sulf,t,r)$(ELptariff(ELp,v) and vo(v) and ELfCV(Elf,cv,sulf) and ELpELf(Elp,ELf) and not ELpnuc(ELp) and ELpd(Elp))..
         0=g=
  +sum(gtyp,
     DCOdem(ELf,cv,sulf,'summ',t,r)
    -sum(rco$(rco_dem(rco,r) and not r(rco) and rcodem(rco)),
       DCOsuplim(ELf,cv,sulf,'summ',t,rco)*Elsnorm('summ')/num_nodes_reg(r))
  )*
*  +sum((gtyp,sulf)$ELfcoal(ELf),DELCOcons(ELp,v,gtyp,t,r)*COcvSCE(cv))*
  sum((Elc,vv)$ELcELp(ELc,vv,ELp,v),DELprofit(ELc,vv,t,r))$ELpcoal(ELp)

  +sum((fss)$(ELpd(ELp) and not Elpcoal(ELp) and ELpfss(ELp,ELf,fss)),
         ELAPf(ELf,fss,t,r)*ELlcnorm(ELl))*
         sum((Elc,vv)$ELcELp(ELc,vv,ELp,v),DELprofit(ELc,vv,t,r))

  -(DELfuelsublim(r,ELl,t)/ELfuelburn(ELp,v,ELf,r))$ELrtariff(r)


*  +sum((ELl,ELf)$(ELpELf(ELp,ELf) and ELpspin(ELp)),ELomcst(ELp,v,r)*ELusomfrac*ELlchours(ELl)*
*         ELupspincap(ELp,v,ELl,ELf,t,r)*ELlcnorm(ELl)*DELprofit(ELp,v,t,r))
;


DELdeficit(ELp,v,t,r)$(ELptariff(ELp,v) or (ELpfit=1 and ELpw(Elp)) )..
1 =g=  sum((Elc,vv)$ELcELp(ELc,vv,ELp,v),DELprofit(ELc,vv,t,r))$(ELptariff(ELp,v))
*+DELfitcap(ELp,v,t,r)$(ELpfit=1 and ELpw(Elp))

*DELdeficit(ELc,vv,t,r)$(ELctariff(ELc,vv))..
*1 =g= DELprofit(ELc,vv,t,r)
;

DELwinddeficit(ELpw,v,t,r)$(ELpfit=1)..
1 =g= DELfitcap(ELpw,v,t,r)
;




DELfconsump(ELpd,v,ELf,fss,t,r)$(ELpfss(ELpd,ELf,fss) and not ELpcoal(ELpd))..
   ELAPf(ELf,fss,t,r)*ELdiscfact(t)*(
         0.01$(fss0(fss) and not ELpnuc(ELpd))+1$(not fss0(fss) or Elpnuc(ELpd)) )
         +0=g=

  -sum((Elc,vv)$ELcELp(ELc,vv,ELpd,v),DELprofit(ELc,vv,t,r))*
         ELAPf(ELf,fss,t,r)$ELptariff(ELpd,v)

  +DELfcons(ELpd,v,ELf,t,r)
  -DELfavail(ELf,t,r)$(ELfog(ELf) and fss0(fss))
;

DELCOconsump(ELpcoal,v,gtyp,cv,sulf,sox,nox,t,r)$ELpfgc(Elpcoal,cv,sulf,sox,nox)..
 (  DCOdem('coal',cv,sulf,'summ',t,r)
  -sum(rco$(rco_dem(rco,r) and not r(rco) and rcodem(rco)),
    DCOsuplim('coal',cv,sulf,'summ',t,rco)*Elsnorm('summ')/num_nodes_reg(r))
 )*ELdiscfact(t)

         +0=g=

  -sum((Elc,vv)$ELcELp(ELc,vv,ELpcoal,v),DELprofit(ELc,vv,t,r))*
         ELtariffmax(Elpcoal,r)*COcvSCE(cv)*ELpCOparas(Elpcoal,v,sulf,SOx,NOx,r)$(
                 (DeSOx(sox) or DeNOx(nox)) and reg(gtyp) and ELptariff(ELpcoal,v))

  -sum((Elc,vv)$ELcELp(ELc,vv,ELpcoal,v),DELprofit(ELc,vv,t,r))*
   (
     DCOdem('coal',cv,sulf,'summ',t,r)
         -sum(rco$(rco_dem(rco,r) and not r(rco) and rcodem(rco)),
       DCOsuplim('coal',cv,sulf,'summ',t,rco)*Elsnorm('summ')/num_nodes_reg(r))
*         DELCOcons(ELpcoal,v,gtyp,t,r)*COcvSCE(cv)
   )$ELptariff(ELpcoal,v)


  +sum((Elc,vv)$ELcELp(ELc,vv,ELpcoal,v),DELprofit(ELc,vv,t,r)*
         ( (ELfgctariff(sox)+ELfgctariff(nox))*
           (ELparasitic(Elpcoal,v)-ELpCOparas(Elpcoal,v,sulf,SOx,NOx,r)*ELfuelburn(ELpcoal,v,'coal',r))
          -(EMfgcomcst(sox)+EMfgcomcst(nox)) )*
         COcvSCE(cv)/ELfuelburn(ELpcoal,v,'coal',r))$ELptariff(ELpcoal,v)


  +(EMfgcomcst(sox)+EMfgcomcst(nox))*DELopmaintbal(t)*COcvSCE(cv)/
         ELfuelburn(ELpcoal,v,'coal',r)

  +DELCOcons(ELpcoal,v,gtyp,t,r)*COcvSCE(cv)

  -sum(ELl,DELsup(ELl,t,r)*COcvSCE(cv)*ELpCOparas(Elpcoal,v,sulf,sox,nox,r))$(
         (DeSOx(sox) or DeNOx(nox)) and reg(gtyp))

  -(DELfgccaplim(ELpcoal,v,sox,t,r)*COcvSCE(cv)/ELfuelburn(ELpcoal,v,'coal',r))$(DeSOx(sox))
  -(DELfgccaplim(ELpcoal,v,nox,t,r)*COcvSCE(cv)/ELfuelburn(ELpcoal,v,'coal',r))$(DeNOx(nox))

  -DEMsulflim(t,r)*EMfgc(sox)*COsulfDW(sulf)*1.6$rdem_on(r)
  -DEMELSO2std(ELpcoal,v,t,r)*EMfgc(sox)*COsulfDW(sulf)*1.6$(SO2_std=1)
  +DEMfgbal(ELpcoal,v,t,r)*VrCo(ELpcoal,'coal',cv)
  -DEMELnoxlim(t,r)*EMfgc(nox)*VrCo(ELpcoal,'coal',cv)*NOxC(r,ELpcoal)
  -DEMELNO2std(ELpcoal,v,t,r)*EMfgc(nox)*VrCo(ELpcoal,'coal',cv)*NO2C(r,ELpcoal)$(SO2_std=1)

;

DELexistcp(ELpd,v,t,r)..

        +0 =g=

  +DELcapbal(ELpd,v,t,r)-DELcapbal(ELpd,v,t-1,r)
  +sum(grid$rgrid(r,grid),DELrsrvreq(t,grid))

  -sum((Elc,vv)$ELcELp(ELc,vv,ELpd,v),DELprofit(ELc,vv,t,r))*
         ELpsunkcost(ELpd,v,t,r)$ELptariff(ELpd,v)
*(1-ELcapsub(ELpd,v,t,r))

  +sum(ELl,DELcaplim(ELpd,v,ELl,t,r)*ELcapfac(ELpd,v)*ELlchours(ELl))
  -DELcapcontr(Elpd,v,t,r)*ELcntrhrs(ELpd,v,t,r)

  +sum(fgc$(ELpcoal(ELpd) and (DeSOx(fgc) or DeNOx(fgc))),
         DELfgccapmax(ELpd,v,fgc,t,r))
;

DELbld(ELpd,v,t,r)$ELpbld(ELpd,v)..

*  sum(ELppd,ELcapadd(Elpd,ELppd)*ELpfixedcost(ELppd,v,t,r)*ELdiscfact(t))
   +0=g=
    DELpurchbal(t)*ELpurcst(Elpd,t,r)
   +DELcnstrctbal(t)*ELconstcst(ELpd,t,r)
   +DELopmaintbal(t+ELleadtime(ELpd))*ELfixedOMcst(ELpd)

  -sum(ELppd$(ELptariff(Elppd,v)),ELcapadd(Elpd,ELppd)*
         sum((Elc,vv)$ELcELp(ELc,vv,ELppd,v),DELprofit(ELc,vv,t+ELleadtime(ELpd),r))*
         ELpfixedcost(ELppd,v,t,r))
*(1-ELcapsub(ELppd,v,t,r))*

  +sum(Elppd,DELcapbal(Elppd,v,t+ELleadtime(ELpd),r)*ELcapadd(ELpd,Elppd))
*  -DELgtconvlim(ELpd,v,t,r)$(ELpgttocc(ELpd) and vo(v))
  +sum((ELl,Elppd),DELcaplim(Elppd,v,ELl,t+ELleadtime(ELpd),r)
         *ELcapadd(ELpd,Elppd)*ELcapfac(ELpd,v)*ELlchours(ELl))

  +sum(grid$rgrid(r,grid),DELrsrvreq(t+ELleadtime(ELpd),grid))*
         sum(Elppd,ELcapadd(ELpd,Elppd))

  +sum(fgc$(ELpcoal(ELpd) and (DeSOx(fgc) or DeNOx(fgc))),
         DELfgccapmax(ELpd,v,fgc,t+ELleadtime(ELpd),r))
;


DELop(ELpd,v,ELl,ELf,t,r)$ELpELf(ELpd,ELf)..
                +0 =g=

  +ELomcst(Elpd,v,r)*DELopmaintbal(t)

  +(ELtariffmax(ELpd,r)*ELparasitic(ELpd,v)-ELomcst(ELpd,v,r))*
         sum((Elc,vv)$ELcELp(ELc,vv,ELpd,v),DELprofit(ELc,vv,t,r))$ELptariff(ELpd,v)

  +DELcapcontr(ELpd,v,t,r)$vo(v)

  -ELfuelburn(ELpd,v,ELf,r)*DELfcons(ELpd,v,ELf,t,r)$(not ELpcoal(ELpd))
  -sum(gtyp$reg(gtyp),ELfuelburn(ELpd,v,ELf,r)*DELCOcons(ELpd,v,gtyp,t,r))$ELpcoal(Elpd)
  -DELcaplim(ELpd,v,ELl,t,r)

  -DELnucconstraint(ELl,t,r)$ELpnuc(ELpd)
  +sum(ELll,DELnucconstraint(ELll,t,r)*ELlcnorm(ELll))$ELpnuc(ELpd)

  +DELsup(ELl,t,r)*ELparasitic(Elpd,v)
;

DELupspincap(Elpd,v,ELl,ELf,t,r)$(Elpspin(Elpd) and ELpELf(ELpd,ELf)).. 0 =g=

  -sum((Elc,vv)$ELcELp(ELc,vv,ELpd,v),DELprofit(ELc,vv,t,r))*
         ELomcst(ELpd,v,r)*ELusomfrac*ELlchours(ELl)$ELptariff(ELpd,v)

  +ELomcst(Elpd,v,r)*DELopmaintbal(t)*ELusomfrac*ELlchours(ELl)

  -ELfuelburn(ELpd,v,ELf,r)*ELusrfuelfrac*ELlchours(ELl)*
         DELfcons(ELpd,v,ELf,t,r)$(not ELpcoal(ELpd))
  -sum(gtyp$spin(gtyp),ELfuelburn(ELpd,v,ELf,r)*ELusrfuelfrac*ELlchours(ELl)*
         DELCOcons(ELpd,v,gtyp,t,r))$ELpcoal(Elpd)

  -DELcaplim(ELpd,v,ELl,t,r)*ELlchours(ELl)

  +DELupspinres(ELl,t,r)*ELparasitic(Elpd,v)
;

*$ontext
DELoploc(ELpd,v,ELl,ELf,t,r)$(not ELpnuc(ELpd) and ELpELf(ELpd,ELf))..
         0 =g=
  +ELlchours(ELl)*ELomcst(Elpd,v,r)*DELopmaintbal(t)
  +ELpsunkcost(ELpd,v,t,r)*
         sum((Elc,vv)$ELcELp(ELc,vv,ELpd,v),DELprofit(ELc,vv,t,r))$(ELptariff(ELpd,v))

  -ELlchours(ELl)*ELfuelburn(ELpd,v,ELf,r)*DELfcons(ELpd,v,ELf,t,r)$(not ELpcoal(ELpd))

  -sum(gtyp$reg(gtyp),ELfuelburn(ELpd,v,ELf,r)*ELlchours(ELl)*
         DELCOcons(ELpd,v,gtyp,t,r))$ELpcoal(Elpd)

  -ELlchours(ELl)*DELcaplim(ELpd,v,ELl,t,r)
  +ELlchours(ELl)*DELdemloc(t,r)
  +DELdemlocbase(ELl,t,r)
;
*$offtext

DELgttocc(ELpgttocc,vo,t,r).. 0=g=DELgtconvlim(ELpgttocc,vo,t,r)
   -DELgtconvlim(ELpgttocc,vo,t-1,r);

DELtrans(ELt,ELl,t,r,rr)$ELtransr(ELt,r,rr)..
      0   =g=
  -DELsup(ELl,t,r)
  +DELopmaintbal(t)*ELtransomcst(ELt,r,rr)
  +sum(ELll,DELdem(ELll,t,rr)*Eltransyield(ELt,r,rr)*ELtranscoef(ELl,ELll,r,rr))
  -DELtranscaplim(ELt,ELl,t,r,rr);

DELtransbld(ELt,t,r,rr).. 0=g=DELpurchbal(t)*ELtranspurcst(ELt,t,r,rr)
   +DELcnstrctbal(t)*ELtransconstcst(ELt,t,r,rr)
   +DELtranscapbal(ELt,t+ELtransleadtime(r,rr),r,rr)
   +sum(ELl,DELtranscaplim(ELt,ELl,t+ELtransleadtime(r,rr),r,rr)*ELlchours(ELl))
;

DELtransexistcp(ELt,t,r,rr)..
   0=g=DELtranscapbal(ELt,t,r,rr)-DELtranscapbal(ELt,t-1,r,rr)
   +sum(ELl,DELtranscaplim(ELt,ELl,t,r,rr)*ELlchours(ELl))
;


DELwindbld(ELpw,v,t,r)$vn(v).. 0=g=

  -sum((Elc,vv)$ELcELp(ELc,vv,ELpw,v),DELprofit(ELc,vv,t+ELleadtime(ELpw),r))*
         ELpfixedcost(ELpw,v,t,r)$ELptariff(ELpw,v)
  -DELfitcap(ELpw,v,t+ELleadtime(Elpw),r)*ELpfixedcost(ELpw,v,t,r)$(ELpfit=1)
  +DELpurchbal(t)*ELpurcst(Elpw,t,r)
  +DELcnstrctbal(t)*ELconstcst(ELpw,t,r)
  +DELopmaintbal(t+ELleadtime(ELpw))*ELfixedOMcst(ELpw)

  +DELwindcapbal(ELpw,v,t+ELleadtime(ELpw),r)
  +DELwindcaplim(ELpw,v,t+ELleadtime(ELpw),r)
  +DELwindtarget(t)
;


DELwindexistcp(ELpw,v,t,r).. 0=g=

  +DELwindcapbal(ELpw,v,t,r)-DELwindcapbal(ELpw,v,t-1,r)
  +DELwindcaplim(ELpw,v,t,r)
  -sum((Elc,vv)$ELcELp(ELc,vv,ELpw,v),DELprofit(ELc,vv,t,r))*
         ELpsunkcost(ELpw,v,t,r)$ELptariff(ELpw,v)

  -DELfitcap(ELpw,v,t,r)*ELpsunkcost(ELpw,v,t,r)$(ELpfit=1)

  +DELwindtarget(t)
;

DELwindop(ELpw,v,ELl,t,r)..

*  -ELwindsub(ELpw,v,t,r)=g=
   0=g=
*  -DELfitcap(ELpw,v,t,r)*(ELomcst(ELpw,v,r)+ELwindsub(ELpw,v,t,r)-ELtariffmax(Elpw,r))$(ELpfit=1)
  -DELfitcap(ELpw,v,t,r)*(ELomcst(ELpw,v,r)-ELtariffmax(Elpw,r))$(ELpfit=1)
  +(ELtariffmax(ELpw,r)*ELparasitic(ELpw,v)-ELomcst(ELpw,v,r))*
         sum((Elc,vv)$ELcELp(ELc,vv,ELpw,v),DELprofit(ELc,vv,t,r))$ELptariff(ELpw,v)

  +DELsup(ELl,t,r)*ELparasitic(Elpw,v)
  +DELopmaintbal(t)*ELomcst(ELpw,v,r)
  -DELwindutil(ELpw,ELl,v,t,r)
;

DELwindsub(ELpw,v,t,r)$(ELpfit=1)..

  -1=g=
  -DELfitcap(Elpw,v,t,r)
;


DELwindoplevel(wstep,ELpw,v,t,r)..
       +0  =g=
  -DELwindcaplim(ELpw,v,t,r)*(ELwindcap(wstep)-ELwindcap(wstep-1))*ELdemgro('LS1',t,r)
  +sum(ELl,ELdiffGW(wstep,ELl,r)*ELdemgro(ELl,t,r)*DELwindutil(ELpw,ELl,v,t,r)*ELlchours(ELl))
  -DELwindcapsum(wstep,t,r)
*  -ELwindspin*sum(ELl,DELupspinres(ELl,t,r)*
*         ELdiffGW(wstep,ELl,r)*ELdemgro(ELl,t,r)*ELparasitic(Elpw,v))
;

DELhydexistcp(ELphyd,v,t,r).. 0=g=
  +DELhydcapbal(ELphyd,v,t,r)-DELhydcapbal(ELphyd,v,t-1,r)
  +sum(grid$rgrid(r,grid),DELrsrvreq(t,grid))
  +sum(ELl,DELhydcaplim(ELphyd,ELl,v,t,r)*ELcapfac(Elphyd,v)*ELlchours(ELl))
  +DELhydutil(ELphyd,v,t,r)*ELhydhrs(r)*ELcapfac(Elphyd,v)$(not ELphydsto(ELphyd))
  -sum((Elc,vv)$ELcELp(ELc,vv,ELphyd,v),DELprofit(ELc,vv,t,r))*
         ELpsunkcost(ELphyd,v,t,r)$ELptariff(ELphyd,v)
*(1-ELcapsub(ELphyd,v,t,r))

;

DELhydbld(ELphyd,v,t,r)$vn(v)..  0=g=

   DELpurchbal(t)*Elpurcst(ELphyd,t,r)
  +DELcnstrctbal(t)*ELconstcst(ELphyd,t,r)
  +DELopmaintbal(t+ELleadtime(ELphyd))*ELfixedOMcst(ELphyd)

  -sum((Elc,vv)$ELcELp(ELc,vv,ELphyd,v),DELprofit(ELc,vv,t+ELleadtime(ELphyd),r))*
         ELpfixedcost(ELphyd,v,t,r)$ELptariff(ELphyd,v)
*(1-ELcapsub(ELphyd,v,t,r))

  +DELhydcapbal(ELphyd,v,t+ELleadtime(ELphyd),r)
  +sum(ELl,DELhydcaplim(ELphyd,ELl,v,t+ELleadtime(ELphyd),r)*ELcapfac(Elphyd,v)*ELlchours(ELl))
  +DELhydutil(ELphyd,v,t+ELleadtime(ELphyd),r)*ELhydhrs(r)*ELcapfac(Elphyd,v)$(not ELphydsto(ELphyd))
  +sum(grid$rgrid(r,grid),DELrsrvreq(t+ELleadtime(ELphyd),grid))
;

DELhydop(ELphyd,v,ELl,t,r)..

               0  =g=

  +(ELtariffmax(ELphyd,r)*ELparasitic(ELphyd,v)-ELomcst(ELphyd,v,r))*
         sum((Elc,vv)$ELcELp(ELc,vv,ELphyd,v),DELprofit(ELc,vv,t,r))$ELptariff(ELphyd,v)

  +DELsup(ELl,t,r)*ELparasitic(Elphyd,v)
  +DELopmaintbal(t)*ELomcst(ELphyd,v,r)
  -DELhydcaplim(ELphyd,ELl,v,t,r)
  -DELhydutil(ELphyd,v,t,r)$(not ELphydsto(ELphyd))
  -DELhydutilsto(v,t,r)$(ELphydsto(ELphyd))
;

DELhydopsto(ELl,v,t,r)..  0=g=
*  -sum(ELphyd$ELphydsto(ELphyd),DELhydcaplim(ELphyd,ELl,v,t,r))
  +DELhydutilsto(v,t,r)*ELhydstoeff
  -DELdem(ELl,t,r)
;

*$ontext

DELfgcexistcp(ELpd,v,fgc,t,r)$(ELpcoal(ELpd) and (DeSOx(fgc) or DeNOx(fgc)))..
      +0 =g=
  -(EMfgccapexD(fgc,t)+EMfgcfixedOMcst(fgc))*
         sum((Elc,vv)$ELcELp(ELc,vv,ELpd,v),DELprofit(ELc,vv,t,r))$ELptariff(ELpd,v)

  +DELfgccapbal(ELpd,v,fgc,t,r)-DELfgccapbal(ELpd,v,fgc,t-1,r)
  +sum(ELl,DELfgccaplim(ELpd,v,fgc,t,r)*
         ELcapfac(ELpd,v)*ELlchours(ELl))
 -DELfgccapmax(ELpd,v,fgc,t,r)
;

DELfgcbld(ELpd,v,fgc,t,r)$(ELpcoal(ELpd) and (DeSOx(fgc) or DeNOx(fgc)))..
   +0
         =g=
  -(EMfgccapexD(fgc,t)+EMfgcfixedOMcst(fgc))*
         sum((Elc,vv)$ELcELp(ELc,vv,ELpd,v),DELprofit(ELc,vv,t+ELfgcleadtime(fgc),r))$ELptariff(ELpd,v)

  +DELpurchbal(t)*EMfgccapexD(fgc,t)

  +DELopmaintbal(t)*EMfgcfixedOMcst(fgc)

  +DELfgccapbal(ELpd,v,fgc,t+ELfgcleadtime(fgc),r)
  +sum(ELl,DELfgccaplim(ELpd,v,fgc,t+ELfgcleadtime(fgc),r)*
         ELcapfac(ELpd,v)*ELlchours(ELl))
  -DELfgccapmax(ELpd,v,fgc,t+ELfgcleadtime(fgc),r)
;



* !!!    Include emissions submodule
$INCLUDE emissionsubmodel.gms


         t(trun) = yes;


model PowerLP /
*        POWER EQUATIONS
         ELobjective,
         ELpurchbal,ELcnstrctbal,ELopmaintbal,
         ELfcons,ELCOCons,
*ELfcons
         ELfavail,
         ELcapbal,ELcaplim,ELcapcontr,
         ELhydcapbal,ELhydcaplim,ELhydutil,ELgtconvlim,
         ELsup,ELdem,ELrsrvreq,
         ELwindcapbal,ELwindcaplim,ELwindutil,ELupspinres,
         ELwindcapsum,
         ELwindcapsum2,
         ELtranscaplim,ELtranscapbal,

*         ELfgclim,ELfgccaplim,ELfgcfcons,ELfgccapbal,
*         EMsulflim, EMELnoxlim

*         ELhydutilsto,

         /
;

*$ontext
model PowerMCP /

ELProfit.DELprofit,ELwindtarget.DELwindtarget,ELfuelsublim.DELfuelsublim,ELfitcap.DELfitcap,
ELpurchbal.DELpurchbal,ELcnstrctbal.DELcnstrctbal,ELopmaintbal.DELopmaintbal,
ELfcons.DELfcons,ELCOcons.DELCOcons,
*ELfconsspin.DELfcons
ELfavail.DELfavail,ELcapbal.DELcapbal,
ELcaplim.DELcaplim,ELcapcontr.DELcapcontr,
*ELgtconvlim.DELgtconvlim,

ELwindcapbal.DELwindcapbal,ELwindcaplim.DELwindcaplim,ELwindutil.DELwindutil,
ELwindcapsum.DELwindcapsum,ELupspinres.DELupspinres,
ELnucconstraint.DELnucconstraint,

ELsup.DELsup,ELdem.DELdem,ELrsrvreq.DELrsrvreq,
*ELdemloc.DELdemloc,ELdemlocbase.DELdemlocbase,

ELtranscapbal.DELtranscapbal,ELtranscaplim.DELtranscaplim,
ELhydcapbal.DELhydcapbal,ELhydcaplim.DELhydcaplim,ELhydutil.DELhydutil,


ELhydutilsto.DELhydutilsto,

ELfgccaplim.DELfgccaplim,ELfgccapmax.DELfgccapmax,ELfgccapbal.DELfgccapbal,

DELImports.ELImports,DELConstruct.ELConstruct,DELOpandmaint.ELOpandmaint,
DELexistcp.ELexistcp,DELbld.ELbld,
*DELgttocc.ELgttocc,
DELop.ELop,DELupspincap.ELupspincap,
*DELoploc.ELoploc,
DELwindop.ELwindop,DELwindoplevel.ELwindoplevel,
DELwindexistcp.ELwindexistcp,DELwindbld.ELwindbld,


DELtrans.ELtrans,DELtransbld.ELtransbld,DELtransexistcp.ELtransexistcp,
DELfconsump.ELfconsump,DELCOconsump.ELCOconsump,
*DELfconsumpspin.ELfconsumpspin

DELhydexistcp.ELhydexistcp,DELhydbld.ELhydbld,DELhydop.ELhydop,
DELhydopsto.ELhydopsto,

DELfgcexistcp.ELfgcexistcp,
DELfgcbld.ELfgcbld,

DELcapsub.Elcapsub,DELfuelsub.ELfuelsub,DELdeficit.ELdeficit,DELwinddeficit.ELwinddeficit,
DELwindsub.ELwindsub,
*DELsubsidycoal.ELsubsidycoal,

DEMELfluegas.EMELfluegas,
EMsulflim.DEMsulflim,
EMELnoxlim.DEMELnoxlim,
EMfgbal.DEMfgbal,EMELSO2std.DEMELSO2std,EMELNO2std.DEMELNO2std


*$ontext

COpurchbal.DCOpurchbal,COcnstrctbal.DCOcnstrctbal,
COopmaintbal.DCOopmaintbal,COcapbal.DCOcapbal,COcaplim.DCOcaplim,
COwashcaplim.DCOwashcaplim,COsulflim.DCOsulflim,
COprodfx.DCOprodfx,COprodCV.DCOprodCV,COprodlim.DCOprodlim,

DCOpurchase.COpurchase,DCOconstruct.COconstruct,DCOopandmaint.COopandmaint,
DCOprod.COprod,DCOexistcp.COexistcp,DCObld.CObld,Dcoalprod.coalprod


         COtransPurchbal.DCOtransPurchbal,COtransCnstrctbal.DCOtransCnstrctbal,
         COtransOpmaintbal.DCOtransOpmaintbal,COtransbldeq.DCOtransbldeq,
         COimportbal.DCOimportbal,

         COimportsuplim.DCOimportsuplim,COimportlim.DCOimportlim,
         COsup.DCOsup,COsuplim.DCOsuplim,
         COdem.DCOdem,COdemOther.DCOdemOther,

         COtranscapbal.DCOtranscapbal,COtransportcaplim.DCOtransportcaplim,
         COtranscaplim.DCOtranscaplim,Cotransloadlim.DCotransloadlim,
*         COexportlim.DCOexportlim,
*         COtransbudgetlim.DCOtransbudgetlim,

         DCOtransPurchase.COtransPurchase,DCOtransConstruct.COtransConstruct,
         DCOtransOpandmaint.COtransOpandmaint,DCOimports.COimports,

         DCOtrans.COtrans,DCOtransload.COtransload,
         DCOtransexistcp.COtransexistcp,DCOtransbld.COtransbld,

         Dcoaluse.coaluse, Dcoalimports.coalimports,
*         Dcoalexports.coalexports

         DOTHERCOconsumpsulf.OTHERCOconsumpsulf,
*$offtext

/;

*         DEMsulflim.up(trun,r) =0;

*        Some variable fixed to the model

*         ELwindbld.fx(ELpw,v,trun,r)=0;
*         ELhydbld.fx(ELphyd,v,trun,r)=0;
*         ELupspincap.fx(ELpd,v,ELl,ELf,fss,cv,sulf,t,r)$ELpELf(ELpd,ELf,fss,cv,sulf)=0;

*         DELfgclim.fx(fgc,Elpd,v,ELl,cv,sulf,t,r)$ELpELf(ELpd,'coal',cv,sulf)=0;
*         DELfgcfcons.fx(fgc,cv,sulf,t,r)=0;
*         DELfgccaplim.fx(fgc,ELpd,v,ELl,t,r)=0;
*         DELfgccapbal.fx(fgc,ELpd,v,t,r)=0;
*         DEMsulflim.fx(t,r)=0;
*         DEMELnoxlim.fx(t,r)=0;

*         ELhydopsto.fx(ELl,v,t,r)=0;
*         DELhydutilsto.fx(v,t,r)=0;




