
********************************************************************************

scalars  import_cap set to 1 to enforce the import constraint /1/
         trans_budg set to 1 to enforce budget constraint for railway expansion /0/
         coal_cap   set to 1 to cap mining in each province to COprodcap parameter /1/
         coal_cuts  set to 1 to apply regional production cuts COprodcuts to regional supplies /1/
         rail_cap   set to 1 to cap mixed freight rail lines /1/
         COrailCFS  set to 1 to apply railway surcharges to railway costs /1/
         ELdereg    set to 1 to switch on deregulated power supply market /1/

         ELdefcap place cap on generator deficits /0/
         ELwtarget  set to 1 switch on strategic wind targets /0/
         ELpfit     set to 1 switch on fit for renewables /0/
         SO2_std   apply regioanl sulfur standards /0/
         nox_std   apply regioanl nox standards /0/

         t_start the year to start optimization when running recursive dynamic

******** Scenario flags
*        These flags are set in Solve_MCP.gms for each of the scenarios above
         deregulated set to 1 for fuel deregulated scenario      /0/
         quotaon set to 1 for fuel allocation                    /0/
         subgrid set to 1 for the investment credit sceanrio     /0/
         partialdereg set to 1 for partial fuel deregulation     /0/

         ELWAcoord set to 1 for coordination of power and water  /0/
         methane_realloc set to 1 for methane reallocation       /0/
*        not currently being used
         multigrid set to 1 to use multiple grid levels for investment susbidy optimization /0/;
********************************************************************************
;

