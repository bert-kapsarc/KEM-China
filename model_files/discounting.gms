********* Discounting power sector
         ELdiscfact(trun)=discfact(ELdiscountrate,trun);

*        Discounting plant capital costs over lifetrun
         ELdiscoef1(ELp,trun) = discounting(ELlifetime(ELp),ELdiscountrate,i,trun,thyb);
*        intdiscfact(ELdiscountrate,trun,thyb)/sumdiscfact(ELlifetime(ELp),ELdiscountrate,i);

*        Discounting transmission capital costs over lifetime (35 time periods)
         ELdiscoef2(trun) = discounting(35,ELdiscountrate,i,trun,thyb);
*intdiscfact(ELdiscountrate,trun,thyb)/sumdiscfact(35,ELdiscountrate,i);

         ELpurcst(ELp,trun,r)=ELpurcst(ELp,trun,r)*ELdiscoef1(ELp,trun);
         ELconstcst(ELp,trun,r)=ELconstcst(ELp,trun,r)*ELdiscoef1(ELp,trun);
         ELtranspurcst(ELt,trun,r,rr)=ELtranspurcst(ELt,trun,r,rr)*ELdiscoef2(trun);
         ELtransconstcst(ELt,trun,r,rr)=ELtransconstcst(ELt,trun,r,rr)*ELdiscoef2(trun);


         EMdiscoef(trun) = discounting(25,ELdiscountrate,i,trun,thyb);
         EMfgccapexD(fgc,trun) = EMfgccapex(fgc,trun)*EMdiscoef(trun);

********* Discounting coal tranport submodel
         COdiscfact(trun)=discfact(COdiscrate,trun);

         COdiscoef(trun) = discounting(30,COdiscrate,i,trun,thyb);




         COpurcst(COf,mm,trun,rco)  = 0*COdiscoef(trun);;
         COconstcst(COf,mm,ss,trun,rco)  = 0*COdiscoef(trun);

         COtranspurcst(tr,trun,r,rr) = COtranscapex(tr,r,rr)*0*COdiscoef(trun);
         COtransconstcst(tr,trun,r,rr) = COtranscapex(tr,r,rr)*1*COdiscoef(trun);



if(COrailCFS=1,

         COtransconstcst('rail',trun,r,rr)$(arc('rail',r,rr) and
                 COtransconstcst('rail',trun,r,rr)<=RailSurcharge/2) =0.001 ;
         COtransconstcst('rail',trun,r,rr)$(arc('rail',r,rr) and
                 COtransconstcst('rail',trun,r,rr)>RailSurcharge/2) =
                         COtransconstcst('rail',trun,r,rr)-RailSurcharge/2 ;
);

********* Discounting water submodel
$ontext
         scalar  WAdiscrate discount rate for water sector  /0.06/;
         WAdiscfact(trun) = discfact(WAdiscrate,trun);

         parameter WAdiscoef1(WAp,trun),WAdiscoef2(trun);
         WAdiscoef2(trun) = intdiscfact(WAdiscrate,trun,thyb);
*        intermediate discounting coefficients
         WAdiscoef1(WAp,trun) = discounting(WAlifetime(WAp),WAdiscrate,i,trun,thyb);
*WAdiscoef2(trun)/sumdiscfact(WAlifetime(WAp),WAdiscrate,i);
*        discounting for Water plants over lifetime

         WAdiscoef2(trun) =  discounting(WAtranslifetime,WAdiscrate,i,trun,thyb);
*WAdiscoef2(trun)/sumdiscfact(35,WAdiscrate,i);
*        discounting for transportation equipment  for 35 year lifetime

         WApurcst(WAp,trun,r) = WApurcst(WAp,trun,r)*WAdiscoef1(WAp,trun);
         WAconstcst(WAp,trun,r) = WAconstcst(WAp,trun,r)*WAdiscoef1(WAp,trun);
         WAtranspurcst(trun,r,rr) = WAtranspurcst("t1",r,rr)* WAdiscoef2(trun);
         WAtransconstcst(trun,r,rr) = WAtransconstcst("t1",r,rr)* WAdiscoef2(trun);

