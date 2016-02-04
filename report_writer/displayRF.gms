********************************************************************************
* Refining Model Display Variables
* To check properties of blended products:
Parameter Property(RFcf,prop,time,r) to display properties of blended products;
Property('95motorgas',prop,time,r)$(sum((RFs,RFci,RFp),RFyield(RFs,RFci,'95motorgas',RFp)*RFconv(RFci,prop)*RFop.l(RFs,RFci,RFp,time,r))>0)=
  sum((RFs,RFci,RFp),RFyield(RFs,RFci,'95motorgas',RFp)*RFconv(RFci,prop)*RFop.l(RFs,RFci,RFp,time,r)*Qattributes(RFci,prop))
 /sum((RFs,RFci,RFp),RFyield(RFs,RFci,'95motorgas',RFp)*RFconv(RFci,prop)*RFop.l(RFs,RFci,RFp,time,r));

Property('91motorgas',prop,time,r)$(sum((RFs,RFci,RFp),RFyield(RFs,RFci,'91motorgas',RFp)*RFconv(RFci,prop)*RFop.l(RFs,RFci,RFp,time,r))>0)=
  sum((RFs,RFci,RFp),RFyield(RFs,RFci,'91motorgas',RFp)*RFconv(RFci,prop)*RFop.l(RFs,RFci,RFp,time,r)*Qattributes(RFci,prop))
 /sum((RFs,RFci,RFp),RFyield(RFs,RFci,'91motorgas',RFp)*RFconv(RFci,prop)*RFop.l(RFs,RFci,RFp,time,r));

Property('HFO',prop,time,r)$(sum((RFs,RFci,RFp),RFyield(RFs,RFci,'HFO',RFp)*RFconv(RFci,prop)*RFop.l(RFs,RFci,RFp,time,r))>0)=
  sum((RFs,RFci,RFp),RFyield(RFs,RFci,'HFO',RFp)*RFconv(RFci,prop)*RFop.l(RFs,RFci,RFp,time,r)*Qattributes(RFci,prop))
 /sum((RFs,RFci,RFp),RFyield(RFs,RFci,'HFO',RFp)*RFconv(RFci,prop)*RFop.l(RFs,RFci,RFp,time,r));

Property('Naphtha',prop,time,r)$(sum((RFs,RFci,RFp),RFyield(RFs,RFci,'Naphtha',RFp)*RFconv(RFci,prop)*RFop.l(RFs,RFci,RFp,time,r))>0)=
  sum((RFs,RFci,RFp),RFyield(RFs,RFci,'Naphtha',RFp)*RFconv(RFci,prop)*RFop.l(RFs,RFci,RFp,time,r)*Qattributes(RFci,prop))
 /sum((RFs,RFci,RFp),RFyield(RFs,RFci,'Naphtha',RFp)*RFconv(RFci,prop)*RFop.l(RFs,RFci,RFp,time,r));

Property('Diesel',prop,time,r)$(sum((RFs,RFci,RFp),RFyield(RFs,RFci,'Diesel',RFp)*RFconv(RFci,prop)*RFop.l(RFs,RFci,RFp,time,r))>0)=
  sum((RFs,RFci,RFp),RFyield(RFs,RFci,'Diesel',RFp)*RFconv(RFci,prop)*RFop.l(RFs,RFci,RFp,time,r)*Qattributes(RFci,prop))
 /sum((RFs,RFci,RFp),RFyield(RFs,RFci,'Diesel',RFp)*RFconv(RFci,prop)*RFop.l(RFs,RFci,RFp,time,r));

*To display the viscosity of fuel oil in cSt:
Parameter viscosity(RFcf,time,r);
Viscosity('HFO',time,r)$(Property('HFO','VBI',time,r))=10**(3*Property('HFO','VBI',time,r)/(1-Property('HFO','VBI',time,r)));

*Blending amounts
Blendamount95.l(RFci,time,r)=sum((RFs,RFp),RFyield(RFs,RFci,'95motorgas',RFp)*RFop.l(RFs,RFci,RFp,time,r));
Blendamount91.l(RFci,time,r)=sum((RFs,RFp),RFyield(RFs,RFci,'91motorgas',RFp)*RFop.l(RFs,RFci,RFp,time,r));
BlendamountHFO.l(RFci,time,r)=sum((RFs,RFp),RFyield(RFs,RFci,'HFO',RFp)*RFop.l(RFs,RFci,RFp,time,r));
BlendamountNaphtha.l(RFci,time,r)=sum((RFs,RFp),RFyield(RFs,RFci,'Naphtha',RFp)*RFop.l(RFs,RFci,RFp,time,r));
BlendamountDiesel.l(RFci,time,r)=sum((RFs,RFp),RFyield(RFs,RFci,'Diesel',RFp)*RFop.l(RFs,RFci,RFp,time,r));

*Total crudes consumption;
Parameter Totalcrudeconsump(time);
Totalcrudeconsump(time)=sum((RFcr,r),RFcrconsump.l(RFcr,time,r));

*To display annual electricity consumption
parameter RFELconsumpyr(time);
RFELconsumpyr(time)=sum((ELl,r),RFtotELconsump.l(ELl,time,r));

Display Property,viscosity;
Display Blendamount95.l,Blendamount91.l,BlendamountHFO.l,BlendamountNaphtha.l,BlendamountDiesel.l;
;
parameter ELPCRevenues(time);
ELPCRevenues(time)=sum((ELl,r),PCELprice*PCELconsump.l(ELl,time,r))

*Total crudes consumption;
Parameter Totalcrudeconsump(time);
Totalcrudeconsump(time)=sum((RFcr,r),RFcrconsump.l(RFcr,time,r));
display Totalcrudeconsump;

Display Totalcrudeconsump,RFELconsumpyr,ELPCRevenues;
********************************************************************************
