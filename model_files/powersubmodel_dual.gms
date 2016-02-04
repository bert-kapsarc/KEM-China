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

* nuclear fuel cost in 2012 RMB/kg;
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
         ELusomfrac ELfuelburn fraction for operating up spinning reserve /0.0/
;
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


         ELomcst('Subcr',v,r)    =15.1;
         ELomcst('Superc',v,r)   =14.6;
         ELomcst('Ultrsc',v,r)   =14.2;
         ELomcst('Hydrolg',v,r)  =27;
         ELomcst('HydroROR',v,r) =27.36;
         ELomcst('HydroSto',v,r) =26;
         ELomcst('Nuclear','old',r) =56.8;
         ELomcst('Nuclear','new',r) =74.6;

         ELomcst('Nuclear','new',r) =38;
* !!!    Nuclear omcst from Yuan 38


         ELomcst('ST',v,r)       =15;
         ELomcst('GT',v,r)       =30;
         ELomcst('CC',v,r)       =26;
         ELomcst('CCcon',v,r)    =26;

parameter
         ELfixedOMcst(ELp) Fixed O&M cost RMB per KW (2012)
*        values from WEIO 2014 ???
/
         ST       25
         GT       43.2
         CC       26
         GTtoCC   26
         CCcon    26

         Windon   220.85
         Windoff  978.05
*         Subcr    132
*         Superc   177
*         Ultrsc   202
         Subcr    388
         Superc   391
         Ultrsc   394

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
         ELexist(ELp,v,chp,Rall) existing capacity in GW
         ELhydexist(ELp,r) existing hydro capacity by type from IHS GW
         ELwindexist(r) existing hydro capacity by type from IHS GW
         ELcapfac(Elp,v) observed capacity factor of power plants
         ELnoxexist(ELpd,v,chp,Rall) nox existing capacity in GW
         ELfgdexist(ELpd,v,chp,Rall) fgd existing capacity in GW
         ELhydroCEIC(rAll) existing hydro capacity by type from IHS GW


         ELcntrhrs(ELp,v,trun,r)
;
         ELcapfac(Elpd,v)=1;
*         ELcapfac(ElpCC,v)=0.95;

*        Estimate from South China Grid 2011 Statistics report 79%
*        From IHS Electricity data
         ELcapfac(Elpnuc,v)=0.892;

*        Assumption on annual maintenance down time
         ELcapfac(Elphyd,v)=0.95;

         ELcntrhrs(Elpcoal,v,trun,r) = 0;
*         ELcntrhrs('Subcr',v,trun,r) = 4.000;
*         ELcntrhrs('Superc',v,trun,r) = 4.500;
*         ELcntrhrs('Ultrsc',v,trun,r) = 6.000;
*         ELcntrhrs(ELpog,v,trun,r) = 1.500;


$gdxin db\power.gdx
$load ELexist ELhydexist ELwindexist ELfgdexist ELnoxexist ELhydroCEIC
$gdxin






* !!!    aggregated provincial capacity to models grid regions
ELexist(Elp,v,chp,r) = sum(GB$regions(r,GB),ELexist(Elp,v,chp,GB));
ELhydroCEIC(r) = sum(GB$regions(r,GB),ELhydroCEIC(GB));
ELfgdexist(Elpd,v,chp,r) = sum(GB$regions(r,GB),ELfgdexist(Elpd,v,chp,GB));
ELnoxexist(Elpd,v,chp,r) = sum(GB$regions(r,GB),ELnoxexist(Elpd,v,chp,GB));


parameter ELcapital(ELp,r) Capital cost of equipment million RMB per GW (2012);
*values from WEIO 2014 converted to RMB, inflated to 2012 (These values are
*from 2012, so no inflation conducted)

         ELcapital('ST',r)       =5500    ;
         ELcapital('GT',r)       =2210  ;
         ELcapital('CC',r)       =3470.5  ;
         ELcapital('GTtoCC',r)   =550    ;


         ELcapital('CCcon',r)   =550    ;
         Elcapital('Subcr',r)    =3786    ;
         ELcapital('Superc',r)   =4417  ;
         ELcapital('Ultrsc',r)   =5048  ;


*         ELcapital('Windon',r)   =7500  ;
         ELcapital('Windoff',r)  =28016.4  ;

         ELcapital('Hydrolg',r)  = 13377.2 ;
         ELcapital('HydroROR',r) = 10727  ;
*        Look into hydro storage capital costs for future development
         ELcapital('Hydrosto',r) = 4000 ;
*         ELcapital('Nuclear_G2',r) =14104.5 ;

*        Capital cost of generation three plant
*         ELcapital('Nuclear',r) = 12620 ;
         ELcapital('Nuclear',r) = 16000 ;

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
         Subcr    20
         Superc   20
         Ultrsc   20
/

         ELleadtime(ELp) Lead time for plant construction units of t
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
         Subcr    0
         Superc   0
         Ultrsc   0
/

         ELfgcleadtime(ELp)
/
         Subcr    0
         Superc   0
         Ultrsc   0
/


         ELCOcvthreshold(Elpd) lower threshold on a coal plants blended CV. Calorific vaolue normalized to SCE
/
         Subcr    3000
         Superc   3500
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
         ELtransD(ELt,r,rr) distance between existing or proposed interregional lines

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

         ELtransexist('HVAC',r,rr)$(ELtransexist('HVAC',rr,r)>0)
                 = ELtransexist('HVAC',rr,r);

         ELtransexist('HVAC',r,r) = 1e9;

         loop(rr,
                 ELtransD('UHVDC',r,rr)$(ELtransD('UHVDC',rr,r)>0) = 0
         );


         set ELtransr(ELt,r,rr);
          ELtransr(ELt,r,rr)$(ELtransD(ELt,r,rr)>0
                                 and rdem_on(r) and rdem_on(rr)) = yes ;
          ELtransr(ELt,r,r) = yes;

*         ELtransD('HVAC','East',rr) =0;
*         ELtransD('HVAC','Shandong','North') =0;
*         ELtransD('HVAC','Shandong','Henan') =0;

         Eltransyield('HVAC',r,rr)$ELtransr('HVAC',r,rr) = 0.94;

         Eltransyield('UHVDC',r,rr)$ELtransr('UHVDC',r,rr) = 0.95;

         Eltransyield('HVAC',r,r) = 0.95;

*         Eltransyield('HVAC','GD','GD') = 0.9468;
*         Eltransyield('HVAC','GX','GX') = 0.9318;
*         Eltransyield('HVAC','YN','YN') = 0.9203;
*         Eltransyield('HVAC','GZ','GZ') = 0.9465;

         Eltransyield('HVAC','South','South') = 0.94;
         Eltransyield('HVAC','Southwest','Southwest') = 0.93;


         Eltransyield('HVAC','central','east')=0.93;

         Eltransyield('HVAC',r,r) = 0.95;

*         execute_unload "db\ELtransyield.gdx", ELtransyield;

*         ELtranscoef(ELl,ELll,r,rr) = 0;
*         ELtranscoef(ELl,ELl,r,rr)$(smax(ELt,Eltransyield(Elt,r,rr))>0) = 1;


* !!!    update transmission costs
         ELtransconstcst('HVAC',time,r,rr)$ELtransr('HVAC',r,rr)=1757.9;
         ELtransconstcst('UHVDC',time,r,rr)$ELtransr('UHVDC',r,rr)=1600;


         ELtransconstcst(ELt,time,r,rr)$ELtransr(ELt,r,rr)= ELtransconstcst(ELt,time,r,rr)
                         *ELtransD(ELt,r,rr)/1e6;
         ELtranspurcst(ELt,time,r,rr)$ELtransr(ELt,r,rr)=0;


         ELtransomcst(ELt,r,r)=15;

