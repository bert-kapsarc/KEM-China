*$include SetsandVariables
*$INCLUDE RW_param.gms
$ontext
Eldemand(Ell,trun,rall) = 0;
Elconsump(sectors,trun,rall) = 0;
fconsump(sectors,fup,trun,rall) = 0;
RFfconsump(sectors,RFcf,trun,rall) =0;
ELsuptot(sectors,trun,rall)=0;
$offtext

*$INCLUDE RW_WAcalc.gms
*$INCLUDE RW_ELcalc.gms
*$INCLUDE RW_CMcalc.gms
$INCLUDE COcalc.gms


*$GDXIN integrated.gdx
*$LOAD WAop = WAop WAVop=WAVop ELop = ELop ELsolop=ELsolop
* ELbld=ELbld ELexistcp=ELexistcp ELsolbld=ELsolbld ELsolexistcp=ELsolexistcp


$INCLUDE CO_createXLS.gms


$ontext
********************************************************************************
*        sum over sectors, regions, fuel types to get aggregate quantities
         expenses("ALL",trun) = sum(sect,expenses(sect,trun));


         ELsuptot("ALL",trun,rall) = sum(sect,ELsuptot(sect,trun,rall));


         Eldemand(Ell,trun,r) = Eldemand(Ell,trun,r)
                                         +PCELconsump.l(ELl,trun,r)
                                         +RFELconsump.l(ELl,trun,r);

         ELconsump("PC",trun,r) = sum(Ell,PCELconsump.l(ELl,trun,r));
         ELconsump("RF",trun,r) = sum(Ell,RFELconsump.l(ELl,trun,r));

         ELconsump(sectors,trun,rN) = sum(r,ELconsump(sectors,trun,r));
         ELconsump("ALL",trun,rall) = sum(sect,ELconsump(sect,trun,rall));

         fconsump("PC",fup,trun,r) = PCfconsump.l(fup,trun,r)*fPCconv(fup)$PCm(fup) ;
         fconsump("RF",fup,trun,r) = RFcrconsump.l(fup,trun,r)*fRFconv(fup)$RFf(fup);
         fconsump("other",fup,trun,r) = OTHERfconsump(fup,trun,r);
         fconsump(sectors,fup,trun,rN) = sum(r,fconsump(sectors,fup,trun,r));
         fconsump("ALL",fup,trun,rall) = sum(sect,fconsump(sect,fup,trun,rall));

         fconsumpMMBTU(sectors,trun,rall) = sum(fup,fconsump(sectors,fup,trun,rall)*Fuelencon1(fup));
         fconsumpMMBTU(sectors,trun,rN) = sum(r,fconsumpMMBTU(sectors,trun,r));

         RFfconsump("PC",RFcf,trun,r) = PCfconsump.l(RFcf,trun,r)$PCm(RFcf) ;
         RFfconsump("RF",RFcf,trun,r) = RFcrconsump.l(RFcf,trun,r)$RFf(RFcf);

         RFfconsump(sectors,RFcf,trun,rN) = sum(r,RFfconsump(sectors,RFcf,trun,r));

         RFfconsump("ALL",RFcf,trun,rall) = sum(sect,RFfconsump(sect,RFcf,trun,rall));
         RFfconsumpMMBTU(sectors,trun,r) = sum(RFcf,RFfconsump(sectors,RFcf,trun,r)*Fuelencon1(RFcf));

         ELcap("ALL",trun,rall) = sum(sectors,ELcap(sectors,trun,rall));
         ELbldtot("ALL",trun,rall) = sum(sect,ELbldtot(sect,trun,rall));


********************************************************************************

         totalenergy = sum((trun,r,fup),(fueluse.l(fup,trun,r)-fExports.l(fup,trun,r))*Fuelencon1(fup));
         totalcrude = sum((crude,trun,r),(fueluse.l(crude,trun,r)-fExports.l(crude,trun,r)));
         crudeexport = sum((crude,trun,r),fExports.l(crude,trun,r));
         totalgcond = sum((trun,r),fueluse.l('gcond',trun,r)-fExports.l('gcond',trun,r));
         gcondexport = sum((trun,r),fExports.l('gcond',trun,r));
         totalHFO = sum((trun,rr),sum(r,RFtrans.l('HFO',trun,r,rr))+RFprodimports.l('HFO',trun,rr));
