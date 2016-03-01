* Scalars and parameters shared between submodel files

$INCLUDE scenario_flags.gms

scalar mmBTUtoTons ;

parameter t_ind time index used in when using recursive dynamics


Parameter RMBUSD(time) RMB to USD exchange rate
/
t11      0.154695
t12      0.158475
t13      0.162551
t14      0.162467
t15      0.160659
/  ;


RMBUSD(trun)$(ord(trun)>5) = RMBUSD('t15');



*========= Conversion factors to get rnergy content of fuels in units of MWH
*Amount of fuel burned per output of energy.
*Coal and methane values from EIA heat rate figures (http://www.eia.gov/electricity/annual/html/epa_08_01.html)
*Nuclear fuel burn from KEM - Saudi power submodel
*Methane is in units of MMBTU/MWh
*diesel,HFO, uranium, and coal are in units of metric tons/MWh

*1 megawatt hour = 860420.65 kilocalories
* 7000 kcal/kg
* coal fuel rate is
*860420.65 kcal/MWH / 7000 kcal/kg  * 1000 kg/ton =>  0.122917 ton/MWH 7000 KCal/kg coal
*251995.7611111 kcal/mmbtu

parameter  FuelperMWH(f) quantity of fuel per MWH

*       Energy density for HFO: 43MJ/kg, 3600MJ/42MJ/kg = 85.71kg/MWh = 0.08571 ton/kg
*       Energy density for diesel: 44.8MJ/kg, 3600MJ/44.8MJ/kg = 80.36kg/MWh = 0.08036 ton/kg
*       Energy density of boe; 0.588 boe/mwh
*       ENergy density of coal 860 420.65 calories/kwh / 7000000000 cal/ton = 0.1228 ton/MWh
*       Energy Density of uranium for electric power pupposes = 0.045346
*        http://www.whatisnuclear.com/physics/energy_density_of_nuclear.html
*       1MWh = 3600 MJ, 3600MJ/MWh/79390000MJ/kg = 0.000045346kg/MWh = 0.045346 kg/MWh

/
         diesel     0.08036
         HFO        0.08571
         lightcrude 0.588
         coal       0.1228
         u-235      0.045346
/;

parameter COcvSCE(cv) average CV of coal noramlized to 7000 kcal per kg SCE
         /
         CV30    3000
         CV38    3800
         CV46    4600
         CV54    5400
         CV62    6200
         CV70    7000
$ontext
         CV30    3000
         CV35    3500
         CV40    4000
         CV45    4500
         CV50    5000
         CV55    5500
         CV60    6000
         CV65    6500
         CV70    7000
$offtext
          /

          COboundCV(cv,bound) average calorific value of coal
         /
         CV30.lo    500
         CV30.up    3400
*         CV35.lo    500
*         CV35.up    4000
         /;

         COcvSCE(cv) = COcvSCE(cv)/7000;
         COcvSCE(cv_met) = 1;
         COcvSCE('CVf') = 1;

$offorder
         loop(CV_ord,
         COboundCV(CV_ord+1,'up') = COboundCV(CV_ord,'up')+800;
*         COboundCV(CV_ord+1,'up') = COboundCV(CV_ord,'up')+1000;
         COboundCV(CV_ord+1,'lo') = COboundCV(CV_ord,'up');
         );

         COboundCV(CV_ord,'up')$(ord(CV_ord)=card(CV_ord))= 10000;
$onorder


*======== Paramters used to calcualte sulfur and nox emissions

parameter COsulfDW(sulf) sulfur content by dry weigh tfor each sulfur-content category
*        ExtLow = 0.25%,Low=1%,Med=2%,High=5%
         /
         ExtLow  0.0025
         Low     0.01
         Med     0.03
*         High    0.05
         /;



*       mg per cubic meter
parameter NOxC(r,ELp) concentration of nox in flu gas ton per cubic meter
$ontext
                         Subcr           Superc          ultrsc
         South           650             625             600

         CoalC           600             600             600
         Northeast       700             700             700
         East            650             625             600
         Central         700             700             700
         Shandong        600             600             600
         Henan           650             625             600
         North           650             650             650
         Sichuan         700             700             700
         Southwest       700             675             650
         Tibet           650             650             650
         West            700             675             650
         Xinjiang        625             600             575

;
$offtext
;
* convert to tons per cubic meter
NOxC(r,ELpcoal) = 552*1e-9;
NOxC(r,'SubcrSML') = 500*1e-9;


*NOxC('CoalC',Elpd) = NOxC('CoalC',ELpd)*0.75;
*NOxC('Shandong',Elpd) = NOxC('Shandong',ELpd)*0.75;
*NOxC('South',Elpd) = NOxC('South',ELpd)*0.75;
*NOxC('Northeast',Elpd) = NOxC('Northeast',ELpd)*1.3;
*NOxC('North',Elpd) = NOxC('North',ELpd)*0.9;
*NOxC('East',Elpd) = NOxC('East',ELpd)*0.9;
*NOxC('Xinjiang',Elpd) = NOxC('Xinjiang',ELpd)*0.75;


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

         alpha0(ELpSubcr,Elfcoal) = 1.35;
         alpha0(ELpSuperc,Elfcoal) = 1.2;
         alpha0('ultrsc',Elfcoal) = 1.25;
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

*$ELfCV(Elf,cv,'extlow')

*EMELsulfmax(time,r) = EMELsulfmax(time,r)*0.1;
*EMELsulfmax(time,r) = EMELsulfmax(time,r)*1e3;



parameter EMfgcomcst(fgc) operation and maintenance cost for fgd system RMB per MWH
         / NoDeSOX 0
           DeSOx  5
           DeNOx  10 /


          EMfgcpower(sulf,fgc,fgc) percentage of power supply required for fgc

;

parameter EMfgccapex(fgc,trun) RMB per KW
          EMfgccapexD(fgc,trun);
          EMfgccapex(DeSOx,trun)=1500  ;
          EMfgccapex(DeNOx,trun)=600  ;

parameter EMfgc(fgc) Percentage emissions of nox and sox from fgc systems
          / noDeSOx 1
            DeSOx 0.2
            noDeNOx 1
            DeNOx 0.2
         /

;

         EMfgcomcst(fgc) = EMfgcomcst(fgc);

* !!!    electricity consumption of fgc system defined as % of thermal eff
         EMfgcpower('extlow',DeSOx,noDeNOx) = 0.01;
         EMfgcpower('low',DeSOx,noDeNOx) = 0.01;
         EMfgcpower('med',DeSOx,noDeNOx) = 0.012;
*         EMfgcpower('high',DeSOx,nox) = 0.015;

         EMfgcpower(sulf,noDeSOx,DeNOx) = 0.01;

         EMfgcpower(sulf,DeSOx,DeNOx) = EMfgcpower(sulf,DeSOx,'noDeNOx')+ EMfgcpower(sulf,'noDeSOx',DeNOx);

parameter ELfit(ELp,trun,r);

         ELfit(ELpw,trun,r) = 600;
         ELfit(ELpw,trun,'CoalC') = 510;
         ELfit(ELpw,trun,'North') = 540;
         ELfit(ELpw,trun,'Northeast') = 580;
         ELfit(ELpw,trun,'West') = 580;
         ELfit(ELpw,trun,'Xinjiang') = 580;
