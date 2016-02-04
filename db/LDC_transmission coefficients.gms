UB = card(hrs24)*card(month);

* loop over the load steps (peak to base)
loop(hrs,



*        averaging the hourly load for the defined load steps using the rank of
*        each hour in the load curve.
*        The load data represents a given month of the year. Multiply each
*        load point by the number of days in the year to get the right number of
*        demand hours represented by parameter ELlchours.

*$ontext
         Eltranscoef(ELl,r,rr) = Eltranscoef(ELl,r,rr)+1;


* move to the next load step where the upper bound is the previous lower bound.
if(ord(ELl)=0,
abort sort_lc_input,hrs_rank, sorted, UB,LB;
);




);







