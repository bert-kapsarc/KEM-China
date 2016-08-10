model PowerLP /
*        POWER EQUATIONS
         ELobjective,
         ELpurchbal,ELcnstrctbal,ELopmaintbal,
         ELfcons,ELCOCons,
*ELfcons
         ELfavail,
         ELcapbal,ELcaplim,ELcapcontr,
         ELhydutil,ELgtconvlim,
         ELsup,ELdem,ELrsrvreq,
         ELwindcaplim,ELwindutil,ELupspinres,
         ELwindcapsum,
         ELtranscaplim,ELtranscapbal,

*         ELfgclim,ELfgccaplim,ELfgcfcons,ELfgccapbal,
*         EMsulflim, EMELnoxlim

*         ELhydutilsto,

         /
;

*$ontext
model PowerMCP /


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

*DELhydexistcp.ELhydexistcp,DELhydbld.ELhydbld,DELhydop.ELhydop,
DELhydopsto.ELhydopsto,

DELfgcexistcp.ELfgcexistcp,
DELfgcbld.ELfgcbld,

DELcapsub.Elcapsub,DELfuelsub.ELfuelsub,DELdeficit.ELdeficit,
*DELsubsidycoal.ELsubsidycoal,

DEMELfluegas.EMELfluegas,
EMsulflim.DEMsulflim,
EMELnoxlim.DEMELnoxlim,
EMfgbal.DEMfgbal,EMELSO2std.DEMELSO2std,EMELNO2std.DEMELNO2std

*$ontext
COprice_eqn,
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
