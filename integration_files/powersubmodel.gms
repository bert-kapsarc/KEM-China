* ELECTRICITY MODEL FOR CHINA
*use  gdx=ChinaPower   to write output to gdx file

*option MCP=path;
*option LP=CBC;

*Include the following files to read in data from Access and
*to include sets and variables
*$INCLUDE ACCESS_sets.gms
*$INCLUDE ACCESS_EL.gms
*$include SetsandVariables.gms
*$include Macros.gms

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


Parameter RMBUSD(time) RMB to USD exchange rate
/
t11      0.154695
t12      0.158475
t13      0.162551
t14      0.162467
t15      0.160659
/  ;

RMBUSD(trun)$(ord(trun)>5) = RMBUSD('t15');

*Check since Tibet value is not available!!!!!
parameter ELfsulfurmax(time,r) 2010 regional sulfur limits in 10000 tons
$ontext
/
         North           114.29
         CoalC           59.3
         Northeast       109.31
         East            163.3
         Central         70.5
         Shandong        75.7
         Henan           73.8
         South           78
         Sichuan         17.6
         Southwest       61.1
         Tibet           0
         West            72.6
         Xinjiang        16.6

/;
$offtext

parameter ELfconsumpmax(ELf,time,rAll) fuel supply constraint;

$gdxin ..\db\power.gdx
$load ELfconsumpmax
$gdxin
ELfconsumpmax(ELf,time,rAll) = ELfconsumpmax(ELf,'t12',rAll);
* Split  fuel allocation in western adn eastern Nei Mongol using GDP as weight
ELfconsumpmax(ELf,time,"NME") = ELfconsumpmax(ELf,time,"NM")*0.3;
ELfconsumpmax(ELf,time,"NM") =
         ELfconsumpmax(ELf,time,"NM")-
         ELfconsumpmax(ELf,time,"NME");



* Get sum of other CO consumption sectors
ELfconsumpmax(ELf,time,r)=sum(GB$regions(r,GB),
                        ELfconsumpmax(ELf,time,GB));

*        assume unlimited uranium supplies
         ELfconsumpmax('u-235',time,r)=9e9;


parameter ELAPf(f,time,r) administered price of fuels;

*general values for fuels - update with actual values
*crude products in BBL (blue barrels, or 42 US gallons)
*refined products in tons
*methane in MMBTU
*coal in tons
*uranium in kg

         ELAPf('HFO',time,r)=1500;
         ELAPf('Diesel',time,r)=7500;
*         ELAPf('Methane',time,r)=10;

         ELAPf(f,time,r) = ELAPf(f,time,r)/RMBUSD("t14");

* nuclear fuel cost in 2012 RMB/kg;
         ELAPf('u-235',time,r) = 700;

* Gas fuel cost in 2012 RMB/MMBTU by regions
         ELAPf('Methane',time,North)= 64.57;
         ELAPf('Methane',time,Northeast)= 78.29;
         ELAPf('Methane',time,West)= 78.29;
         ELAPf('Methane',time,South)= 78.29;
         ELAPf('Methane',time,East)= 69.43;
         ELAPf('Methane',time,Central)= 73.86;

*         ELAPf('Methane',time,r)=0;


Parameters
         ELAPf(f,time,r) administered price of fuels
         ELptariff(ELp,time,r) supply tarrifs


Scalars
         ELreserve scale factor for reserve margin GW /1.25/
         ELwindspin fraction of wind gen defining spinning reserve  /0.2/
         ELusrfuelfrac ELfuelburn fraction for operating up spinning reserve /0.1/
;

Parameter ELdiscfact(time) discount factors for electricity sector
          ELdiscoef1(ELp,trun), ELdiscoef2(trun);

*        Capital costs will be discounted at 6% annually.
         scalar ELdiscountrate discount rate for electricity sector /0.06/;
;

Parameter ELleadtime(ELp) Lead time for plant construction units of t
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

Parameter
         ELwindcap(wstep) regional wind capacity steps (in GW) \
         ELdiffGW(wstep,ELl,r) load difference due to introduction of wind capacity
;


$gdxin ..\db\wind.gdx
$load ELwindcap
$load ELdiffGW
$gdxin

*Rescale to calculate TWH rather than GWH in the caplim equations
*to rescale transmission costs closer to capacity capital costs
         ELlchours(ELl) = 1e-3*ELlchours(ELl);

Parameter
         ELlcnorm(ELl) normalized load hours curve;

alias(
         ELl,ELll);
         ELlcnorm(ELl) = ELlchours(ELl)/sum(ELll,ELlchours(ELll));
*        Use for all submodels supplying or consuming power equally accross all load segements


* These values represent the r-specific LDCs.
parameter
         ELlcgw(rr,ELl) regional load in GW for each load segment in ELlchours;

$gdxin ..\db\LDC.gdx
$load ELlcgw
$gdxin

parameter
         ELdemgro(time,r) Electricity demand growth rate relative to initial condition  ;
         ELdemgro(time,r) =1;

parameter
         ELomcst(ELp,v,r) non-fuel variable O&M cost in RMB per MWh (2012);


         ELomcst('Subcr',v,r)    =15.1;
         ELomcst('Superc',v,r)   =14.6;
         ELomcst('Ultrsc',v,r)   =14.2;
         ELomcst('Hydrolg',v,r)  =79.2;
         ELomcst('HydroROR',v,r) =27.36;
         ELomcst('Nuclear','old',r) =56.8;
         ELomcst('Nuclear','new',r) =74.6;


*        Check with Yiyi fir gas turbines
         ELomcst('ST',v,r)       =15;
         ELomcst('GT',v,r)       =43.2;
         ELomcst('CC',v,r)       =23.5;
         ELomcst('CCcon',v,r)    =21;



parameter
         ELfixedOMcst(ELp) Fixed O&M cost RMB per KW (2012)
*        values from WEIO 2014 ???
/
         ST       18
         GT       43.2
         CC       23.5
         GTtoCC   23.5
         CCcon    23.5

         Windon   220.85
         Windoff  978.05
         Subcr    388.28
         Superc   391.16
         Ultrsc   394.03

