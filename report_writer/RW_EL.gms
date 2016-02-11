*Fuel Consumption
fconsump("EL",ELf,trun,r) =
   sum((Elpd,v,fss),ELfconsump.l(ELpd,v,ELf,fss,trun,r))
;


fconsump("EL",'coal_sce',trun,r) =
         sum((ELpcoal,v,cv,sulf,sox,nox),
                 ELCOconsump.l(ELpcoal,v,cv,sulf,sox,nox,trun,r)*COcvSCE(cv));

fconsump("EL",ELf,trun,"China") = sum(r,fconsump("EL",ELf,trun,r)) ;
fconsump("EL",'coal_sce',trun,"China") = sum(r,fconsump("EL",'coal_sce',trun,r));

parameter ProvAvgCV(COf,trun,rco);
ProvAvgCV(COf,trun,rco)=sum((ash,sulf,cv,ELs),
         coaluse.l(COf,cv,sulf,ELs,trun,rco)*COcvSCE(cv))/
         sum((ash,sulf,cv,ELs),coaluse.l(COf,cv,sulf,ELs,trun,rco));

fconsump("EL",COf,trun,r) = fconsump("EL",COf,trun,r)/ProvAvgCV(COf,trun,r);

*Electricity Production

ELgenELl(Elp,ELl,trun,r) =  (
   sum((v,ELf,fss,cv,sulf,sox,nox),
      ELop.l(ELp,v,ELl,ELf,fss,cv,sulf,sox,nox,trun,r))$Elpd(Elp)
*
*ELpCOparas(Elp,v,sulf,sox,nox)
*  +sum((v,ELf,fss,cv,sulf,sox,nox),
*         ELoploc.l(ELp,v,ELl,ELf,fss,cv,sulf,sox,nox,trun,r))$Elpd(Elp)
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




ELcostsELp(ELpd,v,t,r)$(sum((ELl,ELf,fss,cv,sulf,sox,nox),
                         ELop.l(ELpd,v,ELl,ELf,fss,cv,sulf,sox,nox,t,r))>0) =
ELdiscfact(t)*(
  +sum((ELl,ELf,fss,cv,sulf,sox,nox)$ELpELf(ELpd,ELf,fss,cv,sulf,sox,nox),
     ELpcost(Elpd,v,sox,nox,t,r)*ELop.l(ELpd,v,ELl,ELf,fss,cv,sulf,sox,nox,t,r)


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

  +(ELexistcp.l(ELpd,v,t,r)
    -sum((ELl,ELf,fss,cv,sulf,sox,nox)$(ELpELf(ELpd,ELf,fss,cv,sulf,sox,nox)),
          ELupspincap.l(Elpd,v,ELl,ELf,fss,cv,sulf,sox,nox,t,r)$(ELpspin(ELpd))
*         +ELoploc.l(ELpd,v,ELl,ELf,fss,cv,sulf,sox,nox,t,r)$(not ELpnuc(ELpd))
    )
  )*ELpsunkcost(ELpd,v,t,r)


  +sum(fgc,( ELfgcexistcp.l(ELpd,v,fgc,t,r)
    +ELfgcbld.l(ELpd,v,fgc,t-ELfgcleadtime(fgc),r)
   )*EMfgccapexD(fgc,t))$(ELpcoal(ELpd))
)
;


ELcostsELp(ELpw,v,t,r)=ELdiscfact(t)*(

  +sum((ELl,vv),ELwindop.l(ELpw,vv,ELl,t,r)*ELomcst(ELpw,vv,r))

  +sum((ELpd,vv,ELl,ELf,fss,cv,sulf,sox,nox)$(Elpspin(Elpd)
                                 and ELpELf(ELpd,ELf,fss,cv,sulf,sox,nox)),
       ELupspincap.l(Elpd,vv,ELl,ELf,fss,cv,sulf,sox,nox,t,r)*(
          ELpcost(Elpd,v,sox,nox,t,r)*ELlchours(ELl)*ELusrfuelfrac
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
)$vn(v)
;


ELcostsELp(ELphyd,v,t,r)=ELdiscfact(t)*(
  +ELomcst(ELphyd,v,r)*sum(ELl,ELhydop.l(ELphyd,v,ELl,t,r))
  +(ELhydbld.l(ELphyd,v,t-ELleadtime(ELphyd),r)+ELhydexistcp.l(ELphyd,v,t,r))*
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


scalar total_cost
parameter Accounting utilities costs from the original LP's objective value
;

Accounting('Cost','Total')=

  +sum(t,(COpurchase.l(t)+COConstruct.l(t)+COOpandmaint.l(t))*COdiscfact(t))

  +sum(t,(COtranspurchase.l(t)+COtransConstruct.l(t)
         +COtransOpandmaint.l(t)+COimports.l(t))*COdiscfact(t))

  +sum((tr,rco,rrco,t)$rail(tr),rail_disc(tr,t,rco,rrco)*
         COtransbld.l(tr,t,rco,rrco)*COtransD(tr,rco,rrco)*COdiscfact(t)
  )$(COrailCFS=1)

  +sum(t,(ELImports.l(t)+ELConstruct.l(t)+ELOpandmaint.l(t))*ELdiscfact(t))

  +sum((ELpd,v,ELf,fss,cv,sulf,sox,nox,t,r)$(not ELfcoal(ELf) and not ELpcoal(Elpd)
         and ELpELf(ELpd,Elf,fss,cv,sulf,sox,nox)),
         ELAPf(ELf,fss,t,r)*
         ELfconsump.l(Elpd,v,ELf,fss,t,r)*ELdiscfact(t))

  +sum((fgc,ELpd,v,t,r)$(DeSOx(fgc) and ELpcoal(Elpd)),(
          +ELfgcbld.l(ELpd,v,fgc,t-ELfgcleadtime(fgc),r)
         )*EMfgccapexD(fgc,t)*ELdiscfact(t))
;


Accounting('Revenue','Coal Power')=

sum(t,COdiscfact(t)*(
  +sum((ELpcoal,v,ELf,fss,cv,sulf,sox,nox,r)$ELpELf(ELpcoal,Elf,fss,cv,sulf,sox,nox),
    ( DCOdem.l('coal',cv,sulf,'summ',t,r)*1
      -sum(rco$(rco_dem(rco,r) and not r(rco) and rcodem(rco)),
        DCOsuplim.l('coal',cv,sulf,'summ',t,rco)*Elsnorm('summ')/num_nodes_reg(r))
    )*ELCOconsump.l(ELpcoal,v,cv,sulf,sox,nox,t,r)
  )
))
;

Accounting('Revenue','Power')=

sum(t,ELdiscfact(t)*(

  +sum((r,grid)$rgrid(r,grid),DELrsrvreq.l(t,grid)*ELreserve*ELlcgw(r,'LS1')*ELdemgro('LS1',t,r))

  +sum((Elpd,v,ELl,ELf,fss,cv,sulf,sox,nox,r)$(not ELptariff(ELpd,v)
                 and ELpELf(ELpd,ELf,fss,cv,sulf,sox,nox)),
         ELop.l(ELpd,v,ELl,ELf,fss,cv,sulf,sox,nox,t,r)*
         ELpCOparas(Elpd,v,sulf,sox,nox)*DELsup.l(ELl,t,r))

  +sum((ELphyd,v,ELl,r)$(not ELptariff(ELphyd,v)),ELhydop.l(ELphyd,v,ELl,t,r)*
         ELparasitic(Elphyd,v)*DELsup.l(ELl,t,r))

  +sum((ELpw,v,ELl,r)$(not ELptariff(ELpw,v)),ELwindop.l(ELpw,v,ELl,t,r)*
         ELparasitic(Elpw,v)*DELsup.l(ELl,t,r))

))

+sum((ELp,v,t,r)$ELptariff(ELp,v),ELcostsELp(ELp,v,t,r))

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



Accounting('Cost','Power')=

Accounting('Revenue','Coal Power')

+sum(t,ELdiscfact(t)*(

   ELImports.l(t)+ELConstruct.l(t)+ELOpandmaint.l(t)

  -sum((ELt,r,rr), ELtranspurcst(ELt,t,r,rr)*ELtransbld.l(ELt,t,r,rr))
  -sum((ELt,r,rr), ELtransconstcst(ELt,t,r,rr)*ELtransbld.l(ELt,t,r,rr))
  -sum((ELt,ELl,r,rr)$ELtransr(ELt,r,rr),
         ELtransomcst(ELt,r,rr)*ELtrans.l(ELt,ELl,t,r,rr))

  +sum((ELpd,v,ELf,fss,cv,sulf,sox,nox,r)$(not ELfcoal(ELf) and not ELpcoal(Elpd)
         and ELpELf(ELpd,Elf,fss,cv,sulf,sox,nox)),
         ELAPf(ELf,fss,t,r)*
         ELfconsump.l(Elpd,v,ELf,fss,t,r))

  +sum((fgc,ELpd,v,r)$(DeSOx(fgc) and ELpcoal(Elpd)),
          ELfgcbld.l(ELpd,v,fgc,t-ELfgcleadtime(fgc),r)*EMfgccapexD(fgc,t)
  )

))

;

Accounting('Cost','Coal')=

  +sum(t,(COpurchase.l(t)+COConstruct.l(t)+COOpandmaint.l(t))*COdiscfact(t))

  +sum(t,(COtranspurchase.l(t)+COtransConstruct.l(t)
         +COtransOpandmaint.l(t)+COimports.l(t))*COdiscfact(t))

;


Accounting('Cost','Utility')=
         Accounting('Revenue','Power')
  +sum(t,ELdiscfact(t)*(

    +sum((ELt,r,rr), ELtranspurcst(ELt,t,r,rr)*ELtransbld.l(ELt,t,r,rr))
    +sum((ELt,r,rr), ELtransconstcst(ELt,t,r,rr)*ELtransbld.l(ELt,t,r,rr))
    +sum((ELt,ELl,r,rr)$ELtransr(ELt,r,rr),
         ELtransomcst(ELt,r,rr)*ELtrans.l(ELt,ELl,t,r,rr))
  ))
;

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
