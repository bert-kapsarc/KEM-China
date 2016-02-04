*        only allow demand centers to consume coal
*         rco_dem(rco,r)$(not r(rco))=no;

$INCLUDE imports.gms
$INCLUDE scenarios.gms

********************************************************************************
*Capital cost discounting
$INCLUDE discounting.gms

*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
*        set all discount factors to 1 for one time period run
*         PCdiscfact(time) = 1;
*         WAdiscfact(time) = 1;
         ELdiscfact(time) = 1;
         COdiscfact(time)  = 1;
*         RFdiscfact(time) = 1;
*         CMdiscfact(time) = 1;
*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


set demand_change /1/
parameter elasticity(demand_change,COf,trun,*)  ;


parameter rail_capex(rco,rrco) expost add capital cost of rail lines built but not used
          z_expost       expost objective value including unused capital lines
          accounting_costs;

parameter temp2,COconsumpEIA_save(COf,trun), OTHERCOconsump_save(COf,trun,rr), COintlprice_save ;
*scalar mmBTUtoTons;

OTHERCOconsump_save(COf,trun,rr) =  OTHERCOconsump(COf,trun,rr);

COconsumpEIA_save(COf,trun) = COconsumpEIA(COf,trun);

COintlprice_save(COf,ssi,cv,ash,sulf,trun,rimp) = COintlprice(COf,ssi,cv,ash,sulf,trun,rimp);



scalar zMCP;

