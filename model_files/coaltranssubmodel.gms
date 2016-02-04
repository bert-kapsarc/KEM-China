*following section only needed if the submodel is run o astand-alone basis
$inlinecom /* */
$ontext
********************************************************************************
*$INCLUDE ACCESS_sets.gms
*$INCLUDE ACCESS_CO.gms
$INCLUDE Macros.gms
$INCLUDE SetsandVariables.gms
$INCLUDE ScalarsandParameters.gms
*$INCLUDE RW_param.gms
$INCLUDE coalsubmodel.gms



*Variables from other submodels that need to be exogenously fixed:
$gdxin PowerMCP_p.gdx
*$load coalprod
*$load ELCOconsump ELfconsumpspin
*COexpansion coalintlcv
$gdxin


*   coalprod.fx(COf,cv,sulf,trun,rco)=coalprod.l(COf,cv,sulf,trun,rco)*1;
   ELCOconsump.fx(ELpcoal,cv,sulf,trun,rr)= 0;
   ELfconsumpspin.fx(Elpd,ELf,cv,sulf,trun,rr)=0;


   ELCOconsump.fx(ELpcoal,'CV60',sulf,trun,rr)= sum(cv,ELCOconsump.l(ELpcoal,cv,sulf,trun,rr));
   ELfconsumpspin.fx(Elpd,ELf,'CV60',sulf,trun,rr)=sum(cv,ELfconsumpspin.l(Elpd,Elf,cv,sulf,trun,rr))$ELpcoal(ELpd);

         rdem_on(rr) = yes;


********************************************************************************
$offtext

*Surcahrges sourced from Credit Suisse report 2013
scalar   CF_surcharge railway construction fund surcharge;
scalar   EL_surcharge railway electrification surcharge;

parameter coalsupmax(COf,mm,ss,time,rco) maximum fuel supply in each region

          COfexpmax(time,rco) fixed coal export quantity by port of departure

          COtransD(tr,rco,rrco) transportation distances

          COtranscapex(tr,rco,rrco) purchase cost of transmission capacity Yuan per tonne km

          COtranspurcst(tr,time,rco,rrco) purchase cost of transmission capacity RMB per tone-km (rail) per tone (port)
          COtransconstcst(tr,time,rco,rrco) construction cost of transmission capacity RMB per tone-km (rail) per tone (port)

          COtransbudget(tr,time) budget constraint for investment of tranportation infrastrcuture in million RMB


          Railrates(tc,tc_rate) rail tarrifs Yuan per t per km

          COtransomcst(tr,rco,rrco) O&M cost in Yuan per tonne per km
          COtransomcst2(COf,tr,rco,rrco) O&M cost in Yuan per tonne per km
          COtransomcst1(COf,tr) O&M cost in Yuan per tonne

          COtransexist(tr,rco,rrco)  existing coal transportation capacity
*          COtransalloc(tr,rco,rrco)  allocated coal transportation capacity

          COtransleadtime(tr,rco,rrco) lead time for building fuel transport


          COtransyield(tr,rco,rrco) net of self-consumption and distribution losses

          OTHERCOconsumpProv(COf,IHScoaluse,time,rAll) provincial coal consumption

          OTHERCOconsump(COf,time,rr) exogenous coal demand

          OTHERCOconsumpProv_weight(COf,time,rAll) exogenous coal demand by total weight

          OTHERCOconsump_weight(COf,time,rr) exogenous coal demand by total weight

          COtranslifetime(tr) Lifetime of tranportation equipment

*          Cotranscapmax(tr,rco) upper limit on the available amount of transport infrastructure

          COintlprice(COf,ssi,cv,sulf,time,rco) market price for fuels for aggreaget CV bin

          coalintlprice(COf,time,rco,rrco) inlt price of specific CV
          coalintlcv(COf,time,rco,rrco) colorific value of imported coal

          COfimpmax(COf,time) maximum coal supply for each type of coal

          COfimpss(COf,ssi,cv,sulf,time) available coal in import supply step ssi

;



          COtranslifetime(tr) = 100;

$gdxin db\coaltrans.gdx
$load COtransD COtransexist OTHERCOconsumpProv OTHERCOconsumpProv_weight COtransomcst COtranscapex Railrates
* COtransyield COtransalloc COfexpmax
$gdxin

*$gdxin db\coalprod.gdx
*$load COfimpmax
*$gdxin


          COtransleadtime(tr,rco,rrco) = 0;
