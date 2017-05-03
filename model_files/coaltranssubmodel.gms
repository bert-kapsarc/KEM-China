parameter
COfexpmax(time,rco) fixed coal export quantity by port of departure
COtransD(tr,rco,rrco) transportation distances
COtranscapex(tr,rco,rrco) purchase cost of transmission capacity Yuan per tonne km
COtranspurcst(tr,time,rco,rrco) purchase cost of transportation capacity RMB per tone-km (rail) per tone (port)
COtransconstcst(tr,time,rco,rrco) construction cost of transportation capacity RMB per tone-km (rail) per tone (port)
COtransbudget(tr,time) budget constraint for investment of tranportation infrastrcuture in million RMB
COtransexist(tr,rco,rrco)  existing coal transportation capacity
COtransleadtime(tr,rco,rrco) lead time for building fuel transport
COtransyield(tr,rco,rrco) net of self-consumption and distribution losses
OTHERCOconsump(sect,COf,rr) exogenous coal demand
OTHERCOconsumptrend(sect,COf,time,rr)  exogenous coal demand trend
COintlprice(COf,ssi,cv,sulf,time,rco) market price for fuels for aggreaget CV bin

COfimpmax(COf,time,rco) maximum coal supply for each type of coal by region
COfimpmax_nat(COf,time) maximum coal supply for each type of coal nationally
COfimpss(COf,ssi,cv,sulf,time) available coal in import supply step ssi

COtransomcst_var(COf,tr) Variable O&M cost per ton -km
COtransomcst_fixed(COf,tr) Fixed transport operation cost per ton

COtransomcst2(COf,tr,time) Variable O&M cost per ton -km
COtransomcst1(COf,tr,time) Fixed transport operation cost per ton
RailSurcharge rail tax collected for electricification and construction

COsubprice(time,rr) price of substituting coal consumption

;
$gdxin db\coaltrans.gdx
$load COtransD COtransexist COtranscapex COtransomcst_var COtransomcst_fixed RailSurcharge OTHERCOconsump COfexpmax
$gdxin


         OTHERCOconsumptrend(sect,COf,time,rr) = 1;


         COtransomcst2(COf,tr,time) = COtransomcst_var(COf,tr);
         COtransomcst1(COf,tr,time) = COtransomcst_fixed(COf,tr);
         COtransomcst2(coal_i,tr,time) = COtransomcst_var("coal",tr);
         COtransomcst1(coal_i,tr,time) = COtransomcst_fixed("coal",tr);

* replicate distance between nodes
COtransD(tr,rrco,rco)$(COtransD(tr,rco,rrco)>=COtransD(tr,rrco,rco)) =
                                         COtransD(tr,rco,rrco);

* Set trucking distances equal to rail distances a
COtransD('truck',rco,rrco)$(COtransD('truck',rco,rrco)=0) =
                                         COtransD('rail',rco,rrco);


*!!!!!!!!!!Port yields

* Create connection between all river and sea ports with positive distance
* river ports connect to accesible sea ports on river mouth.
COtransyield(port,rport,rrport)$(COtransD(port,rport,rrport)>0) = 1;
COtransyield(port,rport,rrport)$(COtransD(port,rport,rrport)<=0) = 0;


* COtransyield is set to 1 for port self connection
* This is used in the capacity limit equation for incoming outgoing shipments
* Sea and river ports are given limits on the port not the pathways.
COtransyield(port,rport,rport)=1;

*!!!!!!!!!!Set transyield on land transport
COtransyield('rail',rco,rrco)$(COtransD('rail',rco,rrco)>0)=1;
COtransyield('rail',rimp,rrco)$(COtransexist('rail',rimp,rrco)>0)=1;

COtransyield(land,rco,rco)=0;

* create truck conections where rail connections exist.
* As an assumption for truck routes when rail is bottlenecked
COtransyield('truck',rco,rrco)$(COtransyield('rail',rco,rrco)>0)=1;

