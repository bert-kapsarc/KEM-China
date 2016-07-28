
*$INCLUDE ACCESS_sets.gms
*$INCLUDE ACCESS_CO.gms
*$INCLUDE ACCESS_COtrans.gms
*$INCLUDE ACCESS_EL.gms
$INCLUDE Macros.gms
$INCLUDE SetsandVariables.gms
$INCLUDE ScalarsandParameters.gms
$INCLUDE RW_param.gms
$INCLUDE coalsubmodel.gms
$INCLUDE coaltranssubmodel.gms

         scalar ELdeficitmax;

*!!!     Turn on demand in all regions
         rdem_on(r) = yes;

$INCLUDE powersubmodel.gms
$INCLUDE create_models.gms

$INCLUDE imports.gms


$INCLUDE discounting.gms
         ELdiscfact(time)  = 1;

         ELdefcap=0;
         ELpfit=0;
         ELwtarget=1;
         SO2_std=0;

         ELwindtot=sum((ELpw,v,r),ELwindexistcp.l(ELpw,v,"t12",r))+1e-3;
         ELdeficitmax = 0e3;

*         ELCOconsump.fx(ELpcoal,v,gtyp,cv,sulf,sox,nox,t,r)$(
*                 ELpfgc(Elpcoal,cv,sulf,sox,nox) and (noDesox(sox) or noDenox(nox)) ) =0;


         ELctariff(ELc,v) = no;
         ELcELp(ELp,v,ELp,v)= no;

$INCLUDE scenarios.gms
*$INCLUDE on_grid_tariffs.gms
*$INCLUDE short_run.gms
*COprodStats(COf,mm,ss,"t12",rco)  = COprodStats(COf,mm,ss,"t15",rco);
*$INCLUDE new_stock.gms



*!!!     Turn on railway construction tax
         COrailCFS=1;


         option savepoint=2;
         option MCP=PATH;
         PowerMCP.optfile=1;

*         execute_loadpoint "LongRunWind2020.gdx" ELwindtarget, Elwindop ;
*         ELfitv.fx(Elpw,trun,r) =
*                 (ELwindtarget.m(trun)*ELwindtarget.l(trun))/
*                 sum((v,rr,ELl),ELwindop.l(ELpw,v,ELl,trun,rr));

         execute_loadpoint "LongRun.gdx" ;


         PowerMCP.scaleopt=1;

         ELprofit.scale(ELc,v,trun,r)=1e2;
         DELprofit.scale(ELc,v,trun,r)=1e-2;

         EMfgbal.scale(ELpcoal,v,trun,r)=1e3;
         DEMfgbal.scale(ELpcoal,v,trun,r)=1e-3;

         COtransCnstrctbal.scale(trun)=1e-1;
         COtransbld.scale(tr,trun,rco,rrco)=1e2;

         EMELnoxlim.scale(trun,r)=1e-1;
         DEMELnoxlim.scale(trun,r)=1e1;

         t(trun) = yes;

         Solve PowerMCP using MCP;

$INCLUDE RW_EL.gms
$INCLUDE RW_CO.gms