*          COtransleadtime('rail',rco,rrco)$(COtransexist('rail',rco,rrco)=0)=3;
*          COtransleadtime('rail',rco,rrco)$(COtransexist('rail',rco,rrco)>0)=1;
*          COtransleadtime('port',rco,rrco)=2;


* Split  coal consumption into east and western Nei Mongol using GDP as weight
OTHERCOconsumpProv(COf,IHScoaluse,time,"NME") = OTHERCOconsumpProv(COf,IHScoaluse,time,"NM")*0.3;
OTHERCOconsumpProv(COf,IHScoaluse,time,"NM") =
         OTHERCOconsumpProv(COf,IHScoaluse,time,"NM")-
         OTHERCOconsumpProv(COf,IHScoaluse,time,"NME");

* Split  coal consumption into east and western Nei Mongol using GDP as weight
OTHERCOconsumpProv_weight(COf,time,"NME") = OTHERCOconsumpProv_weight(COf,time,"NM")*0.3;
OTHERCOconsumpProv_weight(COf,time,"NM") =
         OTHERCOconsumpProv_weight(COf,time,"NM")-
         OTHERCOconsumpProv_weight(COf,time,"NME");


$ontext
 Get sum of other CO consumption sectors
OTHERCOconsump(steam,time,rr)=sum((GB,IHSother)$regions(rr,GB),
                         OTHERCOconsumpProv(steam,IHSother,time,GB));
$offtext


OTHERCOconsump(met,time,rr)=sum((GB,IHSmet)$regions(rr,GB),
                         OTHERCOconsumpProv(met,IHSmet,time,GB));

OTHERCOconsump(coal,time,rr)=
                         COstatistics('other consumption',time,rr);




OTHERCOconsump_weight(COf,time,rr)=sum(GB$regions(rr,GB),
         OTHERCOconsumpProv_weight(COf,time,GB));


parameter COconsumpNDRC;

*        rescale exogenous IHS demand projections to values from NDRC 2015 levels
         COconsumpNDRC(COf,time,r)$(ord(time)>3) =
         OTHERCOconsump(COf,time,r)*3900/sum((rr,COff),OTHERCOconsump_weight(COff,'t15',rr));

parameter COconsumpEIA(COf,time) EIA coal demand forecast,
          coalintlpriceEIA(COf,time,rco,rrco) EIA international coal price reference (for china )
          coalintlcvEIA(COf,time,rco,rrco) calorfic value of import coal
          WCD_Quads(time) worl coal demand in quadrillion btu;

$gdxin db\coalprod.gdx
$load coalintlpriceEIA coalintlcvEIA COconsumpEIA WCD_Quads
$gdxin


*        forecast coal price trend, Source: Metal Expert Consulting October 2013, KAPSARC Research
*        assuming average steam coal price of 87 $/ton in 2013.
*        average coking/met coal price 152 $/ton in 2013.
         table COpricetrend(COf,time,COforecast)
                                 min     con     max
         coal.t14             -0.04   0.011   0.05
         coal.t15             -0.04   0.056   0.10
*,lignite
         (hardcoke,met).t14     -0.063   0.051   0.12
         (hardcoke,met).t15     -0.044   0.061   0.20
         ;


*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


* replicate distance between nodes
COtransD(tr,rrco,rco)$(COtransD(tr,rco,rrco)>=COtransD(tr,rrco,rco)) = COtransD(tr,rco,rrco);

* Set trucking distances equal to rail distances as an estimate
COtransD('truck',rco,rrco)$(COtransD('truck',rco,rrco)=0) = COtransD('rail',rco,rrco);


*!!!!!!!!!!Port yields

* Create connection between all river and sea ports, where positive river distances exist
* river ports are only connect to sea ports liying on the river mouth.
* In the database non-connected river and sea ports are flagged with distance -1
COtransyield(port,rport,rrport)$(COtransD(port,rport,rrport)>0) = 1;
COtransyield(port,rport,rrport)$(COtransD(port,rport,rrport)<=0) = 0;


* allow COtrans to ship coal to exoprt destination
COtransyield(port,rport_sea,rexp)= 1;
*COtransyield(port,rport_sea,rrport)$rimp(rrport)= 1;

* allow import coutries to supply coal to domestic china market.
COtransyield(port,rport,rrport_sea)$rimp(rport)= 1;

*Dont allow import basins to exchange coal!
COtransyield(port,rimp,rexp)= 0;

* COtransyield is set to 1 for port self connection
* This is used in the capacity limit equation for aggregate shipments to/from other ports
* I.E. Sea and river ports are given limits on the port not the pathways.
COtransyield(port,rport,rport)=1;