* !!!    Scale interregional transmission costs based on estimated distance bewteen nodes.
         ELtransomcst(ELt,r,rr)$(ord(r) <> ord(rr))=
                 15*ELtransD(ELt,r,rr)/651;
;


         ELtransleadtime(r,rr) = 0 ;
;

parameter
         Elpeff(ELp,v) fuel efficiency
         ELfuelburn(ELp,v,f,cv,r) fuel required per MWh (coal ton - methane mmbtu - HFO&LFO ton)

         ELparasitic(Elp,v)  net producton resulting from parasitic load for various generators

         ELpCOparas(Elp,v,sulf,sox,nox) net producton resulting from parasitic load of coal generators with fgc
;

*        coal efficiency rate, from WEIO
         Elpeff('subcr',v)         = 0.37;
         Elpeff('Superc',v)        = 0.40;
         Elpeff('Ultrsc',v)        = 0.43;

* !!!    Efficiency penalty for older coal plants

         ELpeff(ELpcoal,vo)         = ELpeff(ELpcoal,'new')*0.98;

*        using 3.412 mmbtu/MWh and WEIO efficiencies for China
*         ELfuelburn('ST',v,'methane','CVf',r)          = 8.949;
         ELfuelburn('GT',v,'methane','CVf',r)          = 9.222;
         ELfuelburn('CC',v,'methane','CVf',r)          = 5.883;
         ELfuelburn('CCcon',v,'methane','CVf',r)       = 6;

*        fuel efficiency of power plants
         Elpeff('ST',v)           = 0.35;
         Elpeff('GT',v)           = 0.35;
         Elpeff('CC',v)           = 0.50;
         Elpeff('CCcon',v)        = 0.48;
*       Nuclear efficiency rate, from WEIO
         Elpeff(Elpnuc,v)       = 0.35;

         ELfuelburn('Nuclear',v,'u-235','CVf',r)       = 0.120;

*        coal efficiency rate, from WEIO

         ELfuelburn(ELpcoal,v,ELfcoal,cv_ord,r) =
                 FuelperMWH(ELfcoal)/Elpeff(ELpcoal,v)/COcvSCE(cv_ord);

         ELfuelburn(ELpnuc,v,ELfnuclear,'CVf',r) =
                 FuelperMWH(ELfnuclear)/Elpeff(ELpnuc,v);
*         ELfuelburn('GT',v,ELf,r)$(not ELfng(ELf))=0;
         ELfuelburn(ELpog,v,ELfref,'CVf',r) =
                 FuelperMWH(ELfref)/Elpeff(ELpog,v);
         ELfuelburn(ELpog,v,'lightcrude','CVf',r) =
                 FuelperMWH('lightcrude')/Elpeff(ELpog,v);

*         ELfuelburn(ELpd,v,f,cv,r)=ELfuelburn(ELpd,v,f,cv,r);

*        remove  plants with no fuelburn value  from ELpELf
         ELpELf(Elpd,ELf,fss,cv,sulf,sox,nox)$(smax((v,r),Elfuelburn(ELpd,v,ELf,cv,r))<=0)= no;


* !!!    Define parasitic loads
         ELparasitic(Elp,v)     = 1;
         ELparasitic(Elpcoal,v) = 1-0.06 ;
         ELparasitic(Elpog,v)   = 1-0.06 ;
         ELparasitic(Elphyd,v)  = 1-0.01;
         ELparasitic(Elpnuc,v)  = 1-0.05;

         ELpCOparas(Elpd,v,sulf,sox,nox) = ELparasitic(Elpd,v)
                 -(EMfgcpower(sulf,sox,nox)/Elpeff(Elpd,v))$ELpcoal(Elpd)

* !!!    Demand Data

* These values represent the r-specific LDCs.
parameters
         ELlcgw(rr,ELl) regional load in GW for each load segment in ELlchours
         ELlcgwsales(rr,ELl) regional load for grid sales in GW for each load segment in ELlchours
         ELlcgwonsite(rr,ELl) regional load for on site generation in GW for each load segment in ELlchours
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


         ELlcgwsales(r,ELl) = ELlcgw(r,ELl)
                 *4178/sum((rr,ELll),ELlcgw(rr,ELll)*ELlchours(ELll));

         ELdemandonsite(trun,r) = ELexistonsite(trun,r)*ELdemand(trun,r);
*        rescale onsite generation to 600 TWH
*        estimated by taking 2012 electricity sales (grid)
*        with transmission losses, and subtracting from total electricit prod.

         ELlcgwonsite(r,ELl) =
                 ELdemandonsite('t12',r)/sum(rr,ELdemandonsite('t12',rr))*
                 577/sum(ELll,ELlchours(ELll));

*         abort ELlcgwonsite;


parameter
         ELdemgro(ELl,time,r) Electricity demand growth rate relative to initial condition  ;
         ELdemgro(ELl,time,r)=1$rdem_on(r);


* !!!     Fix intial cpaacpity levels.



alias(v,vv);
         ELexistcs.fx(ELpd,v,trun,r)$(ord(trun)=1)=
                 sum((chp),ELexist(ELpd,v,chp,r));
;

*        Using IHS stats
         ELhydexistcs.fx(ELphyd,v,trun,r)$(ord(trun)=1)=
                 (ELhydexist(ELphyd,r))$vo(v);

*        distibute total WEPP hydro plant capacity amongst differen plant types
*        (lg, ROR, sto) given by the IHS midstream database
         ELhydexistcs.fx('hydrolg',v,trun,r)$(ord(trun)=1 and vo(v))=
          ELhydexistcs.l('hydrolg',v,trun,r)
         +ELhydroCEIC(r)
         -sum(ELphyd,ELhydexistcs.l(ELphyd,v,trun,r));
*                 ELexist('hydrolg',v,'no_chp',r)-sum(ELphyd,ELhydexist(ELphyd,r));

*        No offshore wind represented in the model. Data taken from IHS
         ELwindexistcp.fx('windon',v,trun,r)$(ord(trun)=1)
                 =(ELwindexist(r))$vo(v);

*         ELwindexistcp.fx('windon','old',trun,r)$(ord(trun)=1)=ELexist('windon','no_chp',r)+ELexist('windoff','no_chp',r);


         ELtransexistcp.fx(Elt,trun,r,rr)$(ord(trun)=1)
                 = ELtransexist(Elt,r,rr);

         ELfgcexistcp.fx(ELpd,v,DeSOx,trun,r)$(ord(trun)=1)=
                                         sum(chp,ELfgdexist(ELpd,v,chp,r))
;
         ELfgcexistcp.fx(ELpd,v,DeNOx,trun,r)$(ord(trun)=1)=
                                         sum(chp,ELnoxexist(ELpd,v,chp,r))
;

         ELhydop.fx(ELphydsto,v,ELl,trun,rr)=0;
         ELhydopsto.fx(ELl,v,trun,rr)=0;


Equations
* ====================== Primal Relationships=================================*
         ELobjective

* CAPITAL COSTS
         ELpurchbal(trun)            acumulates all import purchases
         ELcnstrctbal(trun)          accumlates all construction activity
         ELopmaintbal(trun)          accumulates operations and maintenance costs
* FUELS
         ELfcons(ELp,v,ELf,fss,trun,r)    supply of non coal fuel for power generation
         ELCOcons(ELp,v,cv,sulf,sox,nox,trun,r) supply of coal for power
         ELfavail(ELf,trun,r)        Available fuel constraint

