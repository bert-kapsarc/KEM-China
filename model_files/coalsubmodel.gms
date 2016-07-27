$ontext
$INCLUDE Macros.gms
$INCLUDE SetsandVariables.gms
$INCLUDE ScalarsandParameters.gms
$INCLUDE RW_param.gms

$gdxin calibration\ChinaPower.gdx
$load coalprod
$gdxin

coalprod.fx(COf,cv,sulf,trun,rco) =coalprod.l(COf,cv,sulf,trun,rco);
DCOsup.fx(COf,cv,sulf,ELs,trun,rco)=0;
$offtext

parameter COexist(COf,mm,ss,rco) existing coal supply in each region

parameter COprodIHS(COf,mm,ss,time,rco) IHS coal production levels and forecasts
          COprodStats(COf,mm,ss,time,rco) China energy statistic coal production

          COomcst(COf,mm,ss,rw,time,rco) O&M cost in Yuan

          COprodyield(COf,mm,ss,rw,time,rco) production yield for coal

          COwashratio(COf,mm,ss,time,rco) production yield for coal
*         COexpansion(COf,mm,ss,rco) IHS coal production levels and forecasts

          coalcv(COf,mm,ss,rw,time,rco) calorific value of coal

          COsulfur(sulf,time,rco) sulfur content of all coal produced in each region
          COsulfur2(sulf,time,rco) sulfur content of all coal produced in each region

          COstatistics(COstats,time,rAll)

;

$gdxin db\coalprod.gdx
$load COprodyield COwashratio CoprodIHS coalcv COomcst COsulfur COstatistics
*COexpansion coalintlcv
$gdxin


COsulfur(sulf,time,rco) = COsulfur(sulf,'t11',rco);



*        SPLIT INNER MONGOLIA AND EASTERN INNER MONGOLIA
COstatistics(COstats,time,'NME')=COstatistics(COstats,time,'NM')*0.3;
COstatistics(COstats,time,'NM')=COstatistics(COstats,time,'NM')
                                 -COstatistics(COstats,time,'NME');

COstatistics(COstats,trun,r) = sum((GB)$regions(r,GB),
                                 COstatistics(COstats,trun,GB));

COstatistics(COstats,trun,"China") = sum(r,COstatistics(COstats,trun,r) )

parameter COash(ash) coal ash content
         /noash    0  /
$ontext
         ash5     0.05
         ash15    0.15
         ash25    0.25
         ash35    0.35
         ash45    0.45
         /
$offtext
          COashDist(ash) distribution of coal ash content nationally  /
*        source Coal Initiative Reports White Paper Series Guadong Sun, Kennedy School of Government Harvard University
         noash    1  /
$ontext
         ash5     0.092
         ash15    0.398
         ash25    0.336
         ash35    0.137
         ash45    0.037
         /
$offtext

         COashReg(rco) regional average raw coal percentage ash content
;
         COashReg(rco) = 0.3;


$gdxin db\coalprod.gdx
*$load COashReg
$gdxin





parameter COpurcst(COf,mm,time,rco)   purchase cost of mining capacity
          COconstcst(COf,mm,ss,time,rco)   constr cost of mining capacity
          COdiscfact(time) discount factor for fuel sector
          COdiscoef(trun) capital discount coefficient ;

scalar    COdiscrate  fuel sector discounting rate /0.04/;

                         COpurcst(COf,mm,time,rco) = 100;
                         COconstcst(COf,mm,ss,time,rco) = 0;


parameter COleadtime(COf,mm,rco) lead time for building coal mine;
COleadtime(COf,mm,rco) = 0;

*COleadtime(COf,'under',rco) = 2;
*COleadtime(COf,'open',rco) = 1;

