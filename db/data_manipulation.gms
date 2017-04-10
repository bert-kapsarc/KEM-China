parameter   COstatistics(COstats,rAll)
            COprodCEIC2015(r)
;
$gdxin db\coalprod.gdx
$load  COstatistics COprodCEIC2015
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


*        SPLIT INNER MONGOLIA AND EASTERN INNER MONGOLIA supply and demand statistics
*$ontext
COstatistics(COstats,'NME')=COstatistics(COstats,'NM')*0.3;
COstatistics(COstats,'NM')=COstatistics(COstats,'NM')
                        -COstatistics(COstats,'NME');

COstatistics(COstats,r) = sum((GB)$regions(r,GB),
                        COstatistics(COstats,GB));
COstatistics(COstats,"China") = sum(r,COstatistics(COstats,r)) ;
*$offtext

parameter COprodIHSaggr aggregate IHS production data
         COprodIHSaggr_met  aggregate met data;

COprodIHSaggr(time,r) =  sum((COf,mm,ss,rco)$rco_sup(rco,r),COprodData(COf,mm,ss,time,rco));
COprodIHSaggr_met(time,r) =  sum((met,mm,ss,rco)$rco_sup(rco,r),COprodData(met,mm,ss,time,rco));


loop(r,
         COprodData(COf,mm,ss,trun,rco)$(rco_sup(rco,r) and COprodIHSaggr('t15',r)>0)
          = COprodData(COf,mm,ss,'t15',rco)*
          COprodCEIC2015(r)/COprodIHSaggr('t15',r);
);

*        rescale production data
*         COprodData(coal,mm,ss,trun,rco) = COprodData(coal,mm,ss,trun,rco)*100;

*        Coal sales cost index in 2015 compared to 2011 (Source?)
         COomcst(COf,mm,ss,rw,time,rco) = COomcst(COf,mm,ss,rw,"t11",rco)*0.87;

*        Rescale 2012 coal consumption to 2015 levels using CEIC aggregate data
         OTHERCOconsump(sect,COf,rr) = OTHERCOconsump(sect,COf,rr)*0.963;


         COprodcap(COf,trun,r)=sum((mm,ss,rco)$rco_sup(rco,r),
                 COprodData(COf,mm,ss,trun,rco));

         COprodcuts(r)$(COprodcuts(r)> COprodcap('coal','t15',r))=
                 COprodcap('coal','t15',r);

*        remove the production cuts
         COprodcuts(r) = 0;
         COprodcutsSOE = 20.982*0;

         OTHERCOconsump(sect,COf,rr) = OTHERCOconsump(sect,COf,rr)*0.953;


         COcapacity('West') =  700;

COprodaggr(time,r) = sum((COf,mm,ss,rco)$rco_sup(rco,r),COprodData(COf,mm,ss,time,rco));

*        Fix existing capacity using production profile rescales to the
*        aggregate regional capacity estimates
loop(r,
         COexistcp.fx(COf,mm,ss,trun,rco)$(COmine(COf,mm,ss,rco)
                 and ord(trun)=1 and COprodaggr(trun,r)>0)=
                 COprodData(COf,mm,ss,trun,rco)*
                 COcapacity(r)/COprodaggr(trun,r)*(1+1.1$(not SOE(ss) and coal(COf)))
);

COexistcp.fx(COf,mm,ss,trun,rco)$(COmine(COf,mm,ss,rco) and coal_cuts = 1
                 and ord(trun)=1)=
                 COexistcp.l(COf,mm,ss,trun,rco)*(
                         0.84
                         +(0.16$TVE(ss))
*                         +(0.08$Allss(ss))
*                         +(0.08$Local(ss))
*                         +0.16$rco_importer(rco)
*                          +0.16$SOE(ss)
                 )
*                 +(66*COexistcp.l(COf,mm,ss,trun,rco)/
*                 sum((mm2,ss2,rrco)$(CoalCCBR(rrco) and SOE(ss2)),COexistcp.l(COf,mm2,ss2,trun,rrco)))$(CoalCCBR(rco) and Coal(COf) and not SOE(ss))

*                +(99*COexistcp.l(COf,mm,ss,trun,rco)/
*                 sum((mm2,ss2,rrco)$(CBRRMG2(rrco) and not TVE(ss2)),COexistcp.l(COf,mm2,ss2,trun,rrco)))$(CBRRMG2(rco) and not TVE(ss) and Coal(COf))

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
