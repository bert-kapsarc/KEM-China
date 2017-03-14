parameter

          COomcst(COf,mm,ss,rw,time,rco) O&M costs

          COprodyield(COf,mm,ss,rw,time,rco) production yield for coal between 0 and 1

          COwashratio(COf,mm,ss,time,rco) max ratio of coal sent for washing (coal washing capacity constraint)

          coalcv(COf,mm,ss,rw,time,rco) calorific value of coal

          COsulfur(sulf,rco) sulfur content of all coal in each region in 4 rankings (extra low - low - medium - high)

          COprodData(COf,mm,ss,time,rco) China energy statistic coal production

;

$gdxin db\coalprod.gdx
$load COprodyield COwashratio COprodData coalcv COomcst COsulfur
$gdxin



parameter COpurcst(COf,mm,time,rco)   purchase cost of mining capacity
          COconstcst(COf,mm,ss,time,rco)   constr cost of mining capacity
          COdiscfact(time) discount factor for fuel sector
          COdiscoef(trun) capital discount coefficient ;

scalar    COdiscrate  fuel sector discounting rate /0.04/;
          COpurcst(COf,mm,time,rco) = 0;
          COconstcst(COf,mm,ss,time,rco) = 0;


parameter COleadtime(COf,mm,rco) lead time for building coal mine;
COleadtime(COf,mm,rco) = 0;
*COleadtime(COf,'under',rco) = 2;
*COleadtime(COf,'open',rco) = 1;


*        set raw coal yield to one for lignite and steam
*        metallurgical and hard coking coal are always washed
         COprodyield(coal,mm,ss,"raw",trun,rco)$(
                 smax(time,COprodData(coal,mm,ss,time,rco))>0) = 1;


         table COrwtable(rw,COf,COff) Map Other washed coal for met and hardcoke to thermal coal

                                 met       coal

         (raw,washed).met        1         0
         (raw,washed).coal       0         1

         other.coal              1         1

         ;

         table COsulfwash(rw,sulf,sulff)  tables reduce sulfur content of washed coals
                                 ExtLow Low    Med   High

         (washed,other).ExtLow   1      1      1       0
         (washed,other).Low      0      0      0       1
         (washed,other).Med      0      0      0       0
         (washed,other).High     0      0      0       0
;

         COsulfwash('raw',sulf,sulf)=1;

*        Sets used to eliminate unecessary variable indexes from the model
         set COmine(COf,mm,ss,rco) coal mine units used in the model equations
             COrw(COf,mm,ss,sulf,rw,rco) coal washing applied to coal mine units
             COsulf(sulf,rco) regions in the model requiring sulfur constraint
             COcvbins(COf,cv,sulf,mm,ss,rw,trun,rco) calorific values required for each mining region
             COcvrco(COf,cv,sulf,trun,rco)
;
         COmine(COf,mm,ss,rco)$(smax(trun,COprodData(COf,mm,ss,trun,rco))>0)=yes;

         loop((COf,mm,ss),
            COsulf(sulf,rco)$COmine(COf,mm,ss,rco)= yes;
         );


         COrw(COf,mm,ss,sulf,rw,rco)$(
                 smax(trun,COprodyield(COf,mm,ss,rw,trun,rco))>0)=yes;

         loop((sulff,COff),
            COcvbins(COf,cv,sulf,mm,ss,rw,trun,rco)$(
                 COrw(COf,mm,ss,sulf,rw,rco) and
                 COsulfwash(rw,sulff,sulf)=1 and
                 COrwtable(rw,COf,COff)=1 and
                 ((coalcv(COf,mm,ss,rw,trun,rco)<COboundCV(cv,'up') and
                   coalcv(COf,mm,ss,rw,trun,rco)>=COboundCV(cv,'lo')) or
                  (coalcv(COf,mm,ss,rw,trun,rco)=-1 and cv_met(cv))
                 ))= yes ;
         );

        loop((mm,ss,rw,sulff),
            COcvrco(COf,cv,sulf,trun,rco)$(
                 COcvbins(COf,cv,sulf,mm,ss,rw,trun,rco) and
                 COsulfwash(rw,sulf,sulff)=1)
                 =yes;
        );


set        rco_sup(rco,r) region where each coal supply basin is located
;
         rco_sup(rco,r)$rco_r_dem(rco,r) = yes;
*         rco_sup('NMCBHulun','Northeast')=yes;
*         rco_sup('NMCBXilin','Northeast')=yes;



Equations
* ====================== Primal Relationships =================================*
         COobjective Equation (2-1).(1) coal production and transportation cost objective function for coal production

         COpurchbal(trun) acumulates all purchases
         COcnstrctbal(trun) accumlates all construction activity
         COopmaintbal(trun) accumulates operations and maintenance costs

         COcapbal(COf,mm,ss,trun,rco) coal production balance for multi period simulation


         COcaplim(COf,mm,ss,trun,rco) Equation (2-1).(2) coal production capacity constraint.
