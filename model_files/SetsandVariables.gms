
********************************************************************************
*                SetsAndVariables
* This file contains all the sets and variables needed to run the sub-models for
* the KAPSARC Energy Model (KEM).
********************************************************************************
* General and time Sets
Sets
         time            time period for defining parameters and tables /t11*t40/
         trun(time)      final model run time period /t12*t12/
         thyb(trun)      myopic horizon for hybrid recursive dynamics  /t12*t12/
         i              summation index for discounting  /1*10000/
         wind_inc        increments of wind capacity /1*20/
         t(trun)         dynamic set for time

         scenarios pre-defined model scenarios /DI1*DI8,CE1*CE8,base,calib,EIA/

         built_models pre-configured models by sector /Power, Coal/

         lp_mcp set to declare mcp or lp model /LP,MCP/

         sectors        Sectors in the model including aggregate All sectors
                        /All,CO,PC,EL,WA,CM,RF,fup/
         Sect(sectors)

         allmaterials all materials in KEM
                 /coal,met,hardcoke,lignite,
                 crude,HFO, diesel, dummyf,u-235, natgas, ethane, methane, NGL, propane,naphtha,
                 ethylene,methanol, MTBE, styrene,propylene,ethylene-glycol,vcm,
                 ldpe, lldpe, hdpe, pp, pvc, polystyrene,ammonia,urea,2EH,
                 vinacetate,propoxide,prop-glycol,toluene,formald,urea-formald,
                 butadiene,Gcond,Arabsuper,Arabextra,Arablight,Arabmed,Arabheavy,lightcrude
                 sr-gas-oil,hsr-naphtha,lsr-naphtha,hh-naphtha,hl-naphtha,sr-resid,
                 sr-keros,sr-distill,cc-gasoline,cc-naphtha,lhc-naphtha,lt-naphtha,
                 a-gasoline,v-gas-oil,hv-gas-oil,v-resid,cc-gas-oil,c-gas-oil,c-naphtha,
                 ref-gas,fuel-gas,isomerate,h-reformate,l-reformate,95motorgas,91motorgas,
                 LPG,vis-resid,olefingas,petcoke,Butane,Pentane,Jet-fuel,Asphalt,
                 ht-diesel,hc-diesel,CaCO3,CaCO3c,CaCO3SAFm,Sand,Clay,Irono,Gypsum,
                 Pozzn,PortI,PortV,PozzC,PortIp,PortVp,PozzCp,ClinkIh,ClinkVh,ClinkPh,
                 ClinkI,ClinkV,ClinkP,CKD,CaCO3SAF,CSAF,Ca,O,Si,Al,Fe,CO2,CaO,SiO2,
                 Al2O3,Fe2O3,C3S,C2S,C3A,C4AF,biomass,msw,geo/

         f(allmaterials) fuels /coal,met,hardcoke,lignite,
                 crude,dummyf,u-235,natgas,ethane,methane,NGL,
                 propane,naphtha,Gcond,Arabsuper,Arabextra,Arablight,Arabmed,Arabheavy,lightcrude,
                 hsr-naphtha,lsr-naphtha,hh-naphtha,hl-naphtha,sr-resid,Asphalt
                 sr-keros,sr-distill,cc-gasoline,cc-naphtha,lhc-naphtha,lt-naphtha,
                 a-gasoline,v-gas-oil,hv-gas-oil,v-resid,cc-gas-oil,c-gas-oil,c-naphtha,
                 ref-gas,fuel-gas,isomerate,h-reformate,l-reformate,95motorgas,91motorgas,
                 LPG,vis-resid,olefingas,petcoke,HFO,Diesel,Butane,Pentane,Jet-fuel,
                 ht-diesel,hc-diesel,MTBE,biomass,msw,geo/


         fup(f) upstream fuels /coal,met,hardcoke,lignite,
                               methane,ethane,propane,gcond,NGL,u-235,
                               crude,Arabsuper,Arabextra,Arablight,Arabmed,Arabheavy/


         COf(f) coal fuel types /met,hardcoke,coal/

         COfdem(COf) /met,coal/
         coal(COf) thermal coal fuel types /coal/

         met(COf) metallurigcal fuel types /met,hardcoke/