*        check these values with Yiyi
         Nuclear  504.8
         PV       115
         Hydrolg  246.09
         Hydrosto 258.71

         HydroROR 265
/
;


parameter
         ELexist(ELp,v,chp,Rall) existing capacity in GW
         ELhydexist(ELp,r) existing hydro capacity by type from IHS GW
         ELwindexist(r) existing hydro capacity by type from IHS GW
         ELcapfac(Elpnuc) observed capacity factor of power plants
;

*        Estimate from South China Grid 2011 Statistics report 79%
*        From IHS Electricity data
         ELcapfac(Elpnuc)=0.892;


$gdxin ..\db\power.gdx
$load ELexist ELhydexist ELwindexist
$gdxin



* aggregate provincial capacity to models grid regions
ELexist(Elp,v,chp,r) = sum(GB$regions(r,GB),ELexist(Elp,v,chp,GB));



* distibute total WEPP hydro plant capacity amongst differen plant types
* (lg, ROR, sto) given by the IHS midstream database
ELexist(ELphyd,v,chp,r) = ELexist("Hydrolg",v,chp,r)*
                          ELhydexist(ELphyd,r)/sum(ELp,ELhydexist(ELp,r));


* We assume that 80% of total capital costs are for equipment and 20% for
* construction. The costs presented directly below are initial investment costs.

parameter ELcapital(ELp,r) Capital cost of equipment million RMB per GW (2012);
*values from WEIO 2014 converted to RMB, inflated to 2012 (These values are
*from 2012, so no inflation conducted)

         ELcapital('ST',r)       =5500    ;

         ELcapital('GT',r)       =2208.5  ;
         ELcapital('CC',r)       =3470.5  ;

         ELcapital('GTtoCC',r)   =550    ;

         Elcapital('Subcr',r)    =3786    ;
         ELcapital('Superc',r)   =4417  ;
         ELcapital('Ultrsc',r)   =5048  ;


         ELcapital('Windon',r)   =8203  ;
         ELcapital('Windoff',r)  =28016.4  ;

         ELcapital('Hydrolg',r)  =13377.2 ;
         ELcapital('HydroROR',r) =10727  ;
*        Look into hydro storage capital costs for future development
         ELcapital('Hydrosto',r) =12722.1  ;
*         ELcapital('Nuclear_G2',r) =14104.5 ;

*        Capital cost of generation three plant
         ELcapital('Nuclear',r) =12620 ;


         parameter
         ELpurcst(ELp,trun,r) Cost of purchasing equipment USD per kW
         ELconstcst(ELp,trun,r) Local construction etc. costs USD per kW;

         ELpurcst(ELp,trun,r) = 0.8*ELcapital(ELp,r);
         ELconstcst(ELp,trun,r) = 0.2*ELcapital(ELp,r);
;

