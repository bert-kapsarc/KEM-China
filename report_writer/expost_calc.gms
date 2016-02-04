
         socialcost=
 ( sum(trun,
*Upstream
 fImports.l(trun)+fConstruct.l(trun)+fOpandmaint.l(trun)
 +sum((fup,r),fuelcst(fup,trun)*fueluse.l(fup,trun,r))
*Petchem
 +PCImports.l(trun)+PCConstruct.l(trun)+PCOpandmaint.l(trun)
 -sum((ELl,r),PCELconsump.l(ELl,trun,r)*PCELprice)
*Power
 +sum((ELpd,v,r),(ELpurcst(ELpd,trun,r)+ELfixedOMcst(ELpd)+ELconstcst(ELpd,trun,r))*ELbld.l(ELpd,v,trun,r))
 +sum((r,rr),(ELtransconstcst(r,trun,rr)+ELtranspurcst(r,trun,rr))*ELtransbld.l(trun,r,rr))
 +sum((ELps,v,r),(ELpurcst(ELps,trun,r)+ELfixedOMcst(ELps)+ELconstcst(ELps,trun,r))*ELsolbld.l(ELps,v,trun,r))
 +ELOpandmaint.l(trun)
*Water
 +sum((WAp,v,r),(WApurcst(WAp,trun,r)+WAfixedOMcst(WAp)+WAconstcst(WAp,trun,r))*WAbld.l(WAp,v,trun,r))
 +sum((r,rr),(WAtransconstcst(trun,r,rr)+WAtranspurcst(trun,r,rr))*WAtransbld.l(trun,r,rr))
* +sum(rr,(WAstoconstcst(trun,rr)+WAstopurcst(trun,rr))*WAstobld.l(trun,rr))
+WAopandmaint.l(trun)
*Cement

 +CMImports.l(trun)+CMConstruct.l(trun)+CMOpandmaint.l(trun)
 -sum((ELl,r),CMELconsump.l(ELl,trun,r)*CMELprice)
*Refining
 +RFImports.l(trun)+RFConstruct.l(trun)+RFOpandmaint.l(trun)
 -sum((RFci,r),RFPCprice(RFci,trun,r)*RFPCconsump.l(RFci,trun,r))
 -sum((ELl,r),RFELconsump.l(ELl,trun,r)*RFELprice)))/1;
;


         subsidycost=
 sum((trun,v,r),
    sum(ELpdsub,(ELpurcst(ELpdsub,trun,r)+ELconstcst(ELpdsub,trun,r))
         *ELbld.l(ELpdsub,v,trun,r)*(subsidy.l(trun)+gamma_sub(ELpdsub,trun)))
  + sum(ELpssub,(ELPurcst(ELpssub,trun,r)+ELconstcst(ELpssub,trun,r))
         *ELsolbld.l(ELpssub,v,trun,r)*(subsidy.l(trun)+gamma_sub(ELpssub,trun)))
  + sum(WApsub,(WApurcst(WApsub,trun,r)+WAconstcst(WApsub,trun,r))
         *WAbld.l(WApsub,v,trun,r)*(subsidy.l(trun)+gamma_sub("CC",trun)))

 );

         exportrevenue=
*Upstream
( sum((fup,trun,r),fintlprice(fup,trun)*fExports.l(fup,trun,r))
*Petchem
+sum((PCi,trun,r),PCintlprice(PCi,trun)*PCExports.l(PCi,trun,r))
*Refining
+sum((RFcf,trun,r),RFintlprice(RFcf,trun)*RFExports.l(RFcf,trun,r))
*Cement
+sum((CMcf,trun,r),CMintlprice(CMcf,trun)*CMExports.l(CMcf,trun,r)))/1;
;

         econgain = exportrevenue-socialcost-
                 (exportrevenu_base - socialcost_base);
* Trillion BTU per unit of fuel:
* Energy density of Arab Light and Araby Heavy are from KFUPM Report (p. 10-8).
;
         Energycontent=sum((fup,trun,r),
         Fuelencon1(fup)*(fueluse.l(fup,trun,r)-fExports.l(fup,trun,r)));



