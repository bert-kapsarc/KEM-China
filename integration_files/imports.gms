         COintlprice(COf,ssi,cv_ord,sulf,time,rimp) = 0;

* Extract EIA table coal prices and interpolate to match the CV bins used by the model
* convert USD to 2012 RMB. Prices are listed for Guangdond Guizhou port

         COintlprice(COf,"ss1",cv_ord,"low",time,rport_sea)$(coalintlcvEIA(COf,time,'IMOT','south')>=COboundCV(cv_ord,'lo') and
                                               coalintlcvEIA(COf,time,'IMOT','south')<COboundCV(cv_ord,'up')    and
                                                 coalintlpriceEIA(COf,time,'IMOT','south')>0)
         =coalintlpriceEIA(COf,time,'IMOT','south')*6.310*COcvSCE(cv_ord)*7000/coalintlcvEIA(COf,time,'IMOT','south')/1.17*1.5;

*        COintlprice(COf,'ss1',cv_ord,sulf,time,rimp,rrco)$(COintlprice(COf,'ss1',cv_ord,sulf,time,rimp,rrco)=0 and path('port',rimp,rrco))
*         = COintlprice(COf,'ss1',cv_ord,sulf,time,rimp,'South');

        COintlprice('met','ss1','CVmet','low',time,rport_sea) = smax(cv_ord,COintlprice('coal','ss1',cv_ord,'low',time,rport_sea)/COcvSCE(cv_ord))*1.55;

*       set import price fro met coal from inner mongolia
        COintlprice('met','ss1',cv_met,'low',time,"IMMN")= COintlprice('met','ss1',cv_met,'low',time,"south")*0.75;

*       set import price fro met coal from North Korea
        COintlprice('coal','ss1',cv_ord,'low',time,"IMKP") = COintlprice('coal','ss1',cv_ord,'low',time,"south")*0.9;

*        set upper bound on coal imports across major land borders with n Korea and Mognolia
*         COfimpmax('coal',trun,"IMOT")=inf;
*         COfimpmax('met',trun,"IMOT")=inf;
*         COfimpmax('met',trun,"IMMN")=25;
*         COfimpmax('coal',trun,"IMKP")=10;


* set a cap on imports equal to the imports reported in 2013 scaled by the increase in projected demand from 2013
*         COfimpmax(COf,time,rimp)$(ord(time)>3 and COfimpmax(COf,time,rimp)=0 and sum((rr),COconsumpIHS(COf,'t13',rr))>0 )=
*         COfimpmax(COf,'t13',rimp)*(1+ sum(rr$(COconsumpIHS(COf,time,rr)>0),
*                                         COconsumpIHS(COf,time,rr)-COconsumpIHS(COf,'t13',rr))/sum((rr),COconsumpIHS(COf,'t13',rr))
*         );


         loop(ssi,
         COintlprice(COf,ssi,cv,sulf,time,rco)  =
                 COintlprice(COf,"ss1",cv,sulf,time,rco)*
                 2.71828**(5*log(1+(ord(ssi)-1)/200));
         );


*         COintlprice('coal',ss,'CV60','low',time,"IMKP")$(prd(ss)>1)=1e6;
*         COintlprice('met','ss1',cv_met,'low',time,"IMMN")$(prd(ss)>1)=1e6;

         COfimpss(COF,ssi,cv,sulf,trun) = 0;

*        supply step size converted from Quads to tons (6000kcal/ton) using import supply elasticiy of 0.2
         COfimpss(COf,ssi,cv,sulf,trun)$(COintlprice(COf,ssi,cv,sulf,'t12','south')>0)
                 = WCD_Quads(trun)*1/200*252190.21687207/6000;
         COfimpss(COF,ssi,cv,sulf,trun) = COfimpss(COF,ssi,cv,sulf,trun)*1e3;