*,anthracite,meagre,weakcoke,strongcoke,thermcoal,lignite/
*,crude,Arabsuper,Arabextra,Arablight,Arabmed,Arabheavy,methane,ethane,NGL,propane,Gcond,u-235,dummyf/
*         natgas(fup) natural gas / methane,ethane,NGL,propane,Gcond/
*         crude(fup) crude grades /Arabsuper,Arabextra,Arablight,Arabmed,Arabheavy/
*         coal(COf) /met,hardcoke,coal/
*,lignite/

         IHScoaluse / 'Electricity Generation','Industry (excluding met. coal)',
                         'Heat Supply','Residential','Other Non-Industry','Metallurgical' /
         IHSpower(IHScoaluse) /'Electricity Generation'/
         IHSmet(IHScoaluse) /'Metallurgical'/

         IHSother(IHScoaluse)

         COstats /'Production','coal prod IHS','met prod IHS','Other','Metallurgical','Power'/

         COforecast coal price forecast scenarios /max,min,con/

         mm mining method /open,under/
         ssi steps for import supply curve /ss0*ss20/
         fss(ssi) /ss0*ss1/
         fss0(fss) /ss0/
         Exp level and resistance to expansion reached /low,med,high,peak,depl/
         rw coal washing set /raw,washed,other/
         rwother(rw) other washed coal products /other/
         rwnoot(rw) raw washed exculding other /raw,washed/
         rwashed(rw) only washed /washed/
         raw(rw) /raw/

*         cv discrete calorific values 3000 to 7000 kcal per kg /CV30,CV35,CV40,CV45,CV50,CV55,CV60,CV65,CV70,CVmet,CVf/
*         cv_steam(cv) ordered calorific values for thermal coal /CV30,CV35,CV40,CV45,CV50,CV55,CV60,CV65,CV70/

         cv discrete calorific values 3000 to 7000 kcal per kg /CV32,CV38,CV44,CV50,CV56,CV62,CV68,CVmet,CVf/
         cv_steam(cv) ordered calorific values for thermal coal /CV32,CV38,CV44,CV50,CV56,CV62,CV68/

         cv_met(cv) calorific values assigned to met coal /CVmet/
         CVf(cv) place holder for other fuels /CVf/
         cv_ord(cv) ordered calorific values

         sulf  sulfur content in coal / ExtLow,Low,Med,High/

         sulfmet(sulf) sulfur content for metallurgical coals / ExtLow,low/
         ELsulf(sulf) /extlow,low,Med,High/
         bound /lo,up/

         COfcv(f,cv) calorific values assigned to coal types
         COfsulf(COf,sulf) calorific values assigned to coal types

         ash percentage ash content in 5 categories 5 15 25 35 and 50 /noash/
         ELash(ash) /noash/
         tr transportation modes /rail,port,truck/
         port(tr) water based transportation /port/
         rail(tr) rail tranportation /rail/
         land(tr) land based transport modes
;

*        Subset sect includes all sectors, eexluding aggregate all.
         sect(sectors)=yes;
         sect('All')=no;

         cv_ord(cv) = (not cv_met(cv) and not CVf(cv));


         COfcv(met,cv_met)=yes;
         COfcv('coal',cv_steam)=yes;
*         COfcv('lignite',cv_lignite)=yes;

         IHSother(IHScoaluse)$(not IHSpower(IHScoaluse) and not IHSmet(IHScoaluse))=yes;

         COfsulf(coal,sulf) = yes;
         COfsulf(met,sulfmet) = yes;

    sets
*                 rtr all transshipment nodes
                 Rall
                 rco(rALL) all nodes used for coal network
                 r(rco)  all demand regions
                 grid    /North, Northeast, Central, East, West, South/
                 rgrid(r,grid)
*                 region sub regions used to aggregate provinces
                 GB(rALL) standard label for chinese provinces
                 province province of each node
                 city name of major city
                 node_type node type
                 nodes(rco,GB,province,city,node_type) all nodes with region label and full name
                 regions(rco,GB) table used to aggregate provincial demand data into regional demand data
                 rco_dem(rco,r) nodes that can be used for coal consumption in remand region r
                 rcodem(rco) nodes that can be used for coal consumption

                 rimp(rco)
                 rexp(rco)
                 rport(rco)
                 rport_sea(rco)
                 rport_riv(rco)

                 ss domestic coal supply sources for IHS Cola Rush report

                 coord /latitude,longitude/


;
                 parameters latitude(rco),longitude(rco);

*$ontext
$gdxin db\setsandparameters.gdx
$load Rall, rco,GB, r,regions, rco_dem, ss, province, city, node_type, nodes, rport_sea,
$load rport_riv, rport
$load latitude, longitude
$gdxin

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

         rdem_on(rco);

         Alias(North,N) ;
         Alias(Northeast,NE) ;
         Alias(South,S) ;
         Alias(East,E) ;
         Alias(Central,C) ;
         Alias(West,W) ;

         rgrid(North,'North') = yes;
         rgrid(Northeast,'Northeast') = yes;
         rgrid(East,'East') = yes;
         rgrid(Central,'Central') = yes;
         rgrid(West,'West') = yes;
         rgrid(South,'South') = yes;

