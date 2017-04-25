*        CONFIGURE THE ONGRID Tariffs for the power sector, as well as exogneous maximum allowed deficit

         ELdeficitmax = 20e3;

         ELtariffmax(Elp,r)= ELtariffmax(Elp,r)/1.17*0.8;
         
         ELtariffmax(Elpd,r)$(ELpcoal(Elpd)) = (ELtariffmax(Elpd,r)-ELfgctariff('DeSOx')-ELfgctariff('DeNOx'));

         ELtariffmax(Elpw,r) =
                ( ELtariffmax('ultrsc',r)$(ELpfit<>1)
                 +ELtariffmax(ELpw,r)$(ELpfit=1)) ;

* !!!    Set feed-in tariffs for wind producers
         ELfit(ELpw,trun,r) = 600;
         ELfit(ELpw,trun,'CoalC') = 510;
         ELfit(ELpw,trun,'North') = 540;
         ELfit(ELpw,trun,'Northeast') = 580;
         ELfit(ELpw,trun,'West') = 580;
         ELfit(ELpw,trun,'Xinjiang') = 580;

;
*         ELwindsub.up(Elpw,v,trun,r) = ELtariffmax(Elpw,r)-ELtariffmax('Ultrsc',r);


*!!!     Turn on max on-grid tariff
         ELptariff(ELpd,v)$(not ELpgttocc(ELpd)) = yes;
*         ELptariff(ELpw,v) = yes;
         ELptariff(ELphyd,v) = yes;

*         ELctariff(ELc,v) = no;
*         ELcELp(ELp,v,ELp,v)= no;


* !!!!   ELcELp subset defines plants operated by regional power companies
* !!!!   Elctariff defines companies evaluated in the revenue contraints
*$ontext
*        Companies are aggregated by vintage, so we only track vn
         ELctariff(ELbig,vn)=yes;
         ELctariff(ELnuc,vn)=yes;
*         ELctariff(ELwind,v)=yes;
*
         ELcELp(ELbig,vv,ELp,v)$(not Elpnuc(Elp) and Elctariff(Elbig,vv)) = yes;
         ELcELp(ELnuc,v,ELpnuc,v)$Elctariff(Elnuc,v)= yes;
*         ELcELp(ELwind,v,ELpw,v)$Elctariff(Elwind,v)= yes;
*
*$offtext



         Elcapsub.up(Elp,vo,trun,r)=0;
         Elcapsub.up(Elp,vn,trun,r)=0;

         ELfuelsub.up(Elpd,v,ELl,ELf,gtyp,trun,r)$(vo(v) and ELpELf(Elpd,ELf))=0;
