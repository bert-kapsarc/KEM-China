

parameter OTHERCOconsumpNat(COf,trun);

      OTHERCOconsumpNat(COf,trun) = sum(r,OTHERCOconsump(COf,trun,r));

*temp(COf,mm,ss,trun,rco) = COexistcp.l(COf,mm,ss,trun,rco)+CObld.l(COf,mm,ss,trun,rco) - sum(rwnoot,COprod.l(COf,mm,ss,rwnoot,trun,rco)) ;
COexistrco(Cof,trun,rco) = sum((mm,ss),COexistcp.l(COf,mm,ss,trun,rco));
COprodRaw(COf,trun,rco) = sum((mm,ss,sulf,rw),COprod.l(COf,sulf,mm,ss,rw,trun,rco));
COprodPUraw(COf,mm,ss,trun,rco) = sum((sulf,rw),COprod.l(COf,sulf,mm,ss,rw,trun,rco));
COprodNet(COf,rw,trun,rco) = sum((mm,ss,sulf),COprod.l(COf,sulf,mm,ss,rw,trun,rco)*COprodyield(COf,mm,ss,rw,trun,rco));
COprodPUnet(COf,mm,ss,rw,trun,rco) = sum((sulf),COprod.l(COf,sulf,mm,ss,rw,trun,rco)*COprodyield(COf,mm,ss,rw,trun,rco));
CObldrco(Cof,trun,rco) = sum((mm,ss),CObld.l(COf,mm,ss,trun,rco));

COuser(COf,rco)      =sum((cv,sulf,ELs,trun),coaluse.l(COf,cv,sulf,ELs,trun,rco)*COcvSCE(cv));

Cotranstot(tr,trun,rco,rrco) = sum((COf,cv,sulf,ELs),COtrans.l(COf,cv,sulf,tr,ELs,trun,rco,rrco));


COtransin(tr,trun,rrco) = sum((COf,cv,sulf,rco,ELs),COtrans.l(COf,cv,sulf,tr,ELs,trun,rco,rrco));
COtransout(tr,trun,rco) = sum((COf,cv,sulf,rrco,ELs),COtrans.l(COf,cv,sulf,tr,ELs,trun,rco,rrco));

Cotransnet(tr,trun,rrco) = COtransin(tr,trun,rrco) - COtransout(tr,trun,rrco);

COtransfrom(tr,trun,rco) = sum((COf,cv,sulf,rrco,ELs),COtrans.l(COf,cv,sulf,tr,ELs,trun,rco,rrco));

COtransimp(COf,cv,trun,rrco) = sum((sulf,rimp,tr,ELs),COtrans.l(COf,cv,sulf,tr,ELs,trun,rimp,rrco));

COtranstonkm(tr,trun)=sum((COf,cv,sulf,rco,rrco,ELs),COtrans.l(COf,cv,sulf,tr,ELs,trun,rco,rrco)*COtransD(tr,rco,rrco));

*coalimports.l(Cof,cv,sulf,trun,rimp,rrco) = sum((tr,ELs),COtrans.l(COf,cv,sulf,tr,ELs,trun,rimp,rrco));

parameter COtransimp_temp;


loop(i,
COtransimp_temp(COf,cv,trun,rco) = 0;
COtransimp_temp(COf,cv,trun,rco)$(COtransimp(COf,cv,trun,rco)>0) = sum(rrco, sum((sulf,tr,ELs)$(COtransimp(COf,cv,trun,rco)>0),COtrans.l(COf,cv,sulf,tr,ELs,trun,rco,rrco)));
COtransimp(COf,cv,trun,rrco)$(COtransimp(COf,cv,trun,rrco)=0) = sum(rco, sum((sulf,tr,ELs)$(COtransimp(COf,cv,trun,rco)>0),COtrans.l(COf,cv,sulf,tr,ELs,trun,rco,rrco))) ;
COtransimp(COf,cv,trun,rrco) = COtransimp(COf,cv,trun,rrco)-COtransimp_temp(COf,cv,trun,rrco);
);



Cotr(tr,trun) = sum((COf,cv,sulf,rrco,rco,ELs)$(coalprod.l(COf,cv,sulf,trun,rco)>0),COtrans.l(COf,cv,sulf,tr,ELs,trun,rco,rrco) - COtrans.l(COf,cv,sulf,tr,ELs,trun,rrco,rco)) ;
Cotrriver(trun) = sum((COf,cv,sulf,rport_riv,rrport_riv,ELs),COtrans.l(COf,cv,sulf,'port',ELs,trun,rport_riv,rrport_riv));
*-COtrans.l(COf,cv,sulf,'port',ELs,'t01',rrport_riv,rport_riv)
COtrport(rport,trun)  = sum((COf,cv,sulf,rrport,ELs),COtrans.l(COf,cv,sulf,'port',ELs,trun,rport,rrport)) ;
Cotrsea(trun) = sum((COf,cv,sulf,rport_sea,rrport_sea,ELs),COtrans.l(COf,cv,sulf,'port',ELs,trun,rport_sea,rrport_sea)) ;
*-COtrans.l(COf,cv,sulf,'port',ELs,'t01',rrport_sea,rport_sea)
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

parameter Cotranspath(COf,cv,sulf,tr,ELs,trun,rco,rrco,path_order);



Cotranspath(COf,cv,sulf,tr,ELs,trun,rco,rrco,'1') = Cotrans.l(COf,cv,sulf,tr,ELs,trun,rco,rrco) ;
Cotranspath(COf,cv,sulf,tr,ELs,trun,rrco,rco,'2') = Cotrans.l(COf,cv,sulf,tr,ELs,trun,rco,rrco) ;
Cotranspath(COf,cv,sulf,tr,ELs,trun,rrco,rco,path_order)$(not port(tr))= Cotranspath(COf,cv,sulf,tr,ELs,trun,rrco,rco,path_order);