$offtext

$ontext
         invest("EL",trun) = sum((ELpd,v,r),(ELpurcst(ELpd,trun,r)+ELconstcst(ELpd,trun,r))*Elbld.l(ELpd,v,trun,r)/coef1(ELpd,trun))
                                 +sum((ELps,v,r),(ELpurcst(ELps,trun,r)+ELconstcst(ELps,trun,r))*Elsolbld.l(ELps,v,trun,r)/coef1(ELps,trun))
                                 +sum((r,rr),(ELtransconstcst(r,trun,rr)+ELtranspurcst(r,trun,rr))*ELtransbld.l(trun,r,rr)/coef2(trun));

         invest("WA",trun) = sum((WAp,v,r),(WApurcst(WAp,trun,r)+WAconstcst(WAp,trun,r))*WAbld.l(WAp,v,trun,r)/WAdiscfact1(WAp,trun))
                                 +sum((WAp,r,rr),(WAtransconstcst(trun,r,rr)+WAtranspurcst(trun,r,rr))*WAtransbld.l(trun,r,rr)/WAdiscfact2(trun));

         invest("PC",trun) = sum((PCp,r),(PCconstcst(PCp,r,trun)+PCpurcst(PCp,r,trun))*PCbld.l(PCp,trun,r)/discoef(PCp,trun));
         invest("RF",trun) = sum((RFu,r),(RFpurcst(RFu,trun)+RFconstcst(RFu,trun))*RFbld.l(RFu,trun,r)/RFdiscoef(RFu,trun));
         invest("f",trun) = sum((fup,r,rr),(ftranspurcst(fup,trun,r,rr)+ftransconstcst(fup,trun,r,rr))*ftransbld.l(fup,trun,r,rr)/fdisccoeff(fup,trun));

         invest("ALL",trun) = sum(sect,invest(sect,trun));

         ELpinvest(Elpd,trun) = sum((v,r),(ELpurcst(ELpd,trun,r)+ELconstcst(ELpd,trun,r))*Elbld.l(ELpd,v,trun,r)/coef1(ELpd,trun));
         Elpinvest(ELps,trun) = sum((v,r),(ELpurcst(ELps,trun,r)+ELconstcst(ELps,trun,r))*Elsolbld.l(ELps,v,trun,r)/coef1(ELps,trun));
         ELtrinvest(trun) =   sum((r,rr),(ELtransconstcst(r,trun,rr)+ELtranspurcst(r,trun,rr))*ELtransbld.l(trun,r,rr)/coef2(trun));



         WApinvest(WAp,trun) = sum((v,r),(WApurcst(WAp,trun,r)+WAconstcst(WAp,trun,r))*WAbld.l(WAp,v,trun,r)/WAdiscfact1(WAp,trun));
         WAtrinvest(trun) =  sum((r,rr),(WAtransconstcst(trun,r,rr)+WAtranspurcst(trun,r,rr))*WAtransbld.l(trun,r,rr)/WAdiscfact2(trun));

         finvest(fup,trun) = sum((r,rr),(ftranspurcst(fup,trun,r,rr)+ftransconstcst(fup,trun,r,rr))*ftransbld.l(fup,trun,r,rr)/fdisccoeff(fup,trun));

         PCinvest(PCp,trun)= sum(r,(PCconstcst(PCp,r,trun)+PCpurcst(PCp,r,trun))*PCbld.l(PCp,trun,r)/discoef(PCp,trun));

         RFinvest(RFu,trun) = sum(r,(RFpurcst(RFu,trun)+RFconstcst(RFu,trun))*RFbld.l(RFu,trun,r)/RFdiscoef(RFu,trun));
$offtext
