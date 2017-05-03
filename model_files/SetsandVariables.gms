
********************************************************************************
*                SetsAndVariables
* This file contains all the sets and variables needed to run the sub-models for
* the KAPSARC Energy Model (KEM).
********************************************************************************
* General and time Sets
Sets     time            time period for defining parameters and tables
         sectors        Sectors in the model including aggregate All sectors

         allmaterials all materials in KEM
         f(allmaterials) fuels
         fup(f) upstream fuels
         COf(f) coal fuel types
         ELf(f) electricity fuel types

         Rall
         rco(rALL) all nodes used for coal network
         r(rco)  all demand regions
         r_industry(r) Industrial demand regions (KEM China)
         GB(rALL) standard label for chinese provinces
         regions(rco,GB) table used to aggregate provincial demand data into regional demand data
         rco_r_dem(rco,r) supply or transit nodes that can be used for coal consumption in remand region r
         rcodem(rco) all nodes that can be used for coal consumption

         rimp(rco)
         rexp(rco)
         rport(rco)
         rport_sea(rco)
         rport_riv(rco)

         sulf  sulfur content in coal

         rco_exporter(rco)
         rco_importer(rco)

         cv discrete calorific values bins kcal per kg
         cv_met(cv) calorific values assigned to met coal in kcal per kg
         mm coal mining method
         rw coal processsing



         ss              domestic coal supply sources for IHS Cola Rush report
         SOE(ss)         State owned enterprises (KEM China)
         Local(ss)       Local enterprises (KEM China)
         TVE(ss)         Town village enterprises (KEM China)
         ALlss(ss)       All coal suppliers (KEM China)
         SOEex(sS)
;

         parameters latitude(rco),longitude(rco);


$gdxin db\setsandparameters.gdx
$load time
$load Rall, rco,GB, r, r_industry,
$load regions, rco_r_dem
$load rco_exporter, rco_importer
$load rport_riv, rport, rimp, rport_sea,
$load latitude, longitude, sectors
$gdxin

$gdxin db\material_sets.gdx
$load allmaterials, f, fup, COf, ELf,
$load ss, Local, TVE, SOE, Allss,
$load cv, cv_met,  mm, rw, sulf
$gdxin

sets    ELs /summ/;

alias (r,rr), (rr,rrr), (rco,rrco), (rport,rrport), (rimp,rrimp);
alias (rport_sea,rrport_sea), (rport_riv,rrport_riv), (ELs,ELss)  ;
alias (COf,COff);

sets
         trun(time)      final model run time period /t15*t15/
         thyb(trun)      myopic horizon for hybrid recursive dynamics  /t15*t15/
         i              summation index for discounting  /1*10000/
         wind_inc        increments of wind capacity /1*20/
         t(trun)         dynamic set for time
         built_models pre-configured models by sector /Power, Coal, Emissions/

         lp_mcp set to declare mcp or lp model /LP,MCP/


         Sect(sectors)  /CO,PC,EL,WA,CM,RF,fup,OT/
         OT(sect) Other sectors /OT/
         EL(sect) Electricity Sectors /EL/
         CO(sect) Coal Sector /CO/

         coal(COf) thermal coal fuel types /coal, coal_i/
         coal_i(COF) /coal_i/
         coal_t(COf) /coal/

         met(COf) metallurgical fuel types /met/

         rwother(rw) other washed coal products /other/
         rwnoot(rw) raw washed exculding other /raw,washed/
         rwashed(rw) only washed /washed/
         raw(rw) /raw/

         ssi steps for import supply curve /ss0*ss20/
         fss(ssi) /ss0*ss1/
         fss0(fss) /ss0/
         Exp level and resistance to expansion reached /low,med,high,peak,depl/

         bound /lo,up/
         COfcv(f,cv) calorific values assigned to coal types
         COfsulf(COf,sulf) calorific values assigned to coal types

         tr transportation modes /rail,port,truck/
         port(tr) water based transportation /port/
         rail(tr) rail tranportation /rail/
         truck /truck/
         land(tr) land based transport modes
;

alias (ss,ss2), (mm,mm2), (sulf,sulff), (rw,rww), (COf,COff), (coal,coall);


         COfcv(met,cv_met)=yes;
         COfcv(coal,cv)=yes;
         COfcv(coal_i,cv)=yes;

         COfsulf(coal,sulf) = yes;
         COfsulf(coal_i,sulf) = yes;
         COfsulf(met,sulf) = yes;

         land(tr) = yes;
         land(port) = no;

