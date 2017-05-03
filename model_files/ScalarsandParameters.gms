
* Scalars and parameters shared between submodel files

$INCLUDE scenario_flags.gms

scalar mmBTUtoTons ;

parameter t_ind time index used in when using recursive dynamics

parameter discount_rate(sectors);

$gdxin db\financial.gdx
$load discount_rate
$gdxin

Parameter RMBUSD(time) RMB to USD exchange rate
/
t11      0.154695
t12      0.158475
t13      0.162551
t14      0.162467
t15      0.160659
/  ;


RMBUSD(trun)$(ord(trun)>5) = RMBUSD('t15');


parameter  FuelperMWH(f) quantity of fuel per MWH
           COcvSCE(cv) average CV of coal bins noramlized to 7000 kcal per kg
           COboundCV(cv,bound) upper and lower bounds on coal CV bins
           NOxC(r,ELp) concentration nox in flu gas ton per normal cubic meter
           NO2C(r,ELp) concentration no2 in flu gas ton per normal cubic meter
           EMfgcomcst(fgc) operation and maintenance cost of fgd per MWH
           EMfgcfixedOMcst(fgc) operation and maintenance cost of fgd per KW
                 / DeSOx  0 /
           EMfgccapex(fgc) Capital cost of flue gas control per KW
           EMfgccapexD(fgc,trun) Annualized capital cost of flue gas control
           EMfgc(fgc) Percentage emissions of nox and sox from fgc systems

          / noDeSOx 1
            DeSOx 0.2
            noDeNOx 1
            DeNOx 0.2
         /

$gdxin db\material_sets.gdx
$load FuelperMWH COcvSCE EMfgcomcst EMfgccapex
$gdxin

$gdxin db\power.gdx
$load NOxC NO2C
$gdxin
;

*        Initialize undefined emission concentrations
alias (ELpcoal, ELpcoal2);
NOxC(r,ELpcoal)$(NOxC(r,ELpcoal)=0)=smax((rr,ELpcoal2),NOxC(rr,ELpcoal2));
NO2C(r,ELpcoal)$(NO2C(r,ELpcoal)=0)=smax((rr,ELpcoal2),NO2C(rr,ELpcoal2));
$offorder
         COboundCV(cv,"lo")$(ord(cv)=1) = 0;
         COboundCV(cv,"up")$(ord(cv)=1) = (COcvSCE(cv)+COcvSCE(cv+1))/2;
loop(cv$(ord(cv)>1),
         COboundCV(cv,'lo') = COboundCV(cv-1,'up');
         COboundCV(cv,'up') = (COcvSCE(cv)+COcvSCE(cv+1))/2;

);
         COboundCV(cv,'up')$(ord(cv)=card(cv))= 1e6;
$onorder

         COcvSCE(cv) = COcvSCE(cv)/7000;

*======== Paramters used to calcualte sulfur and nox emissions


parameter ELpSO2std(ELp,v,trun,r), ELpNO2std(ELp,v,trun,r);

         ELpSO2std(ELpcoal,v,trun,r)=200;
         ELpSO2std(ELpcoal,v,trun,'Southwest')=400;
         ELpSO2std(ELpcoal,v,trun,'Sichuan')=400;

         ELpNO2std(ELpcoal,v,trun,r)=200;
         ELpNO2std(ELpcoal,vo,trun,r)=200;

         ELpSO2std(ELpcoal,v,trun,r)=ELpSO2std(ELpcoal,v,trun,r)/1e9;
         ELpNO2std(ELpcoal,v,trun,r)=ELpNO2std(ELpcoal,v,trun,r)/1e9;

parameter alpha0(ELp,f) excess air ratio in combustion chamber
          a1(f) Vr first coefficient
          a2(f) V0 coefficient
          c1(f) 1st constant in flue gas equation
          c2(f) constant in theoretical air demand equation
          rho(f) fuel density and volume conversion
          Vr(ELp,f) flue gas volume per unit fule combusted
          VrCo(ELp,f,cv) flue gas volume per unit coal combusted
;

scalar   delta_alpha excess air ration corrected parameter /0.6/  ;

         rho(ELfcrude) = 0.1589873  ;
         rho('diesel') = 1.175  ;
         rho('hfo') = 1.075  ;
         rho('methane') = 1.075  ;

         alpha0(ELpcoal,Elfcoal) = 1.25;
         alpha0(ELpsubcr,Elfcoal) = 1.3;
         alpha0(Elpog,Elfmethane) = 1.075;
         alpha0(Elpog,Elfliquid) = 1.175;

         a1(Elfcoal) = 1.04*7000*4.187/4.187;
*        mhw PER TON OR BBL * 3.6E6 kJ per mwh (dont need volume conversion) *1/rho(ELf)  bbl or ton per m3
         a1(ELfliquid) = 1.10/FuelperMWH(ELfliquid)*3600000/4187;
*        mwh per mmbtu * 3.6e6 Kj per mwh * (dont need volume conversion) *0.036409 mmbtu per m3
         a1('methane') = 1.14/3.412*3600000*0.036409/4187;

         a2(ELfcoal) = 1.05*7000*4.187/4.145;
*        mhw PER TON OR BBL * 3.6E6 kJ per mwh    (dont need volume conversion) *1/rho(ELf)  bbl or ton per m3
         a2(ELfliquid) = 0.85/FuelperMWH(ELfliquid)*3600000/1000;
*        mwh per mmbtu * 3.6e6 Kj per mwh * (dont need volume conversion) *0.036409 mmbtu per m3
         a2('methane') = 0.260/3.412*3600000/1000;

         c1(ELfcoal) = 0.77*1000;
         c1('methane') = -0.25*rho('methane');

         c2(ELfcoal) = 0.278*1000;
         c2(ELfliquid) = 2*rho(ELfliquid);
         c2('methane') = -0.25/0.036409;

         Vr(ELpd,Elf)$(not Elpcoal(Elpd) and not Elfcoal(ELf))=
          a1(Elf)+c1(ELf)
         +1.0161*(alpha0(ELpd,ELf)+delta_alpha-1)*(a2(Elf)+c2(Elf)) ;

         VrCo(ELpd,ELf,cv)  =
          a1(ELf)*COcvSCE(cv)+c1(ELf)
         +1.0161*(alpha0(ELpd,ELf)+delta_alpha-1)*(a2(ELf)*COcvSCE(cv)+c2(Elf));


parameter ELfit(ELp,trun,r);
