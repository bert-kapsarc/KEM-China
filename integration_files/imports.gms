

Parameter COimportprice(COf,cv,sulf,rco)
          COpricetrend(time)
          WCD_Quads(time) world coal demand in quadrillion btu;

$gdxin db\coalprod.gdx
$load  COimportprice COpricetrend WCD_Quads COfimpmax COfimpmax_nat
$gdxin

         COintlprice(COf,"ss0",cv,sulf,time,rco) = COimportprice(COf,cv,sulf,rco)*COpricetrend(time);
*         COintlprice(coal,ssi,cv,sulf,time,rco) = COintlprice(coal,ssi,cv,sulf,time,rco)*1000;

         loop(ssi,
         COintlprice(COf,ssi,cv,sulf,time,rco)  =
                 COintlprice(COf,"ss0",cv,sulf,time,rco)*
                 2.71828**(5*log(1+(ord(ssi)-1)/200));
         );


         COfimpss(COF,ssi,cv,sulf,trun) = 0;

*        supply step size converted from Quads to tons (6000kcal/ton) using import supply elasticiy of 0.2
         COfimpss(COf,ssi,cv,sulf,trun)$(COintlprice(COf,ssi,cv,sulf,'t12','south')>0)
                 = WCD_Quads(trun)*1/200*252190.21687207/6000;
         COfimpss(COF,ssi,cv,sulf,trun) = COfimpss(COF,ssi,cv,sulf,trun)*100;