*!!!!!!!!!!Set transyield on land transport
COtransyield('rail',rco,rrco)$(COtransD('rail',rco,rrco)>0)=1;
COtransyield('rail',rimp,rrco)$(COtransexist('rail',rimp,rrco)>0)=1;


COtransyield('rail',rco,rco)=0;
COtransexist('rail',rco,rco)=0;

* create truck conections between any two rail connected cities.
* As an assumption for truck routes when rail is bottlenecked
COtransyield('truck',rco,rrco)$(COtransyield('rail',rco,rrco)>0)=1;

* prohibit trucked imports
COtransyield('truck',rimp,rrco)=0;


COtransyield('rail',rrco,rco)$(COtransyield('rail',rco,rrco)>0) = COtransyield('rail',rco,rrco);


*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
*        declare and define arc set

         set arc(tr,rco,rrco), pathimp(rco,rrco), pathexp(rco,rrco);

*        all import paths use transportation modes classified as general
         loop(tr,
            pathimp(rimp,rrco)$(COtransyield(tr,rimp,rrco)>0) = yes;
            pathexp(rco,rexp)$(COtransyield(tr,rco,rexp)>0 and not rexp(rco)) = yes;
         );

            pathimp(rrco,rimp)= pathimp(rimp,rrco);
            arc(tr,rco,rrco)$(COtransyield(tr,rco,rrco)>0) = yes;
            arc('port',rimp,rrco) = no;
            arc('truck',rrco,rrco) = no;
*            arc(tr,rco,'EXP') = yes;
*not rimp(rrco) and not rexp(rco) and


         COtransyield(tr,rco,rimp)=0;

*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!




* allow for large quantities of coal transport by truck
COtransexist('truck',rco,rrco)$arc('truck',rco,rrco)=1e4;

********** Set transportation costs (tariffs)
*COtransomcst2(COf,'rail',rco,rrco)= COtransomcst('rail',rco,rrco);
*per distance rate for coal dedicated lines calaculted from regression of tranport rates from SXcoal rail database
COtransomcst2(COf,'rail',rco,rrco)$arc('rail',rco,rrco) = 0.0943;
*fix rate for coal dedicated lines calaculted from regression of tranport rates from SXcoal rail database
COtransomcst1(COf,'rail') = 25.8;

scalar RailSurcharge;
RailSurcharge = RailRates('ELS','rate2')+RailRates('CFS','rate2');

* tariff structure for rail freight lines
COtransomcst2(COf,'rail',rco,rrco)$arc('rail',rco,rrco)=
RailRates('TC4','rate2')+RailSurcharge$(COrailCFS=1);

COtransomcst1(COf,'rail') =RailRates('TC4','rate1');

COtransomcst2(COf,"truck",rco,rrco)$arc('truck',rco,rrco) = 0.55;


* port loading fee estimate 20 Yuan per ton
 COtransomcst1(COf,'port')=20;

* !!!!!!!!!!!LOAD average port shipping rates from database
* and extract variable distance rate assuming above loading/unloading fee.
 COtransomcst2(COf,'port',rport,rrport)$(COtransD('port',rport,rrport)>0 and COtransomcst('port',rport,rrport)>0) =
(COtransomcst('port',rport,rrport)*COtransD('port',rport,rrport)
         -COtransomcst1(COf,'port'))/COtransD('port',rport,rrport);

* Where we do not have an average we use the average sourced from Standard Chartered Report accouting for 30 RMB/ton loading fee
 COtransomcst2(COf,'port',rport,rrport)$(COtransomcst2(COf,'port',rport,rrport)=0)
          = 0.004;
* river variable transportation rate 0.07 gives 0.10 RMB/ton-km for 1000 km trip with above laoding fee
 COtransomcst2(COf,'port',rport_riv,rrport_riv)
          = 0.04;




*estimate transcapex cost if not input. use an average of other rail expansion costs
COtranscapex('rail',rco,rrco)$(COtranscapex('rail',rco,rrco)=0 and arc('rail',rco,rrco)) = 0.33;

* transportation build activities for rail requires building capacity to and from each node (see COtransbldeq constraint)
* devide capital costs by two
COtranscapex(tr,rco,rrco) = COtranscapex(tr,rco,rrco)/2;

* Approximate 100 Yuan per tonne for all port expansion costs. Compiled from data collected by Xiaofan
COtranscapex('port',rco,rco) = 100;