* CAPACITIES (Dispatchable tech)
         ELcapbal(ELpd,v,trun,r) capacity balance constraint
         ELcaplim(ELpd,v,ELl,trun,r) electricity capacity constraint on the generators available or built cpacity
         ELcapstocklim(ELp,v,trun,r) limit on capacity used for production and upspin based on available capacity stock
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



* SPINNING RESERVES
         ELupspinres(ELl,trun,r) up spinning reserve (in case of sudden drop in renewable gen)
*         ELdnspinres(ELpd,ELl,trun,r) down spinning reserve (in case of sudden rise in ren. gen.)

* ELECTRICITY SUPPLY AND DEMAND
         ELsup(ELl,trun,r)            electricity supply constraints
         ELdem(ELl,trun,r)            electricity demand constraints
         ELrsrvreq(trun,r)            electricity reserve margin
         ELdemloc(ELl,trun,r)             local onsite electricity demand constraint

* TRANSMISSION
         ELtranscapbal(ELt,trun,r,rr)     electricity transportation capacity balance
         ELtranscaplim(ELt,Ell,trun,r,rr) electricity transportation capacity constraint

* FGD
*$ontext
         ELfgccaplim(Elpd,v,ELl,fgc,trun,r) capacity limit on flu gas control

         ELfgccapmax(ELpd,v,fgc,trun,r) maximum installed capacity for fgc


         ELfgccapbal(ELpd,v,fgc,trun,r) FGD capacity balance equation GW


         ELprofit(ELp,v,trun,r) regional Profit constraint on each generator type
*$offtext

*         ELCOcvlim(Elpd,trun,r) constraint on the lowest belended calorific value permited for a coal plant

         ELtranslim(trun,r,rr)

* =================== Dual Relationships =====================================*
         DELImports(trun)             dual from imports
         DELConstruct(trun)           dual from construct
         DELOpandmaint(trun)          dual from opandmaint

         DELbld(ELpd,v,trun,r)         dual from Elbld
         DELrsrvbld(ELpd,v,trun,r)
         DELwindbld(ELpw,v,trun,r)     dual from ELwindbld
         DELgttocc(Elp,v,trun,r)       dual from ELgttocc

         DELop(ELpd,v,ELl,ELf,fss,cv,sulf,sox,nox,trun,r) dual from ELop
         DELwindop(ELpw,v,ELl,trun,r)  dual from ELwindop
         DELexistcp(ELpd,v,trun,r)     dual from ELexistcp
         DELexistcs(ELpd,v,trun,r) dual from ELexistcs
         DELwindexistcs(ELpw,v,trun,r) dual from ELwindexistcs
         DELwindexistcp(ELpw,v,trun,r) dual from ELwindexistcp
         DELwindoplevel(wstep,ELpw,v,trun,r) dual from ELwindoplevel
         DELupspincap(ELpd,v,ELl,ELf,fss,cv,sulf,sox,nox,trun,r)  dual from ELupspincap
*         DELdnspincap(ELpd,v,ELl,trun,r)  dual from ELdnspincap

         DELtrans(ELt,ELl,trun,r,rr)      dual from ELtrans
         DELtransbld(ELt,trun,r,rr)       dual from ELtransbld
         DELtransexistcp(ELt,trun,r,rr)   dual from ELtransexistcp
         DELfconsump(ELpd,v,f,fss,trun,r)
         DELCOconsump(ELpcoal,v,cv,sulf,sox,nox,trun,r)

         DELhydexistcs(ELphyd,v,trun,r)  dual of ELhydexistcs
         DELhydexistcp(ELphyd,v,trun,r)  dual of ELhydexistcp
         DELhydbld(ELphyd,v,trun,r)      dual of ELhydbld
         DELhydop(ELphyd,v,ELl,trun,r)   dual of ELhydop
         DELhydopsto(ELl,v,trun,r) dual of ELhydopsto

         DELfgcexistcp(ELpd,v,fgc,trun,r)    dual of ELfgcexistcp
         DELfgcbld(ELpd,v,fgc,trun,r)        dual of ELfgcbld

         DELoploc(ELp,v,ELl,ELf,fss,cv,sulf,sox,nox,trun,r) dual on ELoploc
*         DELtop(ELpd,v,ELf,fss,trun,r)     dual from ELtop




parameter ELpcost(Elp,v,sox,nox,trun,r) Total cost of suppliying capacity for hours in load steps
          DELTA(Elp,v,sulf,sox,nox,trun,r) Difference between maximum tariff and variable non-fuel operating costs for supplying power to the utility
          DELTA2(Elp,v,trun,r) Difference between maximum tariff and variable non-fuel operating costs for supplying power to the utility
          ELpfixedcost(ELp,v,trun,r) Sum of all fixed costs capital and fixed o&m
          ELpsunkcost(ELp,v,trun,r) Sum of all sunk costs capital and fixed o&m
          ELpcapmod(Elp)
;
          ELpcapmod(Elp)=1.001;
$offorder

ELobjective.. z=e=
  +sum(t,(ELImports(t)+ELConstruct(t)+ELOpandmaint(t))*ELdiscfact(t))

  +sum((ELpcoal,v,ELf,fss,cv,sulf,sox,nox,t,r)$ELpELf(ELpcoal,ELf,fss,cv,sulf,sox,nox),
*          CoalFuelPrice*
          ELCOconsump(ELpcoal,v,cv,sulf,sox,nox,t,r))

  +sum((ELpd,v,ELf,fss,t,r)$(not ELfcoal(ELf) and not ELpcoal(Elpd)),
*         +OtherFuelPrices*
         ELfconsump(ELpd,v,ELf,fss,t,r))

  +sum((Elpd,v,t,r),
         +sum(ELppd$ELpbld(ELppd,v),ELcapadd(Elppd,ELpd)*
                 ELbld(Elppd,v,t-ELleadtime(Elppd),r)*ELpfixedcost(ELpd,v,t,r)
         )
  )


  +sum((ELpd,v,fgc,t,r)$(DeSOx(fgc) and ELpcoal(Elpd)),(
          +ELfgcbld(ELpd,v,fgc,t-ELfgcleadtime(ELpd),r)
         )*EMfgccapexD(fgc,t))
;

* CAPITAL COSTS
* Equipment/capital purchase costs [USD]


ELpurchbal(t)..
   sum((ELpd,v,r)$ELpbld(ELpd,v),ELpurcst(ELpd,t,r)*ELbld(ELpd,v,t,r))
  +sum((ELpd,v,r)$(vn(v) and ELpbld(Elpd,v)),ELpurcst(ELpd,t,r)*ELrsrvbld(Elpd,v,t,r))
  +sum((ELt,r,rr), ELtranspurcst(ELt,t,r,rr)*ELtransbld(ELt,t,r,rr))
  +sum((ELpw,v,r)$vn(v), ELPurcst(ELpw,t,r)*ELwindbld(ELpw,v,t,r))
  +sum((ELphyd,v,r)$vn(v),ELpurcst(ELphyd,t,r)*ELhydbld(ELphyd,v,t,r))

  -ELImports(t)=e=0;

* Construction costs for new capital/equipment and GTtoCC  [USD]
ELcnstrctbal(t)..
   sum((ELpd,v,r)$ELpbld(ELpd,v),ELconstcst(ELpd,t,r)*ELbld(ELpd,v,t,r))
  +sum((ELpd,v,r)$(vn(v) and ELpbld(Elpd,v)),
     ELconstcst(ELpd,t,r)*ELrsrvbld(Elpd,v,t,r))
  +sum((ELt,r,rr), ELtransconstcst(ELt,t,r,rr)*ELtransbld(ELt,t,r,rr))
  +sum((ELpw,v,r)$vn(v), ELconstcst(ELpw,t,r)*ELwindbld(ELpw,v,t,r))
  +sum((ELphyd,v,r)$vn(v), ELconstcst(ELphyd,t,r)*ELhydbld(ELphyd,v,t,r))

  -ELConstruct(t)=e=0;

