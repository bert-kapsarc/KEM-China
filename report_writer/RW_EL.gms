*Fuel Consumption
fconsump("EL",ELf,trun,r) =
   sum((Elpd,v,fss),ELfconsump.l(ELpd,v,ELf,fss,trun,r))
;


fconsump("EL",'coal_sce',trun,r) =
         sum((ELpcoal,v,gtyp,cv,sulf,sox,nox),
                 ELCOconsump.l(ELpcoal,v,gtyp,cv,sulf,sox,nox,trun,r)*COcvSCE(cv));

fconsump("EL",ELf,trun,"China") = sum(r,fconsump("EL",ELf,trun,r)) ;
fconsump("EL",'coal_sce',trun,"China") = sum(r,fconsump("EL",'coal_sce',trun,r));

parameter ProvAvgCV(COf,trun,rco);
ProvAvgCV(COf,trun,rco)=sum((ash,sulf,cv,ELs),
         coaluse.l(COf,cv,sulf,ELs,trun,rco)*COcvSCE(cv))/
         sum((ash,sulf,cv,ELs),coaluse.l(COf,cv,sulf,ELs,trun,rco));

fconsump("EL",COf,trun,r) = fconsump("EL",COf,trun,r)/ProvAvgCV(COf,trun,r);

*Electricity Production

ELgenELl(Elp,ELl,trun,r) =  (
   sum((v,ELf),ELop.l(ELp,v,ELl,ELf,trun,r))$Elpd(Elp)
*  +sum((v,ELf,fss,cv,sulf,sox,nox),
*         ELoploc.l(ELp,v,ELl,ELf,fss,cv,sulf,sox,nox,trun,r)*ELlchours(ELl))$Elpd(Elp)
  +sum((v),ELwindop.l(ELp,v,ELl,trun,r))$Elpw(Elp)
  +sum((v),ELhydop.l(ELp,v,ELl,trun,r))$Elphyd(Elp)
*ELparasitic(Elp,v)
)
;

ELgenELl("Trade",ELl,trun,rr) = sum((ELt,ELll,r)$(ord(r)<>ord(rr)),Eltransyield(ELt,r,rr)*
  ELtranscoef(ELll,ELl,r,rr)*ELtrans.l(ELt,ELll,trun,r,rr))
  -sum((ELt,r)$(ord(r)<>ord(rr)),ELtrans.l(ELt,ELl,trun,rr,r));

ELgenELl(ELp,ELl,trun,"China") = sum(r, ELgenELl(ELp,ELl,trun,r));


ELgenELp(ELp,trun,r) = sum(ELl, ELgenELl(ELp,ELl,trun,r));

ELgenELp(ELp,trun,"China") = sum(r, ELgenELp(ELp,trun,r));
ELgenELp('Total',trun,"China") = sum(Elp, ELgenELp(ELp,trun,"China"));

ELcapELp(ELpd,trun,r) = sum(v,ELexistcp.l(ELpd,v,trun,r));
ELcapELp(ELphyd,trun,r) = sum(v,ELhydexistcp.l(ELphyd,v,trun,r));
ELcapELp(ELpw,trun,r) = sum(v,ELwindexistcp.l(ELpw,v,trun,r));

ELcapELp(ELp,trun,"China") = sum(r, ELcapELp(ELp,trun,r));

**ELgenELp("Regional supply of electricity from each plant in TWh","","") = 1;

*Transmission Capacity
ELtransTot(trun,r,rr) = sum((ELl,ELll,ELt),ELtrans.l(ELt,ELll,trun,r,rr)*
         ELtranscoef(ELll,ELl,r,rr));


ELsales(trun,r) = sum(ELl,ELlcgwsales(r,Ell)*ELlchours(ELl)*ELdemgro(ELl,trun,r));
ELsales(trun,'China')=sum(r,ELsales(trun,r));


parameter ELtranspath;



ELtranspath(ELt,ELl,trun,r,rr,'1')$(ord(r)<>ord(rr)) = ELtrans.l(ELt,ELl,trun,r,rr) ;
ELtranspath(ELt,ELl,trun,rr,r,'2')$(ord(r)<>ord(rr)) = ELtrans.l(ELt,ELl,trun,r,rr) ;
ELtranspath(ELt,ELl,trun,r,rr,path_order)= ELtranspath(Elt,ELl,trun,rr,r,path_order);

parameter ELtransbldpath;