*Cotranscapmax('port','SDCB1') = 0;
*Cotranscapmax('port','SDCB1') = 15;
*Cotranscapmax('port','AHCB1') = 100;
*Cotranscapmax('port','AHCB2') = 50;






         COtransbudget('rail','t15') = 500e3;


**********Set leadtimes on new infrasturucture pojects
          COtransleadtime('rail',rco,rrco)$(arc('rail',rco,rrco) and COtransexist('rail',rco,rrco)=0 and card(thyb)>3)=3;
          COtransleadtime('rail',rco,rrco)$(arc('rail',rco,rrco) and card(thyb)>1)=1;
          COtransleadtime('port',rco,rrco)$(arc('port',rco,rrco) and card(thyb)>2) =2;
          COtransleadtime(tr,rco,rrco)$(card(thyb)<=COtransleadtime(tr,rco,rrco))=0;


*********variable fix and upper bounds
         COtransexistcp.fx(tr,trun,rco,rrco)$(ord(trun)=1 and arc(tr,rco,rrco))=COtransexist(tr,rco,rrco);

*         COtransmax.up(time,rco,rrco) = COtransalloc('rail',rco,rrco) ;


         parameter num_nodes_reg(r);
         set rtemp(rco);

         loop(r,
                 rtemp(rco)=no
         loop(rco$rco_dem(rco,r),

                 rtemp(rco) = yes;
         );

         num_nodes_reg(r) = card(rtemp);
         );

Equations
* ====================== Primal Relationships =================================*
         COtransobjective

         COtransPurchbal(trun) acumulates all purchases
         COtransCnstrctbal(trun) accumlates all construction activity
         COtransOpmaintbal(trun) accumulates operations and maintenance costs

         COtransbldeq(tr,trun,rco,rrco) equalize capacpity built between nodes

         COimportbal(trun) acumulates all import purchases
         COimportsuplim(COf,ssi,cv,sulf,trun)  capacity limit on coal import supply steps
         COimportlim(Cof,trun) limitation on coal imports


         COsup(COf,cv,sulf,ELs,trun,rco) measures fuel use
         COsuplim(COf,cv,sulf,ELs,trun,rco) supply limit on the amount of coal consumption outside provincial demand center
         COdem(f,cv,sulf,ELs,trun,rrco) regionalized fuel demand
         COdemOther(COf,trun,rrco)

         COtranscapbal(tr,trun,rco,rrco) coal transport balance
         COtransportcaplim(tr,ELs,trun,rco)  coal port transport balance
         COtranscaplim(tr,ELs,trun,rco,rrco) coal transport capcity constraint

         Cotransloadlim(COf,tr,trun,rco) limit on coal loading at each node

         COexportlim(trun,rco) constraint of coal exports

         COtransbudgetlim(tr,trun) investment budget for railway capacity expansion

*         COtransbldlim(tr,trun,rco)  limit on investment in new port infrastructure

*         COtranslim(trun,rco,rrco) capacity limit on coal rail transport


         COuselim(trun)

* ====================== Dual   Relationships =================================*



         DCOtransPurchase(trun) Equipment purchased costs in USD
         DCOtransConstruct(trun) Construction costs in USD
         DCOtransOpandmaint(trun) Operation and maintenance costs in USD

         DCOimports(trun) dual on Coal trade

         DCOtrans(COf,cv,sulf,tr,ELs,trun,rco,rrco) dual from COtrans
         DCOtransload(COf,tr,trun,rco)  dual from COtransload
         DCOtransexistcp(tr,trun,rco,rrco) dual from COtransexistcp
         DCOtransbld(tr,trun,rco,rrco) dual from COtransbld

         Dcoaluse(COf,cv,sulf,ELs,trun,rco) dual from coal use

         Dcoalimports(COf,ssi,cv,sulf,trun,rco)  dual from coalprod
         Dcoalexports(COf,cv,sulf,trun,rco)  dual from coalprod


         DOTHERCOconsumpsulf(COf,cv,sulf,time,rr) dual on endogenous other coal demand by sulfur content

*         DCOtransmax(trun,rco,rrco) dual for allocation of coal freight capacity
;

$offorder


COtransobjective.. z =e=
   sum(t,(COtranspurchase(t)+COtransConstruct(t)
         +COtransOpandmaint(t)+COimports(t))*COdiscfact(t));


COtranspurchbal(t).. sum((tr,rco,rrco)$arc(tr,rco,rrco),
         COtranspurcst(tr,t,rco,rrco)*COtransbld(tr,t,rco,rrco)*
                         (COtransD(tr,rco,rrco)$land(tr) + 1$port(tr)) )
           -COtranspurchase(t)=e=0;

