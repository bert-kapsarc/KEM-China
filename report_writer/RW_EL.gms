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
ProvAvgCV(COf,trun,rco)=sum((sulf,cv,ELs),
         coaluse.l(COf,cv,sulf,trun,rco)*COcvSCE(cv))/
         sum((sulf,cv,ELs),coaluse.l(COf,cv,sulf,trun,rco));

fconsump("EL",COf,trun,r) = fconsump("EL",COf,trun,r)/ProvAvgCV(COf,trun,r);

*Electricity Production

ELgenELl(Elp,ELl,trun,r) =  (
   sum((v,ELf),ELop.l(ELp,v,ELl,ELf,trun,r))
*(1-ELparasitic(Elp,v))
*  +sum((v,ELf,fss,cv,sulf,sox,nox),
*         ELoploc.l(ELp,v,ELl,ELf,fss,cv,sulf,sox,nox,trun,r)*ELlchours(ELl))$Elpd(Elp)
*  +sum((v),ELwindop.l(ELp,v,ELl,trun,r))$Elpw(Elp)
*(1-ELparasitic(Elp,v))
*  +sum((v),ELhydop.l(ELp,v,ELl,trun,r))$(Elphyd(Elp))
*(1-ELparasitic(Elp,v))
*  -sum((v,reg,cv,sulf,SOx,NOx)$(ELpfgc(Elp,cv,sulf,SOx,NOx) and ELpcoal(Elp) and
*                 (DeSOx(sox) or DeNOx(nox))),
*         ELCOconsump.l(ELp,v,reg,cv,sulf,SOx,NOx,trun,r)*COcvSCE(cv)*
*         ELpCOparas(Elp,v,sulf,SOx,NOx,r))*ELlcnorm(ELl)
)
;
parameter   ELemc;
ELemc(Elpcoal,ELl,trun,r) =
  -sum((v,reg,cv,sulf,SOx,NOx)$(ELpfgc(Elpcoal,cv,sulf,SOx,NOx) and
                 (DeSOx(sox) or DeNOx(nox))),
         ELCOconsump.l(ELpcoal,v,reg,cv,sulf,SOx,NOx,trun,r)*COcvSCE(cv)*
         ELpCOparas(Elpcoal,v,sulf,SOx,NOx,r));


ELgenELl("Trade",ELl,trun,rr) = sum((ELt,ELll,r)$(ord(r)<>ord(rr)),Eltransyield(ELt,r,rr)*
*  ELtranscoef(ELll,ELl,r,rr)*
  ELtrans.l(ELt,ELll,trun,r,rr))
  -sum((ELt,r)$(ord(r)<>ord(rr)),ELtrans.l(ELt,ELl,trun,rr,r));

ELgenELl(ELp,ELl,trun,"China") = sum(r, ELgenELl(ELp,ELl,trun,r));


ELgenELp(ELp,trun,r) = sum(ELl, ELgenELl(ELp,ELl,trun,r));

ELgenELp(ELp,trun,"China") = sum(r, ELgenELp(ELp,trun,r));
ELgenELp('Total',trun,"China") = sum(Elp$(not ELphydsto(ELp)), ELgenELp(ELp,trun,"China"));
ELgenELp('Total',trun,r) = sum(Elp$(not ELphydsto(ELp)), ELgenELp(ELp,trun,r));

ELcapELp(ELp,trun,r) = sum(v,ELexistcp.l(ELp,v,trun,r));
*ELcapELp(ELphyd,trun,r) = sum(v,ELhydexistcp.l(ELphyd,v,trun,r));
*ELcapELp(ELpw,trun,r) = sum(v,ELwindexistcp.l(ELpw,v,trun,r));

ELbldELp(ELp,trun,r) = sum(v,ELbld.l(ELp,v,trun,r));
*ELbldELp(ELphyd,trun,r) = sum(v,ELhydbld.l(ELphyd,v,trun,r));
*ELbldELp(ELpw,trun,r) = sum(v,ELwindbld.l(ELpw,v,trun,r));


ELcapELp(ELp,trun,"China") = sum(r, ELcapELp(ELp,trun,r));
ELbldELp(ELp,trun,"China") = sum(r, ELbldELp(ELp,trun,r));


**ELgenELp("Regional supply of electricity from each plant in TWh","","") = 1;

ELtransTot(trun,r,rr) = sum((ELl,ELll,ELt),ELtrans.l(ELt,ELll,trun,r,rr));
*         ELtranscoef(ELll,ELl,r,rr));