* Operation and maintenance costs [USD]
ELopmaintbal(t)..

  +sum((Elpd,v,ELl,ELf,fss,cv,sulf,sox,nox,r)$ELpELf(ELpd,ELf,fss,cv,sulf,sox,nox),
         ELpcost(Elpd,v,sox,nox,t,r)*(
                 ELop(ELpd,v,ELl,ELf,fss,cv,sulf,sox,nox,t,r)
                 +ELusomfrac*ELlchours(ELl)*
                 ELupspincap(Elpd,v,ELl,ELf,fss,cv,sulf,sox,nox,t,r)$ELpspin(Elpd)
                 +ELlchours(ELl)*
                 ELoploc(ELpd,v,ELl,ELf,fss,cv,sulf,sox,nox,t,r)$(not ELpnuc(ELpd))
         )
  )

  +sum((ELpd,v,r)$ELpbld(ELpd,v),
         ELfixedOMcst(ELpd)*ELbld(ELpd,v,t-ELleadtime(ELpd),r))


  +sum((ELpd,v,r)$(vn(v) and ELpbld(Elpd,v)),
         ELfixedOMcst(ELpd)*ELrsrvbld(ELpd,v,t-ELleadtime(ELpd),r))

  +sum((ELpw,v,ELl,r),ELomcst(ELpw,v,r)*ELwindop(ELpw,v,ELl,t,r))
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
ELfcons(ELpd,v,ELf,fss,t,r)$(not ELfcoal(ELf) and not Elpcoal(ELpd))..

  ELfconsump(ELpd,v,ELf,fss,t,r)

  -sum((ELl,cv,sulf,sox,nox)$ELpELf(ELpd,ELf,fss,cv,sulf,sox,nox),
         ELfuelburn(ELpd,v,ELf,cv,r)*
         (        ELop(ELpd,v,ELl,ELf,fss,cv,sulf,sox,nox,t,r)
                 +ELupspincap(Elpd,v,ELl,ELf,fss,cv,sulf,sox,nox,t,r)
                 *ELusrfuelfrac*ELlchours(ELl)$ELpspin(Elpd)
                 +ELlchours(ELl)*
                 ELoploc(ELpd,v,ELl,ELf,fss,cv,sulf,sox,nox,t,r)$(not ELpnuc(ELpd))
         )
   )
                         =g=0
;

ELCOcons(ELpcoal,v,cv,sulf,sox,nox,t,r)$(cv_ord(cv))..
  +ELCOconsump(ELpcoal,v,cv,sulf,sox,nox,t,r)

  -sum((ELl,ELf,fss)$ELpELf(ELpcoal,ELf,fss,cv,sulf,sox,nox),
         ELfuelburn(ELpcoal,v,ELf,cv,r)*
         (        ELop(ELpcoal,v,ELl,ELf,fss,cv,sulf,sox,nox,t,r)
                 +ELupspincap(Elpcoal,v,ELl,ELf,fss,cv,sulf,sox,nox,t,r)
                 *ELusrfuelfrac*ELlchours(ELl)$ELpspin(Elpcoal)
                 +ELlchours(ELl)*
                 ELoploc(ELpcoal,v,ELl,ELf,fss,cv,sulf,sox,nox,t,r)
         )
   )
                         =g=0
;



* supply of available fuel [units of fuel energy]
ELfavail(ELf,t,r)$(ELfog(ELf))..
  -sum((ELpd,v)$(not ELpcoal(Elpd)),ELfconsump(ELpd,v,ELf,'ss0',t,r))
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
  -sum((ELpd,v,ELf,fss,cv,sulf,sox,nox)$(ELpnuc(ELpd) and
                                 ELpELf(ELpd,ELf,fss,cv,sulf,sox,nox)),
         ELop(ELpd,v,ELl,ELf,fss,cv,sulf,sox,nox,t,r))
  +sum((ELpd,v,ELll,ELf,fss,cv,sulf,sox,nox)$(ELpnuc(ELpd) and
                                 ELpELf(ELpd,ELf,fss,cv,sulf,sox,nox)),
         ELop(ELpd,v,ELll,ELf,fss,cv,sulf,sox,nox,t,r))*ELlcnorm(ELl) =e=0
;


* CAPACITIES
* balance of existing, additional, and future capacity [GW]
ELcapbal(ELpd,v,t,r).. ELexistcs(ELpd,v,t,r)
   +sum(Elppd$ELpbld(Elppd,v),ELcapadd(Elppd,ELpd)*
                                 ELbld(Elppd,v,t-ELleadtime(Elppd),r))
   -ELexistcs(ELpd,v,t+1,r)=g=0;


ELcapstocklim(ELp,v,t,r)..

  +(ELexistcs(ELp,v,t,r)-ELexistcp(ELp,v,t,r))$ELpd(ELp)
  +(ELhydexistcs(ELp,v,t,r)-ELhydexistcp(ELp,v,t,r))$ELphyd(ELp)
  +(ELwindexistcs(ELp,v,t,r)-ELwindexistcp(ELp,v,t,r))$ELpw(ELp)
         =g=0
;


ELcaplim(ELpd,v,ELl,t,r)..
   ELcapfac(ELpd,v)*ELlchours(ELl)*(
          ELexistcp(ELpd,v,t,r)
         +sum(Elppd$ELpbld(Elppd,v),
                 ELcapadd(Elppd,ELpd)*ELbld(Elppd,v,t-ELleadtime(Elppd),r))
   )

  -sum((ELf,fss,cv,sulf,sox,nox)$ELpELf(ELpd,ELf,fss,cv,sulf,sox,nox),
          ELop(ELpd,v,ELl,ELf,fss,cv,sulf,sox,nox,t,r)
         +ELupspincap(Elpd,v,ELl,ELf,fss,cv,sulf,sox,nox,t,r)*
                 ELlchours(ELl)$Elpspin(Elpd)
         +ELlchours(ELl)*
         ELoploc(ELpd,v,ELl,ELf,fss,cv,sulf,sox,nox,t,r)$(not ELpnuc(ELpd))
  )
                 =g=0
;


ELcapcontr(ELpd,v,t,r)$vo(v)..
  +sum((ELl,ELf,fss,cv,sulf,sox,nox)$ELpELf(ELpd,ELf,fss,cv,sulf,sox,nox),
         ELop(ELpd,v,ELl,ELf,fss,cv,sulf,sox,nox,t,r))
  -ELexistcp(ELpd,v,t,r)*ELcntrhrs(ELpd,v,t,r)=g= 0
;


*    To ensure that remaining convertible capacity can be positive in the last period [GW]
ELgtconvlim(ELpgttocc,vo,t,r)..
  -ELgttocc(ELpgttocc,vo,t+1,r)-ELbld(ELpgttocc,vo,t,r)
  +ELgttocc(ELpgttocc,vo,t,r)=g=0
;


* HYDRO
ELhydcapbal(ELphyd,v,t,r).. ELhydexistcs(ELphyd,v,t,r)
   +ELhydbld(ELphyd,v,t-ELleadtime(ELphyd),r)$vn(v)
   -ELhydexistcs(ELphyd,v,t+1,r)=g=0
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
ELwindutil(ELpw,ELl,v,t,r).. sum(wstep,ELdiffGW(wstep,ELl,r)*
    ELdemgro(ELl,t,r)*ELwindoplevel(wstep,ELpw,v,t,r))*ELlchours(ELl)
   -ELwindop(ELpw,v,ELl,t,r)
                 =g=0
