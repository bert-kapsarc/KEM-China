* !!! cost for operating capacity over ELLmchours

         ELtariffmax(Elpd,r)$(not Elpnuc(Elpd)) = ELtariffmax(Elpd,r)*1;


         loop((ELf,fss,cv,sulf),
         ELpcost(Elpd,v,sox,nox,trun,r)$ELpELf(Elpd,ELf,fss,cv,sulf,sox,nox)=
            (ELomcst(ELpd,v,r)+EMfgcomcst(sox)+EMfgcomcst(nox))
         );


         DELTA2(Elp,v,trun,r)=
         ELtariffmax(Elp,r)*ELparasitic(Elp,v)-ELomcst(Elp,v,r);

         DELTA(Elpd,v,sulf,sox,nox,trun,r)=
         (ELtariffmax(Elpd,r)+ELfgctariff(sox)+ELfgctariff(nox))
                 *ELpCOparas(Elpd,v,sulf,sox,nox)
         -ELpcost(Elpd,v,sox,nox,trun,r);



         ELpfixedcost(Elp,v,trun,r)=
         (ELfixedOMcst(ELp)+ELpurcst(ELp,trun,r)+ELconstcst(ELp,trun,r));

         ELpsunkcost(ELp,v,trun,r)=
         ELfixedOMcst(ELp)+(ELpurcst(ELp,trun,r)+ELconstcst(ELp,trun,r))*
         (1$(vn(v) or not (ELpcoal(Elp) and vo(v))) + 0$(ELpcoal(Elp) and vo(v))) ;


         ELpsunkcost(ELp,v,trun,r)$ELphyd(Elp)=
         ELfixedOMcst(ELp)+(ELpurcst(ELp,trun,r)+ELconstcst(ELp,trun,r))*0;


         ELpsunkcost(ELp,v,trun,r)$ELpw(Elp)=
         ELfixedOMcst(ELp)+(ELpurcst(ELp,trun,r)+ELconstcst(ELp,trun,r))*0;

         COintlprice(coal,ssi,cv_ord,sulf,time,rimp)=
         COintlprice(coal,ssi,cv_ord,sulf,time,rimp)*1;


*

         COtransbld.up(tr,trun,'IMKP',rrco)$arc('rail','IMKP',rrco) = 0;
         COtransbld.up(tr,trun,'IMMN',rrco)$arc('rail','IMMN',rrco) = 0;

         COtransbld.up('rail',trun,rco,rrco)$arc('rail',rco,rrco) = 0;
         COtransbld.up('truck',trun,rco,rrco)$arc('truck',rco,rrco) = 0;
         COtransbld.up(port,trun,rco,rrco)$arc(port,rco,rrco) = 0;

*         ELAPf('methane',fss,time,r)=ELAPf('methane',fss,time,r)*0.01;


*        initialize power plants with ongrid electricity tarrifs

         ELptariff(ELpd,v) = no;


$ontext
         ELptariff(ELpnuc,v) = yes;
         ELptariff(ELpcoal,v) = yes;
         ELptariff(ELpCC,v) = yes;
         ELptariff(ELpog,v) = yes;
*         ELptariff('ST',v) = no;
$offtext

if( s('calib'),

         coal_cap=1;
         rail_cap=1;
         import_cap=0;
         COfimpmax('coal',trun)=200;
         COfimpmax('met',trun)=52;

         COrailCFS=0;

         t_start=1;

* !!!    Fix new builds

* !!!    Switch off renewables
*         ELhydop.fx(ELphyd,v,ELl,trun,r)=0;
*         ELwindop.fx(ELpw,v,ELl,trun,r)=0;

$ontext
*!!!     force existing wind to operate
         ELwindoplevel.fx(wstep,ELpw,v,t,r)$(rdem_on(r) and vo(v))=
         1$((ELwindexist(r)/ELdemgro('LS1',t,r)-ord(wstep))>=0)
         + (     ELwindexist(r)/ELdemgro('LS1',t,r)
                 -floor(ELwindexist(r)/ELdemgro('LS1',t,r)))$(
         (ELwindexist(r)/ELdemgro('LS1',t,r)-ord(wstep))<0
         and (ELwindexist(r)/ELdemgro('LS1',t,r)-ord(wstep))>-1 );
$offtext

         ELhydbld.up(Elphyd,'new',trun,r)=0;
*         ELwindbld.up(Elpw,'new',trun,r)=0;


* !!!    No transmission investments
         ELtransbld.up(Elt,trun,r,rr)= 0;


*        allow coal mine expansion in 2011 conterfactual case
*         Cobld.up(COf,mm,ss,'t12',rco)$(COmine(COf,mm,ss,rco))=
*         CoprodIHS(COf,mm,ss,'t15',rco)-CoprodIHS(COf,mm,ss,"t12",rco);
*         Cobld.up(COf,mm,ss,'t12',rco)$(Cobld.up(COf,mm,ss,'t12',rco)<0)  =0;



*temp2(COf,mm,ss,rco) = (CoprodIHS(COf,mm,ss,'t15',rco)-CoprodIHS(COf,mm,ss,'t11',rco));
*CoprodIHS(COf,mm,ss,'t11',rco)=CoprodIHS(COf,mm,ss,'t11',rco)+temp2(COf,mm,ss,rco)$(temp2(COf,mm,ss,rco)>0);

*$(Cobld.up(COf,mm,ss,'t11',rco)<0)=0;


elseif s('EIA'),

COtransbld.up(tr,trun,rco,rrco) = 0;

         t_start=1;

         coal_cap=1;
         rail_cap=1;

*$ontext
*Load EIA demand data
        OTHERCOconsump(COf,time,rr)=0;

        OTHERCOconsump(COf,time,rr)$(OTHERCOconsump(COf,time,rr)>0) =
COconsumpEIA(COf,time)*OTHERCOconsump(COf,time,rr)/sum(r,OTHERCOconsump(COf,time,r));

        OTHERCOconsump(COf,time,rr)$(ord(time)>25 and COconsumpEIA(COf,time)>0) =
COconsumpEIA(COf,time)*OTHERCOconsump(COf,'t35',rr)/sum(r,OTHERCOconsump(COf,'t35',r));

*convert EIA demand from trillion btu to million tons at 7000kcal/kg for steam
*0.252164401 kcal/btu
        OTHERCOconsump(coal,time,rr)=OTHERCOconsump(coal,time,rr)*0.252164401/7 ;


*convert EIA met coal consumption in trillion BTU to million tons using reported
* 2011 met coal consumption in tons from IHS coal rush.

mmBTUtoTons =  sum(met,COconsumpEIA(met,'t11'))/sum((met,r), OTHERCOconsump(met,'t11',r));

        OTHERCOconsump(met,time,rr)=OTHERCOconsump(met,time,rr)/mmBTUtoTons;

*$offtext

*OTHERCOconsump(COf,time,rr)=COconsumpIHS(COf,time,rr)

);