ELtransTot(trun,r,'out') = sum(rr$(ord(rr)<>ord(r)),ELtransTot(trun,r,rr));

ELtransTot(trun,'zTotal','out') = sum(r,ELtransTot(trun,r,'out'));

ELsalesELp(ELp,v,ELl,trun,r) =

   sum((ELf)$ELpELf(ELp,ELf),
         ELop.l(ELp,v,ELl,ELf,trun,r)*(1-ELparasitic(Elp,v)))
  -sum((reg,cv,sulf,SOx,NOx)$(ELpfgc(Elp,cv,sulf,SOx,NOx) and
                 (DeSOx(sox) or DeNOx(nox))),
         ELCOconsump.l(ELp,v,reg,cv,sulf,SOx,NOx,trun,r)*COcvSCE(cv)*
         ELpCOparas(Elp,v,sulf,SOx,NOx,r))
*  +(ELhydop.l(ELp,v,ELl,trun,r)*(1-ELparasitic(Elp,v)))
*  +(ELwindop.l(ELp,v,ELl,trun,r)*(1-ELparasitic(Elp,v)))
;

ELsalesELp('All','all',ELl,trun,r) = sum((ELp,v),ELsalesELp(ELp,v,ELl,trun,r));

ELsalesELp(Elp,v,ELl,trun,'China') = sum(r,ELsalesELp(ELp,v,ELl,trun,r));

ELsalesELp('All','all',ELl,trun,'China') = sum((Elp,v),ELsalesELp(ELp,v,ELl,trun,'China'));

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