*loop(demand_change,

*COintlprice(COf,ssi,cv,ash,sulf,trun,rimp,rrco) = COintlprice_save(COf,ssi,cv,ash,sulf,trun,rimp,rrco) * (1-((card(demand_change)-1)/2+1-ord(demand_change))/100);
*OTHERCOconsump(COf,trun,rrco) = OTHERCOconsump_save(COf,trun,rrco) * (1-((card(demand_change)-1)/2+1-ord(demand_change))/100);


                 if(card(trun)=card(thyb),

*        set all lead times to 0 for static runs
                      if(card(trun)=1,
                         COtransleadtime(tr,rco,rrco) = 0;
                         COleadtime(COf,mm,rco) = 0;
                         ELleadtime(ELp) = 0;
                         ELtransleadtime(r,rr) = 0;
                      );


                          t(trun)=yes;

*z.l=0;

                         Solve integratedLP using LP minimizing z;


*$ontext
*                         Solve integratedMCP using MCP;

zMCP =
   sum(trun,(COpurchase.l(trun)+COConstruct.l(trun)+COOpandmaint.l(trun))*COdiscfact(trun))
  +sum(trun,(COtranspurchase.l(trun)+COtransConstruct.l(trun)
         +COtransOpandmaint.l(trun)+COimports.l(trun))*COdiscfact(trun))
  +sum(trun,(ELImports.l(trun)+ELConstruct.l(trun)+ELOpandmaint.l(trun)
     +sum((Elpd,ELf,r)$ELfAP(ELf),
         ELAPf(ELf,trun,r)*ELfconsump.l(Elpd,ELf,trun,r))
     )*ELdiscfact(trun))
;
*$offtext
*zMCP = 0;

                 elseif card(trun)>card(thyb),

*$INCLUDE solve_recursive

                 );

display z.l,zMCP;


*$ontext
         accounting_costs =sum((COf,cv,ash,sulf,tr,Els,trun,rco,rrco)$rail(tr),
         COtrans.l(COf,cv,ash,sulf,tr,Els,trun,rco,rrco)*(RailSurcharge)*COtransD(tr,rco,rrco))
         +sum((tr,trun,rco,rrco)$rail(tr),
         COtransbld.l(tr,trun,rco,rrco)*COtransconstcst(tr,trun,rco,rrco)*COtransD(tr,rco,rrco));


*        Calculate the capital cost that has not been been spent on constructed
*        rail lines fixed in the model. The capital cost would have been covered
*        by the tarrif but the lines are not used
         COtransconstcst(tr,trun,rco,rrco)$path(tr,rco,rrco)=COdiscoef(trun)*COtranscapex(tr,rco,rrco)-COtransconstcst(tr,trun,rco,rrco);

z_expost = z.l

loop(trun,
loop(rco,
loop(rrco,

if( COtransbld.l('rail',trun,rco,rrco)>0 ,

  if( sum((COf,cv,ash,sulf,ELs),COtrans.l(COf,cv,ash,sulf,'rail',Els,trun,rco,rrco)) <= COtransexistcp.l('rail',trun,rco,rrco) and
      sum((COf,cv,ash,sulf,ELs),COtrans.l(COf,cv,ash,sulf,'rail',Els,trun,rrco,rco)) <= COtransexistcp.l('rail',trun,rrco,rco),

         rail_capex(rco,rrco) =
         COtransbld.l('rail',trun,rco,rrco)/2;

  elseif sum((COf,cv,ash,sulf,ELs),COtrans.l(COf,cv,ash,sulf,'rail',Els,trun,rco,rrco)) > COtransexistcp.l('rail',trun,rco,rrco),
*         sum((COf,cv,ELs),COtrans.l(COf,cv,'CO','rail',Els,trun,rco,rrco)) > sum((COf,cv,ELs),COtrans.l(COf,cv,'CO','rail',Els,trun,rrco,rco)),

         rail_capex(rco,rrco) =
         COtransbld.l('rail',trun,rco,rrco) +
        (COtransexistcp.l('rail',trun,rco,rrco)
          -sum((COf,cv,ash,sulf,ELs),COtrans.l(COf,cv,ash,sulf,'rail',Els,trun,rco,rrco))
         )
  );
);
         rail_capex(rco,rrco)= rail_capex(rco,rrco)*COtransconstcst('rail',trun,rco,rrco)*COtransD('rail',rco,rrco);
         z_expost = z_expost +  rail_capex(rco,rrco);


);
);
);

*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
*        reset discounted capital costs
         COtranspurcst(tr,trun,rco,rrco) = COtranscapex(tr,rco,rrco)*0*COdiscoef(trun);;
         COtransconstcst(tr,trun,rco,rrco) = COtranscapex(tr,rco,rrco)*1*COdiscoef(trun);
*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

         accounting_costs = accounting_costs-sum((tr,trun,rco,rrco)$rail(tr),
         COtransbld.l(tr,trun,rco,rrco)*COtransconstcst(tr,trun,rco,rrco)*COtransD(tr,rco,rrco));



if(COrailCFS=1,

         COtransconstcst('rail',trun,rco,rrco)$(path('rail',rco,rrco) and
                 COtransconstcst('rail',trun,rco,rrco)<=RailSurcharge/2) =0.001 ;
         COtransconstcst('rail',trun,rco,rrco)$(path('rail',rco,rrco) and
                 COtransconstcst('rail',trun,rco,rrco)>RailSurcharge/2) =
                         COtransconstcst('rail',trun,rco,rrco)-RailSurcharge/2 ;
);
*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

         elasticity(demand_change,COf,trun,'coal_imports') = sum((ssi,cv,ash,sulf,rco),coalimports.l(Cof,ssi,cv,ash,sulf,trun,rco)*COcvSCE(cv));
         elasticity(demand_change,COf,trun,'coal_import_price') = sum((ssi,cv,ash,sulf,rco)$(coalimports.l(COf,ssi,cv,ash,sulf,trun,rco)>0),
                 COintlprice(COf,ssi,cv,ash,sulf,trun,rco)/COcvSCE(cv)*
                 coalimports.l(COf,ssi,cv,ash,sulf,trun,rco)/elasticity(demand_change,COf,trun,'coal_imports'));
         elasticity(demand_change,COf,trun,'coal_demand') = sum((rr),OTHERCOconsump(COf,trun,rr));
         elasticity(demand_change,COf,trun,'coal_price') =  sum((cv,r,ash,sulf)$(COdem.m(COf,cv,ash,sulf,'summ',trun,r)>0),COdem.m(COf,cv,ash,sulf,'summ',trun,r)*OTHERcoconsump(COf,trun,r)/sum(rr,OTHERCOconsump(COf,trun,rr)));



