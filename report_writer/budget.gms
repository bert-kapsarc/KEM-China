$INCLUDE RW_calc.gms

*budg("budget_incr",ii,jj) = budgetgrowth("t1")  ;
budg("budget",ii,jj) = -budgetlim.l("t1") ;
if(deregulated =1,
         budg("methane_price",ii,jj) = smax(r,Dfdem.l("methane","t1",r))  ;
         budg("ethane_price",ii,jj) = smax(r,Dfdem.l("ethane","t1",r))  ;
         budg("crude_price",ii,jj) = smax(r,Dfdem.l("arablight","t1",r))  ;
         budg("HFO_price",ii,jj) = smax(r,DRFdem.l("HFO","t1",r))  ;
         budg("diesel_price",ii,jj) = smax(r,DRFdem.l("diesel","t1",r))  ;
else
         budg("methane_price",ii,jj) = fAP("methane","t1")  ;
         budg("ethane_price",ii,jj) = fAP("ethane","t1")  ;
         budg("crude_price",ii,jj) = fAP("arablight","t1")  ;
         budg("HFO_price",ii,jj) = fAP("HFO","t1")  ;
         budg("diesel_price",ii,jj) = fAP("diesel","t1")  ;
);

budg("crude price, saved barrel",ii,jj) = fintlprice("arablight","t1")  ;
budg("subsidy",ii,jj) = subsidy.l('t1');
budg("subsidy_PV",ii,jj) = gamma_sub("PV","t1");
budg("subsidy_nuclear",ii,jj) = gamma_sub("nuclear","t1")  ;
budg("subsidy_CC",ii,jj) = gamma_sub("CC","t1")  ;
budg("subsidy_GTtoCC",ii,jj) = gamma_sub("GTtoCC","t1")  ;
budg("economic_gain",ii,jj) = econgain;
budg("social_cost",ii,jj) = socialcost;
budg("export_revenue",ii,jj) = exportrevenue;
budg("subsidy_cost",ii,jj) = subsidycost;
*budg(ELp,ii,jj) =  ELsupELp(Elp,"t1","nation") ;
*budg(WAp,ii,jj) =  ELsupWAp(WAp,"t1","nation") ;

budg(ELp,ii,jj) =  ELbldELp(Elp,"t1","nation") ;
budg(WAp,ii,jj) =  ELbldELp(WAp,"t1","nation") ;

budg(fup,ii,jj) = fconsump("WA",fup,"t1","nation") +fconsump("EL",fup,"t1","nation");
budg(RFcf,ii,jj) = RFfconsump("WA",RFcf,"t1","nation") +RFfconsump("EL",RFcf,"t1","nation");

budg("Energy consumed",ii,jj) = Energycontent/1e3;
budg("oil",ii,jj) = totalcrude;
budg("gcond",ii,jj) = totalgcond;
budg("energy ",ii,jj) = Energycontent/1e3;
budg(Elp,ii,jj) = ELbldELp(Elp,"t1","nation");
budg(WAp,ii,jj) = ELbldELp(WAp,"t1","nation");
budg("subsidy",ii,jj) = subsidy.l('t1');
budg("subsidy PV",ii,jj) = gamma_sub("PV","t1");
budg("subsidy nuclear",ii,jj) = gamma_sub("nuclear","t1")  ;
budg("subsidy CC",ii,jj) = gamma_sub("CC","t1")  ;
budg("subsidy GTtoCC",ii,jj) = gamma_sub("GTtoCC","t1")  ;
budg("budget",ii,jj) = -budgetlim.l("t1") ;



         execute_unload "dereg.gdx" budg, budg2;
         execute 'call gdxxrw i=dereg.gdx o= budg.xlsx par=budg rng=budg! rdim=1';
         execute 'call gdxxrw i=dereg.gdx o= budg.xlsx par=budg2 rng=budg2! rdim=1';
         display budg;

$ontext
budget(trun) =
*Power
  (ELImports.l(trun)+ELConstruct.l(trun)+ELOpandmaint.l(trun))*ELdiscfact(trun)

+(1-subsidy(t)$(partialdereg=1))*(
 +sum((ELf,r)$ELfup(ELf),Dfdem(ELf,t,r)*ELfconsump(ELf,t,r))*ELdiscfact(t)
 +sum((ELf,r)$ELfref(ELf),DRFdem(ELf,t,r)*ELfconsump(ELf,t,r))*ELdiscfact(t)
 +sum((WAf,r)$WAfup(WAf),Dfdem(WAf,t,r)*WAfconsump(WAf,t,r))*WAdiscfact(t)
 +sum((WAf,r)$WAfref(WAf),DRFdem(WAf,t,r)*WAfconsump(WAf,t,r))*WAdiscfact(t)
 )$(deregulated=1)

  +sum((ELf,r),ELAPF(ELf,t,r)*ELfconsump(ELf,t,r))*ELdiscfact(t)$(deregulated<>1)
  +sum((WAf,r),WAAPf(WAf,t,r)*WAfconsump(WAf,t,r))*WAdiscfact(t)$(deregulated<>1)
*Water
 +(WAImports.l(trun)+WAConstruct.l(trun)+WAOpandmaint.l(trun))*WAdiscfact(trun)  ;

budget(trun) =  sum((ELl,r),PCELprice*PCELconsump.l(ELl,trun,r)+RFELprice*RFELconsump.l(ELl,trun,r)+WAAPel(ELl,trun,r)*WAELconsump.l(ELl,trun,r));

$offtext
