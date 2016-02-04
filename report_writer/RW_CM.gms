         Eldemand(Ell,trun,r) = Eldemand(Ell,trun,r)
                                         +CMELconsump.l(ELl,trun,r)  ;

         ELconsump("CM",trun,r) = sum(Ell,CMELconsump.l(ELl,trun,r));

         fconsump("CM",fup,trun,r) = CMfconsump.l(fup,trun,r)$CMf(fup);

         RFfconsump("CM",RFcf,trun,r) = CMfconsump.l(RFcf,trun,r)$CMf(RFcf);