* interpolate characteristics of chinese coal mines from IHS Coal Rush study, projected every 5 years from 2015
loop(time,
if(ord(time)<5 and ord(time)>1,
         CoprodIHS(COf,mm,ss,time,rco) = CoprodIHS(COf,mm,ss,"t11",rco)+(CoprodIHS(COf,mm,ss,"t15",rco)-CoprodIHS(COf,mm,ss,"t11",rco))/4*(ord(time)-1);
         COprodyield(COf,mm,ss,rw,time,rco) = COprodyield(COf,mm,ss,rw,"t11",rco) +(COprodyield(COf,mm,ss,rw,"t15",rco) - COprodyield(COf,mm,ss,rw,"t11",rco))/4*(ord(time)-1);
         coalcv(COf,mm,ss,rw,time,rco) = coalcv(COf,mm,ss,rw,"t11",rco) +(coalcv(COf,mm,ss,rw,"t15",rco) - coalcv(COf,mm,ss,rw,"t11",rco))/4*(ord(time)-1);
         COomcst(COf,mm,ss,rw,time,rco) = COomcst(COf,mm,ss,rw,"t11",rco) +(COomcst(COf,mm,ss,rw,"t15",rco) - COomcst(COf,mm,ss,rw,"t11",rco))/4*(ord(time)-1);

elseif ord(time)<10 and ord(time)>5,
         CoprodIHS(COf,mm,ss,time,rco) = CoprodIHS(COf,mm,ss,"t15",rco)+(CoprodIHS(COf,mm,ss,"t20",rco)-CoprodIHS(COf,mm,ss,"t15",rco))/5*(ord(time)-5);
         COprodyield(COf,mm,ss,rw,time,rco) = COprodyield(COf,mm,ss,rw,"t15",rco)+(COprodyield(COf,mm,ss,rw,"t20",rco) - COprodyield(COf,mm,ss,rw,"t15",rco))/5*(ord(time)-5);
         coalcv(COf,mm,ss,rw,time,rco) = coalcv(COf,mm,ss,rw,"t15",rco)+(coalcv(COf,mm,ss,rw,"t20",rco) - coalcv(COf,mm,ss,rw,"t15",rco))/5*(ord(time)-5);
         COomcst(COf,mm,ss,rw,time,rco) = COomcst(COf,mm,ss,rw,"t15",rco)+(COomcst(COf,mm,ss,rw,"t20",rco) - COomcst(COf,mm,ss,rw,"t15",rco))/5*(ord(time)-5);

elseif ord(time)<15 and ord(time)>10,
         CoprodIHS(COf,mm,ss,time,rco) = CoprodIHS(COf,mm,ss,"t20",rco)+(CoprodIHS(COf,mm,ss,"t25",rco)-CoprodIHS(COf,mm,ss,"t20",rco))/5*(ord(time)-10);
         COprodyield(COf,mm,ss,rw,time,rco) = COprodyield(COf,mm,ss,rw,"t20",rco)+(COprodyield(COf,mm,ss,rw,"t25",rco) - COprodyield(COf,mm,ss,rw,"t20",rco))/5*(ord(time)-10);
         coalcv(COf,mm,ss,rw,time,rco) = coalcv(COf,mm,ss,rw,"t20",rco)+(coalcv(COf,mm,ss,rw,"t25",rco) - coalcv(COf,mm,ss,rw,"t20",rco))/5*(ord(time)-10);
         COomcst(COf,mm,ss,rw,time,rco) = COomcst(COf,mm,ss,rw,"t20",rco)+(COomcst(COf,mm,ss,rw,"t25",rco) - COomcst(COf,mm,ss,rw,"t20",rco))/5*(ord(time)-10);

elseif ord(time)<20 and ord(time)>15,
         CoprodIHS(COf,mm,ss,time,rco) = CoprodIHS(COf,mm,ss,"t25",rco)+(CoprodIHS(COf,mm,ss,"t30",rco)-CoprodIHS(COf,mm,ss,"t25",rco))/5*(ord(time)-15);
         COprodyield(COf,mm,ss,rw,time,rco) = COprodyield(COf,mm,ss,rw,"t25",rco)+(COprodyield(COf,mm,ss,rw,"t30",rco) - COprodyield(COf,mm,ss,rw,"t25",rco))/5*(ord(time)-15);
         coalcv(COf,mm,ss,rw,time,rco) = coalcv(COf,mm,ss,rw,"t25",rco)+(coalcv(COf,mm,ss,rw,"t30",rco) - coalcv(COf,mm,ss,rw,"t25",rco))/5*(ord(time)-15);
         COomcst(COf,mm,ss,rw,time,rco) = COomcst(COf,mm,ss,rw,"t25",rco)+(COomcst(COf,mm,ss,rw,"t30",rco) - COomcst(COf,mm,ss,rw,"t25",rco))/5*(ord(time)-15);

elseif ord(time)>20 and ord(time)<25,
         CoprodIHS(COf,mm,ss,time,rco) = CoprodIHS(COf,mm,ss,"t30",rco)+(CoprodIHS(COf,mm,ss,"t35",rco)-CoprodIHS(COf,mm,ss,"t30",rco))/5*(ord(time)-20);
         COprodyield(COf,mm,ss,rw,time,rco) = COprodyield(COf,mm,ss,rw,"t30",rco)+(COprodyield(COf,mm,ss,rw,"t35",rco) - COprodyield(COf,mm,ss,rw,"t30",rco))/5*(ord(time)-20);
         coalcv(COf,mm,ss,rw,time,rco) = coalcv(COf,mm,ss,rw,"t30",rco)+(coalcv(COf,mm,ss,rw,"t35",rco) - coalcv(COf,mm,ss,rw,"t30",rco))/5*(ord(time)-20);
         COomcst(COf,mm,ss,rw,time,rco) = COomcst(COf,mm,ss,rw,"t30",rco)+(COomcst(COf,mm,ss,rw,"t35",rco) - COomcst(COf,mm,ss,rw,"t30",rco))/5*(ord(time)-20);


elseif ord(time)>25,
         CoprodIHS(COf,mm,ss,time,rco) = CoprodIHS(COf,mm,ss,"t35",rco) ;
         COprodyield(COf,mm,ss,rw,time,rco) = COprodyield(COf,mm,ss,rw,"t35",rco) ;
         coalcv(COf,mm,ss,rw,time,rco) = coalcv(COf,mm,ss,rw,"t35",rco)           ;
         COomcst(COf,mm,ss,rw,time,rco) = COomcst(COf,mm,ss,rw,"t35",rco)         ;
);

);

