         Eldemand(Ell,trun,r) = Eldemand(Ell,trun,r)+WAelconsump.l(ELl,trun,r);
         ELconsump("WA",trun,r) = sum(Ell,WAelconsump.l(ELl,trun,r));

         fconsump("WA",fup,trun,r) = WAfconsump.l(fup,trun,r)$WAf(fup);
         RFfconsump("WA",RFcf,trun,r) = WAfconsump.l(RFcf,trun,r)$WAf(RFcf);

         WAsupWAp(WApF,trun,r) = sum((WAf,v),WAop.l(WApF,v,WAf,trun,r)*WAyield(WApF,v,r));
         WAsupWAp(WApV,trun,r) = sum((WAf,v,ELl,opm),WAVop.l(WApV,v,ELl,WAf,opm,trun,r)*WAVyield(WApV,v,opm,r)) ;

$ontext
         WAsupWAp("StCo",trun,r) = WAsupWAp("StCo",trun,r)+WAsupWAp("StCoV",trun,r);
         WAsupWAp("GTCo",trun,r) = WAsupWAp("GTCo",trun,r)+WAsupWAp("GTCoV",trun,r);
         WAsupWAp("CCCo",trun,r) = WAsupWAp("CCCo",trun,r)+WAsupWAp("CCCoV",trun,r);
         WAsupWAp(WApV,trun,r) =  0;
*        I've aggregated variable PWR cogen plants with fixed plants
$offtext
         WAsupWAp(WAp,trun,rN) = sum(r,WAsupWAp(WAp,trun,r));

         WAcapWAp(WApCO,trun,r) =  sum(v, (WAbld.l(WApCO,v,trun,r)+
                                        WAexistcp.l(WApCo,v,trun,r))/PWR(WApCO));


         WAcapWAp(WApsingle,trun,r) = sum(v, WAbld.l(WApsingle,v,trun,r)+
                                        WAexistcp.l(WApsingle,v,trun,r));

$ontext
         WAcapWAp("StCo",trun,r) = WAcapWAp("StCo",trun,r)+WAcapWAp("StCoV",trun,r);
         WAcapWAp("GTCo",trun,r) = WAcapWAp("GTCo",trun,r)+WAcapWAp("GTCoV",trun,r);
         WAcapWAp("CCCo",trun,r) = WAcapWAp("CCCo",trun,r)+WAcapWAp("CCCoV",trun,r);
         WAcapWAp(WApV,trun,r) =  0;
*        I've aggregated variable PWR cogen plants with fixed plants
$offtext

         WAcapWAp(WAp,trun,rN) = sum(r,WAcapWAp(WAp,trun,r));


         WAsuptot(trun,r) = sum(WAp,WAsupWAp(WAp,trun,r));
         WAsuptot(trun,rN) = sum(r,WAsuptot(trun,r));

         expenses("WA",trun) =  sum((WAf,r),WAAPf(WAf,trun,r)*WAfconsump.l(WAf,trun,r))
                 + WAImports.l(trun)+WAConstruct.l(trun)+WAOpandmaint.l(trun)
                 + sum((ELl,r), WAELconsump.l(ELl,trun,r)*DELsup.l(ELl,trun,r));

*         revenue("WA",trun) =     sum((ELl,r) , WAELsupply.l(ELl,trun,r)*ELAPelwa(ELl,trun,r))
*                           + sum(r,WAdemval("t1",r)*WAAPwa);


         WAELprod(WApFco,v,trun,r) = sum(WAf,WAop.l(WApFco,v,WAf,trun,r));
         WAELprod(WApV,v,trun,r) = sum((WAf,ELl,opm),WAVop.l(WApV,v,ELl,WAf,opm,trun,r));
         WAELprod(WApV,v,trun,rn) = sum(r,WAELprod(WApV,v,trun,r));

         WAcap(trun,r) =  sum(WAp, WAcapWAp(WAp,trun,r));
         WAcap(trun,rn) = sum(r,WAcap(trun,r));

         WAbldWAp(WAp,trun,r)=0;
         loop(trun,
                 WAbldWAp(WApCO,trun,r) = WAbldWAp(WApCO,trun-1,r)
                                 + sum(v, WAbld.l(WApCO,v,trun,r))/PWR(WApCo);
                 WAbldWAp(WApsingle,trun,r) =  WAbldWAp(WApsingle,trun-1,r)
                                 + sum(v, WAbld.l(WApsingle,v,trun,r));
         );

$ontext
         WAbldWAp("StCo",trun,r) = WAbldWAp("StCo",trun,r)+WAbldWAp("StCoV",trun,r);
         WAbldWAp("GTCo",trun,r) = WAbldWAp("GTCo",trun,r)+WAbldWAp("GTCoV",trun,r);
