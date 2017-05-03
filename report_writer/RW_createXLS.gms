
$INCLUDE RW_calc


parameter        reportELsupElp    electricity supply by plant type and region
                 reportELcapELp    electricity capacity by plant type and region
                 reportELsup      electricity supply by sector and region
                 reportELcap      electricity capacity by sector and region
                 reportELbld    cumulative electricity build by plant and region
                 reportfuel              fuel use by sector and region
                 reportfuelcru        crude use by sector and region
                 reportfueldie       diesel use by sector and region
                 reportfuelCH4      sales gas use by sector and region
                 reportfuelHFO          HFO use by sector and region
                 reportELdem    electricity demand by region
                 reportWAdem    water demand by region
                 reportWAsup    water supply by plant type and region
                 reportWAcap    water capacity by plant type and region
                 reportWAbld    cumulative water build by plant and region
                 reportobj    cumulative water build by plant and region
;

*$ontext

*$onechov > %gams.scrdir%reportobj.scr
reportobj("","title","Value of objective equaiton") = 1 ;
reportobj(trun," USD",sectors) = expenses(sectors,trun);

*$offecho

*$onechov > %gams.scrdir%reportELcapELp.scr
*reportELsupELp("chart title","","Electricity Supply by tech (National)","") = 1 ;
reportELsupELp(rall,ELp,"TWh",trun) = ELsupELp(ELp,trun,rall);
reportELsupELp(rall,WAp,"TWh",trun) = ELsupWAp(WAp,trun,rall);
reportELsupELp(rall,"Total","TWh",trun) = SUM(ELp,ELsupELp(ELp,trun,rall)) + sum(WAp,ELsupWAp(WAp,trun,rall));

*$offecho


*$onechov >%gams.scrdir%reportELcapELp.scr
*reportELcapELp("title","1","Capacity by tech (National)","") = 1 ;
*reportELcapELp("title","2","Proportion of capacity by tech (National)","") = 1 ;
reportELcapELp(rall,ELp,"GW",trun) = ELcapELp(ELp,trun,rall);
reportELcapELp(rall,WAp,"GW",trun) = ELcapWAp(WAp,trun,rall);
reportELcapELp(rall,"Total","GW",trun) = SUM(ELp,ELcapELp(ELp,trun,rall)) + sum(WAp,ELcapWAp(WAp,trun,rall));
*$offecho

*$onechov >%gams.scrdir%reportELsup.scr
*reportELsup("chart title","1","Electricity supply (power sectors)","")= 1 ;
*reportELsup("chart title","2","Electricity supply (cogen sectors)","")= 1 ;
reportELsup(sectors,rall,"TWh",trun) = ELsuptot(sectors,trun,rall);

*$offecho


*$onechov >%gams.scrdir%reportELcap.scr
*reportELcap("","title","Capacity (power sectors) ","Capacity (cogen sector) ") = 1 ;
reportELcap(sectors,rall,"GW",trun) = ELcap(sectors,trun,rall);
*$offecho

*$onechov >%gams.scrdir%reportELbld.scr
*reportELbld("","title","Cumulative build by tech (National) ","") = 1 ;
reportELbld(rall,"Total","GW",trun) = ELbldtot("ALL",trun,rall);
reportELbld(rall,ELp,"GW",trun) = ELbldELp(ELp,trun,rall);
reportELbld(rall,WAp,"GW",trun) = ELbldWAp(WAp,trun,rall);
*$offecho

*$onechov >%gams.scrdir%reportWAsup.scr
*reportWAsup("","title","Proportion of water supply by tech (National)","Water Supply by tech (National)") = 1 ;

reportWAsup(rall,"Total","Billion m3",trun) = WAsuptot(trun,rall);
reportWAsup(rall,WAp,"Billion m3",trun) = WAsupWAp(WAp,trun,rall);

*$offecho


*$onechov >%gams.scrdir%reportWAcap.scr
*reportWAcap("","title","Proportion of water capacity by tech (National)","Water capacity by tech (National)") = 1 ;
reportWAcap(rall,"Total","MMm3/day",trun) = WAcap(trun,rall);
reportWAcap(rall,WAp,"MMm3/day",trun) = WAcapWAp(WAp,trun,rall);

*$offecho

*$onechov >%gams.scrdir%reportWAbld.scr
*reportWAbld("","title","Cumulative build by tech (National) ","") = 1 ;
reportWAbld(rall,WAp,"MMm3/day",trun) = WAbldtot(trun,rall);
reportWAbld(rall,WAp,"MMm3/day",trun) = WAbldWAp(WAp,trun,rall);
*$offecho