;

ELwindcapsum(wstep,t,r).. -sum((ELpw,v),ELwindoplevel(wstep,ELpw,v,t,r))=g=-1;


* SPINNING RESERVES
ELupspinres(ELl,t,r)..
  -ELwindspin*sum((wstep,ELpw,v),
         ELdiffGW(wstep,ELl,r)*ELdemgro(ELl,t,r)*ELwindoplevel(wstep,ELpw,v,t,r)*ELparasitic(Elpw,v))
  +sum((ELpd,v,ELf,fss,cv,sulf,sox,nox)$(ELpELf(ELpd,ELf,fss,cv,sulf,sox,nox)
         and ELpspin(ELpd)),ELupspincap(ELpd,v,ELl,ELf,fss,cv,sulf,sox,nox,t,r)*
         ELpCOparas(Elpd,v,sulf,sox,nox))
=g=0;

* ELECTRICITY SUPPLY AND DEMAND
ELsup(ELl,t,r)..
   sum((ELpd,v,ELf,fss,cv,sulf,sox,nox)$(ELpELf(ELpd,ELf,fss,cv,sulf,sox,nox)),
         ELop(ELpd,v,ELl,ELf,fss,cv,sulf,sox,nox,t,r)*
         ELpCOparas(Elpd,v,sulf,sox,nox))
  +sum((ELphyd,v),ELhydop(ELphyd,v,ELl,t,r)*ELparasitic(Elphyd,v))
  +sum((ELpw,v),ELwindop(ELpw,v,ELl,t,r)*ELparasitic(Elpw,v))

*   -sum((v),ELhydopsto(ELl,v,t,r))

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
*   -sum((v),ELhydopsto(ELl,v,t,rr))
*   -PCELconsump(ELl,t,rr)-RFELconsump(ELl,t,rr)
         =g=ELlcgwsales(rr,ELl)*ELdemgro(ELl,t,rr)*ELlchours(ELl);


ELdemloc(ELl,t,r)..
   sum((ELpd,v,ELf,fss,cv,sulf,sox,nox)$(ELpELf(ELpd,ELf,fss,cv,sulf,sox,nox)
         and not ELpnuc(ELpd)),
         ELoploc(ELpd,v,ELl,ELf,fss,cv,sulf,sox,nox,t,r))
                 =g= (ELlcgwonsite(r,ELl)*ELdemgro(ELl,t,r))
;

* WAELconsump (hybrid RO) is assumed to take directly from supply, bypassing the grid

ELrsrvreq(t,r)..

   sum((ELpd,v), ELexistcs(ELpd,v,t,r))
  +sum((ELpd,v,Elppd)$ELpbld(Elppd,v),
     ELcapadd(Elppd,ELpd)*ELbld(Elppd,v,t-ELleadtime(Elppd),r))
  +sum((ELpd,v)$(vn(v) and ELpbld(Elpd,v)),
     ELrsrvbld(Elpd,v,t-ELleadtime(Elpd),r))
  +sum((ELphyd,v),
     ELhydexistcs(ELphyd,v,t,r)+ELhydbld(ELphyd,v,t-ELleadtime(ELphyd),r)$vn(v))
         =g= ELreserve*ELlcgw(r,'LS1')*ELdemgro('LS1',t,r);

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
ELfgccaplim(ELpd,v,ELl,sox,t,r)$(DeSOx(sox) and ELpcoal(ELpd))..
* and DeSOx(fgc) or DeNOx(fgc)))..
   ELcapfac(ELpd,v)*ELlchours(ELl)*(
          ELfgcexistcp(ELpd,v,sox,t,r)
         +ELfgcbld(ELpd,v,sox,t-ELfgcleadtime(ELpd),r)
   )

    -sum((ELf,fss,cv,sulf,nox)$(ELpELf(ELpd,ELf,fss,cv,sulf,sox,nox)),
         ELop(ELpd,v,ELl,ELf,fss,cv,sulf,sox,nox,t,r)
        +ELupspincap(Elpd,v,ELl,ELf,fss,cv,sulf,sox,nox,t,r)*
         ELlchours(ELl)$Elpspin(Elpd)
    )
          =g= 0
;


ELfgccapmax(ELpd,v,fgc,t,r)$(ELpcoal(ELpd) and DeSOx(fgc))..
* or DeNOx(fgc)))..

   ELexistcp(ELpd,v,t,r)
  +ELbld(ELpd,v,t-ELleadtime(ELpd),r)$ELpbld(ELpd,v)
  -ELfgcexistcp(ELpd,v,fgc,t,r)
  -ELfgcbld(ELpd,v,fgc,t-ELfgcleadtime(ELpd),r)
          =g= 0
;


* balance of existing, additional, and future capacity [GW]
ELfgccapbal(ELpd,v,fgc,t,r)$(ELpcoal(ELpd) and DeSOx(fgc))..
* or DeNOx(fgc)))..
   ELfgcexistcp(ELpd,v,fgc,t,r)
  +ELfgcbld(ELpd,v,fgc,t-ELfgcleadtime(ELpd),r)
  -ELfgcexistcp(ELpd,v,fgc,t+1,r)=g=0
;

*$offtext


ELprofit(ELp,v,t,r)$ELptariff(ELp,v)..

sum((ELl,ELf,fss,cv,sulf,sox,nox)$(ELpELf(ELp,ELf,fss,cv,sulf,sox,nox)
                                         and ELpd(ELp)),
   DELTA(Elp,v,sulf,sox,nox,t,r)*ELop(ELp,v,ELl,ELf,fss,cv,sulf,sox,nox,t,r)

  -( DCOdem(ELf,cv,sulf,'summ',t,r)
     -sum(rco$(rco_dem(rco,r) and not r(rco) and rcodem(rco)),
       DCOsuplim(ELf,cv,sulf,'summ',t,rco)*Elsnorm('summ')/num_nodes_reg(r))
    )*(ELop(ELp,v,ELl,ELf,fss,cv,sulf,sox,nox,t,r)*
         ELfuelburn(ELp,v,ELf,cv,r))$ELpcoal(Elp)

  -(ELAPf(ELf,fss,t,r)*ELop(ELp,v,ELl,ELf,fss,cv,sulf,sox,nox,t,r)*
         ELfuelburn(ELp,v,ELf,cv,r))$(ELpd(ELp) and not Elpcoal(ELp))
)

$ontext
  -sum((ELpd,vv,ELl,ELf,fss,cv,sulf,sox,nox)$(Elpspin(Elpd) and
                                         ELpELf(ELpd,ELf,fss,cv,sulf,sox,nox)),
       ELupspincap(Elpd,vv,ELl,ELf,fss,cv,sulf,sox,nox,t,r)*(
          ELpcost(Elpd,v,sox,nox,t,r)*ELlchours(ELl)*ELusomfrac
         +( ( DCOdem(ELf,cv,sulf,'summ',t,r)
             -sum(rco$(rco_dem(rco,r) and not r(rco) and rcodem(rco)),
                DCOsuplim(ELf,cv,sulf,'summ',t,rco)*
                Elsnorm('summ')/num_nodes_reg(r))
            )$ELpcoal(Elpd)
           +ELAPf(ELf,fss,t,r)$(not Elpcoal(ELpd))
          )*ELfuelburn(ELpd,v,ELf,cv,r)*ELlchours(ELl)*ELusrfuelfrac
         +ELpsunkcost(ELpd,v,t,r)*ELusomfrac
       )
   )$(ELpw(ELp) and vn(v))
