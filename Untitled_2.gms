ELobjvalue.l=
  +sum(t,(ELImports.l(t)+ELConstruct.l(t)+ELOpandmaint.l(t))*ELdiscfact(t))

  +sum((ELpcoal,v,gtyp,COf,cv,sulf,sox,nox,ELf,t,r)$(ELfCV(COf,cv,sulf) and ELpfgc(Elpcoal,cv,sulf,sox,nox)),
          COprice.l(COf,cv,sulf,t,r)*
          ELCOconsump.l(ELpcoal,v,gtyp,cv,sulf,sox,nox,t,r))

  +sum((ELpd,v,ELf,fss,t,r)$(ELpfss(ELpd,ELf,fss) and not ELfcoal(ELf) and not ELpcoal(Elpd)),
         ELfconsump.l(ELpd,v,ELf,fss,t,r)*ELAPf(ELf,fss,t,r)*(
         0.01$(fss0(fss) and not ELpnuc(ELpd))+1$(not fss0(fss) or Elpnuc(ELpd)) )*ELdiscfact(t)
         )
;

COobjvalue.l =
    sum(t,(COpurchase.l(t)+COConstruct.l(t)+COOpandmaint.l(t))*COdiscfact(t))
   +sum(t,(COtranspurchase.l(t)+COtransConstruct.l(t)
         +COtransOpandmaint.l(t)+COimports.l(t))*COdiscfact(t))

   -sum((ELpcoal,v,gtyp,COf,cv,sulf,sox,nox,ELf,t,r)$(ELfCV(COf,cv,sulf) and ELpfgc(Elpcoal,cv,sulf,sox,nox)),
          COprice.l(COf,cv,sulf,t,r)*
          ELCOconsump.l(ELpcoal,v,gtyp,cv,sulf,sox,nox,t,r))
         ;

objvalue.l = COobjvalue.l+ELobjvalue.l;