sets
         coord /latitude,longitude/
;

         SOEex('Shandong') = yes;
         SOEex('Shandong') = yes;
         SOEex('Shandong Hard Coking') = yes;
         SOEex('Shandong Met') = yes;
         SOEex('Shandong Met') = yes;
         SOEex('Anhui Huaibei') = yes;
         SOEex('Anhui Huainan') = yes;
set
         North(r) /North,CoalC,Shandong/
         Northeast(r) /Northeast/
         South(r) /South,Southwest/
         East(r) /East/
         Central(r) /Central,Sichuan,Henan/
         West(r) /West,Xinjiang/
         Henan(r) /Henan/
         Shandong(r) /Shandong/
         Xinjiang(r) /Xinjiang/

         CoalCCBR(rco) /WestCBR, CoalCCBRN, CoalCCBRS, CoalC /
         CBRRMG2(rco) /WestCBR, CoalCCBRN, CoalCCBRS, CoalC, Henan, East, EastCBR, Shandong/


         rdem_on(rco)
         ;

         Alias(North,N) ;
         Alias(Northeast,NE) ;
         Alias(South,S) ;
         Alias(East,E) ;
         Alias(Central,C) ;
         Alias(West,W) ;

         loop(r,
                 rcodem(rco)$rco_r_dem(rco,r) = yes;
         );

*Sets and variables specific to the submodels:

*Power Submodel Sets
********************************************************************************
Sets
         ELl load segments
         ELp power plant types
         ELpon(ELp) power plants switched on
         ELt Transmission technologies
         grid Transmission Grid
         rgrid(r,grid) Regions belongs to each grid
;

Parameter
         ELlchours(ELl) time (hours) in each load segment 1 = peak 5 = base
         ELsdays(ELs)
         /
         summ  365
*         wint  90
*         spfa  155
         /
         ELsnorm(ELs)
         ELlcnorm(ELl) normalized load hours curve;
;

alias(ELl,ELll);

$gdxin db\electricity_sets.gdx
$load ELl, ELp, ELpon,ELt, ELlchours,  grid, rgrid
$gdxin

*        Rescale to calculate TWH rather than GWH in the caplim equations
*        to rescale transmission costs closer to capacity capital costs
         ELlchours(ELl) = 1e-3*ELlchours(ELl);
         Elsnorm(ELs) =  ELsdays(ELs)/sum(ELss,ELsdays(ELss));
         ELlcnorm(ELl) = ELlchours(ELl)/sum(ELll,ELlchours(ELll));


Sets

*  Power plant companies are aggregate at the regional level by technology
         ELc power plant companies /     Nuclear,ELbig,Wind/
         ELbig(ELc) Full regional market concentration /ELbig/
         ELnuc(ELc) Nuclear power companies /Nuclear/
         ELwind(Elc) Wind power plant companies /Wind/

         ELpd(ELp) dispatchable technologies /Nuclear,SubcrSML,SubcrLRG,Superc,Ultrsc,CC,GT,ST,GTtoCC,CCcon/
         ELps(ELp) solar technologies /PV/
         ELpog(ELp) oil and gas fueled technologies /ST,GT,CC,CCcon/
         ELpCC(ELp) combined cycle units /CC,CCcon/
         ELpsingle(Elp) sigle cycle and standalone steam plants (not coal) /GT,ST/
         ELpCCcon(ELp) /CCcon/
         ELpcoal(ELp) coal technologies /SubcrSML,SubcrLRG,Superc,Ultrsc/
         ELpsubcr(ELp) subcritical coal plant /SubcrSML,SubcrLRG/
         ELpsuperc(ELp) subcritical coal plant /Superc/
         ELpnuc(ELp) nuclear /Nuclear/
         ELpspin(ELp) upsin plants used as renewable backup /GT,SubcrSML,SubcrLRG,Superc,Ultrsc/
         ELphyd(ELp) hydro technologies /Hydrolg,Hydrosto, HydroROR/
         ELphydsto(ELp) pumped storage hydro /Hydrosto/
         ELpw(ELp) wind technologies /Windon, windoff/
         ELpwoff(ELpw) wind technologies /Windoff/
         chp set to identify CHP or dual purpose plants with heat recvoery /chp, no_chp/

