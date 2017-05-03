parameter COprodCEIC2015(r)
;
$gdxin db\coalprod.gdx
$load  COprodCEIC2015
$gdxin
$ontext
*        All IHS coal prod forecasts over 5 yr periods have been interpolated

*        we have split coal supply for IHS provincial aggregates
*        the percentages have been estimated using reported values
*        by China Government Statistics
*        "South and east coast Met", "South" = 0.03 %
*        "South and east coast Met", "East") = 0.97 %
*        "Central South Met", "South") =  0.32 %
*        "Central South Met", "East") = 0.68 %


          COomcst(COf,mm,ss,rw,time,rco) O&M cost in Yuan
*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! We haved estimated  unkown met coal cost
*        using 60% markup from regional steam coal costs.

          COprodyield(COf,mm,ss,rw,time,rco) production yield for coal between 0 and 1

          COwashratio(COf,mm,ss,time,rco) max ratio of coal sent for washing (coal washing capacity constraint)

          coalcv(COf,mm,ss,rw,time,rco) calorific value of coal
* !!!!!!!!!!!!!!! no cv for met coals, set to -1
*        if there is no secondary washed coal cv, we use the value
*        of washed coal. This is done to facilitate a calculation
*        that sets the cost of metalurgical secondary washed products
*        to that of the cost of secondary washed steam coal, adjusting for CV

$offtext

parameter COprodIHSaggr aggregate IHS production data
         COprodIHSaggr_met  aggregate met data;

COprodIHSaggr(time,r) =  sum((COf,mm,ss,rco)$(rco_sup(rco,r)),COprodData(COf,mm,ss,time,rco));
*COprodIHSaggr(time,r) = COprodIHSaggr(time,r) + sum((COf,mm,ss,rco)$(coal_i(Cof) and SOE(ss) and rco_sup(rco,r)),COprodData(COf,mm,ss,time,rco));
COprodIHSaggr_met(time,r) =  sum((met,mm,ss,rco)$rco_sup(rco,r),COprodData(met,mm,ss,time,rco));

$ontext
loop(r,
         COprodData(COf,mm,ss,trun,rco)$(rco_sup(rco,r) and COprodIHSaggr('t15',r)>0)
          = COprodData(COf,mm,ss,'t15',rco)*
          COprodCEIC2015(r)/COprodIHSaggr('t15',r);
);
$offtext


*        Coal sales cost index in 2015 compared to 2011 (Source?)
         COomcst(COf,mm,ss,rw,time,rco) = COomcst(COf,mm,ss,rw,"t11",rco)*0.87;

*        Rescale 2012 coal consumption to 2015 levels using CEIC aggregate data
         OTHERCOconsump(sect,COf,rr) = OTHERCOconsump(sect,COf,rr)*0.963;


*        remove the production cuts
*         COprodcuts(r) = 0;
         COprodcutsSOE = 15;

         OTHERCOconsump(sect,COf,rr) = OTHERCOconsump(sect,COf,rr)*0.953;

         COcapacity('West') =  660;

COprodaggr(time,r) = sum((COf,mm,ss,rco)$(rco_sup(rco,r) and (not coal_i(COf) or SOE(ss))),COprodData(COf,mm,ss,time,rco));

*        rescale production data
COprodcap(COf,trun,r)$(COprodaggr(trun,r)>0 )=1e3*
         sum((mm,ss,rco)$rco_sup(rco,r),COprodData(COf,mm,ss,trun,rco))*
         COcapacity(r)/COprodaggr(trun,r);

COomcst(coal_i,mm,ss,rw,time,rco)$(COmine(coal_i,mm,ss,rco) and COprodyield(coal_i,mm,ss,rw,time,rco) > 0)
         = COomcst("coal",mm,ss,rw,time,rco)*1.2;
*COomcst(coal_i,mm,ss,rw,time,rco)$(coalcv(coal_i,mm,ss,rw,time,rco)>0 and
*         COomcst(coal_i,mm,ss,rw,time,rco)/coalcv(coal_i,mm,ss,rw,time,rco)>0.13)
*         = uniform(0.1,0.13)*coalcv(coal_i,mm,ss,rw,time,rco);
* COtransexistcp.fx(tr,trun,rco,rrco)=COtransexistcp.l(tr,trun,rco,rrco)*0.8;

*        Fix existing capacity using production profile rescales to the
*        aggregate regional capacity estimates
loop(r,
         COexistcp.fx(COf,mm,ss,trun,rco)$(COmine(COf,mm,ss,rco) and ord(trun)=1
          and COprodaggr(trun,r)>0 and rco_sup(rco,r))=
                 COprodData(COf,mm,ss,trun,rco)
                 *COcapacity(r)/COprodaggr(trun,r)
);