*Amount of fuel burned per output of energy.
*Coal and methane values from EIA heat rate figures (http://www.eia.gov/electricity/annual/html/epa_08_01.html)
*Nuclear fuel burn from KEM - Saudi power submodel
*Methane is in units of MMBTU/MWh
*diesel,HFO, uranium, and coal are in units of metric tons/MWh

*1 megawatt hour = 860420.65 kilocalories
* 7000 kcal/kg
* coal fuel rate is
*860420.65 kcal/MWH / 7000 kcal/kg  * 1000 kg/ton =>  0.122917 ton/MWH 7000 KCal/kg coal
*251995.7611111 kcal/mmbtu

parameter  FuelperMWH(ELfref) quantity of fuel per MWH

*       Energy density for HFO: 43MJ/kg, 3600MJ/42MJ/kg = 85.71kg/MWh = 0.08571 ton/kg
*       Energy density for diesel: 44.8MJ/kg, 3600MJ/44.8MJ/kg = 80.36kg/MWh = 0.08036 ton/kg
/
         diesel     0.08036
         HFO        0.08571
/;


parameter
         ELfuelburn(ELp,v,ELf,r) fuel required per MWh (coal ton - methane mmbtu - HFO&LFO ton);

*        using 3.412 mmbtu/MWh and WEIO efficiencies for China
         ELfuelburn('ST',v,'methane',r)          = 8.949;
         ELfuelburn('GT',v,'methane',r)          = 9.222;
         ELfuelburn('CC',v,'methane',r)          = 5.883;
         ELfuelburn('CCcon',v,'methane',r)       = 5.883;

*        fuel efficiency of power plants
         ELfuelburn('ST',v,ELfref,r)           = 0.37;
         ELfuelburn('GT',v,ELfref,r)           = 0.37;
         ELfuelburn('CC',v,ELfref,r)           = 0.58;
         ELfuelburn('CCcon',v,ELfref,r)        = 0.58;


         ELfuelburn('Nuclear',v,'u-235',r)       = 0.120;

*        coal efficiency rate, from WEIO
         ELfuelburn('subcr',v,ELfcoal,r)         = 0.37;
         ELfuelburn('Superc',v,ELfcoal,r)        = 0.41;
         ELfuelburn('Ultrsc',v,ELfcoal,r)        = 0.45;


*        860 420.65 calories/kwh / 7000000000 cal/ton = 0.122917 ton/MWh
         ELfuelburn(ELpcoal,v,ELfcoal,r)=  0.122917/ELfuelburn(ELpcoal,v,ELfcoal,r);

*       Nuclear efficiency rate, from WEIO
        ELfuelburn('Nuclear',v,'u-235',r)       = 0.33;

*        http://www.whatisnuclear.com/physics/energy_density_of_nuclear.html
*       1MWh = 3600 MJ, 3600MJ/MWh/79390000MJ/kg = 0.000045346kg/MWh = 0.045346 g/MWh
        ELfuelburn(ELpnuc,v,ELfnuclear,r)=  0.000045346/ELfuelburn(ELpnuc,v,ELfnuclear,r);
        ELfuelburn('GT',v,ELf,r)$(not ELfng(ELf))=0;
        ELfuelburn(ELpog,v,ELfref,r)=  FuelperMWH(ELfref)/ELfuelburn(ELpog,v,ELfref,r);



*Hydro operational hours

Parameter
         ELhydhrs(r) Hydro operational hours calculated using 10 years of production and capacity data from IHS
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

*$gdxin ..\db\power.gdx
*$load ELhydhrs
*$gdxin

* rescale hours by 1000 to and output GWh to TWh
ELhydhrs(r) = ELhydhrs(r)/1000;

*We estimate the conversion from GTtoCC adds 50% more capacity based on data on page 5-5 of KFUPM report.
table
         ELcapadd(ELpp,ELp) a factor for adding capacity (only applicable to dispatchable tech)

                    GT     CCcon

         GTtoCC     -1     1.5
         ;

         ELcapadd(ELpp,ELpp)$( not ELpgttocc(ELpp)) = 1;
         ELcapadd('CCcon','CCcon') = 0;

parameter
         Eltransyield(ELt,r,rr) net of transmission and distribution losses
         ELtransexist(ELt,r,rr) existing transmission capacity in GW
         ELtranscoef(ELl,ELll,r,rr) load step coefficients for inter regional electricity transmission

*ELtransconstcst and Eltranspurcst are discounted at 6% over a 30-year liftime.
         ELtransconstcst(ELt,time,r,rr) construction cost of transmission capacity in RMB per kW
         ELtranspurcst(ELt,time,r,rr) purchase cost of transmission capacity in RMB per kW
         ELtransomcst(ELt,r,rr)  oper. and maint. cost in RMB per MWH
         ELtransleadtime(r,rr)  lead time for building transmission cap
 ;


$gdxin ..\db\power.gdx
$load ELtransexist
$gdxin

$gdxin ..\db\LDC.gdx
$load ELtranscoef
$gdxin

         ELtransexist('HVAC',r,r) = 1e9;

         Eltransyield('HVAC',r,r) = 1;
*         Eltransyield('GD','GD') = 0.9468;
*         Eltransyield('GX','GX') = 0.9318;
*         Eltransyield('YN','YN') = 0.9203;
*         Eltransyield('GZ','GZ') = 0.9465;

         Eltransyield('HVAC',r,rr)$(ELtransexist('HVAC',r,rr)>0) = 0.94;

         Eltransyield('UHVDC',r,rr)$(ELtransexist('UHVDC',r,rr)>0) = 0.98;

         Eltransyield('HVAC','central','east')=0.98;

         Eltransyield('HVAC',r,r) = 0.95;

         Eltransyield('HVAC','South','South') = 0.94;
         Eltransyield('HVAC','Southwest','Southwest') = 0.93;


execute_unload "..\db\ELtransyield.gdx", ELtransyield;


*!!!!!!!!!! Need to update transmission costs
         ELtransconstcst(ELt,time,r,rr)=20;
         ELtranspurcst(ELt,time,r,rr)=75;
         ELtransomcst(ELt,r,rr)=25;

         ELtransomcst(ELt,'central','east')=25;
;

         ELtransleadtime(r,rr) = 0 ;
;
parameter
         ELlifetime(ELp) Lifetime of plant in units of t
/
         ST       30
         GT       35
         CC       35
         GTtoCC   25
         CCcon    25
         Nuclear  35
         PV       25
         Hydrolg  40
         Hydrosto 40
         HydroROR 30
         Windon   20
         Windoff  20
         Subcr    35
         Superc   35
         Ultrsc   35
/;



******** Fix intial cpaacpity levels.

         ELexistcp.fx(ELpd,v,trun,r)$(ord(trun)=1)=
                                         sum(chp,ELexist(ELpd,v,chp,r));

         ELhydexistcp.fx(ELphyd,v,trun,r)$(ord(trun)=1)=
                                         ELexist(ELphyd,v,"no_chp",r);

*        No offshore wind represented in the model. Data taken from IHS

         ELwindexistcp.fx('windon','old',trun,r)$(ord(trun)=1)=ELwindexist(r);
*         ELwindexistcp.fx('windon','old',trun,r)$(ord(trun)=1)=ELexist('windon','no_chp',r)+ELexist('windoff','no_chp',r);

         ELwindexistcp.fx(ELpw,'new',trun,r)$(ord(trun)=1)=0;

         ELtransexistcp.fx(Elt,trun,r,rr)$(ord(trun)=1)= ELtransexist(Elt,r,rr);

******** Set upper bound on variable

         ELbld.up('CCcon','new',trun,r)=0;
         ELbld.up(Elpd,'new',trun,r)=0;
         ELbld.up(ELpcoal,'new',trun,r)=inf;

         ELwindbld.up(Elpw,'new',trun,r)=0;
         ELhydbld.up(Elphyd,'new',trun,r)=0;

*         ELop.up(ELpd,v,ELl,ELf,trun,r)=0;
*         ELop.up(ELpcoal,v,ELl,ELf,trun,r)=inf;
*         ELop.up('CC',v,ELl,ELf,trun,r)=inf;

*         ELgttocc.up('GTtoCC','old',trun,r)=0.4*ELexist('GT',r);

         ELtransbld.up(Elt,trun,r,rr)= 0;

         ELhydbld.up(ELphyd,v,time,r)=0;

Equations
* ====================== Primal Relationships=================================*
         ELobjective

* CAPITAL COSTS
         ELpurchbal(trun)            acumulates all import purchases
         ELcnstrctbal(trun)          accumlates all construction activity
         ELopmaintbal(trun)          accumulates operations and maintenance costs
* FUELS
         ELfcons(ELf,trun,r)         supply of fuel for power generation
         ELfavail(ELf,trun,r)           Available fuel constraint

* CAPACITIES (Dispatchable tech)
*         ELcaptot(trun,r)            to display total regional capacity over trun
         ELcapbal(ELpd,v,trun,r)     capacity balance constraint
         ELcaplim(ELpd,v,ELl,trun,r) electricity capacity constraints
         ELgtconvlim(ELpd,v,trun,r)  conversion limit for existing OCGT plants

* HYDRO
         ELhydcapbal(ELphyd,v,trun,r)   hydro capacity balance constraint
         ELhydcaplim(ELphyd,ELl,v,trun,r)  electricity capacity constraint for hydro
         ELhydutil(ELphyd,v,trun,r)       operation of hydro plants
         ELhydutilsto(ELphyd,v,trun,r)      operation of pumped hydro storage

* NUCLEAR
         ELnucconstraint(ELl,trun,r) constraint on nuclear ramping behavior

* WIND
         ELwindcapbal(ELpw,v,trun,r) capacity balance for wind plants
         ELwindcaplim(ELpw,v,trun,r) capacity constraint for wind plants
         ELwindutil(ELpw,ELl,v,trun,r) measures the operate for wind plants
         ELwindcapsum(wstep,trun,r)      makes sure total wind capacity is within the steps

* SPINNING RESERVES
         ELupspinres(ELpspin,ELl,trun,r) up spinning reserve (in case of sudden drop in renewable gen)
*         ELdnspinres(ELpd,ELl,trun,r) down spinning reserve (in case of sudden rise in ren. gen.)

* ELECTRICITY SUPPLY AND DEMAND
         ELsup(ELl,trun,r)            electricity supply constraints
         ELdem(ELl,trun,r)            electricity demand constraints
         ELrsrvreq(trun,r)            electricity reserve margin

* TRANSMISSION
         ELtranscapbal(ELt,trun,r,rr)     electricity transportation capacity balance
         ELtranscaplim(ELt,Ell,trun,r,rr) electricity transportation capacity constraint

* =================== Dual Relationships =====================================*
         DELImports(trun)             dual from imports
         DELConstruct(trun)           dual from construct
         DELOpandmaint(trun)          dual from opandmaint

         DELbld(ELpd,v,trun,r)         dual from Elbld
         DELwindbld(ELpw,v,trun,r)      dual from ELwindbld
         DELgttocc(Elpd,v,trun,r)      dual from ELgttocc
         DELop(ELpd,v,ELl,ELf,trun,r)    dual from ELop
         DELwindop(ELpw,ELl,v,trun,r)   dual from ELwindop
         DELexistcp(ELpd,v,trun,r)     dual from ELexistcp
         DELwindexistcp(ELpw,v,trun,r)  dual from ELwindexistcp
         DELwindoplevel(wstep,ELpw,v,trun,r) dual from ELwindoplevel
         DELupspincap(ELpd,v,ELl,ELf,trun,r)  dual from ELupspincap
         DELdnspincap(ELpd,v,ELl,trun,r)  dual from ELdnspincap

         DELtrans(ELt,ELl,trun,r,rr)      dual from ELtrans
         DELtransbld(ELt,trun,r,rr)       dual from ELtransbld
         DELtransexistcp(ELt,trun,r,rr)   dual from ELtransexistcp
         DELfconsump(f,trun,r)
         DELCOconsump(ELf,ash,sulf,trun,r)

         DELhydexistcp(ELphyd,v,trun,r)  dual of ELhydexistcp
         DELhydop(ELphyd,ELl,v,trun,r)   dual of ELhydop
         DELhydbld(ELphyd,v,trun,r)      dual of ELhydbld
;

$offorder


ELobjective.. z=e=sum(t,ELImports(t))+sum(t,ELConstruct(t))+sum(t,ELOpandmaint(t))
+sum((ELf,t,r)$ELfAP(ELf),ELAPf(ELf,t,r)*ELfconsump(ELf,t,r));

* CAPITAL COSTS
* Equipment/capital purchase costs [USD]
ELpurchbal(t).. sum((ELpd,v,r)$((ELpcom(ELpd) and vn(v)) or (vo(v) and ELpgttocc(ELpd))),
                         ELpurcst(ELpd,t,r)*ELbld(ELpd,v,t,r))
   +sum((ELpw,v,r), ELPurcst(ELpw,t,r)*ELwindbld(ELpw,v,t,r)$vn(v))
   +sum((ELt,r,rr), ELtranspurcst(ELt,t,r,rr)*ELtransbld(ELt,t,r,rr))
   +sum((ELphyd,v,r),ELpurcst(ELphyd,t,r)*ELhydbld(ELphyd,v,t,r))
   -ELImports(t)=e=0;

* Construction costs for new capital/equipment and GTtoCC  [USD]
ELcnstrctbal(t).. sum((ELpd,v,r)$((ELpcom(ELpd) and vn(v)) or (vo(v) and ELpgttocc(ELpd))),
         ELconstcst(ELpd,t,r)*ELbld(ELpd,v,t,r))
   +sum((ELpw,v,r), ELconstcst(ELpw,t,r)*ELwindbld(ELpw,v,t,r)$vn(v))
   +sum((ELphyd,v,r), ELconstcst(ELphyd,t,r)*ELhydbld(ELphyd,v,t,r))
   +sum((ELt,r,rr), ELtransconstcst(ELt,t,r,rr)*ELtransbld(ELt,t,r,rr))
   -ELConstruct(t)=e=0;

* Operation and maintenance costs [USD]
ELopmaintbal(t)..  sum((ELpd,v,ELl,ELf,r)$(Elfuelburn(ELpd,v,ELf,r)>0 and Elpcom(ELpd)),
   ELomcst(ELpd,v,r)* ELop(ELpd,v,ELl,ELf,t,r))
   +sum((ELpd,v,r),ELfixedOMcst(ELpd)*(ELbld(ELpd,v,t,r)+ELexistcp(ELpd,v,t,r)))

   +sum((ELpw,v,ELl,r),ELomcst(ELpw,v,r)*ELwindop(ELpw,ELl,v,t,r))
   +sum((ELpw,v,r), ELfixedOMcst(ELpw)*(ELwindbld(ELpw,v,t,r)+ELwindexistcp(ELpw,v,t,r)))

   +sum((ELphyd,v,ELl,r),ELomcst(ELphyd,v,r)*ELhydop(ELphyd,ELl,v,t,r))
   +sum((ELphyd,v,r),ELfixedOMcst(ELphyd)*(ELhydbld(ELphyd,v,t,r)+ELhydexistcp(ELphyd,v,t,r)))

   +sum((ELt,ELl,ELll,r,rr), ELtransomcst(ELt,r,rr)*ELtrans(ELt,ELl,t,r,rr))
   -ELOpandmaint(t)=e=0;

* FUELS
* fuel consumption [units of fuel energy]
* fuel burning  is indepednadnt of sulfur content
* this needs to be updated!!!
ELfcons(ELf,t,r).. ELfconsump(ELf,t,r)$(not ELfcoal(ELf))
   +sum((ash,sulf)$(ELfcoal(ELf) and ELash(ash)),ELCOconsump(ELf,ash,sulf,t,r))
   -sum((ELpd,v,ELl)$(Elfuelburn(ELpd,v,ELf,r)>0 and ELpcom(ELpd)),
   ELfuelburn(ELpd,v,ELf,r)*ELop(ELpd,v,ELl,ELf,t,r))
   -sum((ELpspin,v,ELl)$(Elfuelburn(ELpspin,v,ELf,r)>0 and fspin(ELf)) ,
         ELusrfuelfrac*Elfuelburn(ELpspin,v,ELf,r)*ELlchours(ELl)*ELupspincap(ELpspin,v,ELl,ELf,t,r))=g=0;

ELsulflim(r).. -COsulfDW(sulf)*ELCOconsump(ELf,ash,sulf,t,r) =g= -ELfsulfurmax(time,r);

* supply of available fuel [units of fuel energy]
ELfavail(ELf,t,r)$(not ELfcoal(ELf))..  -ELfconsump(ELf,t,r)=g=-ELfconsumpmax(ELf,t,r) ;

* CAPACITIES
* balance of existing, additional, and future capacity [GW]
ELcapbal(ELpd,v,t,r).. ELexistcp(ELpd,v,t,r)
   +sum(ELpp,ELcapadd(ELpp,ELpd)*ELbld(ELpp,v,t-ELleadtime(ELpp),r)$((ELpcom(ELpp) and vn(v)) or (vo(v) and ELpgttocc(ELpp))))
   -ELexistcp(ELpd,v,t+1,r)=g=0;

* Electricity produced by dispatchable technology (ELop) [GWh]
ELcaplim(ELpd,v,ELl,t,r)$(ELpcom(ELpd)).. ELlchours(ELl)*(ELexistcp(ELpd,v,t,r)
   +sum(ELpp,ELcapadd(ELpp,ELpd)*ELbld(ELpp,v,t-ELleadtime(ELpp),r)$((ELpcom(ELpp) and vn(v)) or (vo(v) and ELpgttocc(ELpp))))
   -sum(ELf$(Elfuelburn(ELpd,v,ELf,r)>0 and fspin(ELf) and ELpspin(ELpd)),ELupspincap(ELpd,v,ELl,ELf,t,r)))
   -sum(ELf$(Elfuelburn(ELpd,v,ELf,r)>0 and ELpcom(ELpd)),ELop(ELpd,v,ELl,ELf,t,r))=g=0;

*    To ensure that remaining convertible capacity can be positive in the last period [GW]
ELgtconvlim(ELpgttocc,vo,t,r).. -ELgttocc(ELpgttocc,vo,t+1,r)-ELbld(ELpgttocc,vo,t,r)
   +ELgttocc(ELpgttocc,vo,t,r)=g=0;


* HYDRO
ELhydcapbal(ELphyd,v,t,r).. ELhydexistcp(ELphyd,v,t,r)
   +sum(ELpphyd,ELhydbld(ELpphyd,v,t-ELleadtime(ELpphyd),r))
   -ELhydexistcp(ELphyd,v,t+1,r)=g=0;

ELhydcaplim(ELphyd,ELl,v,t,r).. ELlchours(ELl)*(ELhydexistcp(ELphyd,v,t,r)
   +sum(ELpphyd,ELhydbld(ELpphyd,v,t-ELleadtime(ELpphyd),r)))
   -ELhydop(ELphyd,ELl,v,t,r)=g=0;

ELhydutil(ELphyd,v,t,r)$(not ELphydsto(ELphyd)).. ELhydhrs(r)*(ELhydexistcp(ELphyd,v,t,r)
         +sum(ELpphyd,ELhydbld(ELpphyd,v,t-ELleadtime(ELpphyd),r)))
   -sum(ELl,ELhydop(ELphyd,ELl,v,t,r))=g=0;

ELhydutilsto(ELphyd,v,t,r)$(ELphydsto(ELphyd)).. sum(ELl,ELhydopsto(ELphyd,ELl,v,t,r))
   -sum(ELl,ELhydop(ELphyd,ELl,v,t,r))=g=0;

* NUCLEAR
* nuclear set as base load supplier [GWh]
ELnucconstraint(ELl,t,r) .. -sum((ELpnuc,v,ELf)$(Elfuelburn(ELpnuc,v,ELf,r)>0),ELop(ELpnuc,v,ELl,ELf,t,r))
         +ELlchours(ELl)*sum((ELpnuc,v),ELcapfac(Elpnuc)*(ELexistcp(ELpnuc,v,t,r)
                         +ELbld(ELpnuc,v,t-ELleadtime(ELpnuc),r)$vn(v)))
                         =e=0;
* WIND
ELwindcapbal(ELpw,v,t,r).. ELwindexistcp(ELpw,v,t,r)
                            -ELwindexistcp(ELpw,v,t+1,r)
                            +ELwindbld(ELpw,v,t-ELleadtime(ELpw),r)$vn(v)=g=0;

ELwindcaplim(ELpw,v,t,r)..
         +ELwindexistcp(ELpw,v,t,r)
         +ELwindbld(ELpw,v,t-ELleadtime(ELpw),r)$vn(v)
         -sum(wstep,(ELwindcap(wstep)-ELwindcap(wstep-1))*ELdemgro(t,r)*ELwindoplevel(wstep,ELpw,v,t,r))=g=0;

* Electricity produced by wind [GWh]
ELwindutil(ELpw,ELl,v,t,r).. sum(wstep,ELlchours(ELl)*ELdiffGW(wstep,ELl,r)*
    ELdemgro(t,r)*ELwindoplevel(wstep,ELpw,v,t,r))
   -ELwindop(ELpw,ELl,v,t,r)=g=0;

ELwindcapsum(wstep,t,r).. -sum((ELpw,v),ELwindoplevel(wstep,ELpw,v,t,r))=g=-1;


* SPINNING RESERVES
ELupspinres(ELpspin,ELl,t,r).. -ELwindspin*sum((wstep,ELpw,v),ELdiffGW(wstep,ELl,r)*ELdemgro(t,r)*ELwindoplevel(wstep,ELpw,v,t,r))
   +sum((v,ELf)$(Elfuelburn(ELpspin,v,ELf,r)>0 and fspin(ELf)),ELupspincap(ELpspin,v,ELl,ELf,t,r))=g=0;


* ELECTRICITY SUPPLY AND DEMAND
ELsup(ELl,t,r).. sum((ELpd,v,ELf)$(Elfuelburn(ELpd,v,ELf,r)>0 and ELpcom(ELpd)),ELop(ELpd,v,ELl,ELf,t,r))
   +sum((ELpw,v),ELwindop(ELpw,ELl,v,t,r))
   +sum((ELphyd,v),ELhydop(ELphyd,ELl,v,t,r))
   -sum((ELphyd,v),ELhydopsto(ELphyd,ELl,v,t,r))
*   +WAELsupply(ELl,t,r)-WAELconsump(ELl,t,r)
         -sum((Elt,rr),ELtrans(ELt,ELl,t,r,rr))=g=0;

ELdem(ELl,t,rr)..  sum((ELt,ELll,r),Eltransyield(ELt,r,rr)*ELtrans(ELt,ELll,t,r,rr)*ELtranscoef(ELll,ELl,r,rr))
*-PCELconsump(ELl,t,rr)-RFELconsump(ELl,t,rr)
         =g=ELlchours(ELl)*(ELlcgw(rr,ELl)*ELdemgro(t,rr));

* WAELconsump (hybrid RO) is assumed to take directly from supply, bypassing the grid

ELrsrvreq(t,r).. sum((ELpd,v), ELexistcp(ELpd,v,t,r))
   +sum((ELpd,v,ELpp),ELcapadd(ELpp,ELpd)*ELbld(ELpp,v,t-ELleadtime(ELpp),r)$((ELpcom(ELpp) and vn(v)) or (vo(v) and ELpgttocc(ELpp))))
*   +WAELrsrvcontr(t,r)
         =g= ELreserve*ELlcgw(r,'LS1')*ELdemgro(t,r);
*+WAELpwrdemand(t,r)+PCELpwrdemand(t,r));
*WAELpwrdemand is an estimate of the annual peak power demand for RO plants