*$ontext
ELcostsELp(ELp,v,trun,r) =
ELdiscfact(trun)*(
  +sum((ELl,ELf)$ELpELf(ELp,ELf),
         ELomcst(Elp,v,r)*ELop.l(ELp,v,ELl,ELf,trun,r))

  +sum((ELl,ELf)$(ELpELf(ELp,ELf) and ELpspin(ELp)),
         ELomcst(ELp,v,r)*ELusomfrac*ELlchours(ELl)*
         ELupspincap.l(ELp,v,ELl,ELf,trun,r))

  +sum((gtyp,cv,sulf,sox,nox)$(ELpcoal(ELp) and ELpfgc(ELp,cv,sulf,sox,nox)),
         (EMfgcomcst(sox) +EMfgcomcst(nox))*
         ELCOconsump.l(ELp,v,gtyp,cv,sulf,sox,nox,trun,r)*COcvSCE(cv)/
         ELfuelburn(ELp,v,'coal',r)
  )

  +sum((gtyp,cv,sulf,sox,nox)$ELpfgc(ELp,cv,sulf,sox,nox),
   COprice.l('coal',cv,sulf,trun,r)*
   ELCOconsump.l(ELp,v,gtyp,cv,sulf,sox,nox,trun,r)
  )$ELpcoal(Elp)

  +sum((ELf,fss)$(ELpd(ELp) and not Elpcoal(ELp) and ELpfss(ELp,ELf,fss)),
         ELAPf(ELf,fss,trun,r)*ELfconsump.l(ELp,v,ELf,fss,trun,r)
  )

*  +sum(ELl,ELomcst(Elp,v,r)*ELhydop.l(ELp,v,ELl,trun,r))$ELphyd(ELp)
*  +sum(ELl,ELomcst(Elp,v,r)*ELwindop.l(ELp,v,ELl,trun,r))$ELpw(ELp)

*  +(  ELwindbld.l(ELp,v,trun-ELleadtime(Elp),r)$(vn(v) and ELpw(ELp))
*     +ELhydbld.l(ELp,v,trun-ELleadtime(Elp),r)$(vn(v) and ELphyd(ELp))
     +sum(ELpp$ELpbld(ELpp,v),ELcapadd(Elpp,ELp)*
         ELbld.l(Elpp,v,trun-ELleadtime(Elpp),r))*ELpfixedcost(ELp,v,trun,r)

*  +(  ELwindexistcp.l(ELp,v,trun,r)$(ELpw(ELp))
*     +ELhydexistcp.l(ELp,v,trun,r)$ELphyd(ELp)
*     +Elexistcp.l(ELp,v,trun,r)$ELpd(ELp)
*  )*ELpsunkcost(ELp,v,trun,r)

  +sum(fgc$((DeSOx(fgc) or DeNOx(fgc)) and ELpcoal(ELp)),
         ( ELfgcexistcp.l(ELp,v,fgc,trun,r)
          +ELfgcbld.l(ELp,v,fgc,trun-ELfgcleadtime(fgc),r))*(EMfgccapexD(fgc,trun)+EMfgcfixedOMcst(fgc))
  )
)
;

ELcostsELp('Total','All',trun,r) = sum((ELp,v),ELcostsELp(ELp,v,trun,r));

ELcostsELp(Elp,'All',trun,"China") = sum((v,r),ELcostsELp(ELp,v,trun,r));

ELtranscosts(ELt,trun,r) =
ELdiscfact(trun)*(

    +sum((rr), ELtranspurcst(ELt,trun,rr,r)*ELtransbld.l(ELt,trun,rr,r))
    +sum((rr), ELtransconstcst(ELt,trun,rr,r)*ELtransbld.l(ELt,trun,rr,r))
    +sum((ELl,rr)$ELtransr(ELt,rr,r),
         ELtransomcst(ELt,rr,r)*ELtrans.l(ELt,ELl,trun,rr,r))
  )
;

ELtranscosts('Total',trun,r) = sum(Elt,ELtranscosts(ELt,trun,r));
ELtranscosts(ELt,trun,"China") = sum(r,ELtranscosts(ELt,trun,r)) ;
ELtranscosts('Total',trun,"China") = sum(r,ELtranscosts('Total',trun,r));

ELtariffELp(ELp,v,trun,r)$(sum((ELl,ELf),ELop.l(ELp,v,ELl,ELf,trun,r))>0)
 = ELcostsELp(ELp,v,trun,r)/
( sum((ELl,ELf),ELop.l(ELp,v,ELl,ELf,trun,r)*(1-ELparasitic(Elp,v)))
 -sum((reg,cv,sulf,SOx,NOx)$(ELpfgc(ELp,cv,sulf,SOx,NOx) and Elpcoal(ELp) and
                 (DeSOx(sox) or DeNOx(nox))),
         ELCOconsump.l(Elp,v,reg,cv,sulf,SOx,NOx,trun,r)*COcvSCE(cv)*
         ELpCOparas(Elp,v,sulf,SOx,NOx,r))
)
;


*$offtext


ELdeficitELp(Elc,v,trun,r) = ELdeficit.l(Elc,v,trun,r);
ELdeficitELp('All',v,trun,r) = sum(Elp,ELdeficitELp(Elp,v,trun,r));
ELdeficitELp(Elp,v,trun,'China') = sum(r,ELdeficitELp(Elp,v,trun,r));
ELdeficitELp('All',v,trun,'China') = sum((Elp,r),ELdeficitELp(Elp,v,trun,r));
*$offtext

parameter Accounting utilities costs from the original LP's objective value
;

parameter windsubsidy_res(Elpw,v,trun,r);
windsubsidy_res(Elpw,v,trun,r)=
(
         +sum((ELl,ELf)$ELpELf(ELpw,ELf),ELop.l(ELpw,v,ELl,ELf,trun,r))*(ELtariffmax('SubcrLRG',r)-ELomcst(ELpw,v,r))
         -ELbld.l(ELpw,v,trun,r)*ELpfixedcost(ELpw,v,trun,r)$vn(v)
         -ELexistcp.l(ELpw,v,trun,r)*ELpsunkcost(ELpw,v,trun,r)
)$(ELpfit=1)  ;


Accounting('Costs','Government')=

*+sum((Elpw,v,trun,r),ELwindsub.l(Elpw,v,trun,r)-ELdeficit.l(Elpw,v,trun,r))$(ELpfit=1)

+sum((Elpw,v,ELl,ELf,trun,r)$ELpELf(ELpw,ELf),
         ELop.l(ELpw,v,ELl,ELf,trun,r)*(ELtariffmax(Elpw,r)-ELtariffmax('Ultrsc',r)))$(ELpfit=1)

+sum((Elpw,v,ELl,trun,r)$(windsubsidy_res(Elpw,v,trun,r) >0),
         windsubsidy_res(Elpw,v,trun,r) )


+sum((trun),ELwindtarget.l(trun)*
         ELwindtarget.m(trun))$(ELwtarget=1)

;


Accounting('Revenue','Coal (from power)')=

sum((COf,cv,sulf,trun,r),COdiscfact(trun)*
   ( DCOdem.l(COf,cv,sulf,trun,r)*1
      -sum(rco$(rco_r_dem(rco,r) and not r(rco) and rcodem(rco)),
        DCOsuplim.l('coal',cv,sulf,trun,rco)/num_nodes_reg(r))
   )*
sum((Elpcoal,v,gtyp,sox,nox),ELCOconsump.l(Elpcoal,v,gtyp,cv,sulf,sox,nox,trun,r))$ELfcoal(COf)
)
;

Accounting('Revenue','Coal')=


Accounting('Revenue','Coal (from power)')

+sum((COf,cv,sulf,trun,r),COdiscfact(trun)*
         COprice.l(COf,cv,sulf,trun,r)*
         OTHERCOconsumpsulf.l(COf,cv,sulf,trun,r)
)
;

Accounting('Revenue','Power')=


$ontext
sum(trun,ELdiscfact(trun)*(

  +sum((Elpd,v,ELl,ELf,r)$(not ELptariff(ELpd,v)
                 and ELpELf(ELpd,ELf)),
         ELop.l(ELpd,v,ELl,ELf,trun,r)*
         (1-ELparasitic(Elpd,v))*DELsup.l(ELl,trun,r))

  -sum((ELpcoal,v,ELl,reg,cv,sulf,SOx,NOx,r)$(ELpfgc(Elpcoal,cv,sulf,SOx,NOx) and
                 not ELptariff(ELpcoal,v) and (DeSOx(sox) or DeNOx(nox))),
         ELCOconsump.l(ELpcoal,v,reg,cv,sulf,SOx,NOx,trun,r)*COcvSCE(cv)*
         ELpCOparas(Elpcoal,v,sulf,SOx,NOx,r)*ELlcnorm(Ell)*DELsup.l(ELl,trun,r))

  +sum((ELphyd,v,ELl,r)$(not ELptariff(ELphyd,v)),ELhydop.l(ELphyd,v,ELl,trun,r)*
         (1-ELparasitic(Elphyd,v))*DELsup.l(ELl,trun,r))

  +sum((ELpw,v,ELl,r)$(not ELptariff(ELpw,v)),ELwindop.l(ELpw,v,ELl,trun,r)*
                 (1-ELparasitic(Elpw,v))*DELsup.l(ELl,trun,r))

  +sum(grid,sum(r$rgrid(r,grid),
          sum((ELpd,v)$(not ELptariff(ELpd,v)), Elexistcp.l(ELpd,v,trun,r))
         +sum((ELpd,v,Elppd)$(not ELptariff(ELpd,v)),
                 ELcapadd(Elppd,ELpd)*ELbld.l(Elppd,v,trun-ELleadtime(Elppd),r))
         +sum((ELphyd,v)$(not ELptariff(ELphyd,v)),
                  ELhydexistcp.l(ELphyd,v,trun,r)
                 +ELhydbld.l(ELphyd,v,trun-ELleadtime(ELphyd),r)$vn(v))
  )*DELrsrvreq.l(trun,grid))

  +sum((ELl,r),
         sum((ELpd,v,ELf)$(not ELptariff(ELpd,v)),
                 ELupspincap.l(ELpd,v,ELl,ELf,trun,r)*(1-ELparasitic(Elpd,v))
         )*DELupspinres.l(ELl,trun,r))


))
$offtext

+sum((ELp,v,trun,r),ELcostsELp(ELp,v,trun,r))

+Accounting('Costs','Government')

;



$ontext
Accounting('Revenue','Power onsite')=

sum(trun,ELdiscfact(trun)*(
  +sum((Elpd,v,ELl,ELf,fss,cv,sulf,sox,nox,r)$(not ELpnuc(ELpd) and
                 ELpELf(ELpd,ELf,fss,cv,sulf,sox,nox)),
         ELoploc.l(ELpd,v,ELl,ELf,fss,cv,sulf,sox,nox,trun,r)*(
                  ELpcost(Elpd,v,sox,nox,trun,r)*ELlchours(ELl)
                 +ELpsunkcost(ELpd,v,trun,r)
         )
  )
))
$offtext

;


Accounting('Costs','Power')=
+sum(trun,
   sum((ELp,v,r)$ELpbld(ELp,v),ELpurcst(ELp,trun,r)*ELbld.l(ELp,v,trun,r))

  +sum((ELpcoal,v,fgc,r)$(DeSOx(fgc) or DeNOx(fgc)),
         ELfgcbld.l(ELpcoal,v,fgc,trun,r)*EMfgccapexD(fgc,trun) )

  +sum((ELpcoal,v,fgc,r)$(DeSOx(fgc) or DeNOx(fgc)),
         ELfgcbld.l(ELpcoal,v,fgc,trun,r)*EMfgcfixedOMcst(fgc) )

  +sum((ELp,v,r)$ELpbld(ELp,v),ELconstcst(ELp,trun,r)*ELbld.l(ELp,v,trun,r))


  +sum((Elp,v,ELl,ELf,r)$ELpELf(ELp,ELf),
         ELomcst(Elp,v,r)*(
                 ELop.l(ELp,v,ELl,ELf,trun,r)
                 +ELusomfrac*ELlchours(ELl)*
                 ELupspincap.l(Elp,v,ELl,ELf,trun,r)$ELpspin(Elp)
         )
  )

  +sum((ELpd,v,gtyp,cv,sulf,sox,nox,r)$(ELpcoal(ELpd) and
                                         ELpfgc(ELpd,cv,sulf,sox,nox)),
         (EMfgcomcst(sox)+EMfgcomcst(nox))*
         ELCOconsump.l(ELpd,v,gtyp,cv,sulf,sox,nox,trun,r)*COcvSCE(cv)/
         ELfuelburn(ELpd,v,'coal',r)
  )


  +sum((ELp,v,r)$ELpbld(ELp,v),
         ELfixedOMcst(ELp)*ELbld.l(ELp,v,trun-ELleadtime(ELp),r))

  +sum((ELpd,v,ELf,fss,r)$(not ELfcoal(ELf) and not ELpcoal(Elpd)),
         +ELAPf(ELf,fss,trun,r)*
         ELfconsump.l(ELpd,v,ELf,fss,trun,r))

)

  +Accounting('Revenue','Coal (from power)')


;

Accounting('Costs','Coal')=

  +sum(trun,(COpurchase.l(trun)+COConstruct.l(trun)+COOpandmaint.l(trun))*
         COdiscfact(trun))


  +sum((tr,rco,rrco,trun)$(COrailCFS=1),rail_disc(tr,trun,rco,rrco)*
         COtransD(tr,rco,rrco)*COtransbld.l(tr,trun,rco,rrco)*COdiscfact(trun))

  +sum(trun,(COtranspurchase.l(trun)+COtransConstruct.l(trun)
         +COtransOpandmaint.l(trun)+COimports.l(trun))*COdiscfact(trun))

;


Accounting('Costs','State Owned Utility')=
         Accounting('Revenue','Power')
  +sum(trun,ELdiscfact(trun)*(

    +sum((ELt,r,rr), ELtranspurcst(ELt,trun,r,rr)*ELtransbld.l(ELt,trun,r,rr))
    +sum((ELt,r,rr), ELtransconstcst(ELt,trun,r,rr)*ELtransbld.l(ELt,trun,r,rr))
    +sum((ELt,ELl,r,rr)$ELtransr(ELt,r,rr),
         ELtransomcst(ELt,r,rr)*ELtrans.l(ELt,ELl,trun,r,rr))
  ))
;


Accounting('Costs','Total')=

*Accounting('Costs','Government')

  +sum(trun,(COpurchase.l(trun)+COConstruct.l(trun)+COOpandmaint.l(trun))*COdiscfact(trun))

  +sum(trun,(COtranspurchase.l(trun)+COtransConstruct.l(trun)
         +COtransOpandmaint.l(trun)+COimports.l(trun))*COdiscfact(trun))

  +sum((tr,rco,rrco,trun)$rail(tr),rail_disc(tr,trun,rco,rrco)*
         COtransbld.l(tr,trun,rco,rrco)*COtransD(tr,rco,rrco)*COdiscfact(trun)
  )$(COrailCFS=1)

  +sum(trun,(ELImports.l(trun)+ELConstruct.l(trun)+ELOpandmaint.l(trun))*ELdiscfact(trun))

  +sum((ELpd,v,ELf,fss,trun,r)$(ELpELf(ELpd,ELf) and not Elpcoal(ELpd)),
         ELAPf(ELf,fss,trun,r)*
         ELfconsump.l(Elpd,v,ELf,fss,trun,r)*ELdiscfact(trun))
;



Accounting('Rents','Power')= Accounting('Revenue','Power') - Accounting('Costs','Power')  ;

Accounting('Costs','Losses')=  sum((v,trun),ELdeficitELp('All',v,trun,'China') );


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
