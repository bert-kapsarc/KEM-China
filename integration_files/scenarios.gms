         ELwindtot=0;;

*!!!     Restrict hydro investment
         ELbld.up(Elphyd,'new',trun,r)=0;

         rail_disc('rail',trun,rco,rrco)=COtransconstcst('rail',trun,rco,rrco)*0.9999;


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
         COrailCFS=0;

*!!!     Introduce a cap on coal production.
*     COprodData(COf,mm,ss,t,rco) must be stricly > COexistcp(COf,mm,ss,t,rco)
         coal_cap=1;

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

);

