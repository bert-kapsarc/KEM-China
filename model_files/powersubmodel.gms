$ONTEXT
ELECTRICITY MODEL FOR CHINA
This model provides a representaiton of the power market considereing 3 actors
         1. Power Producers
         2. State grid companies (System Operator)
         3. Central and provicial governments (regulator)
The model is formulated as a cost minimization problem. Hower the price paid
to power generators by the system operator is regulated by the governments
on-grid tariff policy.
$OFFTEXT


scalar   ELdeficitmax maximum amount of deficit allowed in revenue constriant of power producers;
         ELdeficitmax = 0e3;

parameter ELfconsumpmax(ELf,time,r) fuel supply constraint
          FuelAllocation(ELf,r), FuelAllocationTrend(ELf,r)
          ELFuelPrice(f,fss,r), ELFuelPriceTrend(f,fss,time), ELAPf(f,fss,time,r) administered price of fuels
;
         ELFuelPriceTrend(f,fss,time)=1;
*crude products in BBL (blue barrels, or 42 US gallons)
*refined products in tons
*methane in MMBTU
*coal in tons
*uranium in kg

$gdxin db\power.gdx
$load FuelAllocation FuelAllocationTrend ELFuelPrice
$gdxin

ELfconsumpmax(ELf,time,r)=FuelAllocation(ELf,r)*FuelAllocationTrend(ELf,r);
ELAPf(ELf,fss,time,r) = ELFuelPrice(ELf,fss,r)*ELFuelPriceTrend(ELf,fss,time);


Scalars
         ELreserve scale factor for reserve margin GW /1.2/
         ELwindspin fraction of wind gen defining spinning reserve  /0.2/
         ELusrfuelfrac ELfuelburn fraction for operating up spinning reserve /0.1/
         ELusomfrac cost fraction for operating up spinning reserve /0.1/
         ELdiscountrate discount rate for electricity sector
         ELhydstoeff efficiency of pumped hydro storage /0.9/
;

         ELdiscountrate = discount_rate("EL");


Parameter ELdiscfact(time) discount factors for electricity sector
          ELdiscoef1(ELp,trun), ELdiscoef2(trun)
          ELwindcap(wstep) regional wind capacity steps (in GW)
          ELdiffGW(wstep,ELl,r) load difference due to introduction of wind capacity
;


$gdxin db\wind.gdx
$load ELwindcap
$load ELdiffGW
$gdxin

* Plant capacities operating and fixed costs
Parameter ELhydhrs(r) Hydro operational hours
          ELomcst(ELp,v,r) non-fuel variable O&M cost per MWH
          ELfixedOMcst(ELp) Fixed O&M cost RMB per KW (2012)
          ELcapfac(Elp,v) maximum capacity factor of power plants
          ELcapital(ELp,r) Capital cost of equipment RMB per KW (2012)
          ELexist(ELp,v,chp,Rall) existing capacity in GW
          ELhydexist(ELp,r) existing hydro capacity by type from IHS GW
          ELwindexist(r) existing hydro capacity by type from IHS GW

          ELlifetime(ELp) Lifetime of plant in years used for discounting and retirements
          ELleadtime(ELp) Lead time for plant construction in year

          ELnoxexist(ELp,v,chp,Rall) nox existing capacity in GW
          ELfgdexist(ELp,v,chp,Rall) fgd existing capacity in GW

          ELpfixedcost(Elp,v,trun,r) fixed cost of technology for each vintage in each region
          ELpsunkcost(Elp,v,trun,r) sunk cost of technology for each vintage in each region
          ELpurcst(ELp,trun,r) Cost of purchasing equipment per KW
          ELconstcst(ELp,trun,r) Local construction etc. costs per KW
          ELcntrhrs(ELp,v,trun,r) Contracted hours for each plant

          ELfgcleadtime(fgc)/
                 DeSOx    0
                 DeNOx    0 /

          ELCOcvthreshold(Elpd) lower threshold on a coal plants blended CV. Calorific value normalized to SCE
                 /Ultrsc   0.5714/
;
*        Not using lead times in this version
         ELleadtime(ELpcoal)= 0;



$gdxin db\power.gdx
$load ELhydhrs ELomcst ELfixedOMcst ELcapfac ELcapital ELlifetime
$load ELexist ELhydexist ELwindexist ELfgdexist ELnoxexist
$gdxin

* !!!    rescale hours by 1000 to convet GWH to TWH
         ELhydhrs(r) = ELhydhrs(r)/1000;

* Set undeclared cost for vintages and regions
         ELomcst(ELp,v,r)$(ELomcst(ELp,v,r)=0)=smax((vv,rr),ELomcst(ELp,vv,rr));
         ELcapfac(ELp,v)$(ELcapfac(ELp,v)=0)=smax((vv),ELcapfac(ELp,vv));
         Elcapital(ELp,r)$(Elcapital(ELp,r)=0)=smax((rr),Elcapital(ELp,rr));

         ELcntrhrs(Elpcoal,v,trun,r) = 0;

         ELpurcst(ELp,trun,r) = 0.8*ELcapital(ELp,r);
         ELconstcst(ELp,trun,r) = 0.2*ELcapital(ELp,r);
;


table ELcapadd(ELpp,ELp) a factor for adding capacity (only applicable to dispatchable tech)
*We estimate the conversion from GTtoCC adds 50% more capacity based on data on page 5-5 of KFUPM report.
                    GT     CCcon
         GTtoCC     -1     1.5
;

         ELcapadd(ELp,ELp)$( not ELpgttocc(ELp)) = 1;
         ELcapadd('CCcon','CCcon') = 0;


********** Tranmission line parameters
parameter
         Eltransyield(ELt,r,rr) net of transmission and distribution losses
         ELtransexist(ELt,r,rr) existing transmission capacity in GW
         ELtransD(ELt,r,rr) distance in KM of existing or proposed interregional tranmission lines

         ELtranscapital(ELt,r,rr) tranmission line capital cost
         ELtransconstcst(ELt,time,r,rr) construction cost of transmission capacity
         ELtranspurcst(ELt,time,r,rr) purchase cost of transmission capacity
         ELtransomcst(ELt,r,rr)  oper. and maint. cost in RMB per MWH
         ELtransleadtime(r,rr)  lead time for building transmission cap
;

         ELtransleadtime(r,rr) = 0 ;