* TRANSMISSION
* balance of transmission capacity [GW]
ELtranscapbal(ELt,t,r,rr).. ELtransexistcp(ELt,t,r,rr)
   +ELtransbld(ELt,t-ELtransleadtime(r,rr),r,rr)
   -ELtransexistcp(ELt,t+1,r,rr)=g=0;

* Transmission constraint [GWh]
ELtranscaplim(ELt,Ell,t,r,rr).. ELlchours(ELl)*(ELtransexistcp(ELt,t,r,rr)
   +ELtransbld(ELt,t-ELtransleadtime(r,rr),r,rr))
   -ELtrans(ELt,ELl,t,r,rr)=g= 0;

* ==================== DUAL RELATIONSHIPS =====================================
*$ontext
DELimports(t)..  1*ELdiscfact(t)=g=-DELpurchbal(t);
DELConstruct(t).. 1*ELdiscfact(t)=g=-DELcnstrctbal(t);
DELOpandmaint(t).. 1*ELdiscfact(t)=g=-DELopmaintbal(t);

DELfconsump(ELf,t,r)..
         (ELAPf(ELf,t,r)*ELdiscfact(t))
*        conditional for administered fuel prices

                      =g=DELfcons(ELf,t,r)$(not ELfcoal(ELf))-DELfavail(ELf,t,r);