* Allow shipment in both directions along any transportation arc
COtransyield(land,rrco,rco)$(COtransyield(land,rco,rrco)>0) =
                 COtransyield(land,rco,rrco);


*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

*        declare and define arc

         set arc(tr,rco,rrco) set to identify existing transport connections for all modes
;
            arc(tr,rco,rrco)$(COtransyield(tr,rco,rrco)>0) = yes;
            arc('truck',rrco,rrco) = no;

*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

**********Set leadtimes on new infrasturucture pojects
          COtransleadtime('rail',rco,rrco)$(arc('rail',rco,rrco) and COtransexist('rail',rco,rrco)=0 and card(thyb)>3)=3;
          COtransleadtime('rail',rco,rrco)$(arc('rail',rco,rrco) and card(thyb)>1) =1;
          COtransleadtime('port',rco,rrco)$(arc('port',rco,rrco) and card(thyb)>2) =2;
          COtransleadtime(tr,rco,rrco)$(card(thyb)<=COtransleadtime(tr,rco,rrco))=0;


*estimate transcapex cost if not input. use an average of other rail expansion costs
COtranscapex('rail',rco,rrco)$(COtranscapex('rail',rco,rrco)=0 and arc('rail',rco,rrco)) = 0.33;

* transportation build activities for rail requires building capacity to and from each node (see COtransbldeq constraint)
* devide capital costs by two
COtranscapex(tr,rco,rrco) = COtranscapex(tr,rco,rrco)/2;

* Approximate 100 Yuan per tonne for all port expansion costs.
COtranscapex('port',rco,rco) = 100;

COtransbudget('rail','t15') = 500e3;


*********variable fix and upper bounds
         COtransexistcp.fx(tr,trun,rco,rrco)$(ord(trun)=1 and arc(tr,rco,rrco))=COtransexist(tr,rco,rrco);

*         COtransmax.up(time,rco,rrco) = COtransalloc('rail',rco,rrco) ;



         parameter num_nodes_reg(r);
         set rtemp(rco);

         loop(r,
                 rtemp(rco)=no
         loop(rco$rco_r_dem(rco,r),

                 rtemp(rco) = yes;
         );

         num_nodes_reg(r) = card(rtemp);
         );

         parameter rail_disc discount on rail investments from rail tax CFS;


Equations
* ====================== Primal Relationships =================================*
         COobjective  Equation (2-1).(1)
         COobjective_CFS Equation (2-1).(1) with construction fund surcharge cost

         COtransPurchbal(trun) acumulates all purchases
         COtransCnstrctbal(trun) accumlates all construction activity
         COtransOpmaintbal(trun) accumulates operations and maintenance costs

         COtransbldeq(tr,trun,rco,rrco) equalize capacpity built between nodes

         COimportbal(trun) acumulates all import purchases
         COimportsuplim(COf,ssi,cv,sulf,trun)  capacity limit on coal import supply steps
         COimportlim(Cof,trun,rco) cap on coal imports by region
         COimportlim_nat(COf,trun) cap on national imports by type


         COsup(COf,cv,sulf,trun,rco) measures fuel use
         COsuplim(COf,cv,sulf,trun,rco) supply limit on the amount of coal consumption outside provincial demand center
         COdem(f,cv,sulf,trun,rrco) regionalized fuel demand
         COdemOther(COf,trun,rrco)

         COtranscapbal(tr,trun,rco,rrco) coal transport balance
         COtransportcaplim(tr,trun,rco)  coal port transport balance
         COtranscaplim(tr,trun,rco,rrco) coal transport capcity constraint

         Cotransloadlim(COf,tr,trun,rco) limit on coal loading at each node

         COexportlim(trun,rco) constraint for coal exports

*         COtransbudgetlim(tr,trun) investment budget for railway capacity expansion

*         COtransbldlim(tr,trun,rco)  limit on investment in new port infrastructure