*        split coal supply for IHS provincial aggregates
*        the percentages have been estimated using reported values by China Government Statistics

         COprodIHS("met",'under',"South and east coast Met",time,"South") =
         COprodIHS("met",'under',"South and east coast Met",time,"South")*0.03;
         COprodIHS("met",'under',"South and east coast Met",time,"East") =
         COprodIHS("met",'under',"South and east coast Met",time,"South")*0.97;

         COprodIHS("coal",'under',"Central South Met",time,"South") =
         COprodIHS("coal",'under',"Central South Met",time,"South")*0.32;
         COprodIHS("coal",'under',"Central South Met",time,"East") =
         COprodIHS("coal",'under',"Central South Met",time,"South")*0.68;


         CoprodIHS(COf,mm,ss,time,rco)$(CoprodIHS(COf,mm,ss,time,rco)<0) = 0;

* !!!!!!!!!!!!!!! no cv for met coals, set to -1
         coalcv(met,mm,ss,'washed',time,rco)$(
                 COprodyield(met,mm,ss,'washed',time,rco)>0) = -1;


*        if there is no secondary washed coal, artificially assign the cv to
*        that of washed coal. This is done to facilitate a calculation below
*        that sets the cost of metalurgical secondary washed products
*        to that of the cost of secondary washed steam coal, adjusting for CV
         coalcv(coal,mm,ss,'other',time,rco)$(
                 coalcv(coal,mm,ss,'other',time,rco)=0 and
                 coalcv(coal,mm,ss,'washed',time,rco)>0)
         = coalcv(coal,mm,ss,'washed',time,rco);



*        set raw coal yield to one for lignite and steam
*        metallurgical and hard coking coal are always washed
         COprodyield(coal,mm,ss,"raw",trun,rco)$(
                 smax(time,CoprodIHS(coal,mm,ss,time,rco))>0) = 1;