DELCOconsump(ELf,ash,sulf,t,r)$(ELfcoal(ELf) and ELash(ash))..
         0=g=DELfcons(ELf,t,r)+DELsullim();

DELbld(ELpd,v,t,r)$((ELpcom(ELpd) and vn(v)) or (vo(v) and ELpgttocc(ELpd)))..
   0=g=
    DELpurchbal(t)*ELpurcst(Elpd,t,r)
   +DELopmaintbal(t)*ELfixedOMcst(ELpd)
   +DELcnstrctbal(t)*ELconstcst(ELpd,t,r)
   +sum(ELpp,DELcapbal(ELpp,v,t+ELleadtime(ELpd),r)*ELcapadd(ELpd,ELpp))
   -DELgtconvlim(ELpd,v,t,r)$(ELpgttocc(ELpd) and vo(v))
   +sum((ELpp,ELl),ELlchours(ELl)*DELcaplim(ELpp,v,ELl,t+ELleadtime(ELpd),r)*ELcapadd(ELpd,ELpp))
   +DELrsrvreq(t+ELleadtime(ELpd),r)*sum(ELpp,ELcapadd(ELpd,ELpp))
   +sum(ELl,DELnucconstraint(ELl,t+ELleadtime(ELpd),r)$(ELpnuc(ELpd))*ELlchours(ELl));