$offtext


  +sum(ELl,DELTA2(Elp,v,t,r)*ELhydop(ELp,v,ELl,t,r))$ELphyd(ELp)
  +sum((ELl,vv),DELTA2(Elp,vv,t,r)*
         ELwindop(ELp,vv,ELl,t,r))$(ELpw(ELp) and vn(v))


  -(  ELwindbld(ELp,v,t,r)$(vn(v) and ELpw(ELp))
     +ELhydbld(ELp,v,t,r)$(vn(v) and ELphyd(ELp))
     +sum(ELppd$ELpbld(ELppd,v),ELcapadd(Elppd,ELp)*
         ELbld(Elppd,v,t-ELleadtime(Elppd),r))$ELpd(ELp)
   )*ELpfixedcost(ELp,v,t,r)

  -(  sum(vv,ELwindexistcp(ELp,vv,t,r))$(vn(v) and ELpw(ELp))
     +ELhydexistcp(ELp,v,t,r)$ELphyd(ELp)
     +(ELexistcp(ELp,v,t,r)
       -sum((ELl,ELf,fss,cv,sulf,sox,nox)$(ELpELf(ELp,ELf,fss,cv,sulf,sox,nox)),
          ELupspincap(Elp,v,ELl,ELf,fss,cv,sulf,sox,nox,t,r)$(ELpspin(ELp))
         +ELoploc(ELp,v,ELl,ELf,fss,cv,sulf,sox,nox,t,r)$(not ELpnuc(ELp)) )
      )$ELpd(ELp)
  )*ELpsunkcost(ELp,v,t,r)

  -sum(sox$(DeSOx(sox) and ELpcoal(ELp)),(ELfgcexistcp(ELp,v,sox,t,r)
         +ELfgcbld(ELp,v,sox,t-ELfgcleadtime(ELp),r))*EMfgccapexD(sox,t)
  )
         =g= 0
;


* ==================== DUAL RELATIONSHIPS =====================================
*$ontext

DELimports(t)..  1*ELdiscfact(t)=g=-DELpurchbal(t);
DELConstruct(t).. 1*ELdiscfact(t)=g=-DELcnstrctbal(t);
DELOpandmaint(t).. 1*ELdiscfact(t)=g=-DELopmaintbal(t);

DELfconsump(ELpd,v,ELf,fss,t,r)$(not ELpcoal(ELpd) and not ELfcoal(ELf))..
   ELAPf(ELf,fss,t,r)*ELdiscfact(t)*(0$(fss0(fss))+1$(not fss0(fss)))
*or not ELfmethane(Elf)
         +0=g=
  +DELfcons(ELpd,v,ELf,fss,t,r)
*  -DELprofit(ELpd,v,t,r)*DELfcons(ELpd,v,ELf,fss,t,r)$ELptariff(ELpd,v)
*  -DELprofit(ELpd,v,t,r)*ELAPf(ELf,fss,t,r)$ELptariff(ELpd,v)
  -DELfavail(ELf,t,r)$(ELfog(ELf) and fss0(fss))
;

DELCOconsump(ELpcoal,v,cv,sulf,sox,nox,t,r)$cv_ord(cv)..
 (  DCOdem('coal',cv,sulf,'summ',t,r)
  -sum(rco$(rco_dem(rco,r) and not r(rco) and rcodem(rco)),
    DCOsuplim('coal',cv,sulf,'summ',t,rco)*Elsnorm('summ')/num_nodes_reg(r))
 )*ELdiscfact(t)
         +0=g=
  DELCOcons(ELpcoal,v,cv,sulf,sox,nox,t,r)

  -DEMsulflim(t,r)*EMfgc(sox)*COsulfDW(sulf)*1.6*1$rdem_on(r)
*  -DEMELnoxlim(t,r)*EMfgc(nox)*VrCo(ELpcoal,'coal',cv)*NOxC(r,ELpcoal)

;


DELexistcs(ELpd,v,t,r)..

   0
         =g=
  +DELcapstocklim(ELpd,v,t,r)
  +DELcapbal(ELpd,v,t,r)-DELcapbal(ELpd,v,t-1,r)
  +DELrsrvreq(t,r)
;


DELexistcp(ELpd,v,t,r)..

        +0 =g=

  -DELprofit(ELpd,v,t,r)*ELpsunkcost(ELpd,v,t,r)$ELptariff(ELpd,v)

  -DELcapstocklim(ELpd,v,t,r)

  +sum(ELl,DELcaplim(ELpd,v,ELl,t,r)*ELcapfac(ELpd,v)*ELlchours(ELl))
  -DELcapcontr(Elpd,v,t,r)*ELcntrhrs(ELpd,v,t,r)

  +sum(fgc$(ELpcoal(ELpd) and DeSOx(fgc)),
         DELfgccapmax(ELpd,v,fgc,t+ELleadtime(ELpd),r))
* or DeNOx(fgc))),
;

DELbld(ELpd,v,t,r)$ELpbld(ELpd,v)..

*  sum(ELppd,ELcapadd(Elpd,ELppd)*ELpfixedcost(ELppd,v,t,r)*ELdiscfact(t))
   +0=g=
    DELpurchbal(t)*ELpurcst(Elpd,t,r)
   +DELcnstrctbal(t)*ELconstcst(ELpd,t,r)
   +DELopmaintbal(t+ELleadtime(ELpd))*ELfixedOMcst(ELpd)

  -sum(ELppd$ELptariff(Elppd,v),ELcapadd(Elpd,ELppd)*
         DELprofit(Elppd,v,t+ELleadtime(ELpd),r)*
    ELpfixedcost(ELppd,v,t,r))

  +sum(Elppd,DELcapbal(Elppd,v,t+ELleadtime(ELpd),r)*ELcapadd(ELpd,Elppd))
*  -DELgtconvlim(ELpd,v,t,r)$(ELpgttocc(ELpd) and vo(v))
  +sum((ELl,Elppd),DELcaplim(Elppd,v,ELl,t+ELleadtime(ELpd),r)
         *ELcapadd(ELpd,Elppd)*ELcapfac(ELpd,v)*ELlchours(ELl))
  +DELrsrvreq(t+ELleadtime(ELpd),r)*sum(Elppd,ELcapadd(ELpd,Elppd))
;

DELrsrvbld(ELpd,v,t,r)$(vn(v) and ELpbld(ELpd,v)).. 0 =g=
    DELpurchbal(t)*ELpurcst(Elpd,t,r)
   +DELcnstrctbal(t)*ELconstcst(ELpd,t,r)
   +DELopmaintbal(t+ELleadtime(ELpd))*ELfixedOMcst(ELpd)
   +DELrsrvreq(t+ELleadtime(ELpd),r)
;