COtranscnstrctbal(t).. sum((tr,rco,rrco)$arc(tr,rco,rrco),
         COtransconstcst(tr,t,rco,rrco)*COtransbld(tr,t,rco,rrco)*
                         (COtransD(tr,rco,rrco)$land(tr) + 1$port(tr)) )
          -COtransconstruct(t)=e=0;


COtransbldeq(tr,t,rco,rrco)$land(tr)..
   COtransbld(tr,t,rco,rrco)$arc(tr,rco,rrco)
  -COtransbld(tr,t,rrco,rco)$arc(tr,rrco,rco) =e= 0 ;


COtransOpmaintbal(t)..
   sum((COf,cv,sulf,tr,Els,rco,rrco)$(COfCV(COf,cv) and arc(tr,rco,rrco)),
*         and not rimp(rco) and not rexp(rrco)
******* No load/unloading fee for imported coal (price incl unloading fees)
******* No variablie tranport fees for import coal (price incl transport)
          COtransomcst2(COf,tr,rco,rrco)*COtransD(tr,rco,rrco)*COtrans(COf,cv,sulf,tr,ELs,t,rco,rrco)
         +COtransomcst1(COf,tr)*COtrans(COf,cv,sulf,tr,ELs,t,rco,rrco)$port(tr)
  )
  +sum((COf,tr,rco)$(land(tr)),
         COtransomcst1(COf,tr)*COtransload(COf,tr,t,rco))
         -COtransopandmaint(t) =e=0
;


COimportbal(t).. sum((COf,ssi,cv,sulf,rco)$(COfCV(COf,cv)
         and COintlprice(COf,ssi,cv,sulf,t,rco)>0 and COfimpss(COf,ssi,cv,sulf,t)>0),
         COintlprice(COf,ssi,cv,sulf,t,rco)*
         coalimports(COf,ssi,cv,sulf,t,rco))
           -COimports(t)=e=0;


COimportsuplim(COf,ssi,cv,sulf,t)$(COfcv(COf,cv) and COfimpss(COf,ssi,cv,sulf,t)>0)..
  -sum((rco)$(COintlprice(COf,ssi,cv,sulf,t,rco)>0),
         coalimports(COf,ssi,cv,sulf,t,rco))
         =g=-COfimpss(COf,ssi,cv,sulf,t);


COimportlim(COf,t)$(import_cap=1)..
  -sum((ssi,cv,sulf,rco)$(COintlprice(COf,ssi,cv,sulf,t,rco)>0
         and COfCV(COf,cv) and COfimpss(COf,ssi,cv,sulf,t)>0
         and (cv_met(cv) or COcvSCE(cv)*7000<10000) ),
         coalimports(COf,ssi,cv,sulf,t,rco))
         =g=-COfimpmax(COf,t);


*COtransbudgetlim(tr,t)$(trans_budg=1 and rail(tr))..
*  -sum((rco,rrco)$arc(tr,rco,rrco),COtranscapex(tr,rco,rrco)*
*         COtransbld(tr,t,rco,rrco)*COtransD(tr,rco,rrco))
*         =g= -COtransbudget(tr,t) ;

******* No load/unloading fee for imported coal (cost incl unloading )
Cotransloadlim(COf,tr,t,rco)$(land(tr))..
   COtransload(COf,tr,t,rco)
  -sum((ELs,cv,sulf,rrco)$(COfCV(COf,cv) and arc(tr,rco,rrco)),
         COtrans(COf,cv,sulf,tr,ELs,t,rco,rrco))
  +sum((ELs,cv,sulf,rrco)$(COfCV(COf,cv) and arc(tr,rrco,rco)),
         COtransyield(tr,rrco,rco)*
                 COtrans(COf,cv,sulf,tr,Els,t,rrco,rco))
            =g= 0 ;

COexportlim(t,rco)..
  -sum((COf,cv,sulf,tr)$(COfCV(COf,cv)) ,
                 coalexports(COf,cv,sulf,t,rco))
                 =g=-COfexpmax(t,rco);


COsup(COf,cv,sulf,Els,t,rco)$(COfCV(COf,cv))..
  coalprod(COf,cv,sulf,t,rco)$COcvrco(COf,cv,sulf,t,rco)
  +sum((ssi)$(COintlprice(COf,ssi,cv,sulf,t,rco)>0 and COfimpss(COf,ssi,cv,sulf,t)>0),
         coalimports(COf,ssi,cv,sulf,t,rco))
  +sum((tr,rrco)$arc(tr,rrco,rco),COtransyield(tr,rrco,rco)*
         COtrans(COf,cv,sulf,tr,ELs,t,rrco,rco))
  -sum((tr,rrco)$arc(tr,rco,rrco),
         COtrans(COf,cv,sulf,tr,ELs,t,rco,rrco))
  -coaluse(COf,cv,sulf,ELs,t,rco) =g=0