$ontext
         COprodyield(COf,mm,ss,rw,time,rco)$(COprodyield(COf,mm,ss,rw,time,rco)=0 and COexist(COf,mm,ss,rco)=0)
                 = COprodyield(COf,mm,ss-1,rw,time,rco);
         coalcv(COf,mm,ss,rw,time,rco)$(coalcv(COf,mm,ss,rw,time,rco)=0 and COexist(COf,mm,ss,rco)=0)
                 = coalcv(COf,mm,ss-1,rw,time,rco);

*        for new supply steps (above the IHS coal rush levels) apply 10% increase
*         COomcst(COf,mm,ss,rw,time,rco)$(COomcst(COf,mm,ss,rw,time,rco)=0 and COexistcp.l(COf,mm,ss,time,rco)=0 and COprodyield(COf,mm,ss,rw,time,rco)>0)=
*         COomcst(COf,mm,ss-1,rw,time,rco)*1.1;
$offtext


         COprodyield("met",'under',"South and east coast Met",rw,time,"East")=
         COprodyield("met",'under',"South and east coast Met",rw,time,"South");

         COomcst("met",'under',"South and east coast Met",rw,time,"East")=
         COomcst("met",'under',"South and east coast Met",rw,time,"South");

         coalcv("met",'under',"South and east coast Met",rw,time,"East")=
         coalcv("met",'under',"South and east coast Met",rw,time,"South");

         COprodyield("coal",'under',"Central South Met",rw,time,"East")=
         COprodyield("coal",'under',"Central South Met",rw,time,"South");

         COomcst("coal",'under',"Central South Met",rw,time,"East")=
         COomcst("coal",'under',"Central South Met",rw,time,"South");

         coalcv("coal",'under',"Central South Met",rw,time,"East")=
         coalcv("coal",'under',"Central South Met",rw,time,"South");



         table COrwtable(rw,COf,COff) Map Other washed coal for met and hardcoke to thermal coal

                                 met     hardcoke  coal

         (raw,washed).met        1       0         0
         (raw,washed).hardcoke   0       1         0
         (raw,washed).coal       0       0         1

         other.coal              1       1         1

         ;

         table COsulfwash(rw,sulf,sulff)  tables reduce sulfur content of washed coals
                                 ExtLow Low    Med   High

         (washed,other).ExtLow   1      1      1       0
         (washed,other).Low      0      0      0       1
         (washed,other).Med      0      0      0       0
         (washed,other).High     0      0      0       0
;

         COsulfwash('raw',sulf,sulf)=1;

         set COmine(COf,mm,ss,rco) coal mine units used in the model equations
             COrw(COf,mm,ss,sulf,rw,rco) coal washing applied to coal mine units
             COsulf(sulf,rco) regions in the model requiring sulfur constraint
             COcvbins(COf,cv,sulf,mm,ss,rw,trun,rco) calorific values required for each mining region
             COcvrco(COf,cv,sulf,trun,rco)
;
         COmine(COf,mm,ss,rco)$(smax(trun,COprodIHS(COf,mm,ss,trun,rco))>0)=yes;

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


*         coalcv(COf,cv,mm,ss,rw,trun,rco) = 6000;


$ontext
         parameter dist(rco,rrco),min_dist(ss2,rw,rco) ;
         dist(rco,rrco) = (abs(latitude(rco)-latitude(rrco))**2+abs(longitude(rco)-longitude(rrco))**2)**0.5;
         min_dist(ss2,rw,rco) = smin(rrco$(dist(rco,rrco)>0 and (coalcv('coal',"under",ss2,rw,'t11',rrco)>0) ),dist(rco,rrco));


         set rcomin(rco,rrco);

         rcomin(rco,rco)$(smax((ss2,rw),coalcv('coal',"under",ss2,rw,'t11',rco))>0)  = yes;
         rcomin(rco,rrco)$(smin((ss2,rw)$(smax((ss,rww),coalcv('coal',"under",ss,rww,'t11',rco))<=0 and min_dist(ss2,rw,rco)>0),min_dist(ss2,rw,rco))=dist(rco,rrco))  = yes;
         display rcomin;
$offtext


