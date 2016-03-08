*$ontext
* !!!!   Run model long run without thermal capacity stocks post 2000 v='old'

* !!!!   Do not allow new nuclear or wind (only look at thermal capacity stocks)
         ELbld.up(ELpnuc,vn,trun,r)=0;
         ELwindbld.up(Elpw,vn,trun,r)=0;

*        Remove existing capacity stock
         ELexistcp.fx(ELpd,v,trun,r)$(not ELpnuc(Elpd) and not ELpcoal(Elpd) and ord(trun)=1)=    0;
         ELexistcp.fx(ELpd,vn,trun,r)$(ELpcoal(Elpd) and ord(trun)=1)=    0;

         ELfgcexistcp.fx(ELpd,vn,DeSOx,trun,r)$(ord(trun)=1)=0;
         ELfgcexistcp.fx(ELpd,vn,DeNOx,trun,r)$(ord(trun)=1)=0;
;
*$offtext


$ontext
*!!!     Run model short run with adjusted capacity stocks
$INCLUDE short_run.gms
         execute_loadpoint "LongRunNewStockReg.gdx" ELbld, ELfgcbld,ELfgcexistcp, ELtransbld, ELtransexistcp, COtransbld, COtransexistcp;

         ELexistcp.fx(ELpd,v,trun,r)$(not ELpnuc(Elpd) and not ELpcoal(Elpd) and ord(trun)=1)=
                 ELbld.l(ELpd,v,trun,r);

         ELexistcp.fx(ELpd,vn,trun,r)$(ELpcoal(Elpd) and ord(trun)=1)=ELbld.l(ELpd,vn,trun,r);;

*         ELexistcp.up("GT",v,trun,r)$(ord(trun)=1)=    0;

*         ELexistcp.up(ELpCCcon,v,trun,r)$(ord(trun)=1)=
*                 sum(Elppd$ELpbld(Elppd,v),ELcapadd(Elppd,ELpCCcon)*
*                                 ELbld.l(Elppd,v,trun,r));

         ELfgcexistcp.fx(ELpd,v,fgc,trun,r)$(ord(trun)=1 and
                                         (DeSOx(fgc) or DeNOx(fgc)))=
                  ELfgcexistcp.l(ELpd,v,fgc,trun,r)$vo(v)
                 +ELfgcbld.l(ELpd,v,fgc,trun,r);

         ELtransexistcp.up(Elt,trun,r,rr)$(ord(trun)=1)=
         ELtransbld.l(ELt,trun,r,rr) + ELtransexistcp.l(Elt,trun,r,rr);

         COtransexistcp.fx(tr,trun,rco,rrco)$(ord(trun)=1 and arc(tr,rco,rrco))=
         COtransbld.l(tr,trun,rco,rrco)+COtransexistcp.l(tr,trun,rco,rrco);
$offtext
