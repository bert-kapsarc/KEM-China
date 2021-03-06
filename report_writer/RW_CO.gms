
parameter COprodSuppliers
          COcapSuppliers
          COprodCapTVELocal;

          COprodCapTVELocal(COf,trun)=
          sum((mm,ss,rco)$(Local(ss) or TVE(ss) ),
                 COprodData(COf,mm,ss,trun,rco));
;
COcapSuppliers('TVE',COf,trun) =
sum((mm,ss,rco)$TVE(ss),COprodData(COf,mm,ss,trun,rco));
COcapSuppliers('All',COf,trun) =
sum((mm,ss,rco)$Allss(ss),COprodData(COf,mm,ss,trun,rco));
COcapSuppliers('Local',COf,trun) =
sum((mm,ss,rco)$Local(ss),COprodData(COf,mm,ss,trun,rco));
COcapSuppliers('SOE',COf,trun) =
sum((mm,ss,rco)$SOE(ss),COprodData(COf,mm,ss,trun,rco));

COprodSuppliers('TVE',trun,r) =
sum((mm,rw,ss,sulf,rco,COf,COff)$(rco_sup(rco,r) and TVE(ss)),
COprod.l(COf,sulf,mm,ss,rw,trun,rco)*COprodyield(COf,mm,ss,rw,trun,rco)*
COrwtable(rw,COf,COff));

COprodSuppliers('Local',trun,r) =
sum((mm,rw,ss,sulf,rco,COf,COff)$(rco_sup(rco,r) and Local(ss)),
COprod.l(COf,sulf,mm,ss,rw,trun,rco)*COprodyield(COf,mm,ss,rw,trun,rco)*
COrwtable(rw,COf,COff));

COprodSuppliers('SOE',trun,r) =
sum((mm,rw,ss,sulf,rco,COf,COff)$(rco_sup(rco,r) and SOE(ss)),
COprod.l(COf,sulf,mm,ss,rw,trun,rco)*COprodyield(COf,mm,ss,rw,trun,rco)*
COrwtable(rw,COf,COff));

COprodSuppliers('All',trun,r) =
sum((mm,rw,ss,sulf,rco,COf,COff)$(rco_sup(rco,r) and ALlss(ss)),
COprod.l(COf,sulf,mm,ss,rw,trun,rco)*COprodyield(COf,mm,ss,rw,trun,rco)*
COrwtable(rw,COf,COff));

*COprodSuppliers(COf,trun,r) =
*sum((mm,ss,rco)$(rco_sup(rco,r) and (TVE(ss) or Local(ss) or Allss(ss))),
*COexistcp.l(COf,mm,ss,trun,rco));

COexistrco(Cof,trun,rco) = sum((mm,ss),COexistcp.l(COf,mm,ss,trun,rco));
COprodRaw(COf,trun,rco) = sum((mm,ss,sulf,rw),COprod.l(COf,sulf,mm,ss,rw,trun,rco));
COprodPUraw(COf,mm,ss,trun,rco) = sum((sulf,rw),COprod.l(COf,sulf,mm,ss,rw,trun,rco));
COprodNet(COf,ss,trun,r) = sum((mm,rw,sulf,rco)$rco_sup(rco,r),COprod.l(COf,sulf,mm,ss,rw,trun,rco)*COprodyield(COf,mm,ss,rw,trun,rco));
COprodPUnet(COf,mm,ss,rw,trun,rco) = sum((sulf),COprod.l(COf,sulf,mm,ss,rw,trun,rco)*COprodyield(COf,mm,ss,rw,trun,rco));
CObldrco(Cof,trun,rco) = sum((mm,ss),CObld.l(COf,mm,ss,trun,rco));

COuser(COf,rco)      =sum((cv,sulf,trun),coaluse.l(COf,cv,sulf,trun,rco)*COcvSCE(cv));

Cotranstot(tr,trun,rco,rrco) = sum((COf,cv,sulf),COtrans.l(COf,cv,sulf,tr,trun,rco,rrco));


COtransin(tr,trun,rrco) = sum((COf,cv,sulf,rco),COtrans.l(COf,cv,sulf,tr,trun,rco,rrco));
COtransout(tr,trun,rco) = sum((COf,cv,sulf,rrco),COtrans.l(COf,cv,sulf,tr,trun,rco,rrco));

Cotransnet(tr,trun,rrco) = COtransin(tr,trun,rrco) - COtransout(tr,trun,rrco);

COtransfrom(tr,trun,rco) = sum((COf,cv,sulf,rrco),COtrans.l(COf,cv,sulf,tr,trun,rco,rrco));