*$onechov >%gams.scrdir%reportfuel.scr
*reportfuel("00","title","Fuel Consumption (power sector)","Fuel Consumption (cogen and water sector)") = 1 ;
*reportfuel(sector,rN," MMTOE",trun) = MMBTUtoTOE*sum(r,fconsumpMMBTU(sector,trun,r));
reportfuel(sectors,rall,"MMTOE",trun) = MMBTUtoTOE*fconsumpMMBTU(sectors,trun,rall);
*$offecho

*$onechov >%gams.scrdir%reportfuel_crude.scr
*reportfuelcru("00","title","Crude Consumption (power sector)","Crude Consumption (cogen and water sector)") = 1 ;
*reportfuelcru(sector,rN,"MMBBL",trun) = fconsumptype(sector,"crude",trun);
reportfuelcru(sectors,rall," MMBBL",trun) = fconsump(sectors,"crude",trun,rall);
*$offecho

*$onechov >%gams.scrdir%reportfuel_diesel.scr
*reportfueldie("00","title","Diesel Consumption (power sector)","Diesel Consumption (cogen and water sector)") = 1 ;
*reportfueldie(sector,rN,"MM Tonne",trun) = RFfconsumptype(sector,"diesel",trun);
reportfueldie(sectors,rall,"MMTonne",trun) = RFfconsump(sectors,"diesel",trun,rall);
*$offecho

*$onechov >%gams.scrdir%reportfuel_HFO.scr
*reportfuelHFO("00","title","HFO Consumption (power sector)","HFO Consumption (cogen and water sector)") = 1 ;
reportfuelHFO(sectors,rall,"MMTonne",trun) = RFfconsump(sectors,"HFO",trun,rall);
*$offecho

*$onechov >%gams.scrdir%reportfuel_methane.scr
*reportfuelCH4("00","title",      "Methane Consumption (power sector)",
*                                 "Methane Consumption (cogen and water sector)") = 1 ;
*reportfuelCH4(sectors,rN,"Trillion BTU",trun) = fconsumptype(sectors,"methane",trun);
reportfuelCH4(sectors,rall,"Trillion BTU",trun) = fconsump(sectors,"methane",trun,rall);
*$offecho

*$onechov >%gams.scrdir%reportELdem.scr
*reportELdem("","title","Electricity demand") = 1;
reportELdem(trun,"TWh",rN) = sum(r,ELdemand(trun,r));
reportELdem(trun,"TWh",r) = ELdemand(trun,r);
*$offecho

*$onechov >%gams.scrdir%reportWAdem.scr
*reportWAdem("","title","Water demand (National)") = 1;
reportWAdem(trun,"billion m3",rN) = sum(r,WAdemval(trun,r));
reportWAdem(trun,"billion m3",r) = WAdemval(trun,r);

*$offecho


*$offtext

*$batinclude %gams.scrdir%reportobj.scr
*$batinclude %gams.scrdir%reportELsupELp.scr
*$batinclude %gams.scrdir%reportELcap.scr
*$batinclude %gams.scrdir%reportELsupELp.scr
*$batinclude %gams.scrdir%reportELcapELp.scr
*$batinclude %gams.scrdir%reportELbld.scr
*$batinclude %gams.scrdir%reportfuel.scr
*$batinclude %gams.scrdir%reportfuel_crude.scr
*$batinclude %gams.scrdir%reportfuel_HFO.scr
*$batinclude %gams.scrdir%reportfuel_diesel.scr
*$batinclude %gams.scrdir%reportfuel_methane.scr
*$batinclude %gams.scrdir%reportWAsup.scr
*$batinclude %gams.scrdir%reportWAcap.scr
*$batinclude %gams.scrdir%reportWAbld.scr
*$batinclude %gams.scrdir%reportELdem.scr
*$batinclude %gams.scrdir%reportWAdem.scr



execute_unload 'results.gdx'
         reportobj
         reportELsup, reportELcap,
         reportELsupELp, reportELcapElp,
         reportELbld, reportELdem,
         reportfuel,reportfueldie,reportfuelcru,reportfuelCH4,reportfuelHFO
         reportWAsup, reportWAcap, reportWAbld, reportWAdem;

