*
********************************************************************************
*
* This is the model decleration to be used wehn calling solve integratedMCP
*
********************************************************************************

option LP=pathnlp;
*option savepoint=1;
*option solPrint=off;
option limrow=0;
option limcol=0;

$gdxin ChinaPowerSulf.gdx
$load EMsulflim
$gdxin

parameter ELsulfprice(trun,r);

Elsulfprice(trun,r) = EMsulflim.m(trun,r);

Equations
objective
;
*COobjective.. z =e=
objective.. z =e=
   sum(t,(COpurchase(t)+COConstruct(t)+COOpandmaint(t))*COdiscfact(t))
  +sum(t,(COtranspurchase(t)+COtransConstruct(t)
         +COtransOpandmaint(t)+COimports(t))*COdiscfact(t))
  +sum(t,(ELImports(t)+ELConstruct(t)+ELOpandmaint(t)
*         +sum(r,Elsulfprice(t,r)*EMsulf(t,r))
  +sum((ELpd,ELf,r)$ELfAP(ELf),ELAPf(ELf,t,r)*ELfconsump(ELpd,ELf,t,r))
         )*ELdiscfact(t))
;


*+sum(r,EMsulf(t,r)*15000)

model integratedLP
/

         objective

*        COAL EUATIONS
         COpurchbal, COcnstrctbal, COopmaintbal,COcapbal, COcaplim,
         COsulflim,COprodCV, COprodfx, COprodlim,
*         COashlim,        COashlimreg,

*        COAL TRANSPORT EQUATIONS
         COtransPurchbal, COtransCnstrctbal,COtransOpmaintbal,
         COtransbldeq,COimportbal,
         COimportsuplim,COsup,COimportlim,COsuplim,
         COdem,COdemOther,
         COtranscapbal,COtransportcaplim,COtranscaplim,Cotransloadlim,
*         COexportlim,                                       ,l

*         COuselim,


*        POWER EQUATIONS
         ELpurchbal,ELcnstrctbal,ELopmaintbal,ELfcons,ELCOcons,
         ELfavail,ELcapbal,ELcaplim,ELgtconvlim,ELnucconstraint,
         ELwindcapbal,ELwindcaplim,ELwindutil,
         ELwindcapsum,ELupspinres,ELsup,ELdem,ELrsrvreq,ELtranscapbal,
         ELtranscaplim,
         ELhydcapbal,ELhydcaplim,ELhydutil,ELhydutilsto,
*         ELfgclim,ELfgccaplim,ELfgcfcons,ELfgccapbal,

*         ELdemloc,

*        Emission constraints
*         EMELsulflim,
*         EMsulflim,
*         EMELnoxlim
/
;
ELoploc.fx(ELp,v,ELl,ELf,cv,trun,r)  =0;
ELfgc.fx(fgc,ELpd,v,cv,sulf,trun,r) =0;

*$ontext