*GTtoCC is an intermediate process that represents any retrofitting of existing
*GT plants into CC plants.

         v plant vintage /old,new/
         vo(v) old vintage /old/
         vn(v) new vintage /new/
         size plant size /large,small/
         ps plant size /large, small/

         ELpgttocc(ELp) GTtoCC convertible capacity
         ELpcom(ELp)
         ELpbld(ELp,v) Union set to define bld variable for converting old vintage gt to CCconv

         ELfref(ELf) refined fuels /HFO,diesel/
         ELfliquid(ELf) liquid fueld /HFO,diesel,lightcrude/
         ELfcrude(ELf) crude fuels /lightcrude/
         ELfup(ELf) upstream fuels /methane,u-235/
         ELfdummy(f) dummy fuel /dummyf/
         ELfog(ELf) /lightcrude,methane,HFO,diesel/
         ELrfgas(ELf) /HFO,diesel,methane/
         ELfmethane(ELf) /methane/
         ELfcoal(f) /coal/
         ELfnuclear(ELf) /u-235/

         fDiesel(ELf) Diesel only
         fspin(f) Upspin fuels required to backup solar /diesel, methane,coal/

         gtyp Specirfies type of generator for fuel consump variable /reg,spin/
         reg(gtyp) /reg/
         spin(gtyp) /spin/

         wstep wind capacity steps /w1*w100/
         cc cloud cover /nc,pc,oc,dust/

         fgc flue gas control systems /DeSOx, DeNOx, noDeSOx, noDeNOx/
         nofgc(fgc) no fgc /noDeNOx, noDeSOx/
         sox(fgc) /noDeSOx, DeSOx/
         nox(fgc) /noDeNOx, DeNOx/
         DeSOx(fgc) /DeSOx/
         DeNOx(fgc) /DeNOx/
         noDesox(fgc) /noDeSOx/
         noDenox(fgc) /noDeNOx/
;
         alias (ELp,ELpp);
         alias (ELpd,ELppd);
         alias (v,vv);
         alias (ELphyd,ELpphyd);
         alias (wstep,wwstep);
         alias (ELl,ELll);
         alias(ELl,ELlll);

sets
         ELpELf(Elp,f) fuel use for different generators
         ELpfss(Elp,f,fss) fuel use for different generators
         ELpfgc(Elp,cv,sulf,fgc,fgc) fuel use for different generators
         ELfCV(f,cv,sulf) Set for calorific value and sulfur contents by fuel type (coal fuels)
;

         ELpELf(ELp,ELfog)$(ELpon(ELp) and ELpog(ELp)) = yes;
         ELpELf(ELp,Elfnuclear)$(ELpon(ELp) and ELpnuc(ELp)) = yes;
         ELpELf(ELp,'dummyf')$(ELpon(ELp) and Elphyd(ELp)) = yes;
         ELpELf(ELp,'dummyf')$(ELpon(ELp) and Elpw(ELp)) = yes;
         ELpELf(ELp,ELfcoal)$(ELpon(ELp) and ELpcoal(ELp)) = yes;

         ELpfss(ELpd,ELf,'ss0')$ELpELf(ELpd,ELf) = yes;
         ELpfss(ELp,ELfog,fss)$(ELpon(ELp) and ELpog(ELp)) = yes;


         ELpfgc(ELp,cv,sulf,sox,nox)$(ELpon(ELp) and Elpcoal(ELp)) = yes;

         ELpgttocc(ELp)=no;
         ELpgttocc('GTtoCC')=yes;
         ELpcom(ELpd)= not ELpgttocc(ELpd);
         ELpcom('CCcon')=no;

         ELpbld(ELp,v)$( ELpon(ELp) and (not ELpgttocc(ELp) and vn(v)) or
                         (vo(v) and ELpgttocc(ELp)))  = yes ;
         ELpbld('CCcon',v)=no;
         ELpbld('PV',v)=no;

         ELfCV(ELfcoal,cv,sulf) = yes;



* On grid tarrif scenairos
********************************************************************************
positive Variables       capsubsidy(time), subsidy(time) investment subsidy variable
                         DELsuptariff (ELp,trun,r)
;

parameter gamma(ELp,time) specific subsidy grid values
;
          gamma(ELp,time) = 0;

scalar ELwindtot lower bound on wind capacity (existing pus builds) /200/  ;


*        PARAMETERS and SETS used for ongird tariff scenarios and to define
*        concentration of power plants

parameter ELtariffmax(ELp,rco) power plants regional on grid electricity tariffs RMB per MWH
          ELfgctariff(fgc) tariff supplement for flu gas control deployment RMB per MWH
;

