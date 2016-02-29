* !!! cost for operating capacity over ELLmchours
         ELtariffmax(Elpd,r)$(not ELpnuc(Elpd)) = ELtariffmax(Elpd,r)*1;
         ELtariffmax(Elpd,r)$(ELpcoal(Elpd)) = ELtariffmax(Elpd,r)-ELfgctariff('DeSOx')-ELfgctariff('DeNOx');
*
*         ELtariffmax(Elpw,r) = ELtariffmax('Ultrsc',r);

         loop((ELf,fss,cv,sulf),
         ELpcost(Elpd,v,sox,nox,trun,r)$ELpELf(Elpd,ELf,fss,cv,sulf,sox,nox)=
            (ELomcst(ELpd,v,r)+EMfgcomcst(sox)+EMfgcomcst(nox))
         );


         DELTA2(Elp,v,trun,r)=
         ELtariffmax(Elp,r)*ELparasitic(Elp,v)-ELomcst(Elp,v,r);


         loop((ELf,fss,cv),
         DELTA(Elpd,v,sulf,sox,nox,trun,r)$ELpELf(Elpd,ELf,fss,cv,sulf,sox,nox)=
         (ELtariffmax(Elpd,r)+ELfgctariff(sox)+ELfgctariff(nox))
                 *ELpCOparas(Elpd,v,sulf,sox,nox)
         -ELpcost(Elpd,v,sox,nox,trun,r)
         );

         ELpfixedcost(Elp,v,trun,r)=
         (ELfixedOMcst(ELp)+ELpurcst(ELp,trun,r)+ELconstcst(ELp,trun,r));


         ELpsunkcost(ELpd,v,trun,r)=
          ELfixedOMcst(ELpd)
         +(ELpurcst(ELpd,trun,r)+ELconstcst(ELpd,trun,r))*
         (1$(vn(v) or ELpnuc(ELpd)) + 0$(not ELpnuc(Elpd) and vo(v)))
;
*$ontext
         ELpsunkcost(ELpd,v,trun,r)$ELpsubcr(ELpd)=
          ELfixedOMcst(ELpd)
         +(ELpurcst(ELpd,trun,r)+ELconstcst(ELpd,trun,r))*
         (1$(vn(v)) + 0$(vo(v)))
*$offtext
;


         ELpsunkcost(ELp,v,trun,r)$ELphyd(Elp)=
         ELfixedOMcst(ELp)+(ELpurcst(ELp,trun,r)+ELconstcst(ELp,trun,r))*0;


         ELpsunkcost(ELp,v,trun,r)$ELpw(Elp)=
         ELfixedOMcst(ELp)+(ELpurcst(ELp,trun,r)+ELconstcst(ELp,trun,r));

         COintlprice(coal,ssi,cv_ord,sulf,time,rimp)=
         COintlprice(coal,ssi,cv_ord,sulf,time,rimp)*1;


*        no on-grid electricity tarrifs
         ELptariff(ELpd,v) = no;
         ELptariffcoal(v) = no;



         rail_disc(tr,t,rco,rrco)=COtransconstcst(tr,t,rco,rrco);


if( scen('calib'),

         coal_cap=1;
         rail_cap=1;
         import_cap=1;


         COfimpmax('met',t,'IMMN') = 25;
         COfimpmax('coal',t,'IMKP') = 25;

         COrailCFS=0;

         t_start=1;

*!!!     Restrict hydro investment
         ELhydbld.up(Elphyd,'new',trun,r)=0;

$ontext
*!!!     force existing wind to operate
         ELwindoplevel.fx(wstep,ELpw,v,t,r)$(rdem_on(r) and vo(v))=
         1$((ELwindexist(r)/ELdemgro('LS1',t,r)-ord(wstep))>=0)
         + (     ELwindexist(r)/ELdemgro('LS1',t,r)
                 -floor(ELwindexist(r)/ELdemgro('LS1',t,r)))$(
         (ELwindexist(r)/ELdemgro('LS1',t,r)-ord(wstep))<0
         and (ELwindexist(r)/ELdemgro('LS1',t,r)-ord(wstep))>-1 );
$offtext



*        allow coal mine expansion in 2011 conterfactual case
*         Cobld.up(COf,mm,ss,'t12',rco)$(COmine(COf,mm,ss,rco))=
*         CoprodIHS(COf,mm,ss,'t15',rco)-CoprodIHS(COf,mm,ss,"t12",rco);
*         Cobld.up(COf,mm,ss,'t12',rco)$(Cobld.up(COf,mm,ss,'t12',rco)<0)  =0;



*temp2(COf,mm,ss,rco) = (CoprodIHS(COf,mm,ss,'t15',rco)-CoprodIHS(COf,mm,ss,'t11',rco));
*CoprodIHS(COf,mm,ss,'t11',rco)=CoprodIHS(COf,mm,ss,'t11',rco)+temp2(COf,mm,ss,rco)$(temp2(COf,mm,ss,rco)>0);


elseif scen('EIA'),

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
