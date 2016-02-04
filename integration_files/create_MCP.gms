********************************************************************************
*
* This is the model decleration to be used wehn calling solve integratedMCP
*
********************************************************************************

$ontext
parameter budget(time) budget limit for the power and water sectors;
budget(time)=10e3;

Equations
Budgetlim(time);

Budgetlim(t)..
-(
* utilities capital cost and non fuel OM
  (ELImports(t)+ELConstruct(t)+ELOpandmaint(t))*ELdiscfact(t)
 +(WAImports(t)+WAConstruct(t)+WAOpandmaint(t))*WAdiscfact(t)

+(1-subsidy(t)$(partialdereg=1))*(
 +sum((ELf,r)$ELfup(ELf),Dfdem(ELf,t,r)*ELfconsump(ELf,t,r))*ELdiscfact(t)
 +sum((ELf,r)$ELfref(ELf),DRFdem(ELf,t,r)*ELfconsump(ELf,t,r))*ELdiscfact(t)
 +sum((WAf,r)$WAfup(WAf),Dfdem(WAf,t,r)*WAfconsump(WAf,t,r))*WAdiscfact(t)
 +sum((WAf,r)$WAfref(WAf),DRFdem(WAf,t,r)*WAfconsump(WAf,t,r))*WAdiscfact(t)
 )$(deregulated=1)

  +sum((ELf,r),ELAPF(ELf,t,r)*ELfconsump(ELf,t,r))*ELdiscfact(t)$(deregulated<>1)
  +sum((WAf,r),WAAPf(WAf,t,r)*WAfconsump(WAf,t,r))*WAdiscfact(t)$(deregulated<>1)
)
         =g=-(budget(t)*budgetgrowth(t)
+(sum((ELl,r),PCELprice*PCELconsump(ELl,t,r)+RFELprice*RFELconsump(ELl,t,r)+WAAPel(ELl,t,r)*WAELconsump(ELl,t,r))-210.536));
$offtext

option MCP=path;

*option savepoint=1;
*option solPrint=silent;
option limrow=0;
option limcol=0;



model integratedMCP
/
*        COAL SUBMODEL
COpurchbal.DCOpurchbal,COcnstrctbal.DCOcnstrctbal,
COopmaintbal.DCOopmaintbal,COcapbal.DCOcapbal,COcaplim.DCOcaplim,
COsulflim.DCOsulflim,COprodfx.DCOprodfx,COprodCV.DCOprodCV,COprodlim.DCOprodlim,

DCOpurchase.COpurchase,DCOconstruct.COconstruct,DCOopandmaint.COopandmaint,
DCOprod.COprod,DCOexistcp.COexistcp,DCObld.CObld,Dcoalprod.coalprod,

*        COAL TRANSPORTATION SUBMODEL

COtransPurchbal.DCOtransPurchbal,COtransCnstrctbal.DCOtransCnstrctbal,
COtransOpmaintbal.DCOtransOpmaintbal,COtransbldeq.DCOtransbldeq,
COimportbal.DCOimportbal,

COimportsuplim.DCOimportsuplim,COimportlim.DCOimportlim,
COsup.DCOsup,COsuplim.DCOsuplim,
COdem.DCOdem,
COdemOther.DCOdemOther,

COtranscapbal.DCOtranscapbal,COtransportcaplim.DCOtransportcaplim,
COtranscaplim.DCOtranscaplim,Cotransloadlim.DCotransloadlim,
*COexportlim.DCOexportlim,
*COtransbudgetlim.DCOtransbudgetlim,

DCOtransPurchase.COtransPurchase,DCOtransConstruct.COtransConstruct,
DCOtransOpandmaint.COtransOpandmaint,DCOimports.COimports,

DCOtrans.COtrans,DCOtransload.COtransload,
DCOtransexistcp.COtransexistcp,DCOtransbld.COtransbld,

Dcoaluse.coaluse, Dcoalimports.coalimports,
*Dcoalexports.coalexports
DOTHERCOconsumpsulf.OTHERCOconsumpsulf



*        POWER SUBMODEL
ELpurchbal.DELpurchbal,ELcnstrctbal.DELcnstrctbal,ELopmaintbal.DELopmaintbal,
ELfcons.DELfcons,ELfavail.DELfavail,ELcapbal.DELcapbal,ELcaplim.DELcaplim,
ELgtconvlim.DELgtconvlim,ELnucconstraint.DELnucconstraint,

