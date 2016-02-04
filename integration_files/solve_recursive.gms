
         t(trun)=no;
         t(trun)=yes$thyb(trun);
*        initiatlize dynamic set t
         loop(trun,

* find index of absolute time for each time (t) in recursive dynamic solve
* with respect to recursive step trun
                 t_ind(t) = ord(t)+ord(trun)-t_start-1;
                 t_ind(t)$(t_ind(t)<=0) = 1;

                 display t_ind

         if(ord(trun)>=t_start,
                  Solve integratedLP using LP minimizing z;
         );


********         Variable fix and bounds
                 COexistcp.fx(COf,mm,ss,trun+1,rco)=
                         COexistcp.l(COf,mm,ss,trun,rco)
                         +CObld.l(COf,mm,ss,trun-COleadtime(COf,mm,rco),rco);

                 COexistcp.fx(COf,mm,ss,trun+1,rco)$(COexistcp.l(COf,mm,ss,trun+1,rco)>CoprodIHS(COf,mm,ss,trun+1,rco))=
CoprodIHS(COf,mm,ss,trun+1,rco);

*                         -(COexistcp.l(COf,mm,ss,trun,rco)-CoprodIHS(COf,mm,ss,trun+1,rco))$(COexistcp.l(COf,mm,ss,trun,rco)>CoprodIHS(COf,mm,ss,trun+1,rco));

                 COtransexistcp.fx(tr,trun+1,r,rr)=
                         COtransexistcp.l(tr,trun,r,rr)
                         +COtransbld.l(tr,trun-COtransleadtime(tr,r,rr),r,rr);

*$offtext
* next we push forward all the parameter sets for the next solve statemenn t+1

*        add the next time period to dynmic set t
                 t(trun+card(thyb))=yes;

*        next we push forward all the discounted investment cost

                 COdiscfact(t+1) = COdiscfact(t);

                 COpurcst(COf,mm,t+1,rco) = COpurcst(COf,mm,t,rco);
                 COconstcst(COf,mm,ss,t+1,rco) = COconstcst(COf,mm,ss,t,rco);

                 COtranspurcst(tr,t+1,r,rr) = COtranspurcst(tr,t,r,rr);
                 COtransconstcst(tr,t+1,r,rr) = COtransconstcst(tr,t,r,rr);
*                 abort t,COtransconstcst;
$ontext
                 ftranspurcst(fup,tr,t+1,r,rr)=ftranspurcst(fup,tr,t,r,rr);
                 ftransconstcst(fup,tr,t+1,r,rr)=ftransconstcst(fup,tr,t,r,rr);


                 WApurcst(WAp,t+1,r)=WApurcst(WAp,t,r);
                 WAconstcst(WAp,t+1,r)=WAconstcst(WAp,t,r);
                 WAtranspurcst(t+1,r,rr)=WAtranspurcst(t,r,rr);
                 WAtransconstcst(t+1,r,rr)=WAtransconstcst(t,r,rr);

                 ELpurcst(ELp,t+1,r)=ELpurcst(ELp,t,r);
                 ELconstcst(ELp,t+1,r)=ELconstcst(ELp,t,r);
                 ELtranspurcst(ELt,t+1,r,rr)=ELtranspurcst(ELt,t,r,rr);
                 ELtransconstcst(ELt,t+1,r,rr)=ELtransconstcst(ELt,t,r,rr);

                 PCpurcst(PCp,r,t+1)=PCpurcst(PCp,r,t);
                 PCconstcst(PCp,r,t+1)=PCconstcst(PCp,r,t);

                 RFpurcst(RFu,t+1)=RFpurcst(RFu,t);
                 RFconstcst(RFu,t+1)=RFconstcst(RFu,t);
                 RFELpurcst(t+1)=RFELpurcst(t);
                 RFELconstcst(t+1)=RFELconstcst(t);

                 CMpurcst(CMu,t+1)=CMpurcst(CMu,t);
                 CMconstcst(CMu,t+1)=CMconstcst(CMu,t);
                 CMELpurcst(t+1)=CMELpurcst(t);
                 CMELconstcst(t+1)=CMELconstcst(t);
                 CMstorpurcst(t+1)=CMstorpurcst(t);
                 CMstorconstcst(t+1)=CMstorconstcst(t);
$offtext

                 t(trun)=no;
*        remove the initial time period from dynamic set t
         );