*        The supply step setting the upper bound in this equation is disagregated
*        into what exists (COexistcp) and what is built CObld.
*        The equation COsupplylim sets the upper bound of each supply step.

         COsupplylim(COf,mm,ss,trun,rco) Limit on the amount of available coal supplies

         COsulflim(sulf,trun,rco) Eqn (2-1).(3) Constraint that sets the coal sulfur content in each region

         COwashcaplim(COf,mm,ss,trun,rco) Eqn (2-1).(4) Sets the upper bound on coal washing for each regional suplier and mining method

         COprodfx(COf,sulf,mm,ss,trun,rco) Eqn (2-1).(5) Limit the production of co-products (other washed coals) to that of washed coal

         COprodCV(COf,cv,sulf,trun,rco) Eqn (2-1).(6) equation to aggregate coal produciton units into CV bins




* ====================== Dual   Relationships =================================*

         DCOpurchase(trun) dual from purchase
         DCOconstruct(trun) dual from construct
         DCOopandmaint(trun) dual from opandmaint

         DCOprod(COf,sulf,mm,ss,rw,trun,rco) dual from COprod
         DCOexistcp(COf,mm,ss,trun,rco) dual from COexistcp
         DCObld(COf,mm,ss,trun,rco)  dual from CObld
         Dcoalprod(COf,cv,sulf,trun,rco) dual from coalprod
;

$offorder

COpurchbal(t).. sum((COf,mm,ss,rco)$COmine(COf,mm,ss,rco),COpurcst(COf,mm,t,rco)*CObld(COf,mm,ss,t,rco))
           -COpurchase(t)=e=0;

COcnstrctbal(t).. sum((COf,mm,ss,rco)$COmine(COf,mm,ss,rco),COconstcst(COf,mm,ss,t,rco)*CObld(COf,mm,ss,t,rco))
          -COconstruct(t)=e=0;

COopmaintbal(t)..
   sum((COf,sulf,mm,ss,rw,rco)$COrw(COf,mm,ss,sulf,rw,rco),
         COomcst(COf,mm,ss,rw,t,rco)*COprodyield(COf,mm,ss,rw,t,rco)
         *COprod(COf,sulf,mm,ss,rw,t,rco))
  -COopandmaint(t)=e=0;

COcapbal(COf,mm,ss,t,rco)$COmine(COf,mm,ss,rco).. COexistcp(COf,mm,ss,t,rco)+
         CObld(COf,mm,ss,t-COleadtime(COf,mm,rco),rco)
         -COexistcp(COf,mm,ss,t+1,rco)=g=0;

COcaplim(COf,mm,ss,t,rco)$(COmine(COf,mm,ss,rco))..
COexistcp(COf,mm,ss,t,rco)
+CObld(COf,mm,ss,t-COleadtime(COf,mm,rco),rco)
  -sum((sulf,rw)$(not rwother(rw) and COrw(COf,mm,ss,sulf,rw,rco) and COsulf(sulf,rco)),
                 COprod(COf,sulf,mm,ss,rw,t,rco)) =g= 0
;

COsupplylim(COf,mm,ss,t,rco)$(coal_cap=1 and COmine(COf,mm,ss,rco))..
-COexistcp(COf,mm,ss,t,rco)-CObld(COf,mm,ss,t-COleadtime(COf,mm,rco),rco)
                 =g= -COprodData(COf,mm,ss,t,rco)
;


COsulflim(sulf,t,rco)$COsulf(sulf,rco)  ..

  +COsulfur(sulf,rco)*sum((COf,mm,ss)$COmine(COf,mm,ss,rco),
          COexistcp(COf,mm,ss,t,rco)
         +CObld(COf,mm,ss,t-COleadtime(COf,mm,rco),rco))

  -sum((COf,mm,ss,rw)$(not rwother(rw) and COrw(COf,mm,ss,sulf,rw,rco)),
         COprod(COf,sulf,mm,ss,rw,t,rco))   =g= 0 ;


COwashcaplim(COf,mm,ss,t,rco)$(coal(COf) and COmine(COf,mm,ss,rco) and COwashratio(COf,mm,ss,'t11',rco)>0)..

  +COwashratio(COf,mm,ss,'t11',rco)*(COexistcp(COf,mm,ss,t,rco)
         +CObld(COf,mm,ss,t-COleadtime(COf,mm,rco),rco))
  -sum((sulf,rw)$(COrw(COf,mm,ss,sulf,rw,rco) and rwashed(rw)),
         COprod(COf,sulf,mm,ss,rw,t,rco))   =g= 0 ;

COprodfx(COf,sulf,mm,ss,t,rco)$(COmine(COf,mm,ss,rco))..
         +sum(rww$(rwashed(rww) and COrw(COf,mm,ss,sulf,rww,rco) and
                 COprodyield(COf,mm,ss,'washed',t,rco)>0),
                 COprod(COf,sulf,mm,ss,rww,t,rco))
         -sum(rww$(rwother(rww) and COrw(COf,mm,ss,sulf,rww,rco) and
                 COprodyield(COf,mm,ss,'other',t,rco)>0),
                 COprod(COf,sulf,mm,ss,rww,t,rco))   =g=0