parameter Cotransbldpath(tr,trun,rco,rrco,path_order);



Cotransbldpath(tr,trun,rco,rrco,'1') = COtransbld.l(tr,trun,rco,rrco) ;
Cotransbldpath(tr,trun,rrco,rco,'2') = COtransbld.l(tr,trun,rco,rrco) ;

Cotransbldpath(tr,trun,rrco,rco,path_order)$(not port(tr))= Cotransbldpath(tr,trun,rrco,rco,path_order) ;

* reset node type if no production

    nodes(rco,GB,province,city,"supply")$(nodes(rco,GB,province,city,"intermediate") and sum((COf,cv,sulf,trun),coalprod.l(COf,cv,sulf,trun,rco))>0) =yes;
    nodes(rco,GB,province,city,"intermediate")$(nodes(rco,GB,province,city,"intermediate") and sum((COf,cv,sulf,trun),coalprod.l(COf,cv,sulf,trun,rco))>0) =no;

    nodes(rco,GB,province,city,"intermediate")$(nodes(rco,GB,province,city,"supply") and sum((COf,cv,sulf,trun),coalprod.l(COf,cv,sulf,trun,rco))=0) =yes;
    nodes(rco,GB,province,city,"supply")$(nodes(rco,GB,province,city,"supply") and sum((COf,cv,sulf,trun),coalprod.l(COf,cv,sulf,trun,rco))=0) =no;

parameter coalprod_calib(COf,cv,sulf,trun,rco) ;


*use to calaculate shift in coal coalprod
*Execute_Load '../reduced_model/ChinaCoal.gdx', coalprod_calib=coalprod.l;
 coalprod_calib(COf,cv,sulf,trun,rco) =0;

set mag /pos,neg/;
parameter coalprod_shift(rco,trun,mag),coalprod_shift_rel(rco,trun,mag);

coalprod_shift(rco,trun,'pos')$(sum((COf,cv,sulf),coalprod.l(COf,cv,sulf,trun,rco)-coalprod_calib(COf,cv,sulf,trun,rco))>0) =  sum((COf,cv,sulf),coalprod.l(COf,cv,sulf,trun,rco)-coalprod_calib(COf,cv,sulf,trun,rco));
coalprod_shift(rco,trun,'neg')$(sum((COf,cv,sulf),coalprod.l(COf,cv,sulf,trun,rco)-coalprod_calib(COf,cv,sulf,trun,rco))<=0) =  sum((COf,cv,sulf),coalprod.l(COf,cv,sulf,trun,rco)-coalprod_calib(COf,cv,sulf,trun,rco));

coalprod_shift_rel(rco,trun,mag)$(sum((COf,cv,sulf),coalprod_calib(COf,cv,sulf,trun,rco)))= coalprod_shift(rco,trun,mag)/sum((COf,cv,sulf),coalprod_calib(COf,cv,sulf,trun,rco)) ;
*$offtext

parameter coal_price(*,COf,trun);


coal_price('All',COf,trun) =
   sum((cv,sulf,Els,r),
   ( DCOdem.l(COf,cv,sulf,ELs,trun,r)
     -sum(rco$(rco_dem(rco,r) and not r(rco) and rcodem(rco)),
       DCOsuplim.l('coal',cv,sulf,ELs,trun,rco)*Elsnorm(ELs)/num_nodes_reg(r))
   )*sum((rco)$rco_dem(rco,r),coaluse.l(COf,cv,sulf,Els,trun,rco))
   )/sum((cv,sulf,rco,rr,ELs)$rco_dem(rco,rr),coaluse.l(COf,cv,sulf,Els,trun,rco)*COcvSCE(cv))
;

coal_price(r,COf,trun) =
   sum((cv,sulf,Els),
   ( DCOdem.l(COf,cv,sulf,ELs,trun,r)
     -sum(rco$(rco_dem(rco,r) and not r(rco) and rcodem(rco)),
       DCOsuplim.l('coal',cv,sulf,ELs,trun,rco)*Elsnorm(ELs)/num_nodes_reg(r))
   )*sum((rco)$rco_dem(rco,r),coaluse.l(COf,cv,sulf,Els,trun,rco))
   )/sum((cv,sulf,rco,ELs)$rco_dem(rco,r),coaluse.l(COf,cv,sulf,Els,trun,rco)*COcvSCE(cv))
;

coal_price('Qinghuangdao',COf,trun) = smax(ELs,COsup.m(COf,'CV62','LOW',ELs,trun,'North'));

parameter coal_prod_SCE(COf,trun);
parameter coal_imp_SCE(COf,trun);

       coal_prod_SCE(COf,trun)     = sum((sulf,cv,rco),coalprod.l(COf,cv,sulf,trun,rco)*COcvSCE(cv));
       coal_imp_SCE(COf,trun)     = sum((ssi,sulf,cv,rco),coalimports.l(COf,ssi,cv,sulf,trun,rco)*COcvSCE(cv));


parameter EIA(*,COF,trun);

EIA('China weighted average marginal cost',COf,trun) = coal_price('All',COf,trun) ;
EIA('Qinghuangdao',COf,trun) = coal_price('Qinghuangdao',COf,trun);
EIA('Imports 7000 kcal/kg', COf, trun) = coal_imp_SCE(COf,trun);
EIA('Production 7000 kcal/kg', COf, trun) = coal_prod_SCE(COf,trun);
EIA('Coal demand trillion btu',COf,trun) = COconsumpEIA(COF,trun) ;
EIA('Coal demand 7000 kcal/kg',COf,trun) = sum(rr,OTHERCOconsump(COF,trun,rr));
