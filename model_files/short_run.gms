
         CObld.up(COf,mm,ss,trun,rco)$COmine(COf,mm,ss,rco)=0;

         COtransbld.up('rail',trun,rco,rrco)$arc('rail',rco,rrco) = 0;
         COtransbld.up('truck',trun,rco,rrco)$arc('truck',rco,rrco) = 0;
         COtransbld.up(port,trun,rco,rrco)$arc(port,rco,rrco) = 0;

         ELbld.up('GTtoCC',vo,trun,r)=0;
         ELbld.up('CC',vn,trun,r)=0;
         ELbld.up('GT',vn,trun,r)=0;
         ELbld.up(ELpcoal,vn,trun,r)=0;
         ELbld.up(ELpnuc,vn,trun,r)=0;

         ELpurcst('ST',trun,r)=ELpurcst('ST',trun,r)*100;
         ELpurcst('GT',trun,r)=ELpurcst('GT',trun,r);


*         ELfgcbld.up(ELpd,v,fgc,t,r)$(ELpcoal(ELpd) and
*                 (DeSOx(fgc) or DeNOx(fgc)))=0;
*
         ELhydbld.up(Elphyd,'new',trun,r)=0;
         ELwindbld.up(Elpw,'new',trun,r)=0;

* !!!    No transmission investments
         ELtransbld.up(Elt,trun,r,rr)= 0;

*        Inflate methane price to prevent consumption above contracted ss0 price
         ELAPf(ELfog,'ss1',time,r) = ELAPf(ELfog,'ss1',time,r)*10;
