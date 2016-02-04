         parameter       budgetgrowth(time) budget growth
                         exportgrowth(sect,time) export growth
                         popgrowth(time) population growth;
         scalar natgas_growth /1/;

         budgetgrowth(time) = 1;

if(project=1,

         budgetgrowth(time) = 2.5;
         natgas_growth = 1.6;

         popgrowth("t1") = 1.2;

         exportgrowth(sect,time) = 1;
         exportgrowth("CM",time) = 0;

*        Electricity emand growth estimated from
*        "Peak Power Demand  Will Nearly Triple in Next 20 years"
*        chart from KA Care presentaition (source: ECRA 2010)
*$ontext
         ELdemgro("t1","east") =  3.17;
         ELdemgro("t1","cent") =  2.23;
         ELdemgro("t1","west") =  2.84;
         ELdemgro("t1","sout") =  3.07;
*$offtext

******** ELcapital costs reductions
         ELpurcst('PV',time,r)=1700;
         ELpurcst('CSP',time,r)=3600;
         ELpurcst('Nuclear',time,r)=4400;

         ELconstcst('PV',time,r)=400;
         ELconstcst('CSP',time,r)=900;
         ELconstcst('Nuclear',time,r)=1000;


         ELfuelburn("CC","new",ELf,r)= (3.412/0.5)*fuelencon1(ELf);
*        increase heat rates of new CC to 60 %;

*         sum(rr,ELdemgro(time,rr)*ELlcgw("peak",rr)/sum(r,ELlcgw("peak",r)));
*        weighted average of the demand growth in peak power.

******** Water demand
         WAdemval("t1",rr)=WAdemval("t1",rr)*1.015**21;
*        Using 1.5% population growth rate
*         WAgrdem("t1",rr)=WAdemval("t1",rr)*.35;
*        ground demand/supply decreasing to 35% from roughly 40% in 2011

*         WAgrexistcp.up(time,r) = WAgrdem(time,r);
*        existing ground water supply fix for non agricultural use

******** Petchem demand
         PCdemval(PCim,time,rr)=PCdemval(PCim,time,rr)*popgrowth(time);

******** Refining demand
         RFdemval(RFcf,time,rr)=RFdemval(RFcf,time,rr)*popgrowth(time);

         OTHERfconsump(fup,time,r) = OTHERfconsump(fup,time,r)*popgrowth(time);

******** natural gas supply increase
*         fuelsupmax(natgas,time,'west')=fuelsupmax(natgas,time,'east')*0;
*        30% increase in the west
         fuelsupmax(natgas,time,r)=fuelsupmax(natgas,time,r)*natgas_growth;
*        60% increase in the east


******** Export bounds
         PCnatexports.up(PCi,time) = PCnatexport2011(PCi)*exportgrowth("PC",time);
         RFnatexports.up(RFcf,time) = RFnatexport2011(RFcf)*exportgrowth("RF",time);
         CMnatexports.up(CMcf,time) = CMnatexport2011(CMcf)*exportgrowth("CM",time);

* Unofficial projections by Aramco
* DOE 2013 suggests a 2.3 trillion scf increases for Saudi Arabia in 2040 (64% increase)

         fuelsupmax(crude,time,'east')=3650*Fuelsplit(crude,time);
         Fueluse.up(fup,time,r)=fuelsupmax(fup,time,r);

* assume increase in gas allocation proportional to the increase in natural gas
* growth defined in the projection.gms file
fconsumpmax_save(sect,natgas,time,rr) = fconsumpmax_save(sect,natgas,time,rr)*natgas_growth;
);
