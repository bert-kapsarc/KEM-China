UB = card(hrs);

* loop over the load steps (peak to base)
loop(ELl,

*        lower bound is the upper bound minus the size of the step.
*        devide by the average number of days in a month since we are using
*        data representing only one day per month.
*         LB = UB-ELlchours(ELl)/(sum(month,days(month))/card(month));
         LB = sum(ELll$(ord(ELll)>ord(ELl)),ELlchours(ELll))*1000;

*        averaging the hourly load for the defined load steps using the rank of
*        each hour in the load curve.
*        The load data represents a given month of the year. Multiply each
*        load point by the number of days in the year to get the right number of
*        demand hours represented by parameter ELlchours.
$ontext
         sorted(ELl) =  sum((hrs)$(hrs_rank(hrs)<=UB and
                                             hrs_rank(hrs)>LB),
                      sort_lc_input(hrs)) / (ceil(UB) - floor(LB))
$offtext
*$ontext
         sorted(ELl) =  sum((hrs)$(hrs_rank(hrs)<=UB and hrs_rank(hrs)>LB),
                         sort_lc_input(hrs))/(ELlchours(ELl)*1e3);
*$offtext


* move to the next load step where the upper bound is the previous lower bound.
if(ord(ELl)=0,
abort sort_lc_input,hrs_rank, sorted, UB,LB;
);
         UB = LB;




);







