*$ontext
if(scenario = 1,
         deregulated = 0;
         quotaon = 1;
         subgrid = 0;
         partialdereg = 0;
elseif scenario = 2,
         deregulated = 1;
         quotaon = 0;
         subgrid = 0;
         partialdereg = 0;
elseif scenario = 3,
         deregulated = 1;
         quotaon = 0;
         subgrid = 0;
         partialdereg = 1;
elseif scenario = 4,
         deregulated = 0;
         quotaon = 0;
         subgrid = 1;
         partialdereg = 0;
else
         Abort "Scenario not defined. Set to "
                 "1 (current policy), "
                 "2 (deregulated fuel prices), "
                 "3 (partially deregulated fuel prices), "
                 "4 (investment credit)";
);
*$offtext

******** Initialize the subsidy variable used in partial deregulation and
*        investmetn credit sceanrios. For other sceanrios it is fixed to 0
         subsidy.lo(trun)=0;
         if(deregulated = 1,
*        initialize for the dereg fuel subsidy scenario
                 subsidy.l(trun)= 0;
*        if parital deregulation turned on
                 if(partialdereg=1,
                         subsidy.up(trun)=inf;
                         subsidy.lo(trun)=0;
                 else
                         subsidy.up(trun)=0;
                 );
         elseif subgrid = 1,
*        initialize for the investment credit scenario
                 subsidy.l(trun)= 0;
*capsubsidy_level(trun);
                 subsidy.up(trun)=inf;
         else
*        no subsidy
                 subsidy.l(trun)=0;
*                fix upper bound on subsidy variable if running adminstsred
*                prices scenari
                 subsidy.up(trun)=0;
         );

         if(quotaon <>1,

******** remove natural allocation
         ELfconsumpmax('methane',trun,rr)=9e9;
         WAfconsumpmax('methane',trun,rr)=9e9;


*  Remove allocation of arabheavy (supply limit applied in curent policy)
         CMfconsumpmax('methane',trun,rr)=9e9;
         CMfconsumpmax('Arabheavy',trun,rr)=9e9;
* If running the investment credit scenario use allocaiton from current policy
         CMfconsumpmax(CMf,trun,rr)$(subgrid=1 and CMfAP(CMf)) =fconsumpmax_save("CM",CMf,trun,rr);

         PCfeedsup(PCm,trun,rr) = 9e9;
* If running the investment credit scenario use allocaiton from current policy
         PCfeedsup(PCm,trun,rr)$(subgrid=1 and PCmAP(PCm)) = fconsumpmax_save("PC",PCm,trun,rr);

         elseif quotaon = 1 ,

******** enforce the regional natural gas allocation
         ELfconsumpmax(ELf,trun,rr)=fconsumpmax_save("EL",ELf,trun,rr);
         WAfconsumpmax(WAf,trun,rr)=fconsumpmax_save("WA",WAf,trun,rr);
         PCfeedsup(PCm,trun,rr)=fconsumpmax_save("PC",PCm,trun,rr);
         CMfconsumpmax(CMf,trun,rr)=fconsumpmax_save("CM",CMf,trun,rr);
         );

           count2=0;
           repeat(count2=count2+1;
                 if(card(trun)>k,
********** if global set trun is greater than subset time2 start recursive
$INCLUDE solve_recursive.gms

                 else
                 t(trun)=yes;
                 count=0;
                         Repeat(count=count+1;
                                 Solve integratedMCP using MCP;
                         until((integratedMCP.modelstat eq 1)or(count eq 1)));
                 );

                 if(integratedMCP.modelstat=1 and methane_realloc = 1,
$INCLUDE methane_reallocation.gms
                 else count2=10
                 );
           until ( smax(trun,sum(r,excessmethane(trun,r)) < methane_tolerance )
                          or (count2 eq 10)) );

$INCLUDE expost_calc.gms
