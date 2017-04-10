if(run_model('Coal'),
         COprice.l(COf,cv,sulf,t,r)=
   ( COdem.m(COf,cv,sulf,t,r)
     -sum(rco$(rco_r_dem(rco,r) and not r(rco) and rcodem(rco)),
       COsuplim.m(COf,cv,sulf,t,rco)/num_nodes_reg(r))
   )
);


