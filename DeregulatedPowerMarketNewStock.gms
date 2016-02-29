
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

*        Turn on demand in selected regions
         rdem_on(r) = yes;

$INCLUDE powersubmodel.gms

$INCLUDE imports.gms

$INCLUDE discounting.gms
         ELdiscfact(time)  = 1;


$INCLUDE scenarios.gms

parameter contract;

*         option savepoint=2;
         option MCP=path;

         PowerMCP.Optfile=1;
         PowerLP.Optfile=1;


$ontext
*!!!     Enforce maximum on-grid tariffs
         ELptariff(ELpnuc,v) = yes;
         ELptariff(ELpcoal,v) = yes;
         ELptariff(ELpCC,v) = yes;
         ELptariff(ELpog,v) = yes;
*         ELptariff('ST',vn) = no;
         ELptariff(ELphyd,v) = yes;
         ELptariff(ELpw,vn) = yes;
$offtext


*!!!     Turn on railway construction tax
*         COrailCFS=1;

*$ontext
         ELbld.up(ELpnuc,vn,trun,r)=0;

*        Remove existing capacity stock
         ELexistcs.fx(ELpd,v,trun,r)$(not ELpnuc(Elpd) and ord(trun)=1)=    0;

         ELtransexistcp.fx(Elt,trun,r,rr)$(ord(trun)=1)= 0;

         ELfgcexistcp.fx(ELpd,v,DeSOx,trun,r)$(ord(trun)=1)=0;
         ELfgcexistcp.fx(ELpd,v,DeNOx,trun,r)$(ord(trun)=1)=0;

*         COtransexistcp.fx(tr,trun,rco,rrco)$(ord(trun)=1 and arc(tr,rco,rrco))=0;
;
*$offtext


*!!!     Run model short run with adjusted capacity stocks
*$ontext
$INCLUDE short_run.gms
         execute_loadpoint "PowerDeregLongRunNewStock.gdx" ELbld, ELfgcbld, ELrsrvbld,ELtransbld, COtransbld;

         ELexistcs.fx(ELpd,v,trun,r)$(not ELpnuc(Elpd) and ord(trun)=1)=
                 ELbld.l(ELpd,v,trun,r)+ELrsrvbld.l(Elpd,v,trun,r);

         ELtransexistcp.fx(Elt,trun,r,rr)$(ord(trun)=1)=
         ELtransbld.l(ELt,trun,r,rr);

         ELfgcexistcp.fx(ELpd,v,fgc,trun,r)$(ord(trun)=1)=
                 ELfgcbld.l(ELpd,v,fgc,trun,r);
*         COtransexistcp.fx(tr,trun,rco,rrco)$(ord(trun)=1 and arc(tr,rco,rrco))=
*         COtransbld.l(tr,trun,rco,rrco);
*$offtext


*$ontext
* !!!    Solve MCP
         execute_loadpoint "PowerDeregNewStock.gdx"
         Solve PowerMCP using MCP;

$INCLUDE RW_EL.gms
$INCLUDE RW_Co.gms



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