*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! These are estimates for unkown met coal cost
*        estimate 60% additional cost for metallurgical coal production
         COomcst(met,"under",ss,rw,time,rco)$COmine(met,'under',ss,rco) =
                 smax((ss2)$(coalcv('coal',"under",ss2,rw,time,rco)>0 ),
                         COomcst("coal","under",ss2,rw,time,rco)*
         (1.6$rwashed(rw)+
         (coalcv(met,"under",ss,rw,time,rco)/coalcv('coal',"under",ss2,rw,time,rco))$rwother(rw))
                 );

         COomcst(met,"under",ss,rw,time,rco)$(
                 COomcst(met,"under",ss,rw,time,rco)<=0 AND
                 COmine(met,'under',ss,rco)   )=
            smax((ss2),COomcst(met,"under",ss2,rw,time,rco));

         COomcst(met,"under",ss,rw,time,rco)$(
                 COomcst(met,"under",ss,rw,time,rco)<=0 AND
                 COmine(met,'under',ss,rco))=
            smax((rrco),COomcst(met,"under",ss,rw,time,rrco));


*         abort COprodyield;
;


*$ontext


set        rco_sup(rco,r) region where each coal supply basin is located
;
         rco_sup(rco,r)$rco_dem(rco,r) = yes;
*         rco_sup('NMCBHulun','Northeast')=yes;
*         rco_sup('NMCBXilin','Northeast')=yes;



* !!!    uSE ihs estimates for metallurgical coal production levels in 2012
* !!!    Calibrated to reported import volumes using 4% reduction of IHS level
         COprodStats(met,mm,ss,time,rco)
          = COprodIHS(met,mm,ss,time,rco)*0.96;

COstatistics('coal prod IHS',time,r) = sum((coal,mm,ss,rco)$rco_sup(rco,r),
                                         COprodIHS(coal,mm,ss,time,rco));
COstatistics('met prod IHS',time,r) = sum((met,mm,ss,rco)$rco_sup(rco,r),
                                         COprodStats(met,mm,ss,time,rco));

loop(r,
         COprodStats(coal,mm,ss,trun,rco)$(rco_sup(rco,r)
                         and COstatistics('coal prod IHS',trun,r)>0)=
         (COstatistics('Production',trun,r)-COstatistics('met prod IHS',trun,r))
         *COprodIHS(coal,mm,ss,trun,rco)/COstatistics('coal prod IHS',trun,r)*1.03;
);

COprodStats(COf,mm,ss,time,rco)$(ord(time)>2) = COprodIHS(COf,mm,ss,time,rco);

*         COprodStats(COf,mm,ss,time,rco)=
*         COprodStats(COf,mm,ss,time,rco)*(1$met(COf) + 1$coal(COf));

*        fix production levels to those reported in IHS coal rush data or
*        China Energy statistics
         COexistcp.up(COf,mm,ss,trun,rco)$(COmine(COf,mm,ss,rco)
                 and ord(trun)=1)=COprodStats(COf,mm,ss,trun,rco);
*         COprodIHS(COf,mm,ss,time,rco);

*         COomcst(COf,mm,ss,rw,time,rco)$(not raw(rw)) = COomcst(COf,mm,ss,rw,time,rco);
Equations
* ====================== Primal Relationships =================================*
         COobjective

         COpurchbal(trun) acumulates all purchases
         COcnstrctbal(trun) accumlates all construction activity
         COopmaintbal(trun) accumulates operations and maintenance costs

         COcapbal(COf,mm,ss,trun,rco) coal production balance
         COcaplim(COf,mm,ss,trun,rco) coal production capacity constraint

         COsulflim(sulf,trun,rco) constraint on coal sulfur content in each region
         COwashcaplim(COf,mm,ss,trun,rco)
*         COashlim(trun) contraint on the national distribution of ash in raw coal production
*         COashlimreg(trun,rco) contraint on the regional average ash content or raw coal

         COprodCV(COf,cv,sulf,trun,rco)  equation to aggregate coal produciton units by average CV

         COprodfx(COf,sulf,mm,ss,trun,rco) accounting equation to fix the production of other washed to that of washed coal

         COprodlim(COf,mm,ss,trun,rco) limit on mount of coal production

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
*$ontext
COobjective.. z =e=
   sum(t,(COpurchase(t)+COConstruct(t)+COOpandmaint(t))*COdiscfact(t))