$gdxin db\power.gdx
$load ELtransexist ELtransD ELtransyield ELtranscapital ELtransomcst
$gdxin


*        No capacity constraint for intraregional transmission
         ELtransexist('HVAC',r,r) = 1e9;

* Subset for available tranmission connectinos based on defined distances
         set ELtransr(ELt,r,rr);
          ELtransr(ELt,r,rr)$(ELtransD(ELt,r,rr)>0) = yes ;

*        Intraregional conections for all HVAC lines
         ELtransr('HVAC',r,r) = yes;

*        Assign capital and operating cost for undefined transmission lines
         alias (r,r2), (rr,rr2);

ELtranscapital(ELt,r,rr)$(ELtranscapital(ELt,r,rr)=0 and ELtransr(ELt,r,rr))
         =smax((r2,rr2),ELtranscapital(ELt,r2,rr2));

*        Scale tranmission line construction cost by line length
ELtransconstcst(ELt,time,r,rr)$ELtransr(ELt,r,rr)=
         ELtranscapital(ELt,r,rr)*ELtransD(ELt,r,rr);

         ELtranspurcst(ELt,time,r,rr)$ELtransr(ELt,r,rr)=0;

ELtransomcst(ELt,r,r)$(ELtransomcst(ELt,r,r)=0)=
         smax(rr,ELtransomcst(ELt,rr,rr));


* !!!    Scale undefined interregional transmission costs using line distances
ELtransomcst(ELt,r,rr)$(ord(r) <> ord(rr) and ELtransr(ELt,r,rr)
                         and ELtransomcst(ELt,r,rr)=0)=
         ELtransomcst(ELt,r,r)+(ELtransD(ELt,r,rr)-300)*(42-14)/(3000-300);



********* Fuel efficeincies and parasitic loads
parameter
         Elpeff(ELp,v) fuel efficiency
         ELfuelburn(ELp,v,f,r) fuel required per MWh
         ELparasitic(Elp,v) parasitic load of various generators
         ELpCOparas(Elp,v,sulf,sox,nox,r) parasitic load of operating fgc in MWh per metric ton of coal consumption in SCE
         EMfgcpower(sulf,fgc,fgc) percentage reduciton of thermal efficiency when operating fgc
         ;
$gdxin db\power.gdx
$load ELparasitic Elpeff ELfuelburn
$gdxin

* Initialize undefined values for efficiency or parasitic load
ELparasitic(Elp,v)$(ELparasitic(Elp,v)=0)=smax((vv),ELparasitic(Elp,vv));
Elpeff(Elp,v)$(Elpeff(Elp,v)=0)=smax((vv),Elpeff(Elp,vv));

* !!!    electricity consumption of fgc system defined as % of total
         EMfgcpower('extlow',DeSOx,noDeNOx) = 0.010;
         EMfgcpower('low',DeSOx,noDeNOx) = 0.012;
         EMfgcpower('med',DeSOx,noDeNOx) = 0.015;
         EMfgcpower('high',DeSOx,nox) = 0.02;

         EMfgcpower(sulf,noDeSOx,DeNOx) = 0.022;

         EMfgcpower(sulf,DeSOx,DeNOx) =
                 EMfgcpower(sulf,DeSOx,'noDeNOx')+
                 EMfgcpower(sulf,'noDeSOx',DeNOx);

*        power planet gross therma efficiency rate from WEIO
         ELfuelburn(ELpd,v,ELf,r)$(ELpELf(Elpd,ELf) and Elpeff(ELpd,v)>0 and ELfuelburn(ELpd,v,ELf,r)=0) =
                 FuelperMWH(ELf)/ELpeff(ELpd,v);

*        remove plants with no fuelburn value from ELpELf and ELpfss union sets
         ELpELf(Elpd,ELf)$(smax((v,r),Elfuelburn(ELpd,v,ELf,r))<=0)= no;
         ELpfss(ELpd,ELf,fss)$(smax((v,r),Elfuelburn(ELpd,v,ELf,r))<=0) = no;

* Set parasitic load of flue gas control units
         ELpCOparas(Elpcoal,v,sulf,sox,nox,r)$(ELfuelburn(ELpcoal,v,'coal',r)>0) =
         EMfgcpower(sulf,sox,nox)/ELfuelburn(ELpcoal,v,'coal',r);


* !!!    Demand Data
* These values represent the r-specific LDCs.
parameters
         ELlcgw(rr,ELl) regional load in GW for each load segment in ELlchours
         ELlcgwsales(rr,ELl) regional load for grid sales in GW for each load segment in ELlchours
         ELlcgwonsite(rr,ELl) regional load for on site generation in GW for each load segment in ELlchours
         ELdemand(time,rr)  total power demand in each region (used to asses the onsite generation requirements)

         ELdemgro(ELl,time,r) Electricity demand growth rate relative to initial condition
         ELexistonsite(time,r) percentage of onsite generation capacity
;

$gdxin db\LDC.gdx
$load ELlcgw
$gdxin
;

         ELlcgwonsite(r,ELl) = 0;
         ELdemgro(ELl,time,r)=1;


* !!!     Upper bounds on initial capacity levels (exisiting stocks).
         Elexistcp.up(ELp,v,trun,r)=0;

         Elexistcp.up(ELpd,v,trun,r)$(ord(trun)=1)=
                 sum((chp),ELexist(ELpd,v,chp,r));

         ELexistcp.fx(ELphyd,v,trun,r)$(ord(trun)=1)=
                 (ELhydexist(ELphyd,r))$vo(v);

*        No offshore wind represented in the model.
         ELexistcp.fx('windon',v,trun,r)$(ord(trun)=1)
                 =ELwindexist(r)$vo(v);

         ELtransexistcp.fx(Elt,trun,r,rr)$(ord(trun)=1)
                 = ELtransexist(Elt,r,rr);


         ELfgcexistcp.fx(Elpcoal,v,DeSOx,trun,r)$(ord(trun)=1)=
                 sum((chp),ELfgdexist(Elpcoal,v,chp,r));

         ELfgcexistcp.fx(Elpcoal,v,DeNOx,trun,r)$(ord(trun)=1)=
                 sum((chp),ELnoxexist(Elpcoal,v,chp,r));



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
         ELcapbal(ELp,v,trun,r) capacity balance constraint
         ELcaplim(ELp,v,ELl,trun,r) electricity capacity constraint on the generators available or built cpacity
         ELcapcontr(ELpd,v,trun,r) lower bound represent existing capacity contracts
         ELgtconvlim(ELp,v,trun,r)  conversion limit for existing OCGT plants
         ELnucconstraint(ELpd,v,ELf,ELl,trun,r)

