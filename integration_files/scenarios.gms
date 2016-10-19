         ELwindtot=sum((ELpw,v,r),ELexistcp.l(ELpw,v,"t12",r))+1e-3;

*!!!     Restrict hydro investment
         ELbld.up(Elphyd,'new',trun,r)=0;

         rail_disc(tr,trun,rco,rrco)=COtransconstcst(tr,trun,rco,rrco)*0.9999;


*        SET fixed and sunk costs used for power suppliers revenue constraint
         ELpfixedcost(Elp,v,trun,r) =
         ELfixedOMcst(ELp)+(ELpurcst(ELp,trun,r)+ELconstcst(ELp,trun,r));

         ELpsunkcost(ELpd,v,trun,r) =
          ELfixedOMcst(ELpd)+(ELpurcst(ELpd,trun,r)+ELconstcst(ELpd,trun,r))*
         (1$(vn(v)) + 0$(vo(v) and not ELpnuc(ELpd)));

         ELpsunkcost(ELp,v,trun,r)$ELphyd(Elp)=
         ELfixedOMcst(ELp)+(ELpurcst(ELp,trun,r)+ELconstcst(ELp,trun,r));

         ELpsunkcost(ELp,v,trun,r)$ELpw(Elp)=
         ELfixedOMcst(ELp)+(ELpurcst(ELp,trun,r)+ELconstcst(ELp,trun,r));

if( scen('calib'),

*!!!     Turn on demand in all regions
         rdem_on(r) = yes;


*!!!     Turn on railway construction tax
         COrailCFS=1;

*!!!     Introduce a cap on coal production.
*     COprodStats(COf,mm,ss,t,rco) must be stricly > COexistcp(COf,mm,ss,t,rco)
         coal_cap=1;


*!!!     Set upper bound on imports from some suppliers.
         COfimpmax('met',trun,'IMMN') = 25;
         COfimpmax('coal',trun,'IMKP') = 25;

*        allow coal mine expansion up to 2015 forecasted levels
*         Cobld.up(COf,mm,ss,'t12',rco)$(COmine(COf,mm,ss,rco))=
*         CoprodIHS(COf,mm,ss,'t15',rco)-CoprodIHS(COf,mm,ss,"t12",rco);
*         Cobld.up(COf,mm,ss,'t12',rco)$(Cobld.up(COf,mm,ss,'t12',rco)<0)  =0;

         ELwtarget=1;
         t_start=1;

$ontext
*!!!     force existing wind to operate
         ELwindoplevel.fx(wstep,ELpw,v,t,r)$(rdem_on(r) and vo(v))=
         1$((ELwindexist(r)/ELdemgro('LS1',t,r)-ord(wstep))>=0)
         + (     ELwindexist(r)/ELdemgro('LS1',t,r)
                 -floor(ELwindexist(r)/ELdemgro('LS1',t,r)))$(
         (ELwindexist(r)/ELdemgro('LS1',t,r)-ord(wstep))<0
         and (ELwindexist(r)/ELdemgro('LS1',t,r)-ord(wstep))>-1 );
$offtext



*!!!     Used in older version to assign maximum capacity on mixed freight lines
*        Current version assumes all rails lines are coal dedicated
*        This assumption can be modified by setting allocation quotas for some
*        cooridors.
*         rail_cap=1;

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