COtransimp(COf,cv,trun,rrco) = sum((sulf,rimp,tr),COtrans.l(COf,cv,sulf,tr,trun,rimp,rrco));

COtranstonkm(tr,trun)=sum((COf,cv,sulf,rco,rrco),COtrans.l(COf,cv,sulf,tr,trun,rco,rrco)*COtransD(tr,rco,rrco));

*coalimports.l(Cof,cv,sulf,trun,rimp,rrco) = sum((tr),COtrans.l(COf,cv,sulf,tr,trun,rimp,rrco));

parameter COtransimp_temp;


loop(i,
COtransimp_temp(COf,cv,trun,rco) = 0;
COtransimp_temp(COf,cv,trun,rco)$(COtransimp(COf,cv,trun,rco)>0) = sum(rrco, sum((sulf,tr)$(COtransimp(COf,cv,trun,rco)>0),COtrans.l(COf,cv,sulf,tr,trun,rco,rrco)));
COtransimp(COf,cv,trun,rrco)$(COtransimp(COf,cv,trun,rrco)=0) = sum(rco, sum((sulf,tr)$(COtransimp(COf,cv,trun,rco)>0),COtrans.l(COf,cv,sulf,tr,trun,rco,rrco))) ;
COtransimp(COf,cv,trun,rrco) = COtransimp(COf,cv,trun,rrco)-COtransimp_temp(COf,cv,trun,rrco);
);



Cotr(tr,trun) = sum((COf,cv,sulf,rrco,rco)$(sum(Coff,coalprod.l(COf,COff,cv,sulf,trun,rco))>0),COtrans.l(COf,cv,sulf,tr,trun,rco,rrco) - COtrans.l(COf,cv,sulf,tr,trun,rrco,rco)) ;
Cotrriver(trun) = sum((COf,cv,sulf,rport_riv,rrport_riv),COtrans.l(COf,cv,sulf,'port',trun,rport_riv,rrport_riv));
*-COtrans.l(COf,cv,sulf,'port','t01',rrport_riv,rport_riv)
COtrport(rport,trun)  = sum((COf,cv,sulf,rrport),COtrans.l(COf,cv,sulf,'port',trun,rport,rrport)) ;
Cotrsea(trun) = sum((COf,cv,sulf,rport_sea,rrport_sea),COtrans.l(COf,cv,sulf,'port',trun,rport_sea,rrport_sea)) ;
*-COtrans.l(COf,cv,sulf,'port','t01',rrport_sea,rport_sea)
*$offtext

parameter transport ;

transport(land,trun) = Cotr(land,trun);
transport('river',trun) = Cotrriver(trun);
transport('sea',trun) = Cotrsea(trun);

CotransbldD(trun) = sum((rco,rrco)$(COtransbld.l('rail',trun,rco,rrco)>0),COtransD('rail',rco,rrco)/2);
Cotransbldton(trun) = sum((rco,rrco)$(COtransbld.l('rail',trun,rco,rrco)>0),COtransbld.l('rail',trun,rco,rrco)/2);
Cotransbldport(trun) = sum(rco$(COtransbld.l('port',trun,rco,rco)>0),COtransbld.l('port',trun,rco,rco));


parameter COcosts;

COcosts('total_economic_cost ',trun) = COobjvalue.l;
COcosts('mining_cost ',trun) = COOpandmaint.l(trun);
COcosts('import_cost ',trun) =  COimports.l(trun);
COcosts('rail_investment ',trun) = sum((rco,rrco),COtranscapex('rail',rco,rrco)*COtransbld.l('rail',trun,rco,rrco)*COtransD('rail',rco,rrco) ) ;
COcosts('rail_length',trun)= CotransbldD(trun);
COcosts('rail_cap',trun)= Cotransbldton(trun);

COcosts('port_investment',trun) = sum((rco),COtranscapex('port',rco,rco)*COtransbld.l('port',trun,rco,rco)) ;
COcosts('port_cap',trun)= Cotransbldport(trun);

parameter Cotranspath(COf,cv,sulf,tr,trun,rco,rrco,path_order);



Cotranspath(COf,cv,sulf,tr,trun,rco,rrco,'1') = Cotrans.l(COf,cv,sulf,tr,trun,rco,rrco) ;
Cotranspath(COf,cv,sulf,tr,trun,rrco,rco,'2') = Cotrans.l(COf,cv,sulf,tr,trun,rco,rrco) ;
Cotranspath(COf,cv,sulf,tr,trun,rrco,rco,path_order)$(not port(tr))= Cotranspath(COf,cv,sulf,tr,trun,rrco,rco,path_order);

