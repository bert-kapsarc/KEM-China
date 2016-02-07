         COtransbld.up('rail',trun,rco,rrco)$arc('rail',rco,rrco) = 0;
         COtransbld.up('truck',trun,rco,rrco)$arc('truck',rco,rrco) = 0;
         COtransbld.up(port,trun,rco,rrco)$arc(port,rco,rrco) = 0;

         ELbld.up('GTtoCC',vo,trun,r)=0;
         ELbld.up('CC',vn,trun,r)=0;
         ELbld.up('Ultrsc',vn,trun,r)=0;
         ELbld.up('Superc',vn,trun,r)=0;
         ELbld.up('Subcr',vn,trun,r)=0;
         ELbld.up(ELpnuc,vn,trun,r)=0;
         ELbld.up('GT',vn,trun,r)=0;

         ELhydbld.up(Elphyd,'new',trun,r)=0;
*         ELwindbld.up(Elpw,'new',trun,r)=0;

* !!!    No transmission investments
         ELtransbld.up(Elt,trun,r,rr)= 0;
