*        Set OTHER consump of metallurgical and thermal coal for demand that is exogneous to the model
         OTHERCOconsump('met',time,rr)=COstatistics('Metallurgical',time,rr);
         OTHERCOconsump('coal',time,rr)=COstatistics('Other',time,rr);

ELCOconsump.l(Elpcoal,v,gtyp,cv,sulf,sox,nox,trun,rr)=0;
IF( not run_model("Power"),
*        Set Coal demand values for demand sectors not included in the model
         OTHERCOconsump('coal',trun,rr)=OTHERCOconsump('coal',trun,rr)

*        When not solving power sector include predefined inputs
         +COstatistics('Power',trun,rr)$run_with_inputs('predefined')

*        When not solving power sector include savepoint as input
         +sum((Elpcoal,v,gtyp,cv,sulf,sox,nox)$(ELpfgc(ELpcoal,cv,sulf,sox,nox) and ELfcoal('coal')),
                  ELCOconsump.l(Elpcoal,v,gtyp,cv,sulf,sox,nox,trun,rr))$run_with_inputs('savepoint')
         ;

);


parameter COprice_fx(COf) fixed coal price per KG of SCE (7000 KCAL per kg) ;
          COprice_fx('coal') = 600;
          COprice_fx('met') = 1000;
*        Set Coal prices when not solving coal supply model

COprice.l(COf,cv,sulf,trun,r) = 0 ;

IF( not run_model("Coal"),
         COprice.fx(COf,cv,sulf,trun,r)$ELfCV(COf,cv,sulf) = COprice_fx(COf)*COcvSCE(cv);
         ;
);


IF( not run_model("Emissions"),
         DEMsulflim.fx(trun,r)$rdem_on(r) = 0;
         DEMELnoxlim.fx(trun,r)=0;
         DEMfgbal.fx(ELpcoal,v,trun,r)=0;
         DEMELSO2std.fx(ELpcoal,v,trun,r)$(SO2_std=1)=0;
         DEMELNO2std.fx(ELpcoal,v,trun,r)$(SO2_std=1)=0;
);