parameter Cotransbldpath(tr,trun,rco,rrco,path_order);



Cotransbldpath(tr,trun,rco,rrco,'1') = COtransbld.l(tr,trun,rco,rrco) ;
Cotransbldpath(tr,trun,rrco,rco,'2') = COtransbld.l(tr,trun,rco,rrco) ;

Cotransbldpath(tr,trun,rrco,rco,path_order)$(not port(tr))= Cotransbldpath(tr,trun,rrco,rco,path_order) ;

* reset node type if no production

parameter coalprod_calib(COf,COff,cv,sulf,trun,rco) ;


*use to calaculate shift in coal coalprod
*Execute_Load '../reduced_model/ChinaCoal.gdx', coalprod_calib=coalprod.l;
 coalprod_calib(COf,COff,cv,sulf,trun,rco) =0;

set mag /pos,neg/;
parameter coalprod_shift(rco,trun,mag),coalprod_shift_rel(rco,trun,mag);

coalprod_shift(rco,trun,'pos')$(sum((COf,COff,cv,sulf),coalprod.l(COf,COff,cv,sulf,trun,rco)-coalprod_calib(COf,COff,cv,sulf,trun,rco))>0) =  sum((COf,COff,cv,sulf),coalprod.l(COf,COff,cv,sulf,trun,rco)-coalprod_calib(COf,COff,cv,sulf,trun,rco));
coalprod_shift(rco,trun,'neg')$(sum((COf,COff,cv,sulf),coalprod.l(COf,COff,cv,sulf,trun,rco)-coalprod_calib(COf,COff,cv,sulf,trun,rco))<=0) =  sum((COf,COff,cv,sulf),coalprod.l(COf,COff,cv,sulf,trun,rco)-coalprod_calib(COf,COff,cv,sulf,trun,rco));

coalprod_shift_rel(rco,trun,mag)$(sum((COf,COff,cv,sulf),coalprod_calib(COf,COff,cv,sulf,trun,rco)))= coalprod_shift(rco,trun,mag)/sum((COf,COff,cv,sulf),coalprod_calib(COf,COff,cv,sulf,trun,rco)) ;
*$offtext

parameter coal_price(*,COf,trun);


coal_price('All',COf,trun) =
   sum((cv,sulf,r),COprice.l(COf,cv,sulf,trun,r)*
         sum((rco)$rco_r_dem(rco,r),coaluse.l(COf,cv,sulf,trun,rco))
   )/sum((cv,sulf,rco,rr)$rco_r_dem(rco,rr),coaluse.l(COf,cv,sulf,trun,rco)*COcvSCE(cv))
;

coal_price(r,COf,trun) =
   sum((cv,sulf),COprice.l(COf,cv,sulf,trun,r)
   *sum((rco)$rco_r_dem(rco,r),coaluse.l(COf,cv,sulf,trun,rco))
   )/sum((cv,sulf,rco)$rco_r_dem(rco,r),coaluse.l(COf,cv,sulf,trun,rco)*COcvSCE(cv))
;

coal_price('Qinghuangdao',COf,trun) = COsup.m(COf,'CV62','LOW',trun,'North');

parameter coal_prod_SCE(COf,trun);
parameter coal_imp_SCE(COf,trun);

       coal_prod_SCE(COf,trun)     = sum((COff,sulf,cv,rco),coalprod.l(COff,COf,cv,sulf,trun,rco)*(1$met(COf)+COcvSCE(cv)$coal(COf)));
       coal_imp_SCE(COf,trun)     = sum((ssi,sulf,cv,rco),coalimports.l(COf,ssi,cv,sulf,trun,rco)*(1$met(COf)+COcvSCE(cv)$coal(COf)));


parameter EIA(*,COF,trun);

EIA('China weighted average marginal cost',COf,trun) = coal_price('All',COf,trun) ;
EIA('Qinghuangdao',COf,trun) = coal_price('Qinghuangdao',COf,trun);
EIA('Imports, mt SCE', COf, trun) = coal_imp_SCE(COf,trun);
EIA('Production, mt SCE', COf, trun) = coal_prod_SCE(COf,trun);
*EIA('Coal demand trillion btu',COf,trun) = COconsumpEIA(COF,trun) ;
EIA('Coal demand, mt SCE',COf,trun) = sum((cv,sulf,rr),OTHERCOconsumpsulf.l(COf,cv,sulf,trun,rr));
