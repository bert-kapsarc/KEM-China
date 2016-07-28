*parameter contract;

*!!!     Turn on max on-grid tariff
         ELptariff(ELpd,v)$(not ELpgttocc(ELpd)) = yes;
*         ELptariff(ELpw,v) = yes;
         ELptariff(ELphyd,v) = yes;
         ELrtariff(r) = yes;

*         ELctariff(ELc,v) = no;
*         ELcELp(ELp,v,ELp,v)= no;


*!!!     Turn on railway construction tax
         COrailCFS=1;

* !!!!   ELcELp subset defines plants operated by regional power companies
* !!!!   Elctariff defines companies evaluated in the revenue contraints
*$ontext
         ELctariff(ELbig,vn)=yes;
         ELctariff(ELnuc,v)=yes;
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