ELtransbldpath(ELt,trun,r,rr,'1')$(ord(r)<>ord(rr)) = ELtransbld.l(ELt,trun,r,rr) ;
ELtransbldpath(ELt,trun,rr,r,'2')$(ord(r)<>ord(rr)) = ELtransbld.l(ELt,trun,r,rr);
ELtransbldpath(ELt,trun,r,rr,path_order)= ELtransbldpath(ELt,trun,r,rr,path_order) ;




$ontext
ELcostsELp(ELpd,v,t,r)$(sum((ELl,ELf),ELop.l(ELpd,v,ELl,ELf,t,r))>0) =
ELdiscfact(t)*(
  +sum((ELl,ELf)$ELpELf(ELpd,ELf),ELomcst(Elpd,v,r)*ELop.l(ELpd,v,ELl,ELf,t,r))


    +( DCOdem.l('coal',cv,sulf,'summ',t,r)
     -sum(rco$(rco_dem(rco,r) and not r(rco) and rcodem(rco)),
      DCOsuplim.l('coal',cv,sulf,'summ',t,rco)*Elsnorm('summ')/num_nodes_reg(r))
    )*(ELop.l(ELpd,v,ELl,ELf,fss,cv,sulf,sox,nox,t,r)*ELfuelburn(ELpd,v,ELf,cv,r))$ELpcoal(Elpd)

    +ELAPf(ELf,fss,t,r)*ELop.l(ELpd,v,ELl,ELf,fss,cv,sulf,sox,nox,t,r)*
         ELfuelburn(ELpd,v,ELf,cv,r)$(not ELfcoal(ELf) and not Elpcoal(Elpd))
  )

  +sum(ELppd$ELpbld(ELppd,v),ELcapadd(Elppd,ELpd)*
         ELbld.l(Elppd,v,t-ELleadtime(Elppd),r)*
         ELpfixedcost(ELpd,v,t,r)*ELpcapmod(Elpd)
  )

  +ELexistcp.l(ELpd,v,t,r)*ELpsunkcost(ELpd,v,t,r)


  +sum(fgc,( ELfgcexistcp.l(ELpd,v,fgc,t,r)
    +ELfgcbld.l(ELpd,v,fgc,t-ELfgcleadtime(fgc),r)
   )*EMfgccapexD(fgc,t))$(ELpcoal(ELpd))
)
;



ELcostsELp(ELpw,v,t,r)$vn(v)=ELdiscfact(t)*(

  +sum((ELl,vv),ELwindop.l(ELpw,vv,ELl,t,r)*ELomcst(ELpw,vv,r))

  +sum((ELpd,vv,ELl,ELf,fss,cv,sulf,sox,nox)$(Elpspin(Elpd)
                                 and ELpELf(ELpd,ELf,fss,cv,sulf,sox,nox)),
       ELupspincap.l(Elpd,vv,ELl,ELf,fss,cv,sulf,sox,nox,t,r)*(
          ELpcost(Elpd,v,sox,nox,t,r)*ELlchours(ELl)*ELusomfrac
         +( ( DCOdem.l('coal',cv,sulf,'summ',t,r)
             -sum(rco$(rco_dem(rco,r) and not r(rco) and rcodem(rco)),
                DCOsuplim.l('coal',cv,sulf,'summ',t,rco)*
                Elsnorm('summ')/num_nodes_reg(r))
            )$ELpcoal(Elpd)
           +ELAPf(ELf,fss,t,r)$(not Elpcoal(ELpd))
          )*ELfuelburn(ELpd,v,ELf,cv,r)*ELlchours(ELl)*ELusrfuelfrac

          +ELpsunkcost(ELpd,v,t,r)
       )
   )
  +ELwindbld.l(ELpw,v,t,r)*
         ELpfixedcost(ELpw,v,t,r)
  +ELwindexistcp.l(ELpw,v,t,r)*
         ELpsunkcost(ELpw,v,t,r)

)
;


ELcostsELp(ELphyd,v,t,r)=ELdiscfact(t)*(
  +ELomcst(ELphyd,v,r)*sum(ELl,ELhydop.l(ELphyd,v,ELl,t,r))
  +ELhydbld.l(ELphyd,v,t-ELleadtime(ELphyd),r)*
         ELpfixedcost(ELphyd,v,t,r)
  +ELhydexistcp.l(ELphyd,v,t,r)*
         ELpsunkcost(ELphyd,v,t,r)
)
;