*+WAbldWAp("STAux",trun,r);
         WAbldWAp("CCCo",trun,r) = WAbldWAp("CCCo",trun,r)+WAbldWAp("CCCoV",trun,r);
         WAbldWAp(WApV,trun,r) =  0;
*        I've aggregated variable PWR cogen supply with fixed plants
$offtext
         WabldWAp(WAp,trun,rn) = sum(r,WabldWAp(WAp,trun,r));

         WAbldtot(trun,r) = sum(WAp,WAbldWAp(WAp,trun,r));
         WAbldtot(trun,rn) = sum(r,WAbldtot(trun,r));

         ELsupELl(WApFco,ELl,trun,r) = sum((v,WAf),WAop.l(WApFCo,v,WAf,trun,r)*ELlcnorm(ELl));
         ELsupELl(WApV,ELl,trun,r) = sum((v,WAf,opm),WAVop.l(WApV,v,ELl,WAf,opm,trun,r));

*         ELsupELl("StCo",ELl,trun,r) = ELsupELl("StCo",ELl,trun,r)+ELsupELl("StCoV",ELl,trun,r);
*         ELsupELl("GTCo",ELl,trun,r) = ELsupELl("GTCo",ELl,trun,r)+ELsupELl("GTCoV",ELl,trun,r);
*         ELsupELl("CCCo",ELl,trun,r) = ELsupELl("CCCo",ELl,trun,r)+ELsupELl("CCCoV",ELl,trun,r);
*         ELsupELl(WApV,ELl,trun,r) =  0;
         ELsupELl(WAp,ELl,trun,rN) = sum(r,ELsupELl(WAp,ELl,trun,r));


         ELsupELp(WApFco,trun,r) = sum((v,WAf),WAop.l(WApFCo,v,WAf,trun,r));
         ELsupELp(WApV,trun,r) = sum((v,ELl,WAf,opm),WAVop.l(WApV,v,ELl,WAf,opm,trun,r));

$ontext
         ELsupELp("StCo",trun,r) = ELsupELp("StCo",trun,r)+ELsupELp("StCoV",trun,r);
         ELsupELp("GTCo",trun,r) = ELsupELp("GTCo",trun,r)+ELsupELp("GTCoV",trun,r);
         ELsupELp("CCCo",trun,r) = ELsupELp("CCCo",trun,r)+ELsupELp("CCCoV",trun,r);
         ELsupELp(WApV,trun,r) =  0;
$offtext
*        I've aggregated variable PWR cogen supply with fixed plants
         ELsupELp(WAp,trun,rN) = sum(r,ELsupELp(WAp,trun,r));

         ELsuptot("WA",trun,r) = sum((ELl),WAelsupply.l(ELl,trun,r));
         ELsuptot("WA",trun,rN) = sum(r,ELsuptot("WA",trun,r));

         ELcapELp(WApCO,trun,r) =
                         sum(v, WAbld.l(WApCO,v,trun,r)+
                                        WAexistcp.l(WApCo,v,trun,r));
$ontext
         ELcapELp("StCo",trun,r) = ELcapELp("StCo",trun,r)+ELcapELp("StCoV",trun,r);
         ELcapELp("GTCo",trun,r) = ELcapELp("GTCo",trun,r)+ELcapELp("GTCoV",trun,r);
         ELcapELp("CCCo",trun,r) = ELcapELp("CCCo",trun,r)+ELcapELp("CCCoV",trun,r);
         ELcapELp(WApV,trun,r) =  0;
$offtext

*        I've aggregated variable PWR cogen plants with fixed plants
         ELcapELp(WAp,trun,rn) = sum(r,ELcapELp(WAp,trun,r));

         ELcap("WA",trun,r) =
                         sum(WApCO, ELcapELp(WApCO,trun,r));
         ELcap("WA",trun,rn) = sum(r,ELcap("WA",trun,r));

         ELbldELp(WApCO,trun,r)=0;
         loop(trun,
                 ELbldELp(WApCO,trun,r) = ELbldELp(WApCO,trun-1,r)+
                         sum(v, WAbld.l(WApCO,v,trun,r));
         );

*         ELbldELp("StCo",trun,r) = ELbldELp("StCo",trun,r)+ELbldELp("StCoV",trun,r);
*         ELbldELp("GTCo",trun,r) = ELbldELp("GTCo",trun,r)+ELbldELp("GTCoV",trun,r);
*         ELbldELp("CCCo",trun,r) = ELbldELp("CCCo",trun,r)+ELbldELp("CCCoV",trun,r);
*         ELbldELp(WApV,trun,r) =  0;
*        I've aggregated variable PWR cogen plants with fixed plants

         ELbldELp(WAp,trun,rn) = sum(r,ELbldELp(WAp,trun,r));

         ELbldtot("WA",trun,r) = sum(WApCO,ELbldELp(WApCo,trun,r));
         ELbldtot("WA",trun,rn) = sum(r,ELbldtot("WA",trun,r));

