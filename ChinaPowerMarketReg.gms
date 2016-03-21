
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


*!!!     Turn on demand in all regions
         rdem_on(r) = yes;

$INCLUDE powersubmodel.gms

$INCLUDE imports.gms


$INCLUDE discounting.gms
         ELdiscfact(time)  = 1;


$INCLUDE scenarios.gms

$INCLUDE short_run.gms
*$INCLUDE new_stock.gms


         ELpfit=1;
*         EL2020=1;
*         ELfitv.fx(Elpw,trun,r) = 280;

parameter contract;

*!!!     Turn on max on-grid tariff
         ELptariff(ELpd,v)$(not ELpgttocc(ELpd)) = yes;
         ELptariff(ELpw,v) = yes;
         ELptariff(ELphyd,v) = yes;

*!!!     Turn on railway construction tax
         COrailCFS=1;


* !!!!   ELcELp subset defines plants operated by regional power companies
* !!!!   Elctariff defines companies evaluated in the revenue contraints
*$ontext
         ELctariff(ELbig,vn)=yes;
         ELctariff(ELnuc,v)=yes;

         ELcELp(ELbig,vv,ELp,v)$(not Elpnuc(Elp) and Elctariff(Elbig,vv)) = yes;
         ELcELp(ELnuc,v,ELpnuc,v)= yes;

         ELrtariff(r) = yes;
*$offtext

*         ELcELp(ELp,v,ELp,v)= yes;
*         ELctariff(ELp,v)=yes;


         Elcapsub.up(Elp,vo,trun,r)=0;
         Elcapsub.up(Elp,vn,trun,r)=0;

         option savepoint=1;
         option MCP=PATH;
         PowerMCP.optfile=1;

*

*         execute_loadpoint "LongRunWind2020Reg.gdx" ELwindtarget, Elwindop ;
*         ELfitv.fx(Elpw,trun,r) =
*                 (ELwindtarget.m(trun)*ELwindtarget.l(trun))/
*                 sum((v,rr,ELl),ELwindop.l(ELpw,v,ELl,trun,rr));

         execute_loadpoint "PowerMCP_p.gdx";

         PowerMCP.scaleopt=1;

         ELprofit.scale(ELc,v,trun,r)$(not ELnuc(Elc))=1e2;
         DELprofit.scale(ELc,v,trun,r)$(not ELnuc(Elc))=1e-2;

*         COopmaintbal.scale(trun)=1e1;
*         DCOopmaintbal.scale(trun)=1e-1;
*         DELfconsump.up(ELpd,v,ELf,fss,trun,r)=1e-2;
*         ELfconsump.up(ELpd,v,ELf,fss,trun,r)=1e2;

*         DElcapsub.scale(ELp,v,trun,r)=1e-2;
*         Elcapsub.scale(ELp,v,trun,r)=1e2;

*         DElfuelsub.scale(ELp,v,ELl,ELf,trun,r)=1e1;
*         ELfuelsub.scale(ELp,v,ELl,ELf,trun,r)=1e-1;

*          Elexistcp.scale(ELp,v,trun,r)=1e2;
*          DElexistcp.scale(ELp,v,trun,r)=1e-2;

*          ELCOconsump.scale(ELpcoal,v,reg,cv,sulf,SOx,NOx,trun,r)=1e2;
*          DELCOconsump.scale(ELpcoal,v,reg,cv,sulf,SOx,NOx,trun,r)=1e-2;

*          ELfgcexistcp.scale(ELpd,v,fgc,trun,r)=1e2;
*          DELfgcexistcp.scale(ELpd,v,fgc,trun,r)=1e-2;

*          ELop.scale(ELpd,v,ELl,ELf,trun,r)=1e2;
*          DELop.scale(ELpd,v,ELl,ELf,trun,r)=1e-2;

*          ELupspincap.scale(ELp,v,ELl,ELf,t,r)=1e2;
*          ELupspincap.scale(ELp,v,ELl,ELf,t,r)=1e-2;

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