******************Upstream and refining;

         upRFcost=
 ( sum(trun,
*Upstream
 fImports.l(trun)+fConstruct.l(trun)+fOpandmaint.l(trun)
 +sum((fup,r),fuelcst(fup,trun)*(fueluse.l(fup,trun,r)))
*Refining
 +RFImports.l(trun)+RFConstruct.l(trun)+RFOpandmaint.l(trun)
 ))/1;
;

         upRFrevenue=

( sum((fup,trun,r),fintlprice(fup,trun)*fExports.l(fup,trun,r))

+sum((RFcf,trun,r),RFintlprice(RFcf,trun)*RFExports.l(RFcf,trun,r))


+( sum((f,trun,r),fAP(f,trun)*(
          ELfconsump.l(f,trun,r)$ELf(f)
         +WAfconsump.l(f,trun,r)$WAf(f)
         +(PCfconsump.l(f,trun,r)*PCfconv(f))$PCm(f)
         +CMfconsump.l(f,trun,r)$CMf(f) ) )

  )$(deregulated<>1)


+( sum((fup,trun,rr),Dfdem.l(fup,trun,rr)*(1-subsidy.l(trun)$(partialdereg=1))*(
          ELfconsump.l(fup,trun,rr)$ELf(fup)
         +WAfconsump.l(fup,trun,rr)$WAf(fup)
         +CMfconsump.l(fup,trun,rr)$CMf(fup)
) )
  +sum((RFcf,trun,rr),DRFdem.l(RFcf,trun,rr)*(1-subsidy.l(trun)$(partialdereg=1))*(
          ELfconsump.l(RFcf,trun,rr)$ELf(RFcf)
         +WAfconsump.l(RFcf,trun,rr)$WAf(RFcf)
         +CMfconsump.l(RFcf,trun,rr)$CMf(RFcf) ) )

  +sum((fup,trun,rr)$PCm(fup),Dfdem.l(fup,trun,rr)*
         (1-subsidy.l(trun)$(partialdereg=1)$PCfsub(fup))
                         *PCfconsump.l(fup,trun,rr)*fPCconv(fup))
  +sum((RFcf,trun,rr)$(PCm(RFcf)),
         DRFdem.l(RFcf,trun,rr)*PCfconsump.l(RFcf,trun,rr))
 )$(deregulated=1)

)/1;
;

         upRFecongain = upRFrevenue-upRFcost-
                 (upRFrevenu_base - upRFcost_base);



****************** Govt

         Govtcost =  sum(trun,
    sum((ELpd,v,r)$ELpdsub(Elpd),(subsidy.l(trun)+gamma_sub(ELpd,trun))*(ELpurcst(ELpd,trun,r)+ELconstcst(ELpd,trun,r))*ELbld.l(ELpd,v,trun,r))
  + sum((ELps,v,r)$ELpssub(Elps),(subsidy.l(trun)+gamma_sub(ELps,trun))*(ELPurcst(ELps,trun,r)+ELconstcst(ELps,trun,r))*ELsolbld.l(ELps,v,trun,r))
  + sum((WAp,v,r)$WApsub(WAp),(subsidy.l(trun)+gamma_sub("CC",trun))*(WApurcst(WAp,trun,r)+WAconstcst(WAp,trun,r))*WAbld.l(WAp,v,trun,r))
                         );


         Govtrevenue = 0;
$ontext
 sum((fup,trun,r),fintlprice(fup,trun)*fExports.l(fup,trun,r))


+( sum((fup,trun,r)$ch4_c2h6(fup) ,fAP(fup,trun)*(
          ELfconsump.l(fup,trun,r)
         +WAfconsump.l(fup,trun,r)
         +(PCfconsump.l(fup,trun,r)*PCfconv(fup))
         +CMfconsump.l(fup,trun,r)
) )
  )$(deregulated<>1)


+( sum((fup,trun,rr)$ch4_c2h6(fup),Dfdem.l(fup,trun,rr)*(1-subsidy.l(trun)$(partialdereg=1))*(
          ELfconsump.l(fup,trun,rr)
         +WAfconsump.l(fup,trun,rr)
         +CMfconsump.l(fup,trun,rr)
) )

  +sum((fup,trun,rr)$(PCm(fup) and ch4_c2h6(fup) ),Dfdem.l(fup,trun,rr)*
         (1-subsidy.l(trun)$(partialdereg=1)$PCfsub(fup))
                         *PCfconsump.l(fup,trun,rr)*fPCconv(fup))
 )$(deregulated=1)