*         COtranslim(trun,rco,rrco) capacity limit on coal rail transport

         COprice_eqn(COf,cv,sulf,trun,r) Auxiliary equation for the marginal cost of coal in region r

* ====================== Dual   Relationships =================================*



         DCOtransPurchase(trun) Equipment purchased costs in USD
         DCOtransConstruct(trun) Construction costs in USD
         DCOtransOpandmaint(trun) Operation and maintenance costs in USD

         DCOimports(trun) dual on Coal trade

         DCOtrans(COf,cv,sulf,tr,trun,rco,rrco) dual from COtrans
         DCOtransload(COf,tr,trun,rco)  dual from COtransload
         DCOtransexistcp(tr,trun,rco,rrco) dual from COtransexistcp
         DCOtransbld(tr,trun,rco,rrco) dual from COtransbld

         Dcoaluse(COf,cv,sulf,trun,rco) dual from coal use

         Dcoalimports(COf,ssi,cv,sulf,trun,rco)  dual from coalimports
         Dcoalexports(COf,cv,sulf,trun,rco)  dual from coalprod


         DOTHERCOconsumpsulf(COf,cv,sulf,time,rr) dual on endogenous other coal demand by sulfur content

*         DCOtransmax(trun,rco,rrco) dual for allocation of coal freight capacity
;

$offorder
*$ontext
COobjective.. COobjvalue =e=
    sum(t,(COpurchase(t)+COConstruct(t)+COOpandmaint(t))*COdiscfact(t))
   +sum(t,(COtranspurchase(t)+COtransConstruct(t)
         +COtransOpandmaint(t)+COimports(t))*COdiscfact(t))
   +sum((t,rr),COsubconsump(t,rr)*COsubprice(t,rr));