;

COsuplim(COf,cv,sulf,ELs,t,rco)$(not r(rco) and rcodem(rco) and
         COfcv(COf,cv))..
  -coaluse(COf,cv,sulf,ELs,t,rco)
  +sum(rr$(rco_dem(rco,rr)),
         ( OTHERCOconsumpsulf(COf,cv,sulf,t,rr)
           +sum((Elpcoal,v,sox,nox),
                 ELCOconsump(Elpcoal,v,cv,sulf,sox,nox,t,rr))$ELfcoal(COf)
         )*Elsnorm(ELs)/num_nodes_reg(rr))
         =g=0;


COdem(COf,cv,sulf,ELs,t,rr)$COfcv(COf,cv)..
   sum((rco)$rco_dem(rco,rr),coaluse(COf,cv,sulf,Els,t,rco))
  -OTHERCOconsumpsulf(COf,cv,sulf,t,rr)*Elsnorm(ELs)

  -sum((Elpcoal,v,sox,nox),
         ELCOconsump(Elpcoal,v,cv,sulf,sox,nox,t,rr))*Elsnorm(ELs)$ELfcoal(COf)

*         -WAfconsump(COf,t,rr)$WAf(COf)
*        -PCfconsump(COf,t,rr)*fPCconv(COf)$PCm(COf)
*         -RFcrconsump(COf,t,rr)*fRFconv(COf)$RFf(COf)
*         -CMfconsump(COf,t,rr)$CMf(COf)
*  and consumption from all other sectors
*         -fExports(COf,t,rr)*Elsnorm(ELs)

                  =g=  0;

*$offtext

COdemOther(COf,t,rr)..
   sum((sulf,cv)$(COfCV(COf,cv)),
         OTHERCOconsumpsulf(COf,cv,sulf,t,rr)*COcvSCE(cv))
                         =g= OTHERCOconsump(COf,t,rr)
;

COtranscapbal(tr,t,rco,rrco)$arc(tr,rco,rrco)..
                  COtransexistcp(tr,t,rco,rrco)
                 +COtransbld(tr,t-COtransleadtime(tr,rco,rrco),rco,rrco)
                 -COtransexistcp(tr,t+1,rco,rrco) =g=0
;

COtranscaplim(tr,ELs,t,rco,rrco)$(arc(tr,rco,rrco) and land(tr))..
   COtransexistcp(tr,t,rco,rrco)*Elsnorm(ELs)
  +COtransbld(tr,t-COtransleadtime(tr,rco,rrco),rco,rrco)*Elsnorm(ELs)
  -sum((COf,cv,sulf)$COfCV(COf,cv),
         COtrans(COf,cv,sulf,tr,ELs,t,rco,rrco))
=g=0;

$ontext
COtranslim(t,rco,rrco)$(rail_cap=1)..
         -sum((COf,cv,tr,sulf,ELs)$(COfCV(COf,cv) and arc(tr,rco,rrco) and rail(tr)),
                 COtrans(COf,cv,sulf,tr,ELs,t,rco,rrco) )
         + COtransmax(t,rco,rrco)  =g=  0 ;
$offtext

COtransportcaplim(tr,ELs,t,rco)$(rport(rco) and port(tr))..
sum(rrco$(arc(tr,rco,rrco) and ord(rco)=ord(rrco)),COtransexistcp(tr,t,rco,rrco)+
         COtransbld(tr,t-COtransleadtime(tr,rco,rrco),rco,rrco))*Elsnorm(ELs)
-sum((COf,cv,sulf,rrco)$(COfCV(COf,cv) and arc(tr,rco,rrco)),
         COtrans(COf,cv,sulf,tr,Els,t,rco,rrco))
-sum((COf,cv,sulf,rrco)$(COfCV(COf,cv) and arc(tr,rrco,rco)),
         COtrans(COf,cv,sulf,tr,ELs,t,rrco,rco)*COtransyield(tr,rrco,rco))
-sum((COf,ssi,cv,sulf)$(COintlprice(COf,ssi,cv,sulf,t,rco)>0 and COfimpss(COf,ssi,cv,sulf,t)>0),
         coalimports(COf,ssi,cv,sulf,t,rco)*Elsnorm(ELs))
                 =g=0;