;
$offtext
         Govtecongain = 0.9 * upRFecongain   -(Govtcost-Govtcost_base);

         upRFecongain =  0.1 * upRFecongain;


******************refining;



         RFcost=

 sum(trun,RFImports.l(trun)+RFConstruct.l(trun)+RFOpandmaint.l(trun)
 );
;

         RFrevenue=

+sum((RFcf,trun,r),RFintlprice(RFcf,trun)*RFExports.l(RFcf,trun,r))


+( sum((RFcf,trun,r),fAP(RFcf,trun)*(
          ELfconsump.l(RFcf,trun,r)$ELf(RFcf)
         +WAfconsump.l(RFcf,trun,r)$WAf(RFcf)
         +(PCfconsump.l(RFcf,trun,r)*PCfconv(RFcf))$PCm(RFcf)
         +CMfconsump.l(RFcf,trun,r)$CMf(RFcf) ) )

  )$(deregulated<>1)


+(
  sum((RFcf,trun,rr),DRFdem.l(RFcf,trun,rr)*(1-subsidy.l(trun)$(partialdereg=1))*(
          ELfconsump.l(RFcf,trun,rr)$ELf(RFcf)
         +WAfconsump.l(RFcf,trun,rr)$WAf(RFcf)
         +CMfconsump.l(RFcf,trun,rr)$CMf(RFcf) ) )

  +sum((RFcf,trun,rr)$(PCm(RFcf)),
         DRFdem.l(RFcf,trun,rr)*PCfconsump.l(RFcf,trun,rr))
 )$(deregulated=1)
;

         RFecongain = RFrevenue-RFcost-
                 (RFrevenu_base - RFcost_base);





******************power;


         ELcost=
 ( sum(trun,
*Power
  sum((ELpd,v,r),(1-(subsidy.l(trun)+gamma_sub(ELpd,trun))$Elpdsub(ELpd))*(ELpurcst(ELpd,trun,r)+ELconstcst(ELpd,trun,r))*ELbld.l(ELpd,v,trun,r)+ELbld.l(ELpd,v,trun,r)*ELfixedOMcst(ELpd))
 +sum((ELps,v,r),(1-(subsidy.l(trun)+gamma_sub(ELps,trun))$Elpssub(ELps))*(ELPurcst(ELps,trun,r)+ELconstcst(ELps,trun,r))*ELsolbld.l(ELps,v,trun,r)+ELsolbld.l(ELps,v,trun,r)*ELfixedOMcst(ELps))
 +sum((r,rr),(ELtransconstcst(r,trun,rr)+ELtranspurcst(r,trun,rr))*ELtransbld.l(trun,r,rr))
 +ELOpandmaint.l(trun)

 +sum((ELf,r),ELfconsump.l(ELf,trun,r)*ELAPf(ELf,trun,r))$(deregulated<>1)
 +sum((ELf,r),ELfconsump.l(ELf,trun,r)*(1-subsidy.l(trun)$(partialdereg=1))*
         (Dfdem.l(ELf,trun,r)$ELfup(ELf)+
          DRFdem.L(ELf,trun,r)$ELfref(ELf)) )$(deregulated=1)

 +sum((ELl,r),WAELsupply.l(ELl,trun,r)*ELAPELwa(ELl,trun,r))
))/1;
;

ELrevenue=sum((ELl,trun,r),PCELconsump.l(ELl,trun,r)*PCELprice)
+sum((ELl,trun,r),RFELconsump.l(ELl,trun,r)*RFELprice)
+sum((ELl,trun,r),CMELconsump.l(ELl,trun,r)*CMELprice)
+sum((ELl,trun,r),WAELconsump.l(ELl,trun,r)*DELsup.l(ELl,trun,r));

         ELecongain = ELrevenue-ELcost-
                 (ELrevenu_base - ELcost_base);