parameter SOEcapratio ratio of capacity for the SOE mines
          RegionalCapratio;
SOEcapratio(COf,mm,ss,trun,rco)$(not coal_i(COf) and SOE(ss) and sum((COff,mm2,SOE,rrco)$(not coal_i(COff)),COexistcp.l(COff,mm2,SOE,trun,rrco))>0)
= COexistcp.l(COf,mm,ss,trun,rco)/sum((COff,mm2,SOE,rrco)$(not coal_i(COff)),COexistcp.l(COff,mm2,SOE,trun,rrco));

RegionalCapratio(COf,mm,ss,trun,rco,r)$((not SOE(ss) or SOEex(ss)) and not coal_i(COf) and rco_sup(rco,r) and
         sum((COff,mm2,ss2,rrco)$((not SOE(ss2) or SOEex(ss2)) and not coal_i(COff) and rco_sup(rrco,r)), COexistcp.l(COff,mm2,ss2,trun,rrco))>0)
= COexistcp.l(COf,mm,ss,trun,rco)/sum((COff,mm2,ss2,rrco)$((not SOE(ss2) or SOEex(ss2)) and not coal_i(COff) and rco_sup(rrco,r)),COexistcp.l(COff,mm2,ss2,trun,rrco));


* Remove COprodcutsSOE propotionally across all SOE's
         COexistcp.fx(COf,mm,ss,trun,rco)$SOE(ss)=
         COexistcp.l(COf,mm,ss,trun,rco) -
         COprodcutsSOE*SOEcapratio(COf,mm,ss,trun,rco)
;
loop(r,
         COexistcp.fx(COf,mm,ss,trun,rco)$((not SOE(ss) or SOEex(ss)) and not coal_i(COf) and rco_sup(rco,r))=
         COexistcp.l(COf,mm,ss,trun,rco) -
         COprodcuts(r)*RegionalCapratio(COf,mm,ss,trun,rco,r)
)
         ;

COexistcp.fx(COf,mm,ss,trun,rco)$(COmine(COf,mm,ss,rco) and coal_cuts = 1
                 and ord(trun)=1)=
                 COexistcp.l(COf,mm,ss,trun,rco)*(1-(
                         0.16
*                         -(0.16$TVE(ss))
*                         -(0.0$Allss(ss))
*                         -(0.08$Local(ss))
                         -0.16$rco_importer(rco)
*                         -0.16$SOE(ss)
                 )    )
*$(not coal_i(COf))
*$(not coal_i(COf) and not (TVE(ss) or Local(ss)))

*                 +(66*COexistcp.l(COf,mm,ss,trun,rco)/
*                 sum((COff,mm2,ss2,rrco)$(CoalCCBR(rrco) and SOE(ss2) and coal(COff)),COexistcp.l(COf,mm2,ss2,trun,rrco)))$(CoalCCBR(rco) and SOE(ss)  and coal(COf))

*                +(99*COexistcp.l(COf,mm,ss,trun,rco)/
*                 sum((COff,mm2,ss2,rrco)$(CBRRMG2(rrco) and SOE(ss2) and coal(COff)),COexistcp.l(COff,mm2,ss2,trun,rrco)))$(CBRRMG2(rco) and SOE(ss) and coal(COf))

*                 +(165*COexistcp.l(COf,mm,ss,trun,rco)/
*                 sum((mm2,ss2,rrco)$(not TVE(ss2)),COexistcp.l(COf,mm2,ss2,trun,rrco)))$(not TVE(ss) and Coal(COf))


                 ;

*        use CEIC data to adjust for missing hydro capacity in 2012
*        We assume all the missing data are large hydro dams.
*        (lg, ROR, sto) given by the IHS midstream database
parameter  ELhydroCEIC(rAll) existing hydro capacity by type from CEIC in GW  ;

$gdxin db\power.gdx
$load ELhydroCEIC
$gdxin
         ELexistcp.fx('hydrolg',v,trun,r)$(ord(trun)=1 and vo(v))=
          ELhydexist('hydrolg',r)
         +ELhydroCEIC(r)
         -sum(ELphyd,ELhydexist(ELphyd,r));

ELlcgwsales(r,ELl) = ELlcgw(r,ELl)*4178/
         sum((rr,ELll),ELlcgw(rr,ELll)*ELlchours(ELll));

ELlcgwonsite(r,ELl)$(sum(ELll,ELlcgw(r,ELll))>0) =
         (ELlcgw(r,ELl)-ELlcgwsales(r,ELl)/0.91  );