DELop(ELpd,v,ELl,ELf,fss,cv,sulf,sox,nox,t,r)$ELpELf(ELpd,ELf,fss,cv,sulf,sox,nox)..
                +0 =g=
  +ELpcost(Elpd,v,sox,nox,t,r)*DELopmaintbal(t)
  +DELTA(Elpd,v,sulf,sox,nox,t,r)*DELprofit(ELpd,v,t,r)$ELptariff(ELpd,v)

  -DELprofit(ELpd,v,t,r)*ELAPf(ELf,fss,t,r)*ELfuelburn(ELpd,v,ELf,cv,r)$(not ELpcoal(ELpd) and ELptariff(ELpd,v))
  -DELprofit(ELpd,v,t,r)*ELfuelburn(Elpd,v,ELf,cv,r)*
   (DCOdem(ELf,cv,sulf,'summ',t,r)
         -sum(rco$(rco_dem(rco,r) and not r(rco) and rcodem(rco)),
       DCOsuplim(ELf,cv,sulf,'summ',t,rco)*Elsnorm('summ')/num_nodes_reg(r))
   )$(ELpcoal(ELpd) and ELptariff(ELpd,v))

  +DELcapcontr(ELpd,v,t,r)$vo(v)

  -ELfuelburn(ELpd,v,ELf,cv,r)*DELfcons(ELpd,v,ELf,fss,t,r)$(not ELpcoal(ELpd))
  -ELfuelburn(ELpd,v,ELf,cv,r)*
         DELCOcons(ELpd,v,cv,sulf,sox,nox,t,r)$ELpcoal(Elpd)
  -DELcaplim(ELpd,v,ELl,t,r)

  -DELnucconstraint(ELl,t,r)$ELpnuc(ELpd)
  +sum(ELll,DELnucconstraint(ELll,t,r)*ELlcnorm(ELll))$ELpnuc(ELpd)

  +DELsup(ELl,t,r)*ELpCOparas(Elpd,v,sulf,sox,nox)
  -DELfgccaplim(ELpd,v,ELl,sox,t,r)$(DeSOx(sox) and ELpcoal(ELpd))
;


DELupspincap(Elpd,v,ELl,ELf,fss,cv,sulf,sox,nox,t,r)$(Elpspin(Elpd)
         and ELpELf(ELpd,ELf,fss,cv,sulf,sox,nox)).. 0 =g=
  +ELpcost(Elpd,v,sox,nox,t,r)*DELopmaintbal(t)*ELusomfrac*ELlchours(ELl)

$ontext
  -sum((ELp,vv)$(ELpw(ELp) and vn(vv) and ELptariff(ELp,vv)),
         DELprofit(ELp,vv,t,r))*
  (
     ELpcost(Elpd,v,sox,nox,t,r)*ELlchours(ELl)*ELusomfrac
    +( ( DCOdem(ELf,cv,sulf,'summ',t,r)
        -sum(rco$(rco_dem(rco,r) and not r(rco) and rcodem(rco)),
                 DCOsuplim(ELf,cv,sulf,'summ',t,rco)*
                 Elsnorm('summ')/num_nodes_reg(r))
       )$ELpcoal(Elpd)
      +ELAPf(ELf,fss,t,r)$(not Elpcoal(ELpd))
     )*ELfuelburn(ELpd,v,ELf,cv,r)*ELlchours(ELl)*ELusrfuelfrac
    +ELpsunkcost(ELpd,v,t,r)*ELusomfrac
  )
$offtext

  +ELpsunkcost(ELpd,v,t,r)*DELprofit(ELpd,v,t,r)$ELptariff(ELpd,v)
  -ELfuelburn(ELpd,v,ELf,cv,r)*ELusrfuelfrac*ELlchours(ELl)*
         DELfcons(ELpd,v,ELf,fss,t,r)$(not ELfcoal(ELf))
  -ELfuelburn(ELpd,v,ELf,cv,r)*ELusrfuelfrac*ELlchours(ELl)*
         DELCOcons(ELpd,v,cv,sulf,sox,nox,t,r)$ELpcoal(Elpd)
  -DELcaplim(ELpd,v,ELl,t,r)*ELlchours(ELl)

  +DELupspinres(ELl,t,r)*ELpCOparas(Elpd,v,sulf,sox,nox)
  -DELfgccaplim(ELpd,v,ELl,sox,t,r)*ELlchours(ELl)$(DeSOx(sox) and ELpcoal(ELpd))
;

*$ontext
DELoploc(ELpd,v,ELl,ELf,fss,cv,sulf,sox,nox,t,r)$(not ELpnuc(ELpd) and
                 ELpELf(ELpd,ELf,fss,cv,sulf,sox,nox))..   0 =g=
  +ELlchours(ELl)*ELpcost(Elpd,v,sox,nox,t,r)*DELopmaintbal(t)
  +ELpsunkcost(ELpd,v,t,r)*DELprofit(ELpd,v,t,r)$ELptariff(ELpd,v)
  -ELlchours(ELl)*ELfuelburn(ELpd,v,ELf,cv,r)*DELfcons(ELpd,v,ELf,fss,t,r)$(not ELpcoal(ELpd))
  -ELlchours(ELl)*ELfuelburn(ELpd,v,ELf,cv,r)*
         DELCOcons(ELpd,v,cv,sulf,sox,nox,t,r)$ELpcoal(Elpd)
  -ELlchours(ELl)*DELcaplim(ELpd,v,ELl,t,r)
  +DELdemloc(ELl,t,r)
;
*$offtext

DELgttocc(ELpgttocc,vo,t,r).. 0=g=DELgtconvlim(ELpgttocc,vo,t,r)
   -DELgtconvlim(ELpgttocc,vo,t-1,r);

DELtrans(ELt,ELl,t,r,rr)$ELtransr(ELt,r,rr)..
      0   =g=
  -DELsup(ELl,t,r)
  +DELopmaintbal(t)*ELtransomcst(ELt,r,rr)
*ELlchours(ELl)
  +sum(ELll,DELdem(ELll,t,rr)*Eltransyield(ELt,r,rr)
                 *ELtranscoef(ELl,ELll,r,rr))
*ELlchours(ELl)
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
   DELpurchbal(t)*ELpurcst(Elpw,t,r)
  -DELprofit(ELpw,v,t,r)*ELpfixedcost(ELpw,v,t,r)$ELptariff(ELpw,v)
  +DELopmaintbal(t+ELleadtime(ELpw))*ELfixedOMcst(ELpw)
  +DELcnstrctbal(t)*ELconstcst(ELpw,t,r)
  +DELwindcapbal(ELpw,v,t+ELleadtime(ELpw),r)
  +DELwindcaplim(ELpw,v,t+ELleadtime(ELpw),r)
;

DELwindexistcs(ELpw,v,t,r).. 0=g=

  +DELcapstocklim(ELpw,v,t,r)
  +DELwindcapbal(ELpw,v,t,r)-DELwindcapbal(ELpw,v,t-1,r)

;


DELwindexistcp(ELpw,v,t,r).. 0=g=

  -DELcapstocklim(ELpw,v,t,r)
  +DELwindcaplim(ELpw,v,t,r)
  -DELprofit(ELpw,v,t,r)*ELpsunkcost(ELpw,v,t,r)$(vn(v) and ELptariff(ELpw,v))
;

DELwindop(ELpw,v,ELl,t,r)..
                0 =g=

  +DELTA2(Elpw,v,t,r)*
         sum(vv$(vn(vv) and ELptariff(ELpw,vv)),DELProfit(ELpw,vv,t,r))

  +DELsup(ELl,t,r)*ELparasitic(Elpw,v)
  +DELopmaintbal(t)*ELomcst(ELpw,v,r)
  -DELwindutil(ELpw,ELl,v,t,r)
;

DELwindoplevel(wstep,ELpw,v,t,r)..
       +0  =g=
  -sum(ELl,DELwindcaplim(ELpw,v,t,r)*(ELwindcap(wstep)-ELwindcap(wstep-1))*ELdemgro(ELl,t,r))
  +sum(ELl,ELdiffGW(wstep,ELl,r)*ELdemgro(ELl,t,r)*DELwindutil(ELpw,ELl,v,t,r)*ELlchours(ELl))
  -DELwindcapsum(wstep,t,r)
  -ELwindspin*sum(ELl,DELupspinres(ELl,t,r)*
         ELdiffGW(wstep,ELl,r)*ELdemgro(ELl,t,r)*ELparasitic(Elpw,v))