* HYDRO
         ELhydutil(ELphyd,v,trun,r)       operation of hydro plants
         ELhydutilsto(v,trun,r)      operation of pumped hydro storage

* WIND
         ELwindcaplim(ELpw,v,trun,r) capacity constraint for wind plants
         ELwindutil(ELpw,ELl,v,trun,r) measures the operate for wind plants
         ELwindcapsum(wstep,trun,r)      makes sure total wind capacity is within the steps

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

         ELprofit_eqn(ELc,v,trun,r) regional Profit constraint on each generator type
         ELrevenue_constraint(ELc,v,trun,r)
         ELrevenue_constraint_bilinear(ELc,v,trun,r)

         ELwindtarget(trun) national target for renewables
*         ELCOcvlim(Elpd,trun,r) constraint on the lowest belended calorific value permited for a coal plant

         ELdeficitcap(trun)

* =================== Dual Relationships =====================================*
         DELImports(trun)             dual from imports
         DELConstruct(trun)           dual from construct
         DELOpandmaint(trun)          dual from opandmaint

         DELbld(ELp,v,trun,r)         dual from Elbld
         DELwindbld(ELpw,v,trun,r)     dual from ELwindbld
         DELgttocc(Elp,v,trun,r)       dual from ELgttocc

         DELop(ELp,v,ELl,ELf,trun,r) dual from ELop
         DELupspincap(ELpd,v,ELl,ELf,trun,r)  dual from ELupspincap
         DELexistcp(ELp,v,trun,r)     dual from ELexistcp
         DELwindoplevel(wstep,ELpw,v,trun,r) dual from ELwindoplevel

*         DELdnspincap(ELpd,v,ELl,trun,r)  dual from ELdnspincap

         DELtrans(ELt,ELl,trun,r,rr)      dual from ELtrans
         DELtransbld(ELt,trun,r,rr)       dual from ELtransbld
         DELtransexistcp(ELt,trun,r,rr)   dual from ELtransexistcp
         DELfconsump(ELpd,v,f,fss,trun,r)
         DELCOconsump(ELpcoal,v,gtyp,cv,sulf,sox,nox,trun,r)

         DELhydopsto(ELl,v,trun,r) dual of ELhydopsto

         DELfgcexistcp(ELpd,v,fgc,trun,r)    dual of ELfgcexistcp
         DELfgcbld(ELpd,v,fgc,trun,r)        dual of ELfgcbld

         DELoploc(ELp,v,ELl,ELf,trun,r) dual on ELoploc

         DElcapsub(Elp,v,trun,r)
         DELdeficit(ELc,v,trun,r)
         DELwindsub(ELpw,v,trun,r)
;


$offorder



ELobjective.. ELobjvalue=e=
  +sum(t,(ELImports(t)+ELConstruct(t)+ELOpandmaint(t))*ELdiscfact(t))

  +sum((ELpd,v,ELf,fss,t,r)$(ELpfss(ELpd,ELf,fss) and not ELfcoal(ELf) and not ELpcoal(Elpd)),
         ELfconsump(ELpd,v,ELf,fss,t,r)*ELAPf(ELf,fss,t,r)*(
         0.01$(fss0(fss) and not ELpnuc(ELpd))+1$(not fss0(fss) or Elpnuc(ELpd)) )*ELdiscfact(t)
         )

* Fuel supply costs when not running supply submodules
  +sum((ELpcoal,v,gtyp,cv,sulf,sox,nox,t,r)$(ELfCV('coal',cv,sulf) and ELpfgc(Elpcoal,cv,sulf,sox,nox)),
            COprice.l('coal',cv,sulf,t,r)*
          ELCOconsump(ELpcoal,v,gtyp,cv,sulf,sox,nox,t,r))$(not run_model('Coal'))

  +sum((ELc,vv,t,r)$ELctariff(ELc,vv),ELdeficit(ELc,vv,t,r))
;

* CAPITAL COSTS
* Equipment/capital purchase costs [USD]


ELpurchbal(t)..
   sum((ELp,v,r)$ELpbld(ELp,v),ELpurcst(ELp,t,r)*ELbld(ELp,v,t,r))
  +sum((ELt,r,rr), ELtranspurcst(ELt,t,r,rr)*ELtransbld(ELt,t,r,rr))
  +sum((ELpcoal,v,fgc,r)$(DeSOx(fgc) or DeNOx(fgc)),
         ELfgcbld(ELpcoal,v,fgc,t,r)*EMfgccapexD(fgc,t) )

  -ELImports(t)=e=0;

* Construction costs for new capital/equipment and GTtoCC  [USD]
ELcnstrctbal(t)..
   sum((ELp,v,r)$ELpbld(ELp,v),ELconstcst(ELp,t,r)*ELbld(ELp,v,t,r))
  +sum((ELt,r,rr), ELtransconstcst(ELt,t,r,rr)*ELtransbld(ELt,t,r,rr))

  -ELConstruct(t)=e=0;

* Operation and maintenance costs [USD]
ELopmaintbal(t)..

  +sum((Elp,v,ELl,ELf,r)$ELpELf(ELp,ELf),
         ELomcst(Elp,v,r)*(
                 ELop(ELp,v,ELl,ELf,t,r)
                 +ELusomfrac*ELlchours(ELl)*
                 ELupspincap(Elp,v,ELl,ELf,t,r)$ELpspin(Elp)
*                 +ELlchours(ELl)*
*                 ELoploc(ELpd,v,ELl,ELf,t,r)$(not ELpnuc(ELpd))
         )
  )

  +sum((ELp,v,gtyp,cv,sulf,sox,nox,r)$(ELpcoal(ELp) and
         (DeSox(sox) or DeNox(nox)) and ELpfgc(ELp,cv,sulf,sox,nox)),
         (EMfgcomcst(sox)+EMfgcomcst(nox))*
         ELCOconsump(ELp,v,gtyp,cv,sulf,sox,nox,t,r)*COcvSCE(cv)/
         ELfuelburn(ELp,v,'coal',r)
  )

  +sum((ELp,v,r)$ELpbld(ELp,v),
         ELfixedOMcst(ELp)*ELbld(ELp,v,t-ELleadtime(ELp),r))

  +sum((ELpcoal,v,fgc,r)$(DeSOx(fgc) or DeNOx(fgc)),
         ELfgcbld(ELpcoal,v,fgc,t,r)*EMfgcfixedOMcst(fgc) )

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
ELnucconstraint(ELpd,v,ELf,ELl,t,r)$(ELpnuc(ELpd) and ELpELf(ELpd,ELf))..
         ELop(ELpd,v,ELl,ELf,t,r)
  -sum(ELll,ELop(ELpd,v,ELl,ELf,t,r))*ELlcnorm(ELl) =g=0