$gdxin db\power.gdx
$load ELtariffmax
$gdxin

         ELfgctariff('DeSOx') = 15;
         ELfgctariff('DeNOx') = 10;

ELtariffmax(ELpog,r) = ELtariffmax('CC',r) ;
ELtariffmax(ELpcoal,r)$(ELtariffmax(ELpcoal,r)=0) = ELtariffmax('Ultrsc',r);
ELtariffmax(ELphyd,r)$(ELtariffmax(ELphyd,r)=0) = ELtariffmax('Hydrolg',r);
ELtariffmax(ELphydsto,r) = ELtariffmax('CC',r);
ELtariffmax(ELpw,r)$(ELtariffmax(ELpw,r)=0) = ELtariffmax('Windon',r);


sets
ELptariff(ELp,v) power plants with ongrid electricity tarrif
ELctariff(Elc,v) tariff by power company
ELcELp(ELc,vv,ELp,v) bundle of plants belonging to a given company
ELpdsub(ELpd) subsidized disp power plant types
ELpwsub(ELpw) subsidized wind power plant types
ELpsub(ELp)   subsidized power plants
ELrtariff(r)  Limit tariff policy to select regions
;

         ELrtariff(r) = yes;

*        no on-grid electricity tarrifs
         ELptariff(ELpd,v) = no;
         ELctariff(ELc,vv) = no;
         ELcELp(ELc,v,ELp,v)= no;

*        intialize subsidy grid sets for non susbsidized runs
         ELpdsub(Elpd) = no;
         ELpwsub(Elpw) = no;


sets
* power sub-model fuel subsets
ELfAP(f) fuels with predefined allocation or abundant supply
ELfMP(f) optimal allocation of fuels conditional on administered prices
ELpsupMC(ELp,r) power producers paid marginal cost for supplying the grid.
;

ELpsupMC(ELp,r) = yes;

ELfMP(ELfcoal)=  yes;

ELfAP(ELf) = yes;
ELfAP(ELfMP) = no;


*        GLOBAL objective value variable for all sectors
Variable objvalue;


*        Variables of the coal submodels =======================================
variables

         COobjvalue
         COobjvalue_CFS           objective value including CFS
         DCOpurchbal(trun)        free dual of purchbal
         DCOcnstrctbal(trun)      free dual of cnstrctbal
         DCOopmaintbal(trun)      free dual of opmaintbal

         DCOimportbal(trun)       free dual of importbal

         DCOtransPurchbal(trun)        free dual of transpurchbal
         DCOtransCnstrctbal(trun)      free dual of transcnstrctbal
         DCOtransOpmaintbal(trun)      free dual of opmaintbal
         DCOimportbal(trun)            free dual of importbal

         DCOtransbldeq(tr,trun,rco,rrco) free dual on equalizing bi-directional rail capacity built
         COprice(COf,cv,sulf,trun,r)
         COprice_dummy(COf,cv,sulf,trun,r)

positive Variables

         COexistcp(COf,mm,ss,trun,rco)
         CObld(COf,mm,ss,trun,rco)

         COprod(COf,sulf,mm,ss,rw,trun,rco) coal production units with average regional sulfur and ash content

         coalprod(COf,COff,cv,sulf,trun,rco) Quantity of coal produced in a given mining region by average calorific value and sulfur content
         coalprod2(COf,cv,sulf,mm,ss,rw,trun,rco) fg
         coaluse(COf,cv,sulf,trun,rco) Quantity of coal used locally in demand region with internal production
         coaluse_local

         coalimports(COf,ssi,cv,sulf,trun,rco)  Quantity of fuel imported by average calorific value
         coalexports(COf,cv,sulf,trun,rco) Quantity of coal exported

         COtrans(COf,cv,sulf,tr,trun,rco,rrco)
         COtransload(COf,tr,trun,rco)
         COtransexistcp(tr,trun,rco,rrco)
         COtransbld(tr,trun,rco,rrco)

         COtransmax(trun,rco,rrco) allocation of coal freight capacity

         COpurchase(trun) Equipment purchased costs in USD
         COConstruct(trun) Construction costs in USD
         COOpandmaint(trun) Operation and maintenance costs in USD

         COtransPurchase(trun) Equipment purchased costs in USD
         COtransConstruct(trun) Construction costs in USD
         COtransOpandmaint(trun) Operation and maintenance costs in USD
         COimports(trun) Coal trade

         OTHERCOconsumpsulf(f,cv,sulf,trun,rr) endogenous other coal demand by sulfur content

         COsubconsump(trun,rr) coal substitution consumption

         coalusepenalty(trun)

