*        The parameter below is used to flatten the peak demand in region where
*        The estimated load cureve exceeds the available capacity and reserve
*        margin. SUggests either the demand estimation is incorrect or regions
*        encountered some brown out periods due to insuffiecient capacity
*$ontext
parameter ELlcgwdiff(r,ELl)  flatten load curve peak demand;

         ELlcgwdiff('Xinjiang','LS1') =  0.6;
         ELlcgwdiff('Northeast','LS1') =  0.41;
         ELlcgwdiff(r,'LS2') =   ELlcgwdiff(r,'LS1')*.8;

;
         ELlcgw(r,ELl) = ELlcgw(r,ELl)-ELlcgwdiff(r,ELl);

         loop(ELl$(ord(ELL)>1),
              ELlcgw(r,ELl) = ELlcgw(r,ELl)+ELlcgwdiff(r,'LS1')*
                 ELlchours('LS1')/ELlchours(ELl)*(card(Ell)-ord(ELl)+1)/sum(ELll$(ord(ELll)>=ord(ELl)),(ord(Elll)-1))
         );

         loop(ELl$(ord(ELL)>2),
              ELlcgw(r,ELl) = ELlcgw(r,ELl)+ELlcgwdiff(r,'LS2')*
                 ELlchours('LS2')/ELlchours(ELl)*(card(Ell)-ord(ELl)+1)/sum(ELll$(ord(ELll)>=ord(ELl)),(ord(Elll)-2))
         );

         loop(ELl$(ord(ELL)>3),
              ELlcgw(r,ELl) = ELlcgw(r,ELl)+ELlcgwdiff(r,'LS3')*
                 ELlchours('LS3')/ELlchours(ELl)*(card(Ell)-ord(ELl)+1)/sum(ELll$(ord(ELll)>=ord(ELl)),(ord(Elll)-3))
         );
*$offtext