;


DELhydexistcs(ELphyd,v,t,r).. 0=g=

  +DELcapstocklim(ELphyd,v,t,r)
  +DELhydcapbal(ELphyd,v,t,r)-DELhydcapbal(ELphyd,v,t-1,r)
  +DELrsrvreq(t,r)
;


DELhydexistcp(ELphyd,v,t,r).. 0=g=
  -DELcapstocklim(ELphyd,v,t,r)
  +sum(ELl,DELhydcaplim(ELphyd,ELl,v,t,r)*ELcapfac(Elphyd,v)*ELlchours(ELl))
  +DELhydutil(ELphyd,v,t,r)*ELhydhrs(r)*ELcapfac(Elphyd,v)$(not ELphydsto(ELphyd))
  -DELprofit(ELphyd,v,t,r)*ELpsunkcost(ELphyd,v,t,r)$ELptariff(ELphyd,v)
;

DELhydbld(ELphyd,v,t,r)$vn(v)..  0=g=

   DELpurchbal(t)*Elpurcst(ELphyd,t,r)
  +DELcnstrctbal(t)*ELconstcst(ELphyd,t,r)
  +DELopmaintbal(t+ELleadtime(ELphyd))*ELfixedOMcst(ELphyd)

  -DELprofit(ELphyd,v,t,r)*ELpfixedcost(ELphyd,v,t,r)$ELptariff(ELphyd,v)

  +DELhydcapbal(ELphyd,v,t+ELleadtime(ELphyd),r)
  +sum(ELl,DELhydcaplim(ELphyd,ELl,v,t+ELleadtime(ELphyd),r)*ELcapfac(Elphyd,v)*ELlchours(ELl))
  +DELhydutil(ELphyd,v,t+ELleadtime(ELphyd),r)*ELhydhrs(r)*ELcapfac(Elphyd,v)$(not ELphydsto(ELphyd))
  +DELrsrvreq(t+ELleadtime(ELphyd),r)
;

DELhydop(ELphyd,v,ELl,t,r)..
               0  =g=

  +DELTA2(Elphyd,v,t,r)*DELProfit(ELphyd,v,t,r)$ELptariff(ELphyd,v)

  +DELsup(ELl,t,r)*ELparasitic(Elphyd,v)
  +DELopmaintbal(t)*ELomcst(ELphyd,v,r)
  -DELhydcaplim(ELphyd,ELl,v,t,r)
  -DELhydutil(ELphyd,v,t,r)$(not ELphydsto(ELphyd))
*  -DELhydutilsto(v,t,r)$(ELphydsto(ELphyd))
;

DELhydopsto(ELl,v,t,r)..  0=g=
  -sum(ELphyd$ELphydsto(ELphyd),DELhydcaplim(ELphyd,ELl,v,t,r))
  +DELhydutilsto(v,t,r)*ELhydstoeff
  -DELdem(ELl,t,r)
;

*$ontext

DELfgcexistcp(ELpd,v,fgc,t,r)$(ELpcoal(ELpd) and DeSOx(fgc))..
* or DeNOx(fgc))) ..
      +0 =g=
  -EMfgccapexD(fgc,t)*DELprofit(ELpd,v,t,r)$ELptariff(ELpd,v)
  +DELfgccapbal(ELpd,v,fgc,t,r)-DELfgccapbal(ELpd,v,fgc,t-1,r)
  +sum(ELl,DELfgccaplim(ELpd,v,ELl,fgc,t,r)*
         ELcapfac(ELpd,v)*ELlchours(ELl))
 -DELfgccapmax(ELpd,v,fgc,t,r)
;

DELfgcbld(ELpd,v,fgc,t,r)$(ELpcoal(ELpd) and DeSOx(fgc))..
* or DeNOx(fgc)))..
   EMfgccapexD(fgc,t)*ELdiscfact(t)
         =g=
  -EMfgccapexD(fgc,t)*DELprofit(ELpd,v,t+ELfgcleadtime(ELpd),r)$ELptariff(ELpd,v)
  +DELfgccapbal(ELpd,v,fgc,t+ELfgcleadtime(ELpd),r)
  +sum(ELl,DELfgccaplim(ELpd,v,ELl,fgc,t+ELfgcleadtime(ELpd),r)*
         ELcapfac(ELpd,v)*ELlchours(ELl))
  -DELfgccapmax(ELpd,v,fgc,t+ELfgcleadtime(ELpd),r)
;



* !!!    Include emissions submodule
$INCLUDE emissionsubmodel.gms

*$offtext
;


*$ontext

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


ELProfit.DELprofit,
ELpurchbal.DELpurchbal,ELcnstrctbal.DELcnstrctbal,ELopmaintbal.DELopmaintbal,
ELfcons.DELfcons,ELCOcons.DELCOcons,
*ELfconsspin.DELfcons
ELfavail.DELfavail,ELcapbal.DELcapbal,ELcapstocklim.DELcapstocklim,
ELcaplim.DELcaplim,ELcapcontr.DELcapcontr,
*ELgtconvlim.DELgtconvlim,

ELwindcapbal.DELwindcapbal,ELwindcaplim.DELwindcaplim,ELwindutil.DELwindutil,
ELwindcapsum.DELwindcapsum,ELupspinres.DELupspinres,
ELnucconstraint.DELnucconstraint,

ELsup.DELsup,ELdem.DELdem,ELdemloc.DELdemloc,ELrsrvreq.DELrsrvreq,

ELtranscapbal.DELtranscapbal,ELtranscaplim.DELtranscaplim,
ELhydcapbal.DELhydcapbal,ELhydcaplim.DELhydcaplim,ELhydutil.DELhydutil,


*ELhydutilsto.DELhydutilsto,

ELfgccaplim.DELfgccaplim,ELfgccapmax.DELfgccapmax,ELfgccapbal.DELfgccapbal,

DELImports.ELImports,DELConstruct.ELConstruct,DELOpandmaint.ELOpandmaint,
DELexistcs.ELexistcs,DELexistcp.ELexistcp,DELbld.ELbld,DELrsrvbld.ELrsrvbld,
*DELgttocc.ELgttocc,
DELop.ELop,DELoploc.ELoploc,DELupspincap.ELupspincap,
DELwindop.ELwindop,DELwindoplevel.ELwindoplevel,
DELwindexistcs.ELwindexistcs,DELwindexistcp.ELwindexistcp,DELwindbld.ELwindbld,

DELtrans.ELtrans,DELtransbld.ELtransbld,DELtransexistcp.ELtransexistcp,
DELfconsump.ELfconsump,DELCOconsump.ELCOconsump,
*DELfconsumpspin.ELfconsumpspin

DELhydexistcs.ELhydexistcs,DELhydexistcp.ELhydexistcp,DELhydbld.ELhydbld,
DELhydop.ELhydop,
*DELhydopsto.ELhydopsto,

DELfgcexistcp.ELfgcexistcp,
DELfgcbld.ELfgcbld,

EMsulflim.DEMsulflim,
*EMELnoxlim.DEMELnoxlim

*$ontext

COpurchbal.DCOpurchbal,COcnstrctbal.DCOcnstrctbal,
COopmaintbal.DCOopmaintbal,COcapbal.DCOcapbal,COcaplim.DCOcaplim,
COwashcaplim.DCOwashcaplim,
*COsulflim.DCOsulflim,
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


         ELtop.fx(ELpd,v,ELl,ELf,fss,t,r) = 0;




