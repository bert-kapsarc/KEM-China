

Parameter COimportprice(COf,cv,sulf,rco)
          COpricetrend(time)
          WCD_Quads(time) world coal demand in quadrillion btu;

$gdxin db\coalprod.gdx
$load  COimportprice COpricetrend WCD_Quads COfimpmax COfimpmax_nat
$gdxin

* Set price of substitute fuels taking average of Fuel oil 180 in 2016 from CEIC
         COsubprice(trun,rr)=1431;

         COintlprice(COf,"ss0",cv,sulf,time,rco) = COimportprice(COf,cv,sulf,rco)*COpricetrend(time);
*         COintlprice(COf,ssi,cv,sulf,time,rco) = COintlprice(COf,ssi,cv,sulf,time,rco)*1000;



*        Construct supply steps for import supply curve using using import
*        supply elasticiy of 0.2 and
*        supply step size converted from Quads to tons (6000kcal/ton)

         loop(ssi,
         COintlprice(COf,ssi,cv,sulf,time,rco)  =
                 COintlprice(COf,"ss0",cv,sulf,time,rco)*
                 2.71828**(5*log(1+(ord(ssi)-1)/200));
         );


         COfimpss(COF,ssi,cv,sulf,trun) = 0;

         COfimpss(COf,ssi,cv,sulf,trun)$(COintlprice(COf,ssi,cv,sulf,'t12','south')>0)
                 = WCD_Quads(trun)*1/200*252190.21687207/6000;

*        Overirde import supply steps (no import supply elasticity for China)
         COfimpss(COF,ssi,cv,sulf,trun) = COfimpss(COF,ssi,cv,sulf,trun)*1000;


