model PowerLP Equation for power submodule LP (primal equations must match MCP)/
*ELProfit, Ignore profit constraint in LP model. this constraint can only be exprewssed as an MCP.
ELobjective
ELprofit_eqn,
ELwindtarget,
ELdeficitcap,
ELpurchbal,ELcnstrctbal,ELopmaintbal,
ELfcons,ELCOcons,
ELfavail,ELcapbal,
ELcaplim,ELcapcontr,
ELwindcaplim,ELwindutil,
ELwindcapsum,ELupspinres,
ELnucconstraint,
ELsup,ELdem,ELrsrvreq,
ELtranscapbal,ELtranscaplim,
ELhydutil,ELhydutilsto,
ELfgccaplim,ELfgccapmax,ELfgccapbal
/
;

*$ontext
model PowerMCP

/
ELProfit_eqn,ELrevenue_constraint_bilinear.DELrevenue_constraint_bilinear,ELwindtarget.DELwindtarget,
*ELfitcap.DELfitcap,DELwindsub.ELwindsub,
ELdeficitcap.DELdeficitcap,
ELpurchbal.DELpurchbal,ELcnstrctbal.DELcnstrctbal,ELopmaintbal.DELopmaintbal,
ELfcons.DELfcons,ELCOcons.DELCOcons,
ELfavail.DELfavail,ELcapbal.DELcapbal,
ELcaplim.DELcaplim,ELcapcontr.DELcapcontr,
*ELgtconvlim.DELgtconvlim,
ELwindcaplim.DELwindcaplim,ELwindutil.DELwindutil,
ELwindcapsum.DELwindcapsum,ELupspinres.DELupspinres,
ELnucconstraint.DELnucconstraint,
ELsup.DELsup,ELdem.DELdem,ELrsrvreq.DELrsrvreq,
*ELdemloc.DELdemloc
ELtranscapbal.DELtranscapbal,ELtranscaplim.DELtranscaplim,
ELhydutil.DELhydutil,
ELhydutilsto.DELhydutilsto,
ELfgccaplim.DELfgccaplim,ELfgccapmax.DELfgccapmax,ELfgccapbal.DELfgccapbal,

DELImports.ELImports,DELConstruct.ELConstruct,DELOpandmaint.ELOpandmaint,
DELexistcp.ELexistcp,DELbld.ELbld,
*DELgttocc.ELgttocc,
DELop.ELop,DELupspincap.ELupspincap,
*DELoploc.ELoploc,
DELwindoplevel.ELwindoplevel,
DELtrans.ELtrans,DELtransbld.ELtransbld,DELtransexistcp.ELtransexistcp,
DELfconsump.ELfconsump,DELCOconsump.ELCOconsump,
DELhydopsto.ELhydopsto,DELfgcexistcp.ELfgcexistcp,DELfgcbld.ELfgcbld,
DELcapsub.Elcapsub,DELdeficit.ELdeficit,
/;


model CoalLP Equation for power submodule LP (primal equations must match MCP)/

COobjective_CFS
COobjective
COpurchbal,COcnstrctbal,COopmaintbal,
COcapbal,COcaplim,
COwashcaplim,COsulflim,
COprodfx,COprodCV,COprodlim,
*COcapcuts,

COtransPurchbal,COtransCnstrctbal,
COtransOpmaintbal,
COtransbldeq,
COimportbal,

COimportsuplim,COimportlim,COimportlim_nat,
COsup,COsuplim,
COdem,COdemOther,

COtranscapbal,COtransportcaplim,
COtranscaplim,Cotransloadlim,
/
;
model CoalMCP / CoalLP, COprice_eqn /

model CoalMCP_old
/
*$ontext
COpurchbal.DCOpurchbal,COcnstrctbal.DCOcnstrctbal,
COopmaintbal.DCOopmaintbal,COcapbal.DCOcapbal,COcaplim.DCOcaplim,
COwashcaplim.DCOwashcaplim,COsulflim.DCOsulflim,
COprodfx.DCOprodfx,COprodCV.DCOprodCV,COprodlim.DCOprodlim,

DCOpurchase.COpurchase,DCOconstruct.COconstruct,DCOopandmaint.COopandmaint,
DCOprod.COprod,DCOexistcp.COexistcp,DCObld.CObld,Dcoalprod.coalprod

COtransPurchbal.DCOtransPurchbal,COtransCnstrctbal.DCOtransCnstrctbal,
COtransOpmaintbal.DCOtransOpmaintbal,
COtransbldeq.DCOtransbldeq,
COimportbal.DCOimportbal,

COimportsuplim.DCOimportsuplim,COimportlim.DCOimportlim,
COsup.DCOsup,COsuplim.DCOsuplim,
COdem.DCOdem,COdemOther.DCOdemOther,

COtranscapbal.DCOtranscapbal,COtransportcaplim.DCOtransportcaplim,
COtranscaplim.DCOtranscaplim,Cotransloadlim.DCotransloadlim,
* COexportlim.DCOexportlim,
* COtransbudgetlim.DCOtransbudgetlim,

DCOtransPurchase.COtransPurchase,DCOtransConstruct.COtransConstruct,
DCOtransOpandmaint.COtransOpandmaint,DCOimports.COimports,

DCOtrans.COtrans,DCOtransload.COtransload,
DCOtransexistcp.COtransexistcp,DCOtransbld.COtransbld,

Dcoaluse.coaluse, Dcoalimports.coalimports,
* Dcoalexports.coalexports

DOTHERCOconsumpsulf.OTHERCOconsumpsulf,
*$offtext

/;

model EmissionLP /

EMsulflim,EMELnoxlim,
EMfgbal,EMELSO2std,EMELNO2std
/;

model EmissionMCP /

DEMELfluegas.EMELfluegas,
EMsulflim.DEMsulflim,EMELnoxlim.DEMELnoxlim,
EMfgbal.DEMfgbal,EMELSO2std.DEMELSO2std,EMELNO2std.DEMELNO2std
/;

equation objective;
$offorder
objective.. objvalue =e=COobjvalue_CFS+ELobjvalue;
$onorder


* additional model options.

Model CoalPowerLP /PowerLP CoalLP objective/ ;
Model CoalPowerMCP /PowerMCP CoalMCP_old/ ;

Model IntegratedLP /CoalPowerLP EmissionLP/ ;
Model IntegratedMCP /CoalPowerMCP EmissionMCP/ ;

         option savepoint=1;
         option MCP=PATH;
         option NLP=IPOPT;
         option LP=cbc;

         PowerMCP.optfile=1;
         CoalMCP.optfile=1;
         IntegratedMCP.optfile=1;
         CoalPowerMCP.optfile=1;

         IntegratedMCP.scaleopt=1;

         PowerMCP.scaleopt=1;
         CoalMCP.scaleopt=1;

         ELrevenue_constraint_bilinear.scale(ELc,v,trun,r)=1e2;
         DELrevenue_constraint_bilinear.scale(ELc,v,trun,r)=1e-2;

         EMfgbal.scale(ELpcoal,v,trun,r)=1e3;
         DEMfgbal.scale(ELpcoal,v,trun,r)=1e-3;

         COtransCnstrctbal.scale(trun)=1e-1;
         COtransbld.scale(tr,trun,rco,rrco)=1e2;

         EMELnoxlim.scale(trun,r)=1e-1;
         DEMELnoxlim.scale(trun,r)=1e1;

         COtransOpmaintbal.scale(trun)=1e2;
         DCOtransOpmaintbal.scale(trun)=1e-2;
         COobjective.scale=1e2;