;


* CAPACITIES
* balance of existing, additional, and future capacity [GW]
ELcapbal(ELp,v,t,r).. ELexistcp(ELp,v,t,r)
   +sum(Elpp$ELpbld(Elpp,v),ELcapadd(Elpp,ELp)*
                                 ELbld(Elpp,v,t-ELleadtime(Elpp),r))
   -ELexistcp(ELp,v,t+1,r)=g=0
;

ELcaplim(ELp,v,ELl,t,r)..
   ELcapfac(ELp,v)*ELlchours(ELl)*(
          ELexistcp(ELp,v,t,r)
         +sum(Elpp$ELpbld(Elpp,v),
                 ELcapadd(Elpp,ELp)*ELbld(Elpp,v,t-ELleadtime(Elpp),r))
   )

  -sum(ELf$ELpELf(ELp,ELf),
          ELop(ELp,v,ELl,ELf,t,r)
         +ELupspincap(Elp,v,ELl,ELf,t,r)*ELlchours(ELl)$Elpspin(Elp)
*         +ELlchours(ELl)*
*         ELoploc(ELp,v,ELl,ELf,t,r)$(not ELpnuc(ELp))
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


ELhydutil(ELphyd,v,t,r)$(not ELphydsto(ELphyd))..
  ELhydhrs(r)*ELcapfac(Elphyd,v)*(ELexistcp(ELphyd,v,t,r)
   +ELbld(ELphyd,v,t-ELleadtime(ELphyd),r)$vn(v))
   -sum((ELl,ELf)$ELpELf(ELphyd,ELf),ELop(ELphyd,v,ELl,ELf,t,r))=g=0
;

ELhydutilsto(v,t,r)..
   sum(ELl,ELhydopsto(ELl,v,t,r))*ELhydstoeff
   -sum((Elphyd,ELl,ELf)$(ELpELf(ELphyd,ELf) and ELphydsto(ELphyd)),
         ELop(ELphyd,v,ELl,ELf,t,r))=g=0
;

* WIND

ELwindcaplim(ELpw,v,t,r)..
  +ELexistcp(ELpw,v,t,r)
  +ELbld(ELpw,v,t-ELleadtime(ELpw),r)$vn(v)
  -sum((wstep),(ELwindcap(wstep)-ELwindcap(wstep-1))*
         ELdemgro('LS1',t,r)*ELwindoplevel(wstep,ELpw,v,t,r))=g=0
;

* Electricity produced by wind [GWh]
ELwindutil(ELpw,ELl,v,t,r)..

 sum(wstep,ELdiffGW(wstep,ELl,r)*
    ELdemgro(ELl,t,r)*ELwindoplevel(wstep,ELpw,v,t,r))*ELlchours(ELl)
-sum(ELf$ELpELf(ELpw,ELf),ELop(ELpw,v,ELl,ELf,t,r))
                 =g=0
;

ELwindcapsum(wstep,t,r).. -sum((ELpw,v),ELwindoplevel(wstep,ELpw,v,t,r))=g=-1;


* SPINNING RESERVES
ELupspinres(ELl,t,r)..
  -ELwindspin*sum((wstep,ELpw,v),
         ELdiffGW(wstep,ELl,r)*ELdemgro(ELl,t,r)*
         ELwindoplevel(wstep,ELpw,v,t,r)*(1-ELparasitic(Elpw,v)))
  +sum((ELpd,v,ELf)$(ELpELf(ELpd,ELf) and ELpspin(ELpd)),
         ELupspincap(ELpd,v,ELl,ELf,t,r)*(1-ELparasitic(Elpd,v)))
=g=0;

* ELECTRICITY SUPPLY AND DEMAND
ELsup(ELl,t,r)..
   sum((ELp,v,ELf)$ELpELf(ELp,ELf),
         ELop(ELp,v,ELl,ELf,t,r)*(1-ELparasitic(Elp,v)))
  -sum((ELpcoal,v,reg,cv,sulf,SOx,NOx)$(ELpfgc(Elpcoal,cv,sulf,SOx,NOx) and
                 (DeSOx(sox) or DeNOx(nox))),
         ELCOconsump(ELpcoal,v,reg,cv,sulf,SOx,NOx,t,r)*COcvSCE(cv)*
         ELpCOparas(Elpcoal,v,sulf,SOx,NOx,r))*ELlcnorm(ELl)

*  -sum((v),ELhydopsto(ELl,v,t,r))

  -sum((Elt,rr)$ELtransr(ELt,r,rr),
         ELtrans(ELt,ELl,t,r,rr))
                         =g=  0
  +ELlcgwonsite(r,ELl)*ELdemgro(ELl,t,r)*ELlchours(ELl)
;

ELdem(ELl,t,rr)$rdem_on(rr)..
   +sum((ELp,v,ELf)$ELpELf(ELp,ELf),
         ELop(ELp,v,ELl,ELf,t,rr)*(ELparasitic(Elp,v)))
   +sum((ELpcoal,v,reg,cv,sulf,SOx,NOx)$(ELpfgc(Elpcoal,cv,sulf,SOx,NOx) and
                 (DeSOx(sox) or DeNOx(nox))),
         ELCOconsump(ELpcoal,v,reg,cv,sulf,SOx,NOx,t,rr)*COcvSCE(cv)*
         ELpCOparas(Elpcoal,v,sulf,SOx,NOx,rr))*ELlcnorm(ELl)

   +sum((ELt,ELll,r)$ELtransr(ELt,r,rr),
         Eltransyield(ELt,r,rr)*
*ELtranscoef(ELll,ELl,r,rr)*
         ELtrans(ELt,ELll,t,r,rr))

   -sum((v),ELhydopsto(ELl,v,t,rr))
*   -PCELconsump(ELl,t,rr)-RFELconsump(ELl,t,rr)
         =g=ELlcgw(rr,ELl)*ELdemgro(ELl,t,rr)*ELlchours(ELl);



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
     ELexistcp(ELphyd,v,t,r)+ELbld(ELphyd,v,t-ELleadtime(ELphyd),r)$vn(v))
)
*         define peak demand from other sectors
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