loop((GB,city,node_type),
         rimp(rco)$nodes(rco,GB,"Import",city,node_type) = yes;
         rexp(rco)$nodes(rco,GB,"Export",city,node_type) = yes;
);
land(tr) = yes;
land(port) = no;

         loop(r,
         rcodem(rco)$rco_dem(rco,r) = yes;
         );

         alias (r,rr);
         alias (rr,rrr);
         alias (rco,rrco);
         alias (rport,rrport);
         alias (rimp,rrimp);
         alias (rport_sea,rrport_sea);
         alias (rport_riv,rrport_riv);


         alias (mm,mm2);
         alias (ss,ss2);
         alias (sulf,sulff);



         alias (rw,rww)
         alias (COf,COff);

         alias (ssi,ssii);

         set    ELs /summ/
*,wint,spfa/
         alias (ELs,ELss)

*Sets and variables specific to the submodels:

*Power Submodel Sets
********************************************************************************
Sets
         ELl load segment 1 = peak and 5 = base /LS1*LS5/

         ELc power plant companies /     ST,GT,CC,GTtoCC,CCcon,Nuclear,PV,
                                         Hydrolg,Hydrosto,HydroROR,
                                         Windon, Windoff,Subcr,SubcrSML,SubcrLRG,
                                         Superc,Ultrsc
                                         ELbig
                                   /
         ELp(ELc) power plant types /    ST,GT,CC,GTtoCC,CCcon,Nuclear,PV,
                                         Hydrolg,Hydrosto,HydroROR,
                                         Windon, Windoff,Subcr,SubcrSML,SubcrLRG,
                                         Superc,Ultrsc/

         ELbig(ELc) Full regional market concentration /ELbig/
         ELnuc(ELc) Nuclear power companies /Nuclear/
         ELwind(Elc) /windon/

         ELpd(ELp) dispatchable technologies /Nuclear,SubcrSML,SubcrLRG,Superc,Ultrsc,CC,GT,ST,GTtoCC,CCcon/
         ELps(ELp) solar technologies /PV/
         ELpog(ELp) oil and gas fueled technologies /ST,GT,CC,CCcon/
         ELpCC(ELp) single cycle GT /CC,CCcon/
         ELpCCcon(ELp) /CCcon/
         ELpcoal(ELp) coal technologies /SubcrSML,SubcrLRG,Superc,Ultrsc/
         ELpsubcr(ELp) subcritical coal plant /SubcrSML,SubcrLRG/
         ELpsuperc(ELp) subcritical coal plant /Superc/
         ELpnuc(ELp) nuclear /Nuclear/
         ELpspin(ELp) upsin plants used as renewable backup /GT,SubcrSML,SubcrLRG,Superc,Ultrsc/
         ELpsingle(Elp) sigle cycle and standalone steam plants (not coal) /GT,ST/
         ELphyd(ELp) hydro technologies /Hydrolg,Hydrosto, HydroROR/
         ELphydsto(ELp) pumped storage hydro /Hydrosto/
         ELpw(ELp) wind technologies /Windon/
         ELpwon(ELpw) wind technologies /Windon/
*         ELpwoff(ELpw) wind technologies /Windoff/
         chp set to identify CHP or dual purpose plants with heat recvoery /chp, no_chp/

         ELt High Voltage AC and UHV DC transmission technologies  /HVAC,UHVDC/
         HVAV(ELt) /HVAC/

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

         ELf(f) /lightcrude,HFO,diesel,methane,u-235,coal,dummyf/
*        ,biomass,petcoke,msw,LPG,geo/
         ELfref(ELf) refined fuels /HFO,diesel/
         ELfliquid(ELf) liquid fueld /HFO,diesel,lightcrude/
         ELfcrude(ELf) crude fuels /lightcrude/
         ELfup(ELf) upstream fuels /methane,u-235/
         ELfdummy(f) dummy fuel /dummyf/

         ELfog(ELf) /lightcrude,methane,HFO,diesel/
*
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
         ELfCV(f,cv,sulf)
         ELcELp(ELc,vv,ELp,v) bundle of plants belonging to a given company
         ELctariff(Elc,v)