ELtariffELp(ELpd,v,t,r)$(sum((ELl,ELf,fss,cv,sulf,sox,nox),
                         ELop.l(ELpd,v,ELl,ELf,fss,cv,sulf,sox,nox,t,r))>0)
 = ELcostsELp(ELpd,v,t,r)/
sum((ELl,ELf,fss,cv,sulf,sox,nox),ELop.l(ELpd,v,ELl,ELf,fss,cv,sulf,sox,nox,t,r)
         *ELpCOparas(Elpd,v,sulf,sox,nox))
;

ELtariffELp(ELpw,v,t,r)$(sum((ELl,vv),ELwindop.l(ELpw,vv,ELl,t,r))>0)
 = ELcostsELp(ELpw,v,t,r)/(sum((ELl,vv),ELwindop.l(ELpw,vv,ELl,t,r))*ELparasitic(Elpw,v))
;

ELtariffELp(ELphyd,v,t,r)$(sum(ELl,ELhydop.l(ELphyd,v,ELl,t,r))>0)
 = ELcostsELp(ELphyd,v,t,r)/(sum(ELl,ELhydop.l(ELphyd,v,ELl,t,r))*ELparasitic(Elphyd,v))
;
$offtext

parameter Accounting utilities costs from the original LP's objective value
;



Accounting('Revenue','Coal (from power)')=

sum((COf,cv,sulf,t,r),COdiscfact(t)*
   ( DCOdem.l(COf,cv,sulf,'summ',t,r)*1
      -sum(rco$(rco_dem(rco,r) and not r(rco) and rcodem(rco)),
        DCOsuplim.l('coal',cv,sulf,'summ',t,rco)*Elsnorm('summ')/num_nodes_reg(r))
   )*
sum((Elpcoal,v,gtyp,sox,nox),ELCOconsump.l(Elpcoal,v,gtyp,cv,sulf,sox,nox,t,r))$ELfcoal(COf)
)
;

Accounting('Revenue','Coal')=


Accounting('Revenue','Coal (from power)')

+sum((COf,cv,sulf,t,r),COdiscfact(t)*
   ( DCOdem.l(COf,cv,sulf,'summ',t,r)*1
      -sum(rco$(rco_dem(rco,r) and not r(rco) and rcodem(rco)),
        DCOsuplim.l('coal',cv,sulf,'summ',t,rco)*Elsnorm('summ')/num_nodes_reg(r))
   )*
OTHERCOconsumpsulf.l(COf,cv,sulf,t,r)

)
;

Accounting('Revenue','Power')=

sum(t,ELdiscfact(t)*(

  +sum((Elpd,v,ELl,ELf,fss,cv,sulf,sox,nox,r)$(not ELptariff(ELpd,v)
                 and ELpELf(ELpd,ELf)),
         ELop.l(ELpd,v,ELl,ELf,t,r)*
         ELparasitic(Elpd,v)*DELsup.l(ELl,t,r))

  +sum((ELphyd,v,ELl,r)$(not ELptariff(ELphyd,v)),ELhydop.l(ELphyd,v,ELl,t,r)*
         ELparasitic(Elphyd,v)*DELsup.l(ELl,t,r))

  +sum((ELpw,vn)$(not ELptariff(ELpw,vn)),
         sum((v,ELl,r),ELwindop.l(ELpw,v,ELl,t,r)*
                 ELparasitic(Elpw,v)*DELsup.l(ELl,t,r))
  )

))

*+sum((ELp,v,t,r)$ELptariff(ELp,v),ELcostsELp(ELp,v,t,r))

;



$ontext
Accounting('Revenue','Power onsite')=

sum(t,ELdiscfact(t)*(
  +sum((Elpd,v,ELl,ELf,fss,cv,sulf,sox,nox,r)$(not ELpnuc(ELpd) and
                 ELpELf(ELpd,ELf,fss,cv,sulf,sox,nox)),
         ELoploc.l(ELpd,v,ELl,ELf,fss,cv,sulf,sox,nox,t,r)*(
                  ELpcost(Elpd,v,sox,nox,t,r)*ELlchours(ELl)
                 +ELpsunkcost(ELpd,v,t,r)
         )
  )
))
$offtext

;

Accounting('Cost','Government')= sum((Elpw,v,ELl,t,r)$(ELpfit=1),
         ELwindop.l(ELpw,v,ELl,t,r)*ELfit(ELpw,t,r)*ELparasitic(ELpw,v));


