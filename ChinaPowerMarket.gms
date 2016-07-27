
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


         scalar ELwindtotal ;
         scalar ELdeficitmax;

*!!!     Turn on demand in all regions
         rdem_on(r) = yes;

$INCLUDE powersubmodel.gms

$INCLUDE imports.gms


$INCLUDE discounting.gms
         ELdiscfact(time)  = 1;

         ELpfit=0;
         ELwtarget=1;
         SO2_std=0;

         ELwindtot=sum((ELpw,v,r),ELwindexistcp.l(ELpw,v,"t12",r))+1e-3;
         ELdeficitmax = 200e3;

*         ELCOconsump.fx(ELpcoal,v,gtyp,cv,sulf,sox,nox,t,r)$(
*                 ELpfgc(Elpcoal,cv,sulf,sox,nox) and (noDesox(sox) or noDenox(nox)) ) =0;

$INCLUDE scenarios.gms

*$INCLUDE short_run.gms
*COprodStats(COf,mm,ss,"t12",rco)  = COprodStats(COf,mm,ss,"t15",rco);
*$INCLUDE new_stock.gms

*parameter contract;

*!!!     Turn on max on-grid tariff
*         ELptariff(ELpd,v) = yes;
*         ELptariff(ELpw,v) = yes;
*         ELptariff(ELphyd,v) = yes;
         ELctariff(ELc,v) = no;
         ELcELp(ELp,v,ELp,v)= no;

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


         Solve PowerMCP using MCP;

$INCLUDE RW_EL.gms
$INCLUDE RW_CO.gms



parameter ELpcostfuel ;

*
* When solving the standalone power model as an LP  the cost of capacity
* contracts should include the marignal value of the using theexisting capacity
* The marginal values are an important endogenous component of the tariff
* from the generators profit condition (signals scarcity of existing capacity)
* in the MCP, however these marginal values are not considered in the associated
* LP for the utility.
* The generators profit condition is enfocred with the follwoing pretreatment
* using the dual variable associated with existing capacity contracts

$ontext
ELpcostfuel(ELpd,v,spin,ELlm,Elf,cv,sulf,sox,nox,t,r)$ELpElf(Elpd,spin,Elf,cv,sulf,sox,nox)=
  ELpcost(Elpd,v,ELlm,sox,nox,t,r)
  +( ELAPf(ELf,'ss1',t,r)$(not ELpcoal(Elpd))
    +DCOdem.l(ELf,cv,sulf,'summ',t,r)$ELpcoal(ELpd)
  )*ELfuelburn(ELpd,v,ELf,cv,r)*ELlmchours(ELlm)
                 *(1$nospin(spin) + ELusrfuelfrac$upspin(spin))
  +sum((ELl)$(ELpcoal(ELpd) and DeSOx(sox) and ELlELlm(ELl,ELlm)),
         DELfgccaplim.l(sox,ELpd,v,ELl,t,r))$vo(v)
;

ELpcostfuel(ELpd,v,spin,ELlm,Elf,cv,sulf,sox,nox,t,r)$ELpElf(Elpd,spin,Elf,cv,sulf,sox,nox)=
ELpcostfuel(ELpd,v,spin,ELlm,Elf,cv,sulf,sox,nox,t,r)/ELlmchours(ELlm);


contract('MCP_q',ELpd,v,nospin,ELlm,Elf,cv,sulf,sox,nox,t,r) = ELop.l(ELpd,v,ELlm,Elf,cv,sulf,sox,nox,t,r);
contract('MCP_p',ELpd,v,spin,ELlm,Elf,cv,sulf,sox,nox,t,r)$(ElcapELlm.l(ELpd,v,spin,ELlm,Elf,cv,sulf,sox,nox,t,r)>0)
          = ELTariff.l(ELpd,v,spin,ELlm,Elf,cv,sulf,sox,nox,t,r);
contract('MCP_c',ELpd,v,spin,ELlm,Elf,cv,sulf,sox,nox,t,r)$(ElcapELlm.l(ELpd,v,spin,ELlm,Elf,cv,sulf,sox,nox,t,r)>0)
          = ELpcost(ELpd,v,ELlm,sox,nox,t,r)/ELlmchours(ELlm)/(
            ELparasitic(Elpd)-EMfgcpower(sulf,sox,nox)/Elpeff(ELpd,v));
contract('MCP_fc',ELpd,v,spin,ELlm,Elf,cv,sulf,sox,nox,t,r)$(ElcapELlm.l(ELpd,v,spin,ELlm,Elf,cv,sulf,sox,nox,t,r)>0)
          = ( DELfcons.l(ELf,t,r)$(not ELpcoal(Elpd))
                 +DELCOcons.l(ELpd,cv,sulf,sox,nox,t,r)$ELpcoal(ELpd)
                 )*ELfuelburn(ELpd,v,ELf,cv,r)*ELlmchours(ELlm)
                 *(1$nospin(spin) + ELusrfuelfrac$upspin(spin))/ELlmchours(ELlm)/(
            ELparasitic(Elpd)-EMfgcpower(sulf,sox,nox)/Elpeff(ELpd,v)) ;