$ontext
*        intersectoral revenues
   -sum((ELpcoal,v,gtyp,COf,cv,sulf,sox,nox,ELf,t,r)$(ELfCV(COf,cv,sulf) and ELpfgc(Elpcoal,cv,sulf,sox,nox)),
          COprice.l(COf,cv,sulf,t,r)*
          ELCOconsump.l(ELpcoal,v,gtyp,cv,sulf,sox,nox,t,r))$(
$offtext
         ;

COobjective_CFS.. COobjvalue_CFS =e= COobjvalue
 +( sum((COf,cv,sulf,tr,rco,rrco,t)$(
         COfCV(COf,cv) and arc(tr,rco,rrco) and rail(tr)),
         RailSurcharge(t)*COtransD(tr,rco,rrco)*
         COtrans(COf,cv,sulf,tr,t,rco,rrco) )
   -sum((tr,rco,rrco,t)$(arc(tr,rco,rrco) and not truck(tr)),
         rail_disc(tr,t,rco,rrco)*COtransbld(tr,t,rco,rrco)*
         (COtransD(tr,rco,rrco)$land(tr) + 1$port(tr)) )
   )$(COrailCFS=1)
;

COtranspurchbal(t).. sum((tr,rco,rrco)$(arc(tr,rco,rrco) and not truck(tr)),
         COtranspurcst(tr,t,rco,rrco)*COtransbld(tr,t,rco,rrco)*
                         (COtransD(tr,rco,rrco)$land(tr) + 1$port(tr)) )
           -COtranspurchase(t)=e=0;

COtranscnstrctbal(t)..
  +sum((tr,rco,rrco)$(arc(tr,rco,rrco) and not truck(tr)),
         COtransconstcst(tr,t,rco,rrco)*COtransbld(tr,t,rco,rrco)*
         (COtransD(tr,rco,rrco)$land(tr) + 1$port(tr))
   )

  -COtransconstruct(t)=e=0;


COtransbldeq(tr,t,rco,rrco)$(land(tr) and not truck(tr))..
   COtransbld(tr,t,rco,rrco)$arc(tr,rco,rrco)
  -COtransbld(tr,t,rrco,rco)$arc(tr,rrco,rco) =g= 0 ;


COtransOpmaintbal(t)..
   sum((COf,cv,sulf,tr,rco,rrco)$(COfCV(COf,cv) and arc(tr,rco,rrco)),
*         and not rimp(rco) and not rexp(rrco)
******* No load/unloading fee for imported coal (price incl unloading fees)
******* No variablie tranport fees for import coal (price incl transport)
         (
                   COtransomcst2(COf,tr,t)*COtransD(tr,rco,rrco)
                  +COtransomcst1(COf,tr,t)$port(tr)
         )*COtrans(COf,cv,sulf,tr,t,rco,rrco)
  )
  +sum((COf,tr,rco)$(land(tr)),
         COtransomcst1(COf,tr,t)*COtransload(COf,tr,t,rco))
         -COtransopandmaint(t) =e=0
;


COimportbal(t).. sum((COf,ssi,cv,sulf,rco)$(COfCV(COf,cv) and rimp(rco)
         and COintlprice(COf,ssi,cv,sulf,t,rco)>0 and COfimpss(COf,ssi,cv,sulf,t)>0),
         COintlprice(COf,ssi,cv,sulf,t,rco)*
         coalimports(COf,ssi,cv,sulf,t,rco))
           -COimports(t)=e=0;


COimportsuplim(COf,ssi,cv,sulf,t)$(COfcv(COf,cv) and COfimpss(COf,ssi,cv,sulf,t)>0)..
  -sum((rco)$(COintlprice(COf,ssi,cv,sulf,t,rco)>0),
         coalimports(COf,ssi,cv,sulf,t,rco))
         =g=-COfimpss(COf,ssi,cv,sulf,t);


COimportlim(COf,t,rimp)$(import_cap=1)..
  -sum((ssi,cv,sulf)$(COintlprice(COf,ssi,cv,sulf,t,rimp)>0
         and COfCV(COf,cv) and COfimpss(COf,ssi,cv,sulf,t)>0
         and COfimpmax(COf,t,rimp)>0 ),
         coalimports(COf,ssi,cv,sulf,t,rimp))
         =g=-COfimpmax(COf,t,rimp);

COimportlim_nat(COf,t)$(import_cap=1)..
  -sum((ssi,cv,sulf,rimp)$(COintlprice(COf,ssi,cv,sulf,t,rimp)>0
         and COfCV(COf,cv) and COfimpss(COf,ssi,cv,sulf,t)>0),
         coalimports(COf,ssi,cv,sulf,t,rimp))
         =g=-COfimpmax_nat(COf,t);

*COtransbudgetlim(tr,t)$(trans_budg=1 and rail(tr))..
*  -sum((rco,rrco)$arc(tr,rco,rrco),COtranscapex(tr,rco,rrco)*
*         COtransbld(tr,t,rco,rrco)*COtransD(tr,rco,rrco))
*         =g= -COtransbudget(tr,t) ;

******* No load/unloading fee for imported coal (cost incl unloading )
Cotransloadlim(COf,tr,t,rco)$(land(tr))..
   COtransload(COf,tr,t,rco)
  -sum((cv,sulf,rrco)$(COfCV(COf,cv) and arc(tr,rco,rrco)),
         COtrans(COf,cv,sulf,tr,t,rco,rrco))
  +sum((cv,sulf,rrco)$(COfCV(COf,cv) and arc(tr,rrco,rco)),
         COtransyield(tr,rrco,rco)*
                 COtrans(COf,cv,sulf,tr,t,rrco,rco))
            =g= 0 ;

COexportlim(t,rco)..
  -sum((COf,cv,sulf,tr)$(COfCV(COf,cv)) ,
                 coalexports(COf,cv,sulf,t,rco))
                 =g=-COfexpmax(t,rco);


COsup(COf,cv,sulf,t,rco)$(COfCV(COf,cv))..
  sum(COff$(COmet2thermal(COff,COf) and COcvrco(COff,cv,sulf,t,rco)),
         coalprod(COff,COf,cv,sulf,t,rco))
  +sum((ssi)$(COintlprice(COf,ssi,cv,sulf,t,rco)>0 and COfimpss(COf,ssi,cv,sulf,t)>0),
         coalimports(COf,ssi,cv,sulf,t,rco))
  +sum((tr,rrco)$arc(tr,rrco,rco),COtransyield(tr,rrco,rco)*
         COtrans(COf,cv,sulf,tr,t,rrco,rco))
  -sum((tr,rrco)$arc(tr,rco,rrco),
         COtrans(COf,cv,sulf,tr,t,rco,rrco))
  -coaluse(COf,cv,sulf,t,rco) =g=0
;

COsuplim(COf,cv,sulf,t,rco)$(not r(rco) and rcodem(rco) and
         COfcv(COf,cv))..
  -coaluse(COf,cv,sulf,t,rco)
  +sum(rr$(rco_r_dem(rco,rr)),
         ( OTHERCOconsumpsulf(COf,cv,sulf,t,rr)
           +sum((Elpcoal,v,gtyp,sox,nox)$(ELpfgc(ELpcoal,cv,sulf,sox,nox) and ELfcoal(COf)),
                 ELCOconsump(Elpcoal,v,gtyp,cv,sulf,sox,nox,t,rr))$(ELfcoal(COf) and run_model('power'))
         )/num_nodes_reg(rr))
         =g=0;


COdem(COf,cv,sulf,t,rr)$COfcv(COf,cv)..
   sum((rco)$rco_r_dem(rco,rr),coaluse(COf,cv,sulf,t,rco))
  -OTHERCOconsumpsulf(COf,cv,sulf,t,rr)

  -sum((Elpcoal,v,gtyp,sox,nox)$(ELpfgc(ELpcoal,cv,sulf,sox,nox) and ELfcoal(COf)),
         ELCOconsump(Elpcoal,v,gtyp,cv,sulf,sox,nox,t,rr))$run_model('Power')

*         -WAfconsump(COf,t,rr)$WAf(COf)
*        -PCfconsump(COf,t,rr)*fPCconv(COf)$PCm(COf)
*         -RFcrconsump(COf,t,rr)*fRFconv(COf)$RFf(COf)
*         -CMfconsump(COf,t,rr)$CMf(COf)
*  and consumption from all other sectors
*         -fExports(COf,t,rr)

                  =g=  0;

*$offtext

COdemOther(COf,t,rr)..
   sum((sulf,cv)$(COfCV(COf,cv)),OTHERCOconsumpsulf(COf,cv,sulf,t,rr)*
         (1$met(COf)+COcvSCE(cv)$coal(COf)) )
+   sum((sulf,cv)$(COfCV('coal_i',cv) and coal(COf)),
         OTHERCOconsumpsulf('coal_i',cv,sulf,t,rr)*COcvSCE(cv))

+COsubconsump(t,rr)$coal(COf)
                         =g=
   OTHERCOconsump('OT',COf,rr)*OTHERCOconsumptrend('OT',COf,t,rr)

  +( OTHERCOconsump('EL',COf,rr)*OTHERCOconsumptrend('EL',COf,t,rr)$run_with_inputs('predefined')
    +sum((Elpcoal,v,gtyp,cv,sulf,sox,nox)$(ELpfgc(ELpcoal,cv,sulf,sox,nox) and ELfcoal('coal')),
         ELCOconsump.l(Elpcoal,v,gtyp,cv,sulf,sox,nox,t,rr))$run_with_inputs('savepoint')
    )$(not run_model('Power'))

*  -200*(sum(sect,OTHERCOconsump(sect,COf,rr))/sum((sect,r_industry),OTHERCOconsump(sect,COf,r_industry)))$r_industry(rr)
*  +200*(sum(sect,OTHERCOconsump(sect,COf,rr))/sum((sect,r)$(not r_industry(r)),OTHERCOconsump(sect,COf,r)))$(not r_industry(rr))
*        When not solving power sector include savepoint as input
;

COtranscapbal(tr,t,rco,rrco)$(arc(tr,rco,rrco) and not truck(tr))..
                  COtransexistcp(tr,t,rco,rrco)
                 +COtransbld(tr,t-COtransleadtime(tr,rco,rrco),rco,rrco)
                 -COtransexistcp(tr,t+1,rco,rrco) =g=0
;

COtranscaplim(tr,t,rco,rrco)$(arc(tr,rco,rrco) and land(tr) and not truck(tr))..
   COtransexistcp(tr,t,rco,rrco)
  +COtransbld(tr,t-COtransleadtime(tr,rco,rrco),rco,rrco)
  -sum((COf,cv,sulf)$COfCV(COf,cv),
         COtrans(COf,cv,sulf,tr,t,rco,rrco))
=g=0;

$ontext
COtranslim(t,rco,rrco)$(rail_cap=1)..
         -sum((COf,cv,tr,sulf)$(COfCV(COf,cv) and arc(tr,rco,rrco) and rail(tr)),
                 COtrans(COf,cv,sulf,tr,t,rco,rrco) )
         + COtransmax(t,rco,rrco)  =g=  0 ;
$offtext

COtransportcaplim(tr,t,rco)$(rport(rco) and port(tr))..
sum(rrco$(arc(tr,rco,rrco) and ord(rco)=ord(rrco)),COtransexistcp(tr,t,rco,rrco)+
         COtransbld(tr,t-COtransleadtime(tr,rco,rrco),rco,rrco))
-sum((COf,cv,sulf,rrco)$(COfCV(COf,cv) and arc(tr,rco,rrco)),
         COtrans(COf,cv,sulf,tr,t,rco,rrco))
-sum((COf,cv,sulf,rrco)$(COfCV(COf,cv) and arc(tr,rrco,rco)),
         COtrans(COf,cv,sulf,tr,t,rrco,rco)*COtransyield(tr,rrco,rco))
-sum((COf,ssi,cv,sulf)$(COintlprice(COf,ssi,cv,sulf,t,rco)>0 and COfimpss(COf,ssi,cv,sulf,t)>0),
         coalimports(COf,ssi,cv,sulf,t,rco))
                 =g=0;

$ontext
COtransbldlim(t,rco)$(Cotransportmax(rco)>0)..
         -sum((,tr)$(arc(tr,rco,rco) and port(tr)),
                  COtransexistcp(tr,t,rco,rco)
                 +COtransbld(tr,t-COtransleadtime(tr,rco,rco),rco,rco))
                 =g= -Cotransportmax(rco) ;
$offtext


COprice_eqn(COf,cv,sulf,t,r)$COfcv(COf,cv).. COprice(COf,cv,sulf,t,r) -
   ( DCOdem(COf,cv,sulf,t,r)
     -sum(rco$(rco_r_dem(rco,r) and not r(rco)),
       DCOsuplim(COf,cv,sulf,t,rco)/num_nodes_reg(r))
   ) =l=0;

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
  -DCOimportlim(COf,t,rco)$(import_cap=1 and rimp(rco) and COfimpmax(COf,t,rco)>0)
  +DCOsup(COf,cv,sulf,t,rco)
  -sum((tr)$port(tr),
         DCOtransportcaplim(tr,t,rco))$rport(rco)
;


DOTHERCOconsumpsulf(COf,cv,sulf,t,rr)$COfcv(COf,cv) .. 0 =g=
   -( DCOdem(COf,cv,sulf,t,rr)
     -sum(rco$(rco_r_dem(rco,rr) and not r(rco)),
       DCOsuplim(COf,cv,sulf,t,rco)/num_nodes_reg(rr))
   )
  +DCOdemOther(COf,t,rr)*COcvSCE(cv)
  -(DEMsulflim(t,rr)*COsulfDW(sulf)*1.6)$(rdem_on(rr) and coal(COf))
;


Dcoaluse(COf,cv,sulf,t,rco)$COfcv(COf,cv).. 0 =g=
  -DCOsup(COf,cv,sulf,t,rco)
  -DCOsuplim(COf,cv,sulf,t,rco)$(rcodem(rco) and not r(rco))

  +sum((rr)$(rco_r_dem(rco,rr)),
         DCOdem(COf,cv,sulf,t,rr))
;


DCOtransexistcp(tr,t,rco,rrco)$(arc(tr,rco,rrco) and not truck(tr))..


   0=g=
  +DCOtranscapbal(tr,t,rco,rrco)
  -DCOtranscapbal(tr,t-1,rco,rrco)
  +DCOtranscaplim(tr,t,rco,rrco)$(land(tr))
  +DCOtransportcaplim(tr,t,rco)$(rport(rco) and port(tr) and ord(rco)=ord(rrco))
;

DCOtransbld(tr,t,rco,rrco)$(arc(tr,rco,rrco) and not truck(tr)).. 0=g=

   DCOtranspurchbal(t)*COtranspurcst(tr,t,rco,rrco)*
         (COtransD(tr,rco,rrco)$land(tr) + 1$port(tr))
  +DCOtranscnstrctbal(t)*( COtransconstcst(tr,t,rco,rrco)
                          -rail_disc(tr,t,rco,rrco)$(COrailCFS=1 and rail(tr))
                         )*(COtransD(tr,rco,rrco)$land(tr) + 1$port(tr))
  +DCOtransbldeq(tr,t,rco,rrco)$(land(tr))
  -DCOtransbldeq(tr,t,rrco,rco)$(land(tr))

*  -DCOtransbudgetlim(tr,t)*COtranscapex(tr,rco,rrco)*COtransD(tr,rco,rrco)$(
*         trans_budg=1 and rail(tr))
  +DCOtranscapbal(tr,t+COtransleadtime(tr,rco,rrco),rco,rrco)
  +DCOtranscaplim(tr,t+COtransleadtime(tr,rco,rrco),rco,rrco)$land(tr)
  +DCOtransportcaplim(tr,t+COtransleadtime(tr,rco,rco),rco)$(rport(rco) and port(tr) and ord(rco)=ord(rrco))
;


DCOtrans(COf,cv,sulf,tr,t,rco,rrco)$(COfCV(COf,cv)and arc(tr,rco,rrco))..

  +(RailSurcharge(t)*COtransD(tr,rco,rrco))$(COrailCFS=1 and rail(tr)) =g=

  +DCOtransopmaintbal(t)*(COtransomcst2(COf,tr,t)*COtransD(tr,rco,rrco))
  +DCOtransopmaintbal(t)*COtransomcst1(COf,tr,t)$(port(tr))

  +DCOtransloadlim(COf,tr,t,rrco)*COtransyield(tr,rco,rrco)$land(tr)
  -DCOtransloadlim(COf,tr,t,rco)$land(tr)

  +DCOsup(COf,cv,sulf,t,rrco)*COtransyield(tr,rco,rrco)
  -DCOsup(COf,cv,sulf,t,rco)


  -DCOtranscaplim(tr,t,rco,rrco)$(land(tr) and not truck(tr))

  -(DCOtransportcaplim(tr,t,rco)
         +DCOtransportcaplim(tr,t,rrco)*COtransyield(tr,rco,rrco))$(
         rport(rco) and port(tr))
;

DCOtransload(COf,tr,t,rco)$land(tr).. 0 =g=
   DCOtransopmaintbal(t)*COtransomcst1(COf,tr,t)
  +DCOtransloadlim(COf,tr,t,rco)


*  -DCOexportlim(t,rco,rrco)
;