$ontext
COtransbldlim(t,rco)$(Cotransportmax(rco)>0)..
         -sum((ELs,,tr)$(arc(tr,rco,rco) and port(tr)),
                  COtransexistcp(tr,t,rco,rco)*Elsnorm(ELs)
                 +COtransbld(tr,t-COtransleadtime(tr,rco,rco),rco,rco)*Elsnorm(ELs))
                 =g= -Cotransportmax(rco) ;
$offtext

*Dual Relationships
DCOtranspurchase(t).. COdiscfact(t)=g=-DCOtranspurchbal(t);
DCOtransconstruct(t).. COdiscfact(t)=g=-DCOtranscnstrctbal(t);
DCOtransopandmaint(t).. COdiscfact(t)=g=-DCOtransopmaintbal(t);
DCOimports(t).. COdiscfact(t)=g=-DCOimportbal(t);

Dcoalimports(COf,ssi,cv,sulf,t,rco)$(COfcv(COf,cv)
         and COintlprice(COf,ssi,cv,sulf,t,rco)>0
         and COfimpss(COf,ssi,cv,sulf,t)>0).. 0 =g=
   DCOimportbal(t)*COintlprice(COf,ssi,cv,sulf,t,rco)
  -DCOimportsuplim(COf,ssi,cv,sulf,t)
  -DCOimportlim(COf,t)$(import_cap=1
         and (cv_met(cv) or COcvSCE(cv)*7000<10000))
  +sum(ELs,DCOsup(COf,cv,sulf,ELs,t,rco))
  -sum((tr,ELs)$port(tr),
         DCOtransportcaplim(tr,ELs,t,rco)*Elsnorm(ELs))$rport(rco)
;


DOTHERCOconsumpsulf(COf,cv,sulf,t,rr)$COfCV(COf,cv).. 0 =g=
   sum((ELs,rco)$(rco_dem(rco,rr) and rcodem(rco) and not r(rco)),
         DCOsuplim(COf,cv,sulf,ELs,t,rco)*ELsnorm(ELs)/num_nodes_reg(rr))
  -sum(Els,DCOdem(COf,cv,sulf,ELs,t,rr)*ELsnorm(ELs))
  +DCOdemOther(COf,t,rr)*COcvSCE(cv)
  -(DEMsulflim(t,rr)*COsulfDW(sulf)*1.6)$(rdem_on(rr) and coal(COf))
;


* !!!!!! Fix copmlementarity relationship
Dcoaluse(COf,cv,sulf,Els,t,rco)$(COfcv(COf,cv)).. 0 =g=
  -DCOsup(COf,cv,sulf,ELs,t,rco)

  -DCOsuplim(COf,cv,sulf,ELs,t,rco)$(rcodem(rco) and not r(rco))
  +sum((rr)$(rco_dem(rco,rr)),
         DCOdem(COf,cv,sulf,ELs,t,rr))
;


DCotransexistcp(tr,t,rco,rrco)$arc(tr,rco,rrco).. 0=g=
  +DCOtranscapbal(tr,t,rco,rrco)
  -DCOtranscapbal(tr,t-1,rco,rrco)
  +sum(ELs,DCOtranscaplim(tr,ELs,t,rco,rrco)*
         Elsnorm(ELs))$(land(tr))
  +sum(ELs,DCOtransportcaplim(tr,ELs,t,rco)*
         Elsnorm(ELs))$(rport(rco) and port(tr) and ord(rco)=ord(rrco))
;

DCOtransbld(tr,t,rco,rrco)$arc(tr,rco,rrco).. 0=g=

   DCOtranspurchbal(t)*COtranspurcst(tr,t,rco,rrco)*
         (COtransD(tr,rco,rrco)$land(tr) + 1$port(tr))
  +DCOtranscnstrctbal(t)*COtransconstcst(tr,t,rco,rrco)*
         (COtransD(tr,rco,rrco)$land(tr) + 1$port(tr))
  +DCOtransbldeq(tr,t,rco,rrco)$(land(tr))
  -DCOtransbldeq(tr,t,rrco,rco)$(land(tr))