*$ontext
*======== fgc constraints

* Capacity limit on the operation of FGD
ELfgccaplim(ELpd,v,fgc,t,r)$((DeSOx(fgc) or DeNOx(fgc)) and ELpcoal(ELpd))..

*   ( ELexistcp(ELpd,v,t,r)
*    +ELbld(ELpd,v,t-ELleadtime(ELpd),r)$ELpbld(ELpd,v))*
*         ELcapfac(ELpd,v)*sum(ELl,ELlchours(ELl))$(noDeSOx(fgc) or noDeNOx(fgc))

   +ELcapfac(ELpd,v)*sum(ELl,ELlchours(ELl))*(
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

ELrevenue_constraint(ELc,vv,t,r)$ELctariff(ELc,vv)..
+ELdeficit(ELc,vv,t,r)+ELprofit(ELc,vv,t,r) =g= 0;
;

ELrevenue_constraint_bilinear(ELc,vv,t,r)$ELctariff(ELc,vv)..
+ELdeficit(ELc,vv,t,r)+ELprofit(ELc,vv,t,r)
-sum((ELp,v)$(ELptariff(ELp,v) and ELcELp(ELc,vv,ELp,v)),
  sum((cv,sulf)$ELfCV('coal',cv,sulf),
    (COprice('coal',cv,sulf,t,r)$(run_model('Coal')) )*
    sum(gtyp,
       sum((sox,nox)$ELpfgc(ELp,cv,sulf,sox,nox),
         ELCOconsump(ELp,v,gtyp,cv,sulf,sox,nox,t,r))
    ) )$ELpcoal(ELp) ) =g= 0;
;

ELprofit_eqn(ELc,vv,t,r)$ELctariff(ELc,vv)..

ELprofit(ELc,vv,t,r) =e=
+sum((ELp,v)$(ELptariff(ELp,v) and ELcELp(ELc,vv,ELp,v)),

  +sum((ELl,ELf)$(ELpELf(ELp,ELf)),
         +(ELtariffmax(ELp,r)*(1-ELparasitic(Elp,v))-ELomcst(ELp,v,r))*
         ELop(ELp,v,ELl,ELf,t,r) )$(not ELpw(Elp) or (ELpw(ELp) and ELwtarget<>1))

*  Generator tariffs and costs for operating flue gas control systems
  +sum((gtyp,ELfcoal,cv,sulf,sox,nox)$(ELpcoal(ELp) and ELpfgc(ELp,cv,sulf,sox,nox)),
         (
           (ELfgctariff(sox)+ELfgctariff(nox))*
           ((1-ELparasitic(Elp,v))-ELpCOparas(Elp,v,sulf,SOx,NOx,r)*ELfuelburn(ELp,v,ELfcoal,r))
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

*        spining capacity operating cost
  -sum((ELl,ELf)$(ELpELf(ELp,ELf) and ELpspin(ELp)),
         ELomcst(ELp,v,r)*ELusomfrac*ELlchours(ELl)*
                 ELupspincap(ELp,v,ELl,ELf,t,r))

*        fuel cost
  -sum((cv,sulf)$ELfCV('coal',cv,sulf),
    (
         +COprice.l('coal',cv,sulf,t,r)$(not run_model('Coal'))
    )*
    sum(gtyp,(
       sum((sox,nox)$ELpfgc(ELp,cv,sulf,sox,nox),
         ELCOconsump(ELp,v,gtyp,cv,sulf,sox,nox,t,r))
*      -sum((ELl),ELfuelsub(Elp,v,ELl,'coal',gtyp,t,r))$vo(v)
    )))$ELpcoal(ELp)



  -sum((ELf,fss)$(ELpd(ELp) and not Elpcoal(ELp) and ELpfss(ELp,ELf,fss)),
         ELAPf(ELf,fss,t,r)*(
                 ELfconsump(ELp,v,ELf,fss,t,r)
         )
  )

  -(  ELbld(ELp,v,t-ELleadtime(Elp),r)$(vn(v) and ELpw(ELp) and ELwtarget<>1)
     +ELbld(ELp,v,t-ELleadtime(Elp),r)$(vn(v) and ELphyd(ELp))
     +sum(ELppd$ELpbld(ELppd,v),ELcapadd(Elppd,ELp)*
         ELbld(Elppd,v,t-ELleadtime(Elppd),r))$ELpd(ELp)
   )*ELpfixedcost(ELp,v,t,r)

   +ELcapsub(ELp,v,t,r)


  -(  ELexistcp(ELp,v,t,r)$(ELpw(ELp) and ELwtarget<>1)
     +ELexistcp(ELp,v,t,r)$ELphyd(ELp)
     +Elexistcp(ELp,v,t,r)$ELpd(ELp)
  )*ELpsunkcost(ELp,v,t,r)

  -sum(fgc$((DeSOx(fgc) or DeNOx(fgc)) and ELpcoal(ELp)),
         (
           ELfgcexistcp(ELp,v,fgc,t,r)
          +ELfgcbld(ELp,v,fgc,t-ELfgcleadtime(fgc),r))*(EMfgccapexD(fgc,t)+EMfgcfixedOMcst(fgc))
  )

)
;

ELdeficitcap(t)$(ELdefcap=1)..
-sum((ELc,vv,r)$ELctariff(ELc,vv),ELdeficit(ELc,vv,t,r))=g=-ELdeficitmax
;

ELfitcap(ELpw,v,t,r)$(ELpfit=1 and vn(v))..

  +sum((ELl,ELf)$(ELpELf(ELpw,ELf)),ELop(ELpw,v,ELl,ELf,t,r))*
         (ELtariffmax(Elpw,r)-ELomcst(ELpw,v,r))
  -ELwindsub(Elpw,v,t,r)
  -ELbld(ELpw,v,t-ELleadtime(Elpw),r)*ELpfixedcost(ELpw,v,t,r)$vn(v)
         =g= 0
;


ELwindtarget(t)$(ELwtarget=1)..

   sum((ELpw,v,r),ELbld(ELpw,v,t,r)$vn(v)+ELexistcp(ELpw,v,t,r))
         =g= Elwindtot
;



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
*   )*ELpfixedcost(ELp,v,t,r)*sum((Elc,vv)$ELcELp(ELc,vv,ELp,v),DELrevenue_constraint_bilinear(ELc,vv,t,r))
*
*  +(  ELwindexistcp(ELp,v,t,r)$ELpw(ELp)
*     +ELhydexistcp(ELp,v,t,r)$ELphyd(ELp)
*     +Elexistcp(ELp,v,t,r)$ELpd(ELp)
*  )*ELpsunkcost(ELp,v,t,r)*

sum((Elc,vv)$ELcELp(ELc,vv,ELp,v),DELrevenue_constraint_bilinear(ELc,vv,t,r))$(ELptariff(ELp,v))
;


DELdeficit(ELc,vv,t,r)$ELctariff(ELc,vv)..
*and not ELpw(Elp)
*
1$(ELdefcap<>1)    =g=  DELrevenue_constraint_bilinear(ELc,vv,t,r)
         -DELdeficitcap(t)$(ELdefcap=1) ;
;
;


DELfconsump(ELpd,v,ELf,fss,t,r)$(ELpfss(ELpd,ELf,fss) and not ELpcoal(ELpd))..
   ELAPf(ELf,fss,t,r)*(
         0.01$(fss0(fss) and not ELpnuc(ELpd))+1$(not fss0(fss) or Elpnuc(ELpd))
   )*ELdiscfact(t)
         +0=g=

  -sum((Elc,vv)$ELcELp(ELc,vv,ELpd,v),DELrevenue_constraint_bilinear(ELc,vv,t,r))*
         ELAPf(ELf,fss,t,r)$ELptariff(ELpd,v)

  +DELfcons(ELpd,v,ELf,t,r)
  -DELfavail(ELf,t,r)$(ELfog(ELf) and fss0(fss))
;

DELCOconsump(ELpcoal,v,gtyp,cv,sulf,sox,nox,t,r)$ELpfgc(Elpcoal,cv,sulf,sox,nox)..
 COprice('coal',cv,sulf,t,r)*ELdiscfact(t)$run_model('Coal')
+COprice.l('coal',cv,sulf,t,r)*ELdiscfact(t)$(not run_model('Coal'))
         +0=g=

  -sum((Elc,vv)$ELcELp(ELc,vv,ELpcoal,v),DELrevenue_constraint_bilinear(ELc,vv,t,r))*
         ELtariffmax(Elpcoal,r)*COcvSCE(cv)*ELpCOparas(Elpcoal,v,sulf,SOx,NOx,r)$(
                 (DeSOx(sox) or DeNOx(nox)) and reg(gtyp) and ELptariff(ELpcoal,v))

  -sum((Elc,vv)$ELcELp(ELc,vv,ELpcoal,v),DELrevenue_constraint_bilinear(ELc,vv,t,r))*COprice('coal',cv,sulf,t,r)$ELptariff(ELpcoal,v)

  +sum((Elc,vv)$ELcELp(ELc,vv,ELpcoal,v),DELrevenue_constraint_bilinear(ELc,vv,t,r)*
         ( (ELfgctariff(sox)+ELfgctariff(nox))*
           ((1-ELparasitic(Elpcoal,v))-ELpCOparas(Elpcoal,v,sulf,SOx,NOx,r)*ELfuelburn(ELpcoal,v,'coal',r))
          -(EMfgcomcst(sox)+EMfgcomcst(nox)) )*
         COcvSCE(cv)/ELfuelburn(ELpcoal,v,'coal',r))$ELptariff(ELpcoal,v)


  +(EMfgcomcst(sox)+EMfgcomcst(nox))*DELopmaintbal(t)*COcvSCE(cv)/
         ELfuelburn(ELpcoal,v,'coal',r)

  +DELCOcons(ELpcoal,v,gtyp,t,r)*COcvSCE(cv)

  -sum(ELl,DELsup(ELl,t,r)*COcvSCE(cv)*ELpCOparas(Elpcoal,v,sulf,sox,nox,r)*ELlcnorm(ELl)  )$(
         (DeSOx(sox) or DeNOx(nox)) and reg(gtyp))


  -(DELfgccaplim(ELpcoal,v,sox,t,r)*COcvSCE(cv)/ELfuelburn(ELpcoal,v,'coal',r))$DeSOx(sox)
  -(DELfgccaplim(ELpcoal,v,nox,t,r)*COcvSCE(cv)/ELfuelburn(ELpcoal,v,'coal',r))$DeNOx(nox)

*$ontext
  -DEMsulflim(t,r)*EMfgc(sox)*COsulfDW(sulf)*1.6$rdem_on(r)
  -DEMELSO2std(ELpcoal,v,t,r)*EMfgc(sox)*COsulfDW(sulf)*1.6$(SO2_std=1)
  +DEMfgbal(ELpcoal,v,t,r)*VrCo(ELpcoal,'coal',cv)
  -DEMELnoxlim(t,r)*EMfgc(nox)*VrCo(ELpcoal,'coal',cv)*NOxC(r,ELpcoal)
  -DEMELNO2std(ELpcoal,v,t,r)*EMfgc(nox)*VrCo(ELpcoal,'coal',cv)*NO2C(r,ELpcoal)$(SO2_std=1)
*$offtext
;

DELexistcp(ELp,v,t,r)..

        0 =g=

  +DELcapbal(ELp,v,t,r)-DELcapbal(ELp,v,t-1,r)
  -sum((Elc,vv)$ELcELp(ELc,vv,ELp,v),DELrevenue_constraint_bilinear(ELc,vv,t,r))*
         ELpsunkcost(ELp,v,t,r)$(ELptariff(ELp,v) and (not ELpw(Elp) or (ELpw(ELP) and ELwtarget<>1)) )

+sum(ELl,DELcaplim(ELp,v,ELl,t,r)*ELcapfac(ELp,v)*ELlchours(ELl))$(ELpd(ELp))
+sum(grid$rgrid(r,grid),DELrsrvreq(t,grid))$(not ELpw(ELp))

*        Duals for ELpd
  -DELcapcontr(Elp,v,t,r)*ELcntrhrs(ELp,v,t,r)$(ELpd(Elp) and vo(v))

  +sum(fgc$(DeSOx(fgc) or DeNOx(fgc)),
         DELfgccapmax(ELp,v,fgc,t,r))$ELpcoal(ELp)


*        duals for ELphyd
  +DELhydutil(ELp,v,t,r)*ELhydhrs(r)*ELcapfac(Elp,v)$(not ELphydsto(ELp) and ELphyd(ELp))

*        dual for ELpw
  -sum((Elc,vv)$ELcELp(ELc,vv,ELp,v),DELrevenue_constraint_bilinear(ELc,vv,t,r))*
         ELpsunkcost(ELp,v,t,r)$(Elpw(Elp) and ELptariff(ELp,v) and ELwtarget<>1)

  +DELwindcaplim(ELp,v,t,r)$Elpw(Elp)
  +DELwindtarget(t)$(Elpw(ELp) and ELwtarget=1)

;

DELbld(ELp,v,t,r)$ELpbld(ELp,v)..
                      +0 =g=
   DELpurchbal(t)*Elpurcst(ELp,t,r)
  +DELcnstrctbal(t)*ELconstcst(ELp,t,r)
  +DELopmaintbal(t+ELleadtime(ELp))*ELfixedOMcst(ELp)

  +sum(Elpp,DELcapbal(Elpp,v,t+ELleadtime(ELp),r)*ELcapadd(ELp,Elpp))
*  -DELgtconvlim(ELpd,v,t,r)$(ELpgttocc(ELpd) and vo(v))

*        duals excluding wind.
  +sum((ELl,Elpp)$(not ELpw(ELpp) and not ELphyd(ELpp)),DELcaplim(Elpp,v,ELl,t+ELleadtime(ELp),r)
         *ELcapadd(ELp,Elpp)*ELcapfac(ELp,v)*ELlchours(ELl))

  +sum(grid$rgrid(r,grid),DELrsrvreq(t+ELleadtime(ELp),grid))*
         sum(Elpp$(not Elpw(Elp)),ELcapadd(ELp,Elpp))


*        duals for ELpd
  -sum(ELppd$(ELptariff(Elppd,v)),ELcapadd(Elp,ELppd)*
         sum((Elc,vv)$ELcELp(ELc,vv,ELppd,v),DELrevenue_constraint_bilinear(ELc,vv,t+ELleadtime(ELp),r))*
         ELpfixedcost(ELppd,v,t,r))$ELpd(ELp)

  +sum(fgc$(DeSOx(fgc) or DeNOx(fgc)),
         DELfgccapmax(ELp,v,fgc,t+ELleadtime(ELp),r))$ELpcoal(ELp)

*        duals for ELhyd
  -(sum((Elc,vv)$ELcELp(ELc,vv,Elp,v),DELrevenue_constraint_bilinear(ELc,vv,t+ELleadtime(ELp),r))*
         ELpfixedcost(ELp,v,t,r))$(ELphyd(ELp) and ELptariff(ELp,v))
  +(DELhydutil(ELp,v,t+ELleadtime(ELp),r)*ELhydhrs(r)*ELcapfac(Elp,v))$(not ELphydsto(ELp) and ELphyd(ELp))

*        dual for ELpw

  -sum((Elc,vv)$ELcELp(ELc,vv,ELp,v),DELrevenue_constraint_bilinear(ELc,vv,t+ELleadtime(ELp),r))*
         ELpfixedcost(ELp,v,t,r)$(ELpw(ELp) and ELptariff(ELp,v) and ELwtarget<>1)

  +DELwindcaplim(ELp,v,t+ELleadtime(ELp),r)$ELpw(ELp)
  +DELwindtarget(t)$(ELwtarget=1 and ELpw(ELp) )
;


DELop(ELp,v,ELl,ELf,t,r)$ELpELf(ELp,ELf)..
                +0 =g=

  +ELomcst(Elp,v,r)*DELopmaintbal(t)
  +DELsup(ELl,t,r)*(1-ELparasitic(Elp,v))

  -DELcaplim(ELp,v,ELl,t,r)$(not ELpw(ELp) and not ELphyd(ELp))

  +(ELtariffmax(ELp,r)*(1-ELparasitic(Elp,v))-ELomcst(ELp,v,r))*
         sum((Elc,vv)$ELcELp(ELc,vv,ELp,v),DELrevenue_constraint_bilinear(ELc,vv,t,r))$(ELpd(ELp) and ELptariff(ELp,v))

  +DELcapcontr(ELp,v,t,r)$(ELpd(ELp) and vo(v))

  -ELfuelburn(ELp,v,ELf,r)*DELfcons(ELp,v,ELf,t,r)$(ELpd(ELp) and not ELpcoal(ELp))
  -sum(gtyp$reg(gtyp),ELfuelburn(ELp,v,ELf,r)*DELCOcons(ELp,v,gtyp,t,r))$ELpcoal(Elp)

  +DELnucconstraint(ELp,v,ELf,ELl,t,r)$ELpnuc(ELp)
  -sum(ELll,DELnucconstraint(ELp,v,ELf,ELll,t,r)*ELlcnorm(ELll))$ELpnuc(ELp)

*       Duals for ELpw
  +(ELtariffmax(ELp,r)*(1-ELparasitic(Elp,v))-ELomcst(ELp,v,r))*
         sum((Elc,vv)$ELcELp(ELc,vv,ELp,v),DELrevenue_constraint_bilinear(ELc,vv,t,r))$(ELpw(ELp) and ELptariff(ELp,v) and ELwtarget<>1)
  -DELwindutil(ELp,ELl,v,t,r)$ELpw(ELp)

*       Duals for ELphyd
    +(ELtariffmax(ELp,r)*(1-ELparasitic(Elp,v))-ELomcst(ELp,v,r))*
         sum((Elc,vv)$ELcELp(ELc,vv,ELp,v),DELrevenue_constraint_bilinear(ELc,vv,t,r))$(ELphyd(ELp) and ELptariff(ELp,v))

  -DELhydutil(ELp,v,t,r)$(not ELphydsto(ELp)and ELphyd(ELp))
  -DELhydutilsto(v,t,r)$(ELphydsto(ELp))

;

DELupspincap(Elpd,v,ELl,ELf,t,r)$(Elpspin(Elpd) and ELpELf(ELpd,ELf)).. 0 =g=

  -sum((Elc,vv)$ELcELp(ELc,vv,ELpd,v),DELrevenue_constraint_bilinear(ELc,vv,t,r))*
         ELomcst(ELpd,v,r)*ELusomfrac*ELlchours(ELl)$ELptariff(ELpd,v)
$ontext
  -sum((Elc,vv)$ELcELp(ELc,vv,ELpd,v),DELrevenue_constraint_bilinear(ELc,vv,t,r))*(
   sum(gtyp$spin(gtyp),    DELCOcons(ELpd,v,gtyp,t,r))$ELpcoal(ELpd)
*                         +DELfcons(ELpd,v,ELf,t,r)$(not ELpcoal(ELpd))
*                         +ELAPf(ELf,'ss0',t,r)$(not ELpcoal(ELpd))
         )*ELfuelburn(ELpd,v,ELf,r)*ELusrfuelfrac*ELlchours(ELl)
$offtext

  +ELomcst(Elpd,v,r)*DELopmaintbal(t)*ELusomfrac*ELlchours(ELl)

  -ELfuelburn(ELpd,v,ELf,r)*ELusrfuelfrac*ELlchours(ELl)*
         DELfcons(ELpd,v,ELf,t,r)$(not ELpcoal(ELpd))

  -sum(gtyp$spin(gtyp),ELfuelburn(ELpd,v,ELf,r)*ELusrfuelfrac*ELlchours(ELl)*
         DELCOcons(ELpd,v,gtyp,t,r))$ELpcoal(Elpd)

  -DELcaplim(ELpd,v,ELl,t,r)*ELlchours(ELl)

  +DELupspinres(ELl,t,r)*(1-ELparasitic(Elpd,v))
;

*$ontext
DELoploc(ELpd,v,ELl,ELf,t,r)$(not ELpnuc(ELpd) and ELpELf(ELpd,ELf))..
         0 =g=
  +ELlchours(ELl)*ELomcst(Elpd,v,r)*DELopmaintbal(t)
  +ELpsunkcost(ELpd,v,t,r)*
         sum((Elc,vv)$ELcELp(ELc,vv,ELpd,v),DELrevenue_constraint_bilinear(ELc,vv,t,r))$(ELptariff(ELpd,v))

  -ELlchours(ELl)*ELfuelburn(ELpd,v,ELf,r)*DELfcons(ELpd,v,ELf,t,r)$(not ELpcoal(ELpd))

  -sum(gtyp$reg(gtyp),ELfuelburn(ELpd,v,ELf,r)*ELlchours(ELl)*
         DELCOcons(ELpd,v,gtyp,t,r))$ELpcoal(Elpd)

  -ELlchours(ELl)*DELcaplim(ELpd,v,ELl,t,r)
  +ELlchours(ELl)*DELdemloc(t,r)
;
*$offtext

DELgttocc(ELpgttocc,vo,t,r).. 0=g=DELgtconvlim(ELpgttocc,vo,t,r)
   -DELgtconvlim(ELpgttocc,vo,t-1,r);

DELtrans(ELt,ELl,t,r,rr)$ELtransr(ELt,r,rr)..
      0   =g=
  -DELsup(ELl,t,r)
  +DELopmaintbal(t)*ELtransomcst(ELt,r,rr)
  +sum(ELll,DELdem(ELll,t,rr)*Eltransyield(ELt,r,rr))
*ELtranscoef(ELl,ELll,r,rr)
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


DELwindsub(ELpw,v,t,r)$(ELpfit=1 and vn(v))..

  -1=g=
  -DELfitcap(Elpw,v,t,r)
;


DELwindoplevel(wstep,ELpw,v,t,r)..
       +0  =g=
  -DELwindcaplim(ELpw,v,t,r)*(ELwindcap(wstep)-ELwindcap(wstep-1))*ELdemgro('LS1',t,r)
  +sum(ELl,ELdiffGW(wstep,ELl,r)*ELdemgro(ELl,t,r)*DELwindutil(ELpw,ELl,v,t,r)*ELlchours(ELl))
  -DELwindcapsum(wstep,t,r)
  -ELwindspin*sum(ELl,DELupspinres(ELl,t,r)*
         ELdiffGW(wstep,ELl,r)*ELdemgro(ELl,t,r)*(1-ELparasitic(Elpw,v)))
;

DELhydopsto(ELl,v,t,r)..  0=g=
  +DELhydutilsto(v,t,r)*ELhydstoeff
  -DELdem(ELl,t,r)
;

*$ontext

DELfgcexistcp(ELpd,v,fgc,t,r)$(ELpcoal(ELpd) and (DeSOx(fgc) or DeNOx(fgc)))..
      0 =g=
  -(EMfgccapexD(fgc,t)+EMfgcfixedOMcst(fgc))*
         sum((Elc,vv)$ELcELp(ELc,vv,ELpd,v),DELrevenue_constraint_bilinear(ELc,vv,t,r))$ELptariff(ELpd,v)

  +DELfgccapbal(ELpd,v,fgc,t,r)-DELfgccapbal(ELpd,v,fgc,t-1,r)

  +(
          DELfgccaplim(ELpd,v,fgc,t,r)

   )*ELcapfac(ELpd,v)*sum(ELl,ELlchours(ELl))

 -DELfgccapmax(ELpd,v,fgc,t,r)
;

DELfgcbld(ELpd,v,fgc,t,r)$(ELpcoal(ELpd) and (DeSOx(fgc) or DeNOx(fgc)))..
   +0
         =g=
  -(EMfgccapexD(fgc,t)+EMfgcfixedOMcst(fgc))*
         sum((Elc,vv)$ELcELp(ELc,vv,ELpd,v),DELrevenue_constraint_bilinear(ELc,vv,t+ELfgcleadtime(fgc),r))$ELptariff(ELpd,v)

  +DELpurchbal(t)*EMfgccapexD(fgc,t)

  +DELopmaintbal(t)*EMfgcfixedOMcst(fgc)

  +DELfgccapbal(ELpd,v,fgc,t+ELfgcleadtime(fgc),r)

  +(
          DELfgccaplim(ELpd,v,fgc,t,r)
   )*ELcapfac(ELpd,v)*sum(ELl,ELlchours(ELl))

  -DELfgccapmax(ELpd,v,fgc,t+ELfgcleadtime(fgc),r)
;