;


         ELpELf(ELpog,ELfog) = yes;
         ELpELf(ELpnuc,Elfnuclear) = yes;
         ELpELf(Elphyd,'dummyf') = yes;
         ELpELf(Elpw,'dummyf') = yes;
         ELpELf(ELpcoal,ELfcoal) = yes;

         ELpfss(ELpd,ELf,'ss0')$ELpELf(ELpd,ELf) = yes;
         ELpfss(ELpog,ELfog,fss) = yes;


         ELpfgc(Elpcoal,cv_ord,sulf,sox,nox) = yes;

         ELpgttocc(ELp)=no;
         ELpgttocc('GTtoCC')=yes;
         ELpcom(ELpd)= not ELpgttocc(ELpd);
         ELpcom('CCcon')=no;

         ELpbld(ELp,v)$( (not ELpgttocc(ELp) and vn(v)) or
                         (vo(v) and ELpgttocc(ELp)))  = yes ;

         ELfCV(ELfcoal,cv_ord,sulf) = yes;
         ELfCV(ELfnuclear,CVf,'ExtLow') = yes;
         ELfCV(ELfog,CVf,'ExtLow') = yes;

*         fDiesel(ELf)=no;
*         fDiesel('Diesel')=yes;





         Parameter
         ELlchours(ELl) time (hours) in each load segment 1 = peak 5 = base
/
         LS1  117
         LS2  1127
         LS3  3820
         LS4  3024
         LS5  696

$ontext
         LS1  117
         LS2  1130
         LS3  3830
         LS4  3007
         LS5  700
$offtext
/


         ELsdays(ELs)
         /
         summ  365
*         wint  90
*         spfa  155
         /


         ELsnorm(ELs)
;

*        Rescale to calculate TWH rather than GWH in the caplim equations
*        to rescale transmission costs closer to capacity capital costs
         ELlchours(ELl) = 1e-3*ELlchours(ELl);

         Elsnorm(ELs) =  ELsdays(ELs)/sum(ELss,ELsdays(ELss));

Parameter ELlcnorm(ELl) normalized load hours curve;


alias(ELl,ELll);
         ELlcnorm(ELl) = ELlchours(ELl)/sum(ELll,ELlchours(ELll));
*        Use for all submodels supplying or consuming power equally accross all load segements

*         abort ELlcw,ELlchours,ELlmchours;


* On grid tarrif scenairos
********************************************************************************
positive Variables       capsubsidy(time), subsidy(time) investment subsidy variable
                         DELsuptariff (ELp,trun,r)
;

parameter gamma(ELp,time) specific subsidy grid values
;
          gamma(ELp,time) = 0;

parameter ELtariffmax(ELp,rco) power plants regional on grid electricity tariffs RMB per MWH
          ELfgctariff(fgc) tariff supplement for flu gas control deployment RMB per MWH
;

scalar ELwindtot lower bound on wind capacity (existing pus builds) /200/  ;


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
ELptariffcoal(v) power plants with ongrid electricity tarrif
ELpdsub(ELpd) subsidized disp power plant types
ELpwsub(ELpw) subsidized wind power plant types
ELpsub(ELp)   subsidized power plants

ELrtariff(r)
;

*        intialize subsidy grid sets for non susbsidized runs
ELrtariff(r)   =no;
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

         coalprod(COf,cv,sulf,trun,rco) Quantity of coal produced in a given mining region by average calorific value and sulfur content
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


         coalusepenalty(trun)

*        Dual Variabls Coal Production ========================*



         DCOcapbal(COf,mm,ss,trun,rco) dual on coal transport balance
         DCOcaplim(COf,mm,ss,trun,rco) dual coal transport capcity constraint

         DCOsulflim(sulf,trun,rco) dual COsulflim
         DCOwashcaplim(COf,mm,ss,trun,rco)

         DCOprodCV(COf,cv,sulf,trun,rco) dual price for coal produciton by average CV
         DCOprodfx(COf,sulf,mm,ss,trun,rco)
         DCOprodlim(COf,mm,ss,trun,rco)


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

*Dual activities for the MCP
         DELpurchbal(trun)               free dual of purchbal
         DELcnstrctbal(trun)             free dual of cnstrctbal
         DELopmaintbal(trun)             free dual of opmaintbal

         DELnucconstraint(ELl,trun,r)

         DEMfgbal(ELp,v,trun,r)


Positive variables


         ELcapsub(ELp,v,trun,r)   Capital subsidy paid by government to compensate generators
         ELfuelsub(ELp,v,ELl,ELf,gtyp,trun,r)  Variable subsidy paid by government to compensate generators
         ELdeficit(ELp,v,trun,r) Deficit encountered by companies operating bundle of gerneators
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
         DELprofit(ELc,v,trun,r)
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
