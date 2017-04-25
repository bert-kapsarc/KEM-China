*        Set OTHER consump of metallurgical and thermal coal for demand that is exogneous to the model
*         OTHERCOconsump('met',time,rr)=COstatistics('Metallurgical',rr);
*         OTHERCOconsump('coal',time,rr)=COstatistics('Other',rr);

ELCOconsump.l(Elpcoal,v,gtyp,cv,sulf,sox,nox,trun,rr)=0;


parameter COprice_fx(COf) fixed coal price per KG of SCE (7000 KCAL per kg) ;
          COprice_fx('coal') = 700;
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