*  -DCOtransbudgetlim(tr,t)*COtranscapex(tr,rco,rrco)*COtransD(tr,rco,rrco)$(
*         trans_budg=1 and rail(tr))
  +DCOtranscapbal(tr,t+COtransleadtime(tr,rco,rrco),rco,rrco)
  +sum(ELs,DCOtranscaplim(tr,ELs,t+COtransleadtime(tr,rco,rrco),rco,rrco)*
         Elsnorm(ELs))$(land(tr))
  +sum(ELs,DCOtransportcaplim(tr,ELs,t+COtransleadtime(tr,rco,rco),rco)*
         Elsnorm(ELs))$(rport(rco) and port(tr) and ord(rco)=ord(rrco))
;

DCOtrans(COf,cv,sulf,tr,Els,t,rco,rrco)$(COfCV(COf,cv)and arc(tr,rco,rrco))
         .. 0 =g=
   DCOtransopmaintbal(t)*(COtransomcst2(COf,tr,rco,rrco)*COtransD(tr,rco,rrco))
*$(not rimp(rco) and not rexp(rrco))
  +DCOtransopmaintbal(t)*COtransomcst1(COf,tr)$(port(tr))
* and not rimp(rco) and not rexp(rrco)

  +DCOtransloadlim(COf,tr,t,rrco)*COtransyield(tr,rco,rrco)$land(tr)
  -DCOtransloadlim(COf,tr,t,rco)$land(tr)

*  -DCOexportlim(t,rco,rrco)

  +DCOsup(COf,cv,sulf,ELs,t,rrco)*COtransyield(tr,rco,rrco)
  -DCOsup(COf,cv,sulf,ELs,t,rco)

  -DCOtranscaplim(tr,ELs,t,rco,rrco)$land(tr)
  -(DCOtransportcaplim(tr,ELs,t,rco)
         +DCOtransportcaplim(tr,ELs,t,rrco)*COtransyield(tr,rco,rrco))$(
         rport(rco) and port(tr))
;

DCOtransload(COf,tr,t,rco)$land(tr).. 0 =g=
   DCOtransopmaintbal(t)*COtransomcst1(COf,tr)
  +DCOtransloadlim(COf,tr,t,rco)
;



$ontext
********************************************************************************
;

Scalar
count /0/;
Repeat(count=count+1; Solve FuelMCP using MCP; until((FuelMCP.modelstat eq 1)or(count eq 20)));
********************************************************************************
$offtext


$ontext
$INCLUDE powersubmodel.gms

$INCLUDE imports.gms
$INCLUDE scenarios.gms
$INCLUDE emissionsubmodel.gms

$INCLUDE discounting.gms

         COdiscfact(time)  = 1;


option MCP=path;
option LP=pathnlp;

option limrow=0;
option limcol=0;


option savepoint=1;


model coaltransMCP/


COpurchbal.DCOpurchbal,COcnstrctbal.DCOcnstrctbal,
COopmaintbal.DCOopmaintbal,COcapbal.DCOcapbal,COcaplim.DCOcaplim,
COsulflim.DCOsulflim,COprodfx.DCOprodfx,COprodCV.DCOprodCV,COprodlim.DCOprodlim,

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
*COtransbudgetlim.DCOtransbudgetlim,

         DCOtransPurchase.COtransPurchase,DCOtransConstruct.COtransConstruct,
         DCOtransOpandmaint.COtransOpandmaint,DCOimports.COimports,

         DCOtrans.COtrans,DCOtransload.COtransload,
         DCOtransexistcp.COtransexistcp,DCOtransbld.COtransbld,

         Dcoaluse.coaluse, Dcoalimports.coalimports,
*         Dcoalexports.coalexports

         DOTHERCOconsumpsulf.OTHERCOconsumpsulf,

*         EMsulflim.DEMsulflim,

/
;



model coaltransLP
/
***** Coaltrans equations
         COtransobjective,

         COtransPurchbal, COtransCnstrctbal,COtransOpmaintbal,
         COtransbldeq,COimportbal,
         COimportsuplim,COsup,COimportlim,COsuplim,
         COdem,COdemOther,

         COtranscapbal,COtransportcaplim,COtranscaplim,Cotransloadlim,
*         COexportlim,

*         EMsulflim

*         COexportlim
*        ,COtransbudgetlim
*         COashlim,COashlimreg,
/
;

t(trun)=yes;
z.l=0;
*Solve coaltransLP using LP minimizing z;


*execute_loadpoint "coaltransMCP_p.gdx";

Solve coaltransMCP using MCP;

scalar zMCP;

zMCP=0;


zMCP= sum(trun,(COtranspurchase.l(trun)+COtransConstruct.l(trun)
         +COtransOpandmaint.l(trun)+COimports.l(trun))*COdiscfact(trun))

display zMCP,z.l;

$offtext