contract('MCP_cc',ELpd,v,spin,ELlm,Elf,cv,sulf,sox,nox,t,r)$(ElcapELlm.l(ELpd,v,spin,ELlm,Elf,cv,sulf,sox,nox,t,r)>0)
          =  sum(ELl$ELlELlm(ELl,ELlm),DELcaplim.l(ELpd,v,ELl,t,r))$vo(v)/(
            ELparasitic(Elpd)-EMfgcpower(sulf,sox,nox)/Elpeff(ELpd,v));
contract('MCP_p2',ELpd,v,spin,ELlm,Elf,cv,sulf,sox,nox,t,r)$(ElcapELlm.l(ELpd,v,spin,ELlm,Elf,cv,sulf,sox,nox,t,r)>0)
          = DELcaplimcontr.l(ELpd,v,spin,ELlm,Elf,cv,sulf,sox,nox,t,r);
$offtext




$ontext

ELpcostfuel(ELpd,v,spin,ELlm,Elf,cv,sulf,sox,nox,t,r)$ELpElf(Elpd,spin,Elf,cv,sulf,sox,nox)=
  ELpcost(Elpd,v,ELlm,sox,nox,t,r)
  +( ELAPf(ELf,'ss1',t,r)$(not ELpcoal(Elpd))
    +DCOdem.l(ELf,cv,sulf,'summ',t,r)$ELpcoal(ELpd)
  )*ELfuelburn(ELpd,v,ELf,cv,r)*ELlmchours(ELlm)
                 *(1$nospin(spin) + ELusrfuelfrac$upspin(spin))
*  +DELcaplim.l(ELpd,v,t,r)$vo(v)
;
*$offtext
*ELtariff.fx(ELpd,v,ELlm,Elf,cv,sulf,sox,nox,t,r)$ELpElf(Elpd,Elf,cv,sulf,sox,nox) = 1e6;


ELtariff.fx(ELpd,v,spin,ELlm,Elf,cv,sulf,t,r)$(ELpElf(Elpd,spin,Elf,cv,sulf))
         =ELpcostfuel(ELpd,v,spin,ELlm,Elf,cv,sulf,t,r);

ELcapELlm.up(ELpd,v,spin,ELlm,ELf,cv,sulf,t,r)$(ELpELf(ELpd,spin,Elf,cv,sulf)
         and ELpcostfuel(ELpd,v,spin,ELlm,Elf,cv,sulf,t,r) >
         (ELtariffmax(ELpd,r)*ELlmchours(ELlm)))
         = 0;


*ELbld.up(ELpd,v,t,r) = ELbld.l(ELpd,v,t,r) ;


         option NLP=pathnlp;

*         execute_loadpoint "PowerLP_p.gdx";
         Solve PowerLP using NLP minimizing z;

*abort ELtariff.l;


*z.l = z.l + sum((ELpd,v,ELlm,Elf,cv,sulf,t,r)$vo(v),DELcaplim.l(ELpd,v,t,r)*Elop.l(ELpd,v,ELlm,Elf,cv,sulf,t,r))
*          + sum((ELpd,v,ELlm,Elf,cv,sulf,t,r)$vo(v),DELcaplim.l(ELpd,v,t,r)*ELupspincap.l(Elpd,v,ELlm,ELf,cv,sulf,t,r))


*$offtext
Display z.l;
*Display zMCP;
*$offtext



contract('LP_q',ELpd,v,nospin,ELlm,Elf,cv,sulf,t,r) = Elop.l(ELpd,v,ELlm,Elf,cv,sulf,t,r);
contract('LP_p',ELpd,v,spin,ELlm,Elf,cv,sulf,t,r)$(Elop.l(ELpd,v,ELlm,Elf,cv,sulf,t,r)>0)
          = ELTariff.l(ELpd,v,spin,ELlm,Elf,cv,sulf,t,r);
contract('LP_p2',ELpd,v,spin,ELlm,Elf,cv,sulf,t,r)$(Elop.l(ELpd,v,ELlm,Elf,cv,sulf,t,r)>0)
          = ELcaplimcontr.m(ELpd,v,spin,ELlm,Elf,cv,sulf,t,r);
contract('LP_p3',ELpd,v,spin,ELlm,Elf,cv,sulf,t,r)$(Elop.l(ELpd,v,ELlm,Elf,cv,sulf,t,r)>0)
          = ELcaplim.m(ELpd,v,t,r);
*/ELlmchours(Ellm);




$offtext