Accounting('Cost','Power')=
+sum(t,
   sum((ELpd,v,r)$ELpbld(ELpd,v),ELpurcst(ELpd,t,r)*ELbld.l(ELpd,v,t,r))
*  +sum((ELpd,v,r)$(vn(v) and ELpbld(Elpd,v)),ELpurcst(ELpd,t,r)*ELrsrvbld.l(Elpd,v,t,r))
  +sum((ELpw,v,r)$vn(v), ELPurcst(ELpw,t,r)*ELwindbld.l(ELpw,v,t,r))
  +sum((ELphyd,v,r)$vn(v),ELpurcst(ELphyd,t,r)*ELhydbld.l(ELphyd,v,t,r))

  +sum((ELpd,v,r)$ELpbld(ELpd,v),ELconstcst(ELpd,t,r)*ELbld.l(ELpd,v,t,r))
*  +sum((ELpd,v,r),ELconstcst(ELpd,t,r)*ELrsrvbld.l(Elpd,v,t,r))
  +sum((ELpw,v,r)$vn(v), ELconstcst(ELpw,t,r)*ELwindbld.l(ELpw,v,t,r))
  +sum((ELphyd,v,r)$vn(v), ELconstcst(ELphyd,t,r)*ELhydbld.l(ELphyd,v,t,r))


  +sum((Elpd,v,ELl,ELf,r)$ELpELf(ELpd,ELf),
         ELomcst(Elpd,v,r)*(
                 ELop.l(ELpd,v,ELl,ELf,t,r)
                 +ELusomfrac*ELlchours(ELl)*
                 ELupspincap.l(Elpd,v,ELl,ELf,t,r)$ELpspin(Elpd)
         )
  )

  +sum((ELpd,v,r)$ELpbld(ELpd,v),
         ELfixedOMcst(ELpd)*ELbld.l(ELpd,v,t-ELleadtime(ELpd),r))

*  +sum((ELpd,v,r),ELfixedOMcst(ELpd)*ELrsrvbld.l(ELpd,v,t-ELleadtime(ELpd),r))

  +sum((ELpw,v,ELl,r),ELomcst(ELpw,v,r)*ELwindop.l(ELpw,v,ELl,t,r))
  +sum((ELpw,v,r)$vn(v),ELfixedOMcst(ELpw)*ELwindbld.l(ELpw,v,t-ELleadtime(ELpw),r))

  +sum((ELphyd,v,ELl,r),
         ELomcst(ELphyd,v,r)*ELhydop.l(ELphyd,v,ELl,t,r))
  +sum((ELphyd,v,r)$vn(v),ELfixedOMcst(ELphyd)*ELhydbld.l(ELphyd,v,t-ELleadtime(ELphyd),r))


  +Accounting('Revenue','Coal (from power)')

  +sum((ELpd,v,ELf,fss,r)$(not ELfcoal(ELf) and not ELpcoal(Elpd)),
         +ELAPf(ELf,fss,t,r)*
         ELfconsump.l(ELpd,v,ELf,fss,t,r))

)


;

Accounting('Cost','Coal')=

  +sum(t,(COpurchase.l(t)+COConstruct.l(t)+COOpandmaint.l(t))*COdiscfact(t))

  +sum(t,(COtranspurchase.l(t)+COtransConstruct.l(t)
         +COtransOpandmaint.l(t)+COimports.l(t))*COdiscfact(t))

;


Accounting('Cost','State Owned Utility')=
         Accounting('Revenue','Power')
  +sum(t,ELdiscfact(t)*(

    +sum((ELt,r,rr), ELtranspurcst(ELt,t,r,rr)*ELtransbld.l(ELt,t,r,rr))
    +sum((ELt,r,rr), ELtransconstcst(ELt,t,r,rr)*ELtransbld.l(ELt,t,r,rr))
    +sum((ELt,ELl,r,rr)$ELtransr(ELt,r,rr),
         ELtransomcst(ELt,r,rr)*ELtrans.l(ELt,ELl,t,r,rr))
  ))
;


Accounting('Cost','Total')=

