   ELpurcst(ELp,trun,r)*ELbld.l(ELp,v,trun,r)
  +ELPurcst(ELp,trun,r)*ELwindbld.l(ELp,v,trun,r)
  +ELpurcst(ELp,trun,r)*ELhydbld.l(ELp,v,trun,r)
  +sum((fgc)$(DeSOx(fgc) or DeNOx(fgc)),
         ELfgcbld.l(ELp,v,fgc,trun,r)*EMfgccapexD(fgc,trun) )

  +ELconstcst(ELp,trun,r)*ELbld.l(ELp,v,trun,r)
  +ELconstcst(ELp,trun,r)*ELwindbld.l(ELp,v,trun,r)
  +ELconstcst(ELp,trun,r)*ELhydbld.l(ELp,v,trun,r)


  +sum((ELl,ELf),
         ELomcst(Elp,v,r)*(
                 ELop.l(ELp,v,ELl,ELf,trun,r)
                 +ELusomfrac*ELlchours(ELl)*
                 ELupspincap.l(Elp,v,ELl,ELf,trun,r)
         )
  )

  +sum((gtyp,cv,sulf,sox,nox),
         (EMfgcomcst(sox)+EMfgcomcst(nox))*
         ELCOconsump.l(ELp,v,gtyp,cv,sulf,sox,nox,trun,r)*COcvSCE(cv)/
         ELfuelburn(ELp,v,'coal',r)
  )


  +ELfixedOMcst(ELp)*ELbld.l(ELp,v,trun-ELleadtime(ELp),r))

  +sum((ELl),ELomcst(ELp,v,r)*ELwindop.l(ELp,v,ELl,trun,r))
  +ELfixedOMcst(ELp)*ELwindbld.l(ELp,v,trun-ELleadtime(ELp),r)

  +sum(ELl,ELomcst(ELp,v,r)*ELhydop.l(ELp,v,ELl,trun,r))
  +ELfixedOMcst(ELp)*ELhydbld.l(ELp,v,trun-ELleadtime(ELp),r)

  +sum((ELpd,v,ELf,fss,r)$(not ELfcoal(ELf) and not ELpcoal(Elpd)),
         +ELAPf(ELf,fss,trun,r)*
         ELfconsump.l(ELpd,v,ELf,fss,trun,r))