DELgttocc(ELpgttocc,vo,t,r).. 0=g=DELgtconvlim(ELpgttocc,vo,t,r)
   -DELgtconvlim(ELpgttocc,vo,t-1,r);

DELtrans(ELt,ELl,t,r,rr)..0 =g=DELopmaintbal(t)*ELtransomcst(ELt,r,rr)
   -DELsup(ELl,t,r)+DELdem(ELl,t,rr)*Eltransyield(ELt,r,rr)
   -DELtranscaplim(ELt,ELl,t,r,rr);

DELtransbld(ELt,t,r,rr).. 0=g=DELpurchbal(t)*ELtranspurcst(ELt,t,r,rr)
   +DELcnstrctbal(t)*ELtransconstcst(ELt,t,r,rr)
   +DELtranscapbal(ELt,t+ELtransleadtime(r,rr),r,rr)
   +sum(ELl,ELlchours(ELl)*DELtranscaplim(ELt,ELl,t+ELtransleadtime(r,rr),r,rr));

DELtransexistcp(ELt,t,r,rr)..
   0=g=DELtranscapbal(ELt,t,r,rr)-DELtranscapbal(ELt,t-1,r,rr)
   +sum(ELl,DELtranscaplim(ELt,ELl,t,r,rr)*ELlchours(ELl));

DELop(ELpd,v,ELl,ELf,t,r)$(Elfuelburn(ELpd,v,ELf,r)>0 and ELpcom(ELpd))..
   0=g=DELopmaintbal(t)*ELomcst(ELpd,v,r)
  -DELnucconstraint(ELl,t,r)$(ELpnuc(ELpd))
  -DELcaplim(ELpd,v,ELl,t,r)+DELsup(ELl,t,r)
  -DELfcons(ELf,t,r)*ELfuelburn(ELpd,v,ELf,r);

DELexistcp(ELpd,v,t,r).. 0=g=DELcapbal(ELpd,v,t,r)-DELcapbal(ELpd,v,t-1,r)
  +sum(ELl,DELcaplim(ELpd,v,ELl,t,r)$(ELpcom(ELpd))*ELlchours(ELl))+DELrsrvreq(t,r)
  +sum(ELl,DELnucconstraint(ELl,t,r)$(ELpnuc(ELpd))*ELlchours(ELl))
  +DELopmaintbal(t)*ELfixedOMcst(ELpd);

DELwindbld(ELpw,v,t,r)$vn(v).. 0=g=
   DELpurchbal(t)*ELpurcst(Elpw,t,r)
  +DELopmaintbal(t)*ELfixedOMcst(ELpw)
  +DELcnstrctbal(t)*ELconstcst(ELpw,t,r)
  +DELwindcapbal(ELpw,v,t+ELleadtime(ELpw),r)+DELwindcaplim(ELpw,v,t+ELleadtime(ELpw),r);

DELwindop(ELpw,ELl,v,t,r)..
  0=g=DELopmaintbal(t)*ELomcst(ELpw,v,r)+DELsup(ELl,t,r)-DELwindutil(ELpw,ELl,v,t,r);

DELwindexistcp(ELpw,v,t,r).. 0=g=DELwindcapbal(ELpw,v,t,r)-DELwindcapbal(ELpw,v,t-1,r)
  +DELwindcaplim(ELpw,v,t,r)
  +DELopmaintbal(t)*ELfixedOMcst(ELpw)
;

DELwindoplevel(wstep,ELpw,v,t,r).. 0=g=-DELwindcaplim(ELpw,v,t,r)*(ELwindcap(wstep)-ELwindcap(wstep-1))*ELdemgro(t,r)
  +sum(ELl,ELlchours(ELl)
         *ELdiffGW(wstep,ELl,r)*ELdemgro(t,r)*DELwindutil(ELpw,ELl,v,t,r))-DELwindcapsum(wstep,t,r)
  -ELwindspin*sum((ELl,ELpspin),DELupspinres(ELpspin,ELl,t,r)*ELdiffGW(wstep,ELl,r)*ELdemgro(t,r))
;

DELupspincap(Elpspin,v,ELl,ELf,t,r)$(Elfuelburn(ELpspin,v,ELf,r)>0 and fspin(ELf))..
 0=g=DELupspinres(Elpspin,ELl,t,r)-ELlchours(ELl)*DELcaplim(Elpspin,v,ELl,t,r)
  -DELfcons(ELf,t,r)*ELusrfuelfrac*Elfuelburn(Elpspin,v,ELf,r)*ELlchours(ELl);
;


DELhydexistcp(ELphyd,v,t,r).. 0=g=
   DELhydcapbal(ELphyd,v,t,r)-DELhydcapbal(ELphyd,v,t-1,r)
  +sum(ELl,DELhydcaplim(ELphyd,ELl,v,t,r)*ELlchours(ELl))
  +sum(ELl,DELhydutil(ELphyd,v,t,r)*ELhydhrs(r))
  +DELopmaintbal(t)*ELfixedOMcst(ELphyd)
;

DELhydop(ELphyd,ELl,v,t,r)..  0=g=
   DELopmaintbal(t)*ELomcst(ELphyd,v,r)
  -DELhydcaplim(ELphyd,ELl,v,t,r)
  -DELhydutil(ELphyd,v,t,r)
  +DELsup(ELl,t,r)
;

DELhydbld(ELphyd,v,t,r)$vn(v)..  0=g=
 DELpurchbal(t)*Elpurcst(ELphyd,t,r)
 +DELopmaintbal(t)*ELfixedOMcst(ELphyd)
 +DELcnstrctbal(t)*ELconstcst(ELphyd,t,r)
 +DELhydcapbal(ELphyd,v,t+ELleadtime(ELphyd),r)
 +sum(Ell,DELhydcaplim(ELphyd,ELl,v,t+ELleadtime(ELphyd),r))
;


$ontext
model PowerLP /ELobjective,ELpurchbal,ELcnstrctbal,ELopmaintbal,ELfcons,
ELfavail,ELcapbal,ELcaplim,ELgtconvlim,ELnucconstraint,
ELwindcapbal,ELwindcaplim,ELwindutil,
ELwindcapsum,ELupspinres,ELsup,ELdem,ELrsrvreq,ELtranscapbal,
ELtranscaplim,ELhydcapbal,ELhydcaplim,ELhydutil/
;

model PowerMCP /
DELbld.ELbld,DELexistcp.ELexistcp,DELop.ELop,ELopmaintbal.dELopmaintbal,
DELtrans.ELtrans,DELgttocc.ELgttocc,ELcaplim.DELcaplim,ELdem.DELdem,
ELrsrvreq.DELrsrvreq, ELpurchbal.dELpurchbal,ELcnstrctbal.dELcnstrctbal,
ELcapbal.DELcapbal,ELgtconvlim.DELgtconvlim,ELsup.DELsup,DELimports.ELimports,
DELOpandmaint.ELOpandmaint,ELtranscapbal.DELtranscapbal,DELConstruct.ELConstruct,
ELtranscaplim.DELtranscaplim,DELtransbld.ELtransbld,DELtransexistcp.ELtransexistcp,
DELfconsump.ELfconsump,ELfcons.DELfcons,ELfavail.DELfavail,DElwindbld.ELwindbld,
DELwindop.ELwindop,DELwindexistcp.ELwindexistcp,ELwindcapbal.DELwindcapbal,
ELwindcaplim.DELwindcaplim,DELwindoplevel.ELwindoplevel,ELwindutil.DELwindutil,ELwindcapsum.DELwindcapsum,
ELupspinres.DELupspinres,DELupspincap.ELupspincap,ELnucconstraint.DELnucconstraint,
DELhydexistcp.ELhydexistcp,DELhydop.ELhydop,DELhydbld.ELhydbld,
ELhydcapbal.DELhydcapbal,ELhydcaplim.DELhydcaplim,ELhydutil.DELhydutil