;


COprodCV(COf,cv,sulf,t,rco)$COcvrco(COf,cv,sulf,t,rco)..
*and COsulf(sulf,rco)  and  COcvrco(COf,cv,sulf,t,rco)
   sum((COff,sulff,mm,ss,rw)$(COcvbins(COff,cv,sulff,mm,ss,rw,t,rco) ),

    COprod(COff,sulff,mm,ss,rw,t,rco)*COprodyield(COff,mm,ss,rw,t,rco)*
    COrwtable(rw,COf,COff)*COsulfwash(rw,sulf,sulff))

   -coalprod(COf,cv,sulf,t,rco)
                         =g=0
;



*================= dual relationships ==========================================

DCOpurchase(t).. 1*COdiscfact(t)=g=-DCOpurchbal(t);
DCOconstruct(t).. 1*COdiscfact(t)=g=-DCOcnstrctbal(t);
DCOopandmaint(t).. 1*COdiscfact(t)=g=-DCOopmaintbal(t);

Dcoalprod(COf,cv,sulf,t,rco)$(COcvrco(COf,cv,sulf,t,rco)).. 0=g=
   -DCOprodCV(COf,cv,sulf,t,rco)
   +DCOsup(COf,cv,sulf,t,rco)$COfCV(COf,cv);


DCOprod(COf,sulf,mm,ss,rw,t,rco)$COrw(COf,mm,ss,sulf,rw,rco)..   0 =g=
*$(COrw(COf,mm,ss,sulf,rw,rco) )
   COomcst(COf,mm,ss,rw,t,rco)*COprodyield(COf,mm,ss,rw,t,rco)*DCOopmaintbal(t)$COrw(COf,mm,ss,sulf,rw,rco)
   -DCOcaplim(COf,mm,ss,t,rco)$(not rwother(rw))
   -DCOsulflim(sulf,t,rco)$(not rwother(rw) and COsulf(sulf,rco))
   -DCOwashcaplim(COf,mm,ss,t,rco)$(coal(COf) and rwashed(rw) and COwashratio(COf,mm,ss,'t11',rco)>0)



   +DCOprodfx(COf,sulf,mm,ss,t,rco)$(rwashed(rw) and COmine(COf,mm,ss,rco) and COprodyield(COf,mm,ss,'washed',t,rco)>0)
   -DCOprodfx(COf,sulf,mm,ss,t,rco)$(rwother(rw) and COmine(COf,mm,ss,rco) and COprodyield(COf,mm,ss,'other',t,rco)>0)
   +sum((cv,COff,sulff)$COcvbins(COf,cv,sulf,mm,ss,rw,t,rco),
         COprodyield(COf,mm,ss,rw,t,rco)*COrwtable(rw,COff,COf)*
         COsulfwash(rw,sulff,sulf)*
         DCOprodCV(COff,cv,sulff,t,rco) )
;

DCOexistcp(COf,mm,ss,t,rco)$COmine(COf,mm,ss,rco).. 0 =g=
   DCOcaplim(COf,mm,ss,t,rco)
   +DCOcapbal(COf,mm,ss,t,rco)
   -DCOcapbal(COf,mm,ss,t-1,rco)
   +sum(sulf$COsulf(sulf,rco),COsulfur(sulf,rco)*DCOsulflim(sulf,t,rco))
   +(DCOwashcaplim(COf,mm,ss,t,rco)*
         COwashratio(COf,mm,ss,'t11',rco))$(coal(COf) and COwashratio(COf,mm,ss,'t11',rco)>0)

   -DCOprodlim(COf,mm,ss,t,rco)$(coal_cap=1)

;

DCObld(COf,mm,ss,t,rco)$COmine(COf,mm,ss,rco) .. 0 =g=
   COpurcst(COf,mm,t,rco)*DCOpurchbal(t)
   +COconstcst(COf,mm,ss,t,rco)*DCOcnstrctbal(t)
   +DCOcapbal(COf,mm,ss,t+COleadtime(COf,mm,rco),rco)
   +DCOcaplim(COf,mm,ss,t+COleadtime(COf,mm,rco),rco)
   +sum(sulf$COsulf(sulf,rco),COsulfur(sulf,rco)*DCOsulflim(sulf,t+COleadtime(COf,mm,rco),rco))
   +(DCOwashcaplim(COf,mm,ss,t+COleadtime(COf,mm,rco),rco)*
         COwashratio(COf,mm,ss,'t11',rco))$(coal(COf) and COwashratio(COf,mm,ss,'t11',rco)>0)
   -DCOprodlim(COf,mm,ss,t+COleadtime(COf,mm,rco),rco)$(coal_cap=1)
;