ELwindcapbal.DELwindcapbal,ELwindcaplim.DELwindcaplim,ELwindutil.DELwindutil,
ELwindcapsum.DELwindcapsum,ELupspinres.DELupspinres,
ELsup.DELsup,ELdem.DELdem,ELdemloc.DELdemloc,ELrsrvreq.DELrsrvreq,

ELtranscapbal.DELtranscapbal,ELtranscaplim.DELtranscaplim,

ELhydcapbal.DELhydcapbal,ELhydcaplim.DELhydcaplim,
ELhydutil.DELhydutil,ELhydutilsto.DELhydutilsto,

ELfgclim.DELfgclim,ELfgccaplim.DELfgccaplim,
ELfgcfcons.DELfgcfcons,ELfgccapbal.DELfgccapbal,

DELImports.ELImports,DELConstruct.ELConstruct,DELOpandmaint.ELOpandmaint,
DELbld.ELbld,DELwindbld.ELwindbld,DELgttocc.ELgttocc,DELop.ELop,DELoploc.ELoploc
,DELwindop.ELwindop,DELexistcp.ELexistcp,DELwindexistcp.ELwindexistcp,
DELwindoplevel.ELwindoplevel,DELupspincap.ELupspincap,

DELtrans.ELtrans,DELtransbld.ELtransbld,DELtransexistcp.ELtransexistcp,
DELfconsump.ELfconsump,DELCOconsump.ELCOconsump,

DELhydexistcp.ELhydexistcp,DELhydop.ELhydop,DELhydopsto.ELhydopsto,
DELhydbld.ELhydbld,

DELfgc.ELfgc,DELfgcexistcp.ELfgcexistcp,DELfgcbld.ELfgcbld,

*        Emissions constraints
EMsulflim.DEMsulflim

*ELsuptariff.DELsuptariff

/;

*DEMsulflim.fx(trun,r)=0;
*DEMELsulflim.fx(trun,r)=0;

*DCOsuplim.fx(COf,ash,sulf,ELs,trun,rco) = 0;

$ontext
$gdxin ..\calibration\Integratedlp_p.gdx
$load OTHERCOconsumpsulf ELfgc
$gdxin

OTHERCOconsumpsulf.fx(COf,ash,sulf,trun,rr)=OTHERCOconsumpsulf.l(COf,ash,sulf,trun,rr);
ELfgc.fx(ELpd,v,sulf,trun,r)=ELfgc.l(ELpd,v,sulf,trun,r);
$offtext

*$ontext

integratedMCP.optfile = 1 ;

integratedMCP.workspace=1024;

integratedMCP.scaleopt = 1;
*COdem.scale(COf,ELs,time,rr)=1e3;

$ontext



PCpurchbal.scale(time)=1e3;
DPCpurchbal.scale(time)=1e-3;
PCopmaintbal.scale(time)=1e3;
DPCopmaintbal.scale(time)=1e-3;
PCopandmaint.scale(time)=1e1;
DPCopandmaint.scale(time)=1e-1;
PCcnstrctbal.scale(time)=1e2;
DPCcnstrctbal.scale(time)=1e-2;
PCExpendlim.scale(time)=1e2;
DPCExpendlim.scale(time)=1e-2;
PCImports.scale(time)=1e2;
DPCImports.scale(time)=1e-2;
DPCpowerbal.scale(time,r)=1e-1;

WApurchbal.scale(time)=1e2;
DWApurchbal.scale(time)=1e-2;

ELpurchbal.scale(time)=1e2;
DELpurchbal.scale(time)=1e-2;
WAopmaintbal.scale(time)=1e2;
DWAopmaintbal.scale(time)=1e-2;
budgetlim.scale(time)=1e1;
ELopmaintbal.scale(time)=1e1;
DELopmaintbal.scale(time)=1e-1;
WAcnstrctbal.scale(time)=1e1;
DWAcnstrctbal.scale(time)=1e-1;
ELcnstrctbal.scale(time)=1e1;
DELcnstrctbal.scale(time)=1e-1;
DWAtransbld.scale(time,r,rr)=1e1;

WAfcons.scale(WAf,time,r)=1e1;
DWAfcons.scale(WAf,time,r)=1e-1;
DELfcons.scale(ELf,time,r) = 1e-1;
ELfcons.scale(ELf,time,r)=1e1;

*$offtext

$offtext
