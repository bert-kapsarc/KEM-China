model PowerLP_eqns Equation for power submodule LP (primal equations must match MCP)/
*ELProfit, Ignore profit constraint in LP model. this constraint can only be exprewssed as an MCP.
ELwindtarget,ELfuelsublim,
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

model PowerLP /PowerLP_eqns ELobjective/

*$ontext
model PowerMCP

/
ELProfit.DELprofit,ELwindtarget.DELwindtarget,ELfuelsublim.DELfuelsublim,
*ELfitcap.DELfitcap,DELwindsub.ELwindsub,
ELdeficitcap.DELdeficitcap,
ELpurchbal.DELpurchbal,ELcnstrctbal.DELcnstrctbal,ELopmaintbal.DELopmaintbal,
ELfcons.DELfcons,ELCOcons.DELCOcons,
*ELfconsspin.DELfcons
ELfavail.DELfavail,ELcapbal.DELcapbal,
ELcaplim.DELcaplim,ELcapcontr.DELcapcontr,
*ELgtconvlim.DELgtconvlim,
*ELwindcapbal.DELwindcapbal,
ELwindcaplim.DELwindcaplim,ELwindutil.DELwindutil,
ELwindcapsum.DELwindcapsum,ELupspinres.DELupspinres,
ELnucconstraint.DELnucconstraint,
ELsup.DELsup,ELdem.DELdem,ELrsrvreq.DELrsrvreq,
*ELdemloc.DELdemloc,ELdemlocbase.DELdemlocbase,
ELtranscapbal.DELtranscapbal,ELtranscaplim.DELtranscaplim,
*ELhydcapbal.DELhydcapbal,ELhydcaplim.DELhydcaplim,
ELhydutil.DELhydutil,
ELhydutilsto.DELhydutilsto,
ELfgccaplim.DELfgccaplim,ELfgccapmax.DELfgccapmax,ELfgccapbal.DELfgccapbal,

DELImports.ELImports,DELConstruct.ELConstruct,DELOpandmaint.ELOpandmaint,
DELexistcp.ELexistcp,DELbld.ELbld,
*DELgttocc.ELgttocc,
DELop.ELop,DELupspincap.ELupspincap,
*DELoploc.ELoploc,
*DELwindop.ELwindop,
DELwindoplevel.ELwindoplevel,
*DELwindexistcp.ELwindexistcp,DELwindbld.ELwindbld,
DELtrans.ELtrans,DELtransbld.ELtransbld,DELtransexistcp.ELtransexistcp,
DELfconsump.ELfconsump,DELCOconsump.ELCOconsump,
*DELfconsumpspin.ELfconsumpspin
DELhydopsto.ELhydopsto,DELfgcexistcp.ELfgcexistcp,DELfgcbld.ELfgcbld,
DELcapsub.Elcapsub,DELfuelsub.ELfuelsub,DELdeficit.ELdeficit,
*DELsubsidycoal.ELsubsidycoal,
/;


model CoalLP_eqns Equation for power submodule LP (primal equations must match MCP)/
COobjective
COprice_eqn,
COpurchbal,COcnstrctbal,COopmaintbal,
COcapbal,COcaplim,
COwashcaplim,COsulflim,
COprodfx,COprodCV,COsupplylim,

COtransPurchbal,COtransCnstrctbal,
COtransOpmaintbal,
COtransbldeq,
COimportbal,

COimportsuplim,COimportlim,
COsup,COsuplim,
COdem,COdemOther,

COtranscapbal,COtransportcaplim,
COtranscaplim,Cotransloadlim,
/
;

model CoalLP /CoalLP_eqns/

model CoalMCP
/
*$ontext
COobjective,
COprice_eqn,
COpurchbal.DCOpurchbal,COcnstrctbal.DCOcnstrctbal,
COopmaintbal.DCOopmaintbal,COcapbal.DCOcapbal,COcaplim.DCOcaplim,
COwashcaplim.DCOwashcaplim,COsulflim.DCOsulflim,
COprodfx.DCOprodfx,COprodCV.DCOprodCV,COsupplylim.DCOprodlim,

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

model EmissionLP_eqns /

EMsulflim,EMELnoxlim,
EMfgbal,EMELSO2std,EMELNO2std
/;

model EmissionMCP /

DEMELfluegas.EMELfluegas,
EMsulflim.DEMsulflim,EMELnoxlim.DEMELnoxlim,
EMfgbal.DEMfgbal,EMELSO2std.DEMELSO2std,EMELNO2std.DEMELNO2std
/;
equation objective;
variable objvalue;
$offorder
objective.. objvalue =e=
 sum(t,(COpurchase(t)+COConstruct(t)+COOpandmaint(t))*COdiscfact(t))
+sum(t,(COtranspurchase(t)+COtransConstruct(t)
         +COtransOpandmaint(t)+COimports(t))*COdiscfact(t))
+sum(t,(ELImports(t)+ELConstruct(t)+ELOpandmaint(t))*ELdiscfact(t))
+sum((ELpd,v,ELf,fss,t,r)$(not ELfcoal(ELf) and not ELpcoal(Elpd)),
         ELAPf(ELf,fss,t,r)*(
         0.01$(fss0(fss) and not ELpnuc(ELpd))+1$(not fss0(fss) or Elpnuc(ELpd)) )*ELdiscfact(t)
         )
;
$onorder


* additiona model options.
Model IntegratedLP /PowerLP_eqns EmissionLP_eqns CoalLP_eqns objective/ ;
Model IntegratedMCP /PowerMCP CoalMCP EmissionMCP/ ;

         IntegratedMCP.scaleopt=1;

         PowerMCP.scaleopt=1;
         CoalMCP.scaleopt=1;

         ELprofit.scale(ELc,v,trun,r)=1e2;
         DELprofit.scale(ELc,v,trun,r)=1e-2;

         EMfgbal.scale(ELpcoal,v,trun,r)=1e3;
         DEMfgbal.scale(ELpcoal,v,trun,r)=1e-3;

         COtransCnstrctbal.scale(trun)=1e-1;
         COtransbld.scale(tr,trun,rco,rrco)=1e2;

         EMELnoxlim.scale(trun,r)=1e-1;
         DEMELnoxlim.scale(trun,r)=1e1;