         ELpurcst(ELp,trun,r)=ELpurcst(ELp,trun,r)/ELdiscoef1(ELp,trun);
         ELconstcst(ELp,trun,r)=ELconstcst(ELp,trun,r)/ELdiscoef1(ELp,trun);


         WApurcst(WAp,trun,r)=WApurcst(WAp,trun,r)/WAdiscoef1(WAp,trun);
         WAconstcst(WAp,trun,r)=WAconstcst(WAp,trun,r)/WAdiscoef1(WAp,trun);


parameter govtcaptialcost, capitalcost;

         govtcaptialcost(Elpd)  =  sum(trun,
sum((v,r)$ELpdsub(Elpd),(subsidy.l(trun)+gamma_sub(ELpd,trun))*(ELpurcst(ELpd,trun,r)+ELconstcst(ELpd,trun,r))*ELbld.l(ELpd,v,trun,r))
                         );

         govtcaptialcost(Elps)  =   sum(trun,
sum((v,r)$ELpssub(Elps),(subsidy.l(trun)+gamma_sub(ELps,trun))*(ELPurcst(ELps,trun,r)+ELconstcst(ELps,trun,r))*ELsolbld.l(ELps,v,trun,r))
                         );

         govtcaptialcost("all") = sum(Elp,govtcaptialcost(Elp));

         capitalcost(Elpd)  =  sum(trun,
sum((v,r),(ELpurcst(ELpd,trun,r)+ELconstcst(ELpd,trun,r))*ELbld.l(ELpd,v,trun,r))
                         );

         capitalcost(Elps)  =   sum(trun,
sum((v,r),(ELPurcst(ELps,trun,r)+ELconstcst(ELps,trun,r))*ELsolbld.l(ELps,v,trun,r))
                         );


         capitalcost(WAp)  =   sum(trun,
sum((v,r),(WAPurcst(WAp,trun,r)+WAconstcst(WAp,trun,r))*WAbld.l(WAp,v,trun,r))
                                 );


         capitalcost("all") = sum(ELp,capitalcost(Elp))+sum(WAp,capitalcost(WAp));
