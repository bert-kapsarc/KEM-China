*        Set OTHER consump of metallurgical and thermal coal for demand that is exogneous to the model
         OTHERCOconsump('met',time,rr)=COstatistics('Metallurgical',time,rr);
         OTHERCOconsump('coal',time,rr)=COstatistics('Other',time,rr);


IF( not run_model("Power"),
*        Set Coal demand values for demand sectors not included in the model
         OTHERCOconsump('coal',time,rr)=OTHERCOconsump('coal',time,rr)

*        When not solving power sector include predefined inputs
         +COstatistics('Power',time,rr)$run_inputs('predefined')

*        When not solving power sector include savepoint as input
         +sum((Elpcoal,v,gtyp,sox,nox)$(ELpfgc(ELpcoal,cv,sulf,sox,nox) and ELfcoal(COf)),
                  ELCOconsump.l(Elpcoal,v,gtyp,cv,sulf,sox,nox,t,rr))*Elsnorm(ELs)$run_inputs('savepoint')
         ;
);


parameter COprice_fx(COf) fixed coal price per KG of SCE (7000 KCAL per kg) ;

*        Set Coal prices when not solving coal supply model
IF( not run_model("Coal"),
         COprice.l(COf,cv,sulf,t,r) = COprice_fx(COf)*COcvSCE(cv);
         ;
);