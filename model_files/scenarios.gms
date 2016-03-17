* !!! cost for operating capacity over ELLmchours
         ELtariffmax(Elpd,r)$(not ELpnuc(Elpd)) = ELtariffmax(Elpd,r)/1.17;
         ELtariffmax(Elpd,r)$(ELpcoal(Elpd)) = ELtariffmax(Elpd,r)-ELfgctariff('DeSOx')-ELfgctariff('DeNOx');
*
*         ELtariffmax(Elpw,r) = ELtariffmax('Ultrsc',r);

         ELpcost(Elpd,v,sox,nox,trun,r)=
            ELomcst(ELpd,v,r)+(EMfgcomcst(sox)+EMfgcomcst(nox))$ELpcoal(ELpd);

         DELTA(Elp,v,trun,r)=
         ELtariffmax(Elp,r)*ELparasitic(Elp,v)-ELomcst(Elp,v,r);

         ELpfixedcost(Elp,v,trun,r) =
         ELfixedOMcst(ELp)+(ELpurcst(ELp,trun,r)+ELconstcst(ELp,trun,r));


         ELpsunkcost(ELpd,v,trun,r) =
          ELfixedOMcst(ELpd)+(ELpurcst(ELpd,trun,r)+ELconstcst(ELpd,trun,r))*
         (1$(vn(v)) + 0$(vo(v) and not ELpnuc(ELpd)));

         ELpsunkcost(ELp,v,trun,r)$ELphyd(Elp)=
         ELfixedOMcst(ELp)+(ELpurcst(ELp,trun,r)+ELconstcst(ELp,trun,r))*0;

         ELpsunkcost(ELp,v,trun,r)$ELpw(Elp)=
         ELfixedOMcst(ELp)+(ELpurcst(ELp,trun,r)+ELconstcst(ELp,trun,r));


*        no on-grid electricity tarrifs
         ELptariff(ELpd,v) = no;


* !!!    Set feed-in tariffs
         ELfit(ELpw,trun,r) = 600;
         ELfit(ELpw,trun,'CoalC') = 510;
         ELfit(ELpw,trun,'North') = 540;
         ELfit(ELpw,trun,'Northeast') = 580;
         ELfit(ELpw,trun,'West') = 580;
         ELfit(ELpw,trun,'Xinjiang') = 580;


         ELfitv.fx(Elpw,trun,r) = ELfit(Elpw,trun,r);

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
