
*0.63


*Check since Tibet value is not available!!!!!
parameter EMsulfmax(time,r) 2010 regional total sulfur emission in million tons
/
         t12.North           1.656
         t12.CoalC           2.292
         t12.Northeast       2.395
         t12.East            2.721
         t12.Central         1.844
         t12.Shandong        1.758
         t12.Henan           1.28
         t12.South           1.308
         t12.Sichuan         1.433
         t12.Southwest       1.714
         t12.Tibet           0.001
         t12.West            1.977
         t12.Xinjiang        0.808
/


;

parameter EMELsulfmax(time,r) 2010 regional power sector emission in million tons
/
         t12.North           0.399
         t12.CoalC           1.019
         t12.Northeast       0.785
         t12.East            0.912
         t12.Central         0.442
         t12.Shandong        0.677
         t12.Henan           0.401
         t12.South           0.412
         t12.Sichuan         0.457
         t12.Southwest       0.729
         t12.Tibet           0
         t12.West            0.637
         t12.Xinjiang        0.187
/

;



parameter EMELnoxmax(time,r) 2010 regional power sector emission in million tons
/
         t12.North           0.903
         t12.CoalC           1.2067
         t12.Northeast       1.2513
         t12.East            1.936
         t12.Central         0.692
         t12.Shandong        0.724
         t12.Henan           0.726
         t12.South           0.636
         t12.Sichuan         0.355
         t12.Southwest       0.562
         t12.Tibet           0
         t12.West            0.953
         t12.Xinjiang        0.263
/
;
*         EMELnoxmax('t12','Sichuan')=0.233;


*         EMELnoxmax(time,Shandong) = EMELnoxmax(time,Shandong)*1.1;

Parameter ELdiscfact(time) discount factors for electricity sector
          EMdiscoef(trun);


;

Equations

*EMELsulflim(trun,r) sulfur emssions from the power sector

EMsulflim(trun,r) power sector sulfur emission constraint

EMELnoxlim(trun,r) power sector nox emission constraint

EMfgbal(ELp,v,trun,r) flue gas balance for different plants

EMELSO2std(ELpcoal,v,trun,r) so2 flue gas  emmission standard for power plants ton per Nm3

EMELNO2std(ELpcoal,v,trun,r) no2 flue gas emmission standard for power plants ton per Nm3

DEMELfluegas(ELpcoal,v,trun,r)
;

* We assume an 80% combustion efficiency for sulfur in coal,
* and a molecular conversion factor of 2  2O + S  => SO2
* molecular weight of sulfur is approx 2 times that of oxygen
* each unit of sulfur generate 160% SO2

$offorder

EMsulflim(t,r)$rdem_on(r)..
  -sum((cv,sulf),(
     sum((ELpcoal,v,gtyp,sox,nox)$ELpfgc(ELpcoal,cv,sulf,sox,nox),
         ELCOconsump(Elpcoal,v,gtyp,cv,sulf,sox,nox,t,r)*EMfgc(sox))
    +sum((coal)$(COfcv(coal,cv)),OTHERCOconsumpsulf(coal,cv,sulf,t,r))
   )*COsulfDW(sulf)*1.6)
         =g=
   -EMsulfmax(t,r);
;


EMELnoxlim(t,r)..
  -sum((ELpcoal,v,gtyp,cv,sulf,sox,nox)$ELpfgc(Elpcoal,cv,sulf,sox,nox),
         ELCOconsump(ELpcoal,v,gtyp,cv,sulf,sox,nox,t,r)*EMfgc(nox)*
         VrCo(ELpcoal,'coal',cv)*NOxC(r,ELpcoal)
   )
         =g= -EMELnoxmax(t,r)*1
;

EMfgbal(ELpcoal,v,t,r)..
   sum((gtyp,cv,sulf,sox,nox)$ELpfgc(Elpcoal,cv,sulf,sox,nox),
         ELCOconsump(ELpcoal,v,gtyp,cv,sulf,sox,nox,t,r)*
         VrCo(ELpcoal,'coal',cv)
   )
          -EMELfluegas(ELpcoal,v,t,r)
                 =e= 0
;

EMELSO2std(ELpcoal,v,t,r)$(SO2_std=1)..
  -sum((cv,sulf,gtyp,sox,nox)$ELpfgc(ELpcoal,cv,sulf,sox,nox),
         ELCOconsump(Elpcoal,v,gtyp,cv,sulf,sox,nox,t,r)*EMfgc(sox)*
         COsulfDW(sulf)*1.6
  )

   +EMELfluegas(ELpcoal,v,t,r)*ELpSO2std(ELpcoal,v,t,r)
                 =g= 0
;


EMELNO2std(ELpcoal,v,t,r)$(SO2_std=1)..
  -sum((gtyp,cv,sulf,sox,nox)$ELpfgc(Elpcoal,cv,sulf,sox,nox),
         ELCOconsump(ELpcoal,v,gtyp,cv,sulf,sox,nox,t,r)*EMfgc(nox)*
         VrCo(ELpcoal,'coal',cv)*NO2C(r,ELpcoal)
   )

   +EMELfluegas(ELpcoal,v,t,r)*ELpNO2std(ELpcoal,v,t,r)
                 =g= 0
;



DEMELfluegas(ELpcoal,v,t,r)..
  0 =g=
  -DEMfgbal(ELpcoal,v,t,r)
  +DEMELSO2std(ELpcoal,v,t,r)*ELpSO2std(ELpcoal,v,t,r)$(SO2_std=1)
  +DEMELNO2std(ELpcoal,v,t,r)*ELpNO2std(ELpcoal,v,t,r)$(SO2_std=1)
  ;
