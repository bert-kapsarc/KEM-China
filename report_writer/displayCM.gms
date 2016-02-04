
*Display variables to validate solution:
Parameter mixfraction(CMm,CMci) mass fraction of molecules in clinker products;
mixfraction(CMm,CMci)$CMmixingspec('max',CMm,CMci,'masscon')=
 sum((CMp,CMf,trun,r),CMprocessuse(CMm,CMp)*CMmassout(CMm,CMci,CMp)*CMop.l(CMm,CMp,CMf,trun,r))
/sum((CMmm,CMp,CMf,trun,r),CMprocessuse(CMmm,CMp)*CMmassout(CMmm,CMci,CMp)*CMop.l(CMmm,CMp,CMf,trun,r));

Parameter clinkfraction(CMclp,CMclinker,trun,r) mass fraction of molecules in clinker products;
clinkfraction(CMclp,CMclinker,trun,r)$(sum((CMcl)$CMclp(CMcl),CMmass.l(CMcl,CMclinker,trun,r))>0)=CMmass.l(CMclp,CMclinker,trun,r)
/sum((CMcl)$CMclp(CMcl),CMmass.l(CMcl,CMclinker,trun,r));

Parameter clinkerproduced(CMci);
Clinkerproduced(CMci)=sum((CMp,CMf,trun,r),CMprocessuse('CSAF',CMp)*CMmassout('CSAF',CMci,CMp)*CMop.l('CSAF',CMp,CMf,trun,r));

Parameter clinkermass(CMclinker);
clinkermass(CMclinker)=sum((CMclp,trun,r),CMmass.l(CMclp,CMclinker,trun,r));

Parameter calcinationCO2(CMcf,trun,r) CO2 produced from calcination reaction;
calcinationCO2('CO2',trun,r)=sum((CMci,CMp,CMf),CMmassout(CMci,'CO2',CMp)*CMop.l(CMci,CMp,CMf,trun,r));

Parameter CO2perclinker(trun) tons of CO2 per ton of clinker;
CO2perclinker(trun)=sum((CMm,CMp,CMf,r),CMmassout(CMm,'CO2',CMp)*CMop.l(CMm,CMp,CMf,trun,r))
/sum((CMclinker,CMp,CMf,r),CMop.l(CMclinker,CMp,CMf,trun,r));

Parameter Limestonepertonofcement(trun);
Limestonepertonofcement(trun)=sum(r,CMcrconsump.l('CaCO3',trun,r))
/sum((CMci,CMcements,CMpp,CMf,r),CMmassout(CMci,CMcements,CMpp)*CMop.l(CMci,CMpp,CMf,trun,r));
*sum((CMcr,r),CMcrconsump.l(CMcr,trun,r))
*sum(r,CMcrconsump.l('CaCO3',trun,r))

Parameter CMELconsumpyear(trun) electricity use in TWh;
CMELconsumpyear(trun)=sum((ELl,r),CMtotELconsump.l(ELl,trun,r));

Parameter CMtonsofclinkerpertonofcement(trun);
CMtonsofclinkerpertonofcement(trun)=sum((CMci,CMp,CMf,r),CMmassout('CSAF',CMci,CMp)*CMop.l('CSAF',CMp,CMf,trun,r))
/sum((CMci,CMcements,CMp,CMf,r),CMmassout(CMci,CMcements,CMp)*CMop.l(CMci,CMp,CMf,trun,r));

Parameter cementproduced(trun);
cementproduced(trun)=sum((CMci,CMcements,CMpp,CMf,r),CMmassout(CMci,CMcements,CMpp)*CMop.l(CMci,CMpp,CMf,trun,r));
*Objective function:
z.l=sum(t,CMOpandmaint.l(t)*CMdiscfact(t))+sum(t,CMImports.l(t)*CMdiscfact(t))
 +sum(t,CMConstruct.l(t)*CMdiscfact(t))+sum((CMf,t,r),CMAPf(CMf,t,r)*CMfconsump.l(CMf,t,r)*CMdiscfact(t))
 -sum(t,CMRevenues.l(t)*CMdiscfact(t)) ;

Parameter CMunitsconv(CMf) from fuel units to GJ
/methane 1.055056
 Arabheavy 6.23
 HFO 43.24
 Diesel 38.85/

Parameter GJpertonofcement(trun) in GJ per ton of cement produced;
GJpertonofcement(trun)=sum((CMf,r),CMunitsconv(CMf)*CMfconsump.l(CMf,trun,r))
*/sum((CMclinker,CMp,CMf,r),CMop.l(CMclinker,CMp,CMf,trun,r));
/sum((CMci,CMcements,CMp,CMf,r),CMmassout(CMci,CMcements,CMp)*CMop.l(CMci,CMp,CMf,trun,r));


Display z.l,GJpertonofcement,mixfraction,
clinkfraction,CMtonsofclinkerpertonofcement,
calcinationCO2,CO2perclinker,Limestonepertonofcement,
Clinkerproduced, clinkermass,CMELconsumpyear,cementproduced;