;
*$offtext



COpurchbal(t).. sum((COf,mm,ss,rco)$COmine(COf,mm,ss,rco),COpurcst(COf,mm,t,rco)*CObld(COf,mm,ss,t,rco))
           -COpurchase(t)=e=0;

COcnstrctbal(t).. sum((COf,mm,ss,rco)$COmine(COf,mm,ss,rco),COconstcst(COf,mm,ss,t,rco)*CObld(COf,mm,ss,t,rco))
          -COconstruct(t)=e=0;

COopmaintbal(t)..
   sum((COf,sulf,mm,ss,rw,rco)$COrw(COf,mm,ss,sulf,rw,rco),
         COomcst(COf,mm,ss,rw,t,rco)*COprodyield(COf,mm,ss,rw,t,rco)
         *COprod(COf,sulf,mm,ss,rw,t,rco))
  -COopandmaint(t)=e=0;

COcapbal(COf,mm,ss,t,rco)$COmine(COf,mm,ss,rco)..COexistcp(COf,mm,ss,t,rco)+
         CObld(COf,mm,ss,t-COleadtime(COf,mm,rco),rco)
         -COexistcp(COf,mm,ss,t+1,rco)=g=0;

COcaplim(COf,mm,ss,t,rco)$(COmine(COf,mm,ss,rco))..
*

COexistcp(COf,mm,ss,t,rco)
+CObld(COf,mm,ss,t-COleadtime(COf,mm,rco),rco)
  -sum((sulf,rw)$(not rwother(rw) and COrw(COf,mm,ss,sulf,rw,rco) and COsulf(sulf,rco)),
                 COprod(COf,sulf,mm,ss,rw,t,rco)) =g= 0
;


COsulflim(sulf,t,rco)$COsulf(sulf,rco)  ..

  +COsulfur(sulf,t,rco)*sum((COf,mm,ss)$COmine(COf,mm,ss,rco),
          COexistcp(COf,mm,ss,t,rco)
         +CObld(COf,mm,ss,t-COleadtime(COf,mm,rco),rco))

  -sum((COf,mm,ss,rw)$(not rwother(rw) and COrw(COf,mm,ss,sulf,rw,rco)),
         COprod(COf,sulf,mm,ss,rw,t,rco))   =g= 0 ;


COwashcaplim(COf,mm,ss,t,rco)$(coal(COf) and COmine(COf,mm,ss,rco) and COwashratio(COf,mm,ss,'t11',rco)>0)..

  +COwashratio(COf,mm,ss,'t11',rco)*(COexistcp(COf,mm,ss,t,rco)
         +CObld(COf,mm,ss,t-COleadtime(COf,mm,rco),rco))
  -sum((sulf,rw)$(COrw(COf,mm,ss,sulf,rw,rco) and rwashed(rw)),
         COprod(COf,sulf,mm,ss,rw,t,rco))   =g= 0 ;

$ontext
COashlim(t)..
COashDist(ash)*sum((COf,mm,ss,rco)$COmine(COf,mm,ss,rco),COexistcp(COf,mm,ss,t,rco)+CObld(COf,mm,ss,t-COleadtime(COf,mm,rco),rco))
-sum((COf,sulf,mm,ss,rw,rco)$(not rwother(rw) and COrw(COf,mm,ss,sulf,rw,rco)),
         COprod(COf,sulf,mm,ss,rw,t,rco))   =e= 0 ;

COashlimreg(t,rco)..
COashReg(rco)*sum((COf,mm,ss)$COmine(COf,mm,ss,rco),COexistcp(COf,mm,ss,t,rco)+CObld(COf,mm,ss,t-COleadtime(COf,mm,rco),rco))
-sum((COf,sulf,mm,ss,rw)$(not rwother(rw) and COrw(COf,mm,ss,sulf,rw,rco)),
         COprod(COf,sulf,mm,ss,rw,t,rco)*COash(ash))   =g= 0 ;
$offtext

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