*ELdnspinres.DELdnspinres,DELdnspincap.ELdnspincap
/;

********* Discounting power sector
         ELdiscfact(trun)=discfact(ELdiscountrate,trun);

*        Discounting plant capital costs over lifetrun
         ELdiscoef1(ELp,trun) = discounting(ELlifetime(ELp),ELdiscountrate,i,trun,thyb);
*        intdiscfact(ELdiscountrate,trun,thyb)/sumdiscfact(ELlifetime(ELp),ELdiscountrate,i);

*        Discounting transmission capital costs over lifetime (35 time periods)
         ELdiscoef2(trun) = discounting(35,ELdiscountrate,i,trun,thyb);
*intdiscfact(ELdiscountrate,trun,thyb)/sumdiscfact(35,ELdiscountrate,i);

         ELpurcst(ELp,trun,r)=ELpurcst(ELp,trun,r)*ELdiscoef1(ELp,trun);
         ELconstcst(ELp,trun,r)=ELconstcst(ELp,trun,r)*ELdiscoef1(ELp,trun);
         ELtranspurcst(r,trun,rr)=ELtranspurcst(r,trun,rr)*ELdiscoef2(trun);
         ELtransconstcst(r,trun,rr)=ELtransconstcst(r,trun,rr)*ELdiscoef2(trun);



t(trun) = yes;

Solve PowerLP using LP minimizing z;

Parameters

ELopTOTES(ELpd)
ELhydopTOTES(ELphyd)
ELexistcpTOTES(ELp)
ELldemandTOTES
ELhydopREGION(ELphyd,r);

ELopTOTES(ELpd) = sum((v,ELl,ELf,time,r),ELop.l(ELpd,v,ELl,ELf,time,r));

ELhydopTOTES(ELphyd) = sum((ELl,v,time,r),ELhydop.l(ELphyd,ELl,v,time,r));

ELexistcpTOTES(ELp) = sum((r,chp),ELexist(ELp,chp,r));

ELldemandTOTES=sum((r,ELl),ELlchours(ELl)*(ELlcgw(r,ELl)));

ELhydopREGION(ELphyd,r)=sum((ELl,v,time),ELhydop.l(ELphyd,ELl,v,time,r));

Display z.l, ELopTOTES, ELhydopTOTES,ELexistcpTOTES,ELldemandTOTES,ELhydopREGION;



Solve PowerMCP using MCP;

Parameters

ELopTOTES(ELpd)
ELhydopTOTES(ELphyd)
ELexistcpTOTES(ELp)
ELldemandTOTES
ELhydopREGION(ELphyd,r);

ELopTOTES(ELpd) = sum((v,ELl,ELf,time,r),ELop.l(ELpd,v,ELl,ELf,time,r));

ELhydopTOTES(ELphyd) = sum((ELl,v,time,r),ELhydop.l(ELphyd,ELl,v,time,r));

ELexistcpTOTES(ELp) = sum((r,chp),ELexist(ELp,chp,r));

ELldemandTOTES=sum((r,ELl),ELlchours(ELl)*(ELlcgw(r,ELl)));

ELhydopREGION(ELphyd,r)=sum((ELl,v,time),ELhydop.l(ELphyd,ELl,v,time,r));

z.l=sum(t,ELImports.l(t))+sum(t,ELConstruct.l(t))+sum(t,ELOpandmaint.l(t))
+sum((ELf,t,r),ELAPf(ELf,t,r)*ELfconsump.l(ELf,t,r));

Display z.l, ELopTOTES, ELhydopTOTES,ELexistcpTOTES,ELldemandTOTES,ELhydopREGION;


$offtext
$ontext

* Solve statements for either the recursive dynamics approach or full optimization:
Scalar
count /0/
k;
*        If global set time is greater than size of subset time2, start recursive
If((card(trun)>card(time2)),

         t(trun)=yes$time2(trun);
         k=card(time2);

         Loop(trun,

Repeat(count=count+1; Solve PowerMCP using MCP; until((PowerMCP.modelstat eq 1)or(count eq 10)));

         ELexistcp.fx(ELpd,v,trun+1,r)=ELexistcp.l(ELpd,v,trun,r)
                      +sum(ELpp$((ELpcom(ELpp) and vn(v)) or (vo(v) and ELpgttocc(ELpp))),
                                   ELcapadd(ELpp,ELpd)*ELbld.l(ELpp,v,trun-ELleadtime(ELpp),r));
         ELsolexistcp.fx(ELps,v,trun+1,r)=ELsolexistcp.l(ELps,v,trun,r)
                      +ELsolbld.l(ELps,v,trun-ELleadtime(ELps),r)$vn(v);
         ELtransexistcp.fx(trun+1,r,rr)=ELtransexistcp.l(trun,r,rr)
                      +ELtransbld.l(trun-ELtransleadtime(r,rr),r,rr);
         ELgttocc.fx('GTtoCC','old',trun+1,r)=ELexistcp.l('GT','old',trun,r)
                      -ELbld.l('GTtoCC','old',trun,r);

          t(trun+k)=yes;

* next we push forward all the parameter sets for the next solve statement t+1
         ELpurcst(ELp,t+1,r)=ELpurcst(ELp,t,r);
         ELconstcst(ELp,t+1,r)=ELconstcst(ELp,t,r);
         ELtranspurcst(Elt,t+1,r,rr)=ELtranspurcst(ELt,t,r,rr);
         ELtransconstcst(ELt,t+1,r,rr)=ELtransconstcst(ELt,t,r,rr);

         t(trun)=no;
         count=0;
         display t,ELpurcst, ELexistcp.l, ELbld.l;
         );
Else

         t(trun)=yes;

Repeat(count=count+1; Solve PowerMCP using MCP; until((PowerMCP.modelstat eq 1)or(count eq 1)));

);

$offtext