*****************water;



         WAcost=
 ( sum(trun,
*Water
  sum((WAp,v,r),(1-(subsidy.l(trun)+gamma_sub("CC",trun))$WApsub(WAp))*(WApurcst(WAp,trun,r)+WAconstcst(WAp,trun,r))*WAbld.l(WAp,v,trun,r)+WAbld.l(WAp,v,trun,r)*WAfixedOMcst(WAp))
* sum((WAp,v,r),(WApurcst(WAp,trun,r)+WAconstcst(WAp,trun,r))*WAbld.l(WAp,v,trun,r))
 +sum((r,rr),(WAtransconstcst(trun,r,rr)+WAtranspurcst(trun,r,rr))*WAtransbld.l(trun,r,rr))
* +sum(rr,(WAstoconstcst(trun,rr)+WAstopurcst(trun,rr))*WAstobld.l(trun,rr))
+WAopandmaint.l(trun)

+sum((ELl,r),WAELconsump.l(ELl,trun,r)*DELsup.l(ELl,trun,r))


 +sum((waf,r),wafconsump.l(waf,trun,r)*WAAPf(waf,trun,r))$(deregulated<>1)
 +sum((waf,r),wafconsump.l(waf,trun,r)*(1-subsidy.l(trun)$(partialdereg=1))*
         ( Dfdem.l(waf,trun,r)$wafup(waf)
          +DRFdem.l(waf,trun,r)$wafref(waf)) )$(deregulated=1)
))/1;

*We don't have the explicit use of water by sector, and therefore the revenues of unchanging exogenous water demand will cancel out below;
WArevenue=sum((ELl,trun,r),WAELsupply.l(ELl,trun,r)*ELAPELwa(ELl,trun,r))  ;



         WAecongain = WArevenue-WAcost-
                 (WArevenu_base - WAcost_base);



*****************Petchem;



         PCcost=
 ( sum(trun,
*Petchem
 PCImports.l(trun)+PCConstruct.l(trun)+PCOpandmaint.l(trun)


 +sum((PCm,r),PCfconsump.l(PCm,trun,r)*pcfeedcst(PCm,trun,r))$(deregulated<>1)
 +sum((PCm,r)$(PCmup(PCm) and PCmsub(PCm)),PCfconsump.l(PCm,trun,r)*Dfdem.l(PCm,trun,r)*PCfconv(PCm)*(1-subsidy.l(trun)$(partialdereg=1)))$(deregulated=1)
 +sum((PCm,r)$(PCmup(PCm) and PCmnsub(PCm)),PCfconsump.l(PCm,trun,r)*Dfdem.l(PCm,trun,r)*PCfconv(PCm))$(deregulated=1)
 +sum((PCm,r)$PCmref(PCm),DRFdem.l(PCm,trun,r)*pcfconsump.l(PCm,trun,r))$(deregulated=1)

))/1;
;

         pcrevenue=
*Petchem
(sum((PCi,trun,r),PCintlprice(PCi,trun)*PCExports.l(PCi,trun,r))
+Sum((RFci,trun,r)$RFMTBE(RFci),RFPCconsump.l(RFci,trun,r)*RFPCprice(RFci,trun,r)))


/1;
;

         PCecongain = PCrevenue-PCcost-
                 (PCrevenu_base - PCcost_base);



********************CEMENT;



         CMcost=
 ( sum(trun,
*Cement
 CMImports.l(trun)+CMConstruct.l(trun)+CMOpandmaint.l(trun)

 +sum((CMf,r),CMfconsump.l(CMf,trun,r)*CMAPf(CMf,trun,r))$(deregulated<>1)
 +sum((CMf,r)$CMfup(CMf),CMfconsump.l(CMf,trun,r)*Dfdem.l(CMf,trun,r)*(1-subsidy.l(trun)$(partialdereg=1)))$(deregulated=1)
 +sum((CMf,r)$CMfref(CMf),DRFdem.l(CMf,trun,r)*(1-subsidy.l(trun)$(partialdereg=1))*CMfconsump.l(CMf,trun,r))$(deregulated=1)

))/1;
;


         CMrevenue=
*Cement
sum((CMcf,trun,r),CMintlprice(CMcf,trun)*CMExports.l(CMcf,trun,r))/1;
;

         CMecongain = CMrevenue-CMcost-
                 (CMrevenu_base - CMcost_base);


**************************Other


         Othercost=
+( sum((f,trun,r),fAP(f,trun)*(OTHERfconsump(f,trun,r) ) )

  )$(deregulated<>1)


+( sum((fup,trun,rr),Dfdem.l(fup,trun,rr)*(1-subsidy.l(trun)$(partialdereg=1))*(
         +OTHERfconsump(fup,trun,rr) ) )
 )$(deregulated=1) ;