*        Dual Variabls Coal Production ========================*



         DCOcapbal(COf,mm,ss,trun,rco) dual on coal transport balance
         DCOcaplim(COf,mm,ss,trun,rco) dual coal transport capcity constraint

         DCOsulflim(COf,mm,ss,sulf,trun,rco) dual COsulflim
         DCOwashcaplim(COf,mm,ss,trun,rco)

         DCOprodCV(COf,cv,sulf,trun,rco) dual price for coal produciton by average CV
         DCOprodfx(COf,sulf,mm,ss,trun,rco)
         DCOprodlim(COf,trun,rco)


*        Dual Variabls Coal Transporation =====================*

         DCOexporttransbal(COf,cv,sulf,trun,rco,rrco) dual on balance coal exports and coal transport
         DCOimportsuplim(COf,ssi,cv,sulf,trun) dual capacity limit on coal import supply steps
         DCOimportlim(Cof,trun,rco) dual capacity limitation on coal imports

         DCOsup(COf,cv,sulf,trun,rco) dual on coal supply constraint
         DCOsuplim(f,cv,sulf,trun,rco) supply limit on the amount of coal consumption outside provincial demand center

         DCOdem(f,cv,sulf,trun,rrco) dual of coal demand constraint
         DCOdemOther(COf,trun,rrco) dual of total demand constrian


         DCOtranscapbal(tr,trun,rco,rrco) dual price for fuel transport balance
         DCOtransportcaplim(tr,trun,rco) dual price for fuel transport port balance
         DCOtranscaplim(tr,trun,rco,rrco) dual price for fuel transport capacity constraint

         DCotransloadlim(COf,tr,trun,rco) dual price for transport loading constraint

         DCOexportlim(trun,rco) constraint of coal exports

         DCOtransbudgetlim(tr,trun) investment budget for railway capacity expansion

*         DCOtransbldlim(tr,trun,rco)  dual of COtransbldlim

*         DCOtranslim(trun,rco,rrco) dual of capacity limit on coal rail transport


;


*        Power Submodel variables ============================================

*Variables of the Power submodel
Variables
         ELobjvalue
         y(f,trun)
         testing(trun)
*         fsubsidy(trun)

         ELprofit(ELc,vv,trun,r)

*Dual activities for the MCP
         DELpurchbal(trun)               free dual of purchbal
         DELcnstrctbal(trun)             free dual of cnstrctbal
         DELopmaintbal(trun)             free dual of opmaintbal

         DELnucconstraint(ELp,v,ELf,ELl,trun,r)

         DEMfgbal(ELp,v,trun,r)


Positive variables


         ELcapsub(ELp,v,trun,r)   Capital subsidy paid by government to compensate generators
         ELfuelsub(ELp,v,ELl,ELf,gtyp,trun,r)  Variable subsidy paid by government to compensate generators
         ELdeficit(ELc,v,trun,r) Deficit encountered by companies operating bundle of gerneators
         ELwinddeficit(ELp,v,trun,r) Deficit encountered by companies operating bundle of gerneators

         ELtariff(ELp,v,trun,r)
         ELwindsub(ELp,v,trun,r)
         ELsubsidywind(ELp,v,trun,r)

*electricity production activities
         ELbld(ELp,v,trun,r) Construction of new conventional power plants in GW
         ELrsrvbld(ELp,v,trun,r) Build activity for reserve margin
         ELwindbld(ELp,v,trun,r) Construction of new wind turbine in GW
         ELhydbld(ELp,v,trun,r) Construction of new hydro plants in GW
*         ELexistcs(ELp,v,trun,r) Exisiting cpacity stock in GW
         ELexistcp(ELp,v,trun,r) Existing conventional power capacity used for produciton and upspin in GW
*         ELwindexistcs(ELp,v,trun,r) Existing wind capacity stock in GW
         ELwindexistcp(ELp,v,trun,r) Existing wind power capacity contracted in GW
