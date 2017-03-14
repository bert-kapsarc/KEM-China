*!!!     Set upper bound on imports from some suppliers.
         COfimpmax('met',trun,'IMMN') = 25;
         COfimpmax('coal',trun,'IMKP') = 25;


Parameter COimportprice(COf,cv,sulf,rco)
          COpricetrend(time)
          WCD_Quads(time) world coal demand in quadrillion btu;

$gdxin db\coalprod.gdx
$load  COimportprice COpricetrend WCD_Quads
$gdxin

         COintlprice(COf,"ss1",cv,sulf,time,rco) = COimportprice(COf,cv,sulf,rco)*COpricetrend(time);

         loop(ssi,
         COintlprice(COf,ssi,cv,sulf,time,rco)  =
                 COintlprice(COf,"ss1",cv,sulf,time,rco)*
                 2.71828**(5*log(1+(ord(ssi)-1)/200));
         );


         COfimpss(COF,ssi,cv,sulf,trun) = 0;

*        supply step size converted from Quads to tons (6000kcal/ton) using import supply elasticiy of 0.2
         COfimpss(COf,ssi,cv,sulf,trun)$(COintlprice(COf,ssi,cv,sulf,'t12','south')>0)
                 = WCD_Quads(trun)*1/200*252190.21687207/6000;
         COfimpss(COF,ssi,cv,sulf,trun) = COfimpss(COF,ssi,cv,sulf,trun)*1e3;


