         OTHERCOconsump('met',time,rr)=COstatistics('Metallurgical',time,rr);
         OTHERCOconsump('coal',time,rr)=COstatistics('Other',time,rr);

*        SPLIT INNER MONGOLIA AND EASTERN INNER MONGOLIA supply and demand statistics
         COstatistics(COstats,time,'NME')=COstatistics(COstats,time,'NM')*0.3;
         COstatistics(COstats,time,'NM')=COstatistics(COstats,time,'NM')
                                 -COstatistics(COstats,time,'NME');

         COstatistics(COstats,trun,r) = sum((GB)$regions(r,GB),
                                 COstatistics(COstats,trun,GB));

         COstatistics(COstats,trun,"China") = sum(r,COstatistics(COstats,trun,r))
if(run_lp_mcp('LP'),

*        Set Coal demand values


         OTHERCOconsump('coal',time,rr)=OTHERCOconsump('coal',time,rr)
         +COstatistics('Power',time,rr)$(not run_model("Power") and run_inputs('predefined'))

           -sum((Elpcoal,v,gtyp,sox,nox)$(ELpfgc(ELpcoal,cv,sulf,sox,nox) and ELfcoal(COf)),
                  ELCOconsump(Elpcoal,v,gtyp,cv,sulf,sox,nox,t,rr))*Elsnorm(ELs)$(not run_model("Power") and run_inputs('savepoint'))
         +COstatistics('Power',time,rr)

);

;