********* Discounting petchem submodel

         Scalars PCdiscountrate Real discount rate for petrochemicals sector /0.08/;
         PCdiscfact(trun)=discfact(PCdiscountrate,trun);

         parameter PCdiscoef(PCp,trun) Discounting coefficient;

*        Discounting process/plant capital costs over lifetime
*         PCdiscoef(PCp,trun) = intdiscfact(PCdiscountrate,trun,thyb)/sumdiscfact(35,PCdiscountrate,i);
         PCdiscoef(PCp,trun) = discounting(35,PCdiscountrate,i,trun,thyb);

         PCpurcst(PCp,r,trun)=PCpurcst(PCp,r,trun)*PCdiscoef(PCp,trun);
         PCconstcst(PCp,r,trun)=PCconstcst(PCp,r,trun)*PCdiscoef(PCp,trun);

********* Discounting refining submodel

         Scalars RFdiscountrate Real discount rate for refining sector /0.08/;
         RFdiscfact(trun)=discfact(RFdiscountrate,trun);

         parameter RFdiscoef(RFu,trun) Discounting coefficient for refining units;

         RFdiscoef(RFu,trun)=discounting(35,RFdiscountrate,i,trun,thyb);
*intdiscfact(RFdiscountrate,trun,thyb)/sumdiscfact(35,RFdiscountrate,i);
         RFpurcst(RFu,trun)=RFpurcst(RFu,trun)*RFdiscoef(RFu,trun);
         RFconstcst(RFu,trun)=RFconstcst(RFu,trun)*RFdiscoef(RFu,trun);

         parameter RFdiscoef2(trun) Discounting coefficient for power capacity;

         RFdiscoef2(trun)= discounting(35,RFdiscountrate,i,trun,thyb);
*intdiscfact(RFdiscountrate,trun,thyb)/sumdiscfact(35,RFdiscountrate,i);
         RFELpurcst(trun)=RFELpurcst(trun)*RFdiscoef2(trun);
         RFELconstcst(trun)=RFELconstcst(trun)*RFdiscoef2(trun);


********* Discounting cement sub model

         Scalars CMdiscountrate Real discount rate for cement sector /0.06/;
         CMdiscfact(trun)=discfact(CMdiscountrate,trun);

         parameter CMdiscoef(CMu,trun) Discounting coefficient for cement production units;
         CMdiscoef(CMu,trun)=discounting(25,CMdiscountrate,i,trun,thyb);
*intdiscfact(CMdiscountrate,trun,thyb)/sumdiscfact(25,CMdiscountrate,i);
         CMpurcst(CMu,trun)=CMpurcst(CMu,trun)*CMdiscoef(CMu,trun);
         CMconstcst(CMu,trun)=CMconstcst(CMu,trun)*CMdiscoef(CMu,trun);

         parameter CMdiscoef2(trun) Discounting coefficient for on-site power capacity;
         CMdiscoef2(trun)= discounting(35,CMdiscountrate,i,trun,thyb);
*intdiscfact(CMdiscountrate,trun,thyb)/sumdiscfact(35,CMdiscountrate,i);
         CMELpurcst(trun)=CMELpurcst(trun)*CMdiscoef2(trun);
         CMELconstcst(trun)=CMELconstcst(trun)*CMdiscoef2(trun);

         parameter CMdiscoef3(trun) Discounting coefficient for storage capacity;
         CMdiscoef3(trun)=  discounting(35,CMdiscountrate,i,trun,thyb);
*intdiscfact(CMdiscountrate,trun,thyb)/sumdiscfact(35,CMdiscountrate,i);
         CMstorpurcst(trun)=CMstorpurcst(trun)*CMdiscoef3(trun);
         CMstorconstcst(trun)=CMstorconstcst(trun)*CMdiscoef3(trun);
$offtext
