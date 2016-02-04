******** Parameters used in expost calculations
         parameters econgain,subsidycost,socialcost,exportrevenue, Energycontent;

         Parameters Govtcost, GovtRevenue, Govtecongain, capitalcost;
         Parameters UPRFcost,upRFrevenue,upRFecongain;
         Parameters RFcost,RFrevenue,RFecongain;
         Parameters ELcost,ELrevenue,ELecongain;
         Parameters WAcost,WArevenue,WAecongain;
         Parameters PCcost,PCrevenue,PCecongain;
         Parameters CMcost,CMrevenue,CMecongain;
         Parameters othercost,otherecongain;

******** parameter tables used to write to excel file
         parameter totalcost, totalsubsidy, budgetused, methane, energy, export, socialgain;


******** Stuff for subsidy grid

         scalar          crude_step grid resolution crude gas prices
                         natgas_step grid resolution natural gas prices
                         grid_spaces grid spaces for refined subsidy grid
                         fj_n, fk_n,
*        scalar to calculate the current grid position used to snake through grid
                         loop_stoper
;


         parameter
         fAP_bound adminsitered fuel price bounds for sub gird
         gamma_step(ELp) size of subsidy grid step
         gamma_bound     upper and lower bounds for gamma
         gamma_upbound_save upperbound on specific subsidy for grid
         gamma_lobound_save lowerbound on specific subsdiy for grid
         capsubsidy_level(trun) optimal value of the general grid subsidy if budget constraint is binding;

         capsubsidy_level(trun) = 0;

         parameter price_opt used to collect results for fuel price optimization in the investment credit scenario
                   gridshape used to find flat regions of subsidy grid to suppress grid refinement;

                   price_opt("subsidy",fx,fy,jj) = 0;


         parameter
         capitalsubsidy(ii,jj,fx,time,fi,fj,fk), gridgamma(ii,jj,fx,ELp,trun,fi,fj,fk)
         fuelAP(time,f,r,fx,fy),gridgovtecongain(ii,jj,fx,fi,fj,fk),
         utilitybudget(ii,jj,fx,time,fi,fj,fk),
         gridsocialcost(ii,jj,fx,fi,fj,fk),gridsubsidycost(ii,jj,fx,fi,fj,fk),
         gridexportrevenue(ii,jj,fx,fi,fj,fk),gridenergy(ii,jj,fx,fi,fj,fk),
         gridecongain(ii,jj,fx,fi,fj,fk),gridquotaflag(ii,jj,fx,fi,fj,fk)
         gridexcessmethane(ii,jj,fx,trun,fi,fj,fk),
         gridmethanemax(ii,jj,fx,Sect,time,r,fi,fj,fk),
         gridaux(ii,jj,fx,fi,fj,fk);

*        these are used to find location of subsidy grid maxima expost grid solve
         set     maximizer(fi,fj,fk), minimizer(fi,fj,fk),
                 rmax(r), sect_max(sect);

         scalar maxa,mina;

******** Parameters used for methane reallocation algorithm
         Parameter
         unusedmethane(Sect,time,rr), excessmethane(trun,r),  unalloc_methane(trun),
         MP_methane(Sect,trun,rr), methanemax(Sect,time,rr);

*        upper bound on amount of unused  methane when reallocating unused quotas
         scalar  maxMP_methane
                 methane_tolerance /.1/;