*$ontext
$ifthen exist '.\xls\nul'
         execute 'for %F in (.\xls\*.xlsx) do (call gdxxrw i=results.gdx o=.\xls\%~nF.xlsx par=reportELsup rng=ELsup! rdim=2)'
         execute 'for %F in (.\xls\*.xlsx) do (call gdxxrw i=results.gdx o=.\xls\%~nF.xlsx par=reportELcap rng=ELcap! rdim=2)'
         execute 'for %F in (.\xls\*.xlsx) do (call gdxxrw i=results.gdx o=.\xls\%~nF.xlsx par=reportELsupELp rng=ELsupELp! rdim=2)'
         execute 'for %F in (.\xls\*.xlsx) do (call gdxxrw i=results.gdx o=.\xls\%~nF.xlsx par=reportELcapELp rng=ELcapElp! rdim=2)'
         execute 'for %F in (.\xls\*.xlsx) do (call gdxxrw i=results.gdx o=.\xls\%~nF.xlsx par=reportELbld rng=ELbld! rdim=2)'
         execute 'for %F in (.\xls\*.xlsx) do (call gdxxrw i=results.gdx o=.\xls\%~nF.xlsx par=reportELdem rng=ELdem! rdim=1)'

         execute 'for %F in (.\xls\*.xlsx) do (call gdxxrw i=results.gdx o=.\xls\%~nF.xlsx par=reportWAsup rng=WAsup! rdim=2)'
         execute 'for %F in (.\xls\*.xlsx) do (call gdxxrw i=results.gdx o=.\xls\%~nF.xlsx par=reportWAcap  rng=WAcap! rdim=2)'
         execute 'for %F in (.\xls\*.xlsx) do (call gdxxrw i=results.gdx o=.\xls\%~nF.xlsx par=reportWAbld  rng=WAbld! rdim=2)'
         execute 'for %F in (.\xls\*.xlsx) do (call gdxxrw i=results.gdx o=.\xls\%~nF.xlsx par=reportWAdem  rng=WAdem! rdim=1)'
         execute 'for %F in (.\xls\*.xlsx) do (call gdxxrw i=results.gdx o=.\xls\%~nF.xlsx par=reportobj  rng=obj! rdim=2)'

         execute 'for %F in (.\xls\*.xlsx) do (call gdxxrw i=results.gdx o=.\xls\%~nF.xlsx par=reportfuel  rng=fuel! rdim=2)'
         execute 'for %F in (.\xls\*.xlsx) do (call gdxxrw i=results.gdx o=.\xls\%~nF.xlsx par=reportfuelcru  rng=crude! rdim=2)'
         execute 'for %F in (.\xls\*.xlsx) do (call gdxxrw i=results.gdx o=.\xls\%~nF.xlsx par=reportfuelCH4  rng=CH4! rdim=2)'
         execute 'for %F in (.\xls\*.xlsx) do (call gdxxrw i=results.gdx o=.\xls\%~nF.xlsx par=reportfueldie  rng=diesel! rdim=2)'
         execute 'for %F in (.\xls\*.xlsx) do (call gdxxrw i=results.gdx o=.\xls\%~nF.xlsx par=reportfuelHFO  rng=HFO! rdim=2)'
;

$else
         execute 'mkdir .\xls'
         execute 'call gdxxrw i=results.gdx o=.\xls\report.xlsx par=reportELsup rng=ELsup! rdim=2'
         execute 'call gdxxrw i=results.gdx o=.\xls\report.xlsx par=reportELcap rng=ELcap! rdim=2'
         execute 'call gdxxrw i=results.gdx o=.\xls\report.xlsx par=reportELsupELp rng=ELsupElp! rdim=2'
         execute 'call gdxxrw i=results.gdx o=.\xls\report.xlsx par=reportELcapElp rng=ELcapElp! rdim=2'
         execute 'call gdxxrw i=results.gdx o=.\xls\report.xlsx par=reportELbld rng=ELbld! rdim=2'
         execute 'call gdxxrw i=results.gdx o=.\xls\report.xlsx par=reportELdem rng=ELdem! rdim=1'

         execute 'call gdxxrw i=results.gdx o=.\xls\report.xlsx par=reportWAsup rng=WAsup! rdim=2'
         execute 'call gdxxrw i=results.gdx o=.\xls\report.xlsx par=reportWAcap rng=WAcap! rdim=2'
         execute 'call gdxxrw i=results.gdx o=.\xls\report.xlsx par=reportWAbld rng=WAbld! rdim=2'
         execute 'call gdxxrw i=results.gdx o=.\xls\report.xlsx par=reportWAdem rng=WAdem! rdim=1'
         execute 'call gdxxrw i=results.gdx o=.\xls\report.xlsx par=reportobj rng=obj! rdim=2'

         execute 'call gdxxrw i=results.gdx o=.\xls\report.xlsx par=reportfuel  rng=fuel! rdim=2'
         execute 'call gdxxrw i=results.gdx o=.\xls\report.xlsx par=reportfuelcru  rng=crude! rdim=2'
         execute 'call gdxxrw i=results.gdx o=.\xls\report.xlsx par=reportfueldie  rng=diesel! rdim=2'
         execute 'call gdxxrw i=results.gdx o=.\xls\report.xlsx par=reportfuelHFO  rng=HFO! rdim=2'
         execute 'call gdxxrw i=results.gdx o=.\xls\report.xlsx par=reportfuelCH4  rng=CH4! rdim=2'
;
$endif

*$offtext