*         ELhydexistcs(ELp,v,trun,r) Existing hydro power capacity stock in GW
         ELhydexistcp(ELp,v,trun,r) Existing hydro power capacity contracted in GW
         ELgtconvcc(v,trun,r) GT conversino to CC

         ELop(ELp,v,ELl,f,trun,r) capacity contracted by the state owned utility
         ELupspincap(ELp,v,ELl,f,trun,r)
         ELoploc(ELp,v,ELl,ELf,trun,r) Conventional electricity production in TWH
         ELhydop(ELp,v,ELl,trun,r)    operation of hydro capacity in TWh
         ELhydopsto(ELl,v,trun,r) storage of hydro capacity at pumped reservoirs
         ELwindop(ELp,v,ELl,trun,r)  electricity production of wind power in TWH
         ELwindoplevel(wstep,ELpw,v,trun,r) level of utilization in between wind capacity steps
         ELgttocc(Elp,v,trun,r)

         ELdnspincap(ELpd,v,ELl,trun,r)

*transportation activities
         ELtrans(ELt,ELl,trun,r,rr)
         ELtransbld(ELt,trun,r,rr)
         ELtransexistcp(ELt,trun,r,rr)
* Flue Gas Desulphurization activities

*Cross-cutting activities
         ELImports(trun)          Equipment purchased costs in USD (typically imported)
         ELConstruct(trun)        Construction costs in USD
         ELOpandmaint(trun)       Operation and maintenance costs in USD
         ELfconsump(Elp,v,f,fss,trun,r) Fuel consumption by power sector
         ELCOconsump(ELp,v,gtyp,cv,sulf,fgc,fgc,trun,r) Fuel consumption by power sector
         ELCOconsump2(ELp,cv,sulf,trun,r)     Fuel consumption by power sector

*FGD operation variable
         ELfgcexistcp(ELp,v,fgc,trun,r)  Flu gas desulphurization capacity in GW
         ELfgcbld(ELp,v,fgc,trun,r)  New Flu gas desulphurization capacity builds in GW

*Duals for electricity
         DELcapbal(Elp,v,trun,r)    free dual of capbal
         DELwindcapbal(ELpw,v,trun,r)
         DELwindcaplim(ELp,v,trun,r)
         DELgtconvlim(ELp,v,trun,r) free dual of Elgtconvlim
         DELcaplim(ELp,v,ELl,trun,r) dual of ELcaplim
         DELcapstocklim(ELp,v,trun,r) dual of ELcapstocklim
         DELcapcontr(ELp,v,trun,r) dual of ELcapcontr

         DELwindutil(ELp,ELl,v,trun,r)
         DELwindcapsum(wstep,trun,r)
         DELupspinres(ELl,trun,r)

         DELhydcapbal(ELphyd,v,trun,r)     Dual of hydro capacity balance
         DELhydcaplim(ELphyd,ELl,v,trun,r) Dual of hydro capacity limit

         DELhydutil(ELp,v,trun,r)   Dual of hydro utilization
         DELhydutilsto(v,trun,r)   Dual of hydro storage utilization


         DELsup(ELl,trun,r)     dual of ELsup
         DELdem(ELl,trun,r)     dual of ELdem
         DELdemloc(trun,r)       dual of ELdemloc
         DELdemlocbase(ELl,trun,r)       dual of ELdemloc

         DELrsrvreq(trun,grid)     dual of ELrsrvreq

*Duals for transportation
         DELtranscapbal(ELt,trun,r,rr) dual of ELtranscapbal
         DELtranscaplim(ELt,ELl,trun,r,rr) dual of ELtranscaplim

         DELfavail(ELf,trun,r) dual of ELfavail


         DELfcons(ELp,v,ELf,trun,r) dual of fuel supply equation
         DELCOcons(Elp,v,gtyp,trun,r) dual of fuel supply equation
         DELupspinres(ELl,trun,r)
         DELdnspinres(ELpd,ELl,trun,r)


* Duals fro FGD
         DELfgccapbal(ELpd,v,fgc,trun,r)
         DELfgccaplim(Elp,v,fgc,trun,r)
         DELfgccapmax(ELp,v,fgc,trun,r)

         DELCOcvlimit(Elpd,trun,r)

* Duals for profit constraint and wind target
         DELrevenue_constraint_bilinear(ELc,v,trun,r)
         DELwindtarget(trun)
         DELfitcap(ELp,v,trun,r)
         DELdeficitcap(trun)

         DELfuelsublim(r,ELl,trun)

*Duals for electricity
         DEMELsulflim(trun,r) sulfur emssions from the power sector
         DEMsulflim(trun,r) dual on sulfur emission constraint
         DEMELnoxlim(trun,r) dual on power sector nox emission constraint

         DEMELSO2std(ELpcoal,v,trun,r)
         DEMELNO2std(ELpcoal,v,trun,r)

         EMELfluegas(ELp,v,trun,r)
;