COprodlim(COf,mm,ss,t,rco)$(coal_cap=1 and COmine(COf,mm,ss,rco))..
          -COexistcp(COf,mm,ss,t,rco)-CObld(COf,mm,ss,t-COleadtime(COf,mm,rco),rco)
                 =g=
*                         -CoprodIHS(COf,mm,ss,t,rco)
                         -COprodStats(COf,mm,ss,t,rco)
;


*================= dual relationships ==========================================

DCOpurchase(t).. 1*COdiscfact(t)=g=-DCOpurchbal(t);
DCOconstruct(t).. 1*COdiscfact(t)=g=-DCOcnstrctbal(t);
DCOopandmaint(t).. 1*COdiscfact(t)=g=-DCOopmaintbal(t);

Dcoalprod(COf,cv,sulf,t,rco)$(COcvrco(COf,cv,sulf,t,rco)).. 0=g=
   -DCOprodCV(COf,cv,sulf,t,rco)
   +sum(ELs,DCOsup(COf,cv,sulf,ELs,t,rco))$COfCV(COf,cv);


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
   +sum(sulf$COsulf(sulf,rco),COsulfur(sulf,t,rco)*DCOsulflim(sulf,t,rco))
   +(DCOwashcaplim(COf,mm,ss,t,rco)*
         COwashratio(COf,mm,ss,'t11',rco))$(coal(COf) and COwashratio(COf,mm,ss,'t11',rco)>0)

   -DCOprodlim(COf,mm,ss,t,rco)$(coal_cap=1)

;

DCObld(COf,mm,ss,t,rco)$COmine(COf,mm,ss,rco) .. 0 =g=
   COpurcst(COf,mm,t,rco)*DCOpurchbal(t)
   +COconstcst(COf,mm,ss,t,rco)*DCOcnstrctbal(t)
   +DCOcapbal(COf,mm,ss,t+COleadtime(COf,mm,rco),rco)
   +DCOcaplim(COf,mm,ss,t+COleadtime(COf,mm,rco),rco)
   +sum(sulf$COsulf(sulf,rco),COsulfur(sulf,t,rco)*DCOsulflim(sulf,t+COleadtime(COf,mm,rco),rco))
   +(DCOwashcaplim(COf,mm,ss,t+COleadtime(COf,mm,rco),rco)*
         COwashratio(COf,mm,ss,'t11',rco))$(coal(COf) and COwashratio(COf,mm,ss,'t11',rco)>0)
   -DCOprodlim(COf,mm,ss,t+COleadtime(COf,mm,rco),rco)$(coal_cap=1)
;



********************************************************************************
*Capital cost discounting
$ontext
$INCLUDE coaltranssubmodel.gms
$INCLUDE powersubmodel.gms



$INCLUDE imports.gms
$INCLUDE scenarios.gms
$INCLUDE discounting.gms

         COdiscfact(time)  = 1;


option MCP=path;
option LP=pathnlp;

option limrow=10;
option limcol=10;

model coalMCP/

*Coal

COpurchbal.DCOpurchbal,COcnstrctbal.DCOcnstrctbal,
COopmaintbal.DCOopmaintbal,COcapbal.DCOcapbal,COcaplim.DCOcaplim,
COsulflim.DCOsulflim,COprodfx.DCOprodfx,COprodCV.DCOprodCV,COprodlim.DCOprodlim,

DCOpurchase.COpurchase,DCOconstruct.COconstruct,DCOopandmaint.COopandmaint,
DCOprod.COprod,DCOexistcp.COexistcp,DCObld.CObld,Dcoalprod.coalprod
/
;



model coalLP
/
         COobjective,
         COpurchbal, COcnstrctbal, COopmaintbal,COcapbal, COcaplim,
         COsulflim,COprodCV, COprodfx, COprodlim,
*         COashlim,        COashlimreg,
/
;

t(trun)=yes;

Solve coalLP using LP minimizing z;


Solve coalMCP using MCP;

scalar zMCP;

zMCP= sum(trun,(COpurchase.l(trun)+COConstruct.l(trun)+COOpandmaint.l(trun))*COdiscfact(trun))


display z.l,zMCP;
$offtext
