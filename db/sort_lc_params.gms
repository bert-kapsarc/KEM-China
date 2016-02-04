$include SetsandVariables.gms


sets     hrs24          24 hours day /1*24/
         month          12 month of year /1*12/
         hrs(i)         hours in the load curve data set /1*8784/
         j               /1*31/
;

alias(hrs24,hhrs24)

alias(hrs,rank);



* These values represent the r-specific LDCs.
parameter ELlcgw(rr,ELl) regional load in GW for each load segment in ELlchours


          HLCmonths(r,hrs24,month) hourly load curves for represenative day in each month
          HLC(r,i) hourly load curves for represenative day in each month
          LDC(i)  load duration curve in GW for all load hours
          WRCFmonths(rALL,hrs24,month) wind profile for represenative day in each month
          WRCFmonthavgon(rALL,month) onshore wind profiles for represenative day in each month
          WRCFmonthavgoff(rALL,month) offshore wind profile for represenative day in each month
          WRCFon(r,i) onshore wind profile for represenative day in each month
          WRCFoff(r,i) onshore wind profile for represenative day in each month

          sort_lc_input(i) original load curve for sorting. Representative daily profiles for each month
          sort_lc_temp(i)
          sorted(ELl) sorted and discretized load curve
          HLC_temp(i) one dimentional load curve array with hourly data
          hrs_rank(i) rank extracted from HLC_temp
          HLC_rank(r,i) rank of each regional HLC


         ELtranscoef(ELl,ELll,r,rr) load step coefficients for inter regional electricity transmission



          day_hrs(i) number of days attributed to each hour



                 days(month)   number of days in each month for year 2012
         /       1       31
                 2       29
                 3       31
                 4       30
                 5       31
                 6       30
                 7       31
                 8       31
                 9       30
                 10      31
                 11      30
                 12      31      /;

alias(month,month2);

         parameter days_acc(month);
         days_acc(month) = sum(month2$(ord(month2)<ord(month)),days(month2));


*HLC(r,hrs24,month) = sum(GB$regions(r,GB),HLC(GB,hrs24,month)) ;


scalar UB upper bound for HLC rank value for a given load step
       LB lower bound for HLC rank value for a given load step;

parameter UBELl(Ell) upper bound for HLC rank value for a given load step
       LBELl(ELl) lower bound for HLC rank value for a given load step;

* first upper bound is the highest rank in the set (number of hours in the year)


UBELl('LS1') = card(hrs);
loop(ELl,
*        lower bound is the upper bound minus the size of the step.
*        devide by the average number of days in a month since we are using
*        data representing only one day per month.
*         LB = UB-ELlchours(ELl)/(sum(month,days(month))/card(month));
         LBELl(Ell) = sum(ELll$(ord(ELll)>ord(ELl)),ELlchours(ELll))*1000;
*         (1-(sum(ELll$(ord(ELll)<=ord(Ell)),ELlchours(ELll)))/sum(ELll,ELlchours(ELll)));

         UBELl(ELl+1) = LBELl(ELl);
);

Eltranscoef(ELl,ELll,r,rr)=0;