Accounting('Cost','Government')

  +sum(t,(COpurchase.l(t)+COConstruct.l(t)+COOpandmaint.l(t))*COdiscfact(t))

  +sum(t,(COtranspurchase.l(t)+COtransConstruct.l(t)
         +COtransOpandmaint.l(t)+COimports.l(t))*COdiscfact(t))

  +sum((tr,rco,rrco,t)$rail(tr),rail_disc(tr,t,rco,rrco)*
         COtransbld.l(tr,t,rco,rrco)*COtransD(tr,rco,rrco)*COdiscfact(t)
  )$(COrailCFS=1)

  +sum(t,(ELImports.l(t)+ELConstruct.l(t)+ELOpandmaint.l(t))*ELdiscfact(t))

  +sum((ELpd,v,ELf,fss,cv,sulf,sox,nox,t,r)$(not ELfcoal(ELf) and not ELpcoal(Elpd)
         and ELpELf(ELpd,Elf)),
         ELAPf(ELf,fss,t,r)*
         ELfconsump.l(Elpd,v,ELf,fss,t,r)*ELdiscfact(t))

  +sum((fgc,ELpd,v,t,r)$(DeSOx(fgc) and ELpcoal(Elpd)),(
          +ELfgcbld.l(ELpd,v,fgc,t-ELfgcleadtime(fgc),r)
         )*EMfgccapexD(fgc,t)*ELdiscfact(t))
;



Accounting('Rents','Power')= Accounting('Revenue','Power') - Accounting('Cost','Power')  ;

$ontext
*        Calculations for sectors


         expenses("EL",trun) =  sum((ELpd,ELf,fss,r),ELAPf(ELf,fss,trun,r)*ELfconsump.l(ELpd,ELf,fss,trun,r))
                 + ELImports.l(trun)+ELConstruct.l(trun)+ELOpandmaint.l(trun);


         Eldemand(Ell,trun,r) = Eldemand(Ell,trun,r)+ELlchours(ELl)*ELlcgw(ELl,r)*ELdemgro(trun,r);

         ELconsump("EL",trun,r) =ELconsump("EL",trun,r)+ sum(ELl,ELlchours(ELl)*ELlcgw(ELl,r)*ELdemgro(trun,r));

         fconsump("EL",fup,trun,r) = ELfconsump.l(fup,trun,r)$ELf(fup);
         RFfconsump("EL",RFcf,trun,r) = ELfconsump.l(RFcf,trun,r)$ELf(RFcf);

         ELsupELl(Elpd,ELl,trun,r) = sum((v,ELf),ELop.l(ELpd,v,ELl,ELf,trun,r));
         ELsupELl(ELps,ELl,trun,r) = sum((v),ELsolop.l(ELps,ELl,v,trun,r));
         ELsupELl(ELp,ELl,trun,rN)= sum(r,ELsupELl(ELp,ELl,trun,r));
         ELgenELp(Elpd,trun,r) = sum((v,ELl,ELf),ELop.l(ELpd,v,ELl,ELf,trun,r));
         ELgenELp(ELps,trun,r) = sum((v,ELl),ELsolop.l(ELps,ELl,v,trun,r));
         ELgenELp(ELp,trun,rN)= sum(r,ELgenELp(ELp,trun,r));
         ELsuptot("EL",trun,rall) = sum(ELp, ELgenELp(ELp,trun,rall));

         ELcapELp(ELpd,trun,r) =
         sum(v, sum(ELpp,ELcapadd(ELpp,ELpd)*ELbld.l(ELpp,v,trun,r))+
                                ELexistcp.l(ELpd,v,trun,r));

         ELcapELp(ELps,trun,r) =
                         sum(v, ELsolbld.l(ELps,v,trun,r)+
                                ELsolexistcp.l(ELps,v,trun,r));

         ELcapELp(ELp,trun,rN) = sum(r, ELcapELp(ELp,trun,r));
         ELcap("EL",trun,r) = sum(ELp, ELcapELp(ELp,trun,r));
         ELcap("EL",trun,rN) = sum(r, ELcap("EL",trun,r));

         ELbldELp(ELp,trun,r)=0;

*         loop(trun,
                 ELbldELp(ELpd,trun,r) =
*ELbldELp(ELpd,trun-1,r)
                                         + sum(v, ELbld.l(ELpd,v,trun,r));
                 ELbldELp(ELps,trun,r) =
*ELbldELp(ELps,trun-1,r)
                                         + sum(v, ELsolbld.l(ELps,v,trun,r));
*         );

         ELbldELp(ELp,trun,rn) = sum(r,ELbldELp(ELp,trun,r));
         ELbldtot("EL",trun,r) = sum(ELp,ELbldELp(ELp,trun,r));
         ELbldtot("EL",trun,rn) = sum(r,ELbldtot("EL",trun,r));

*         ELpeakdem(trun,r) = (ELlcgw("peak",r)*ELdemgro(trun,r)
*                                         + WAELpwrdemand.l(trun,r)+PCELpwrdemand.l(trun,r));

$offtext
