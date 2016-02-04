UB = card(hrs);

* loop over the load steps (peak to base)
loop(hrs,



*        averaging the hourly load for the defined load steps using the rank of
*        each hour in the load curve.
*        The load data represents a given month of the year. Multiply each
*        load point by the number of days in the year to get the right number of
*        demand hours represented by parameter ELlchours.

*$ontext
         loop(ELl,
           loop(ELll,
             if(HLC_rank(r,hrs)<=UBELl(ELl) and HLC_rank(r,hrs)>LBELl(ELl) and
                HLC_rank(rr,hrs)<=UBELl(ELll) and HLC_rank(rr,hrs)>LBELl(ELll),
                 Eltranscoef(ELl,ELll,r,rr) = Eltranscoef(ELl,ELll,r,rr)+1;
             );
           );
         );
);

Eltranscoef(ELl,ELll,r,rr) =
         Eltranscoef(ELl,ELll,r,rr)/sum(ELlll,Eltranscoef(ELl,ELlll,r,rr));







