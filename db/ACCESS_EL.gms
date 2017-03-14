$onecho > cmd.txt
I=db\ChinaPower.accdb
X=db\power.gdx

Q1=SELECT 'HVAC',r,rr,AC FROM ELtransgrid \
UNION SELECT 'UHVDC',r,rr,DC FROM ELtransgrid
P1=ELtransexist

Q2=SELECT ELp,vintage,[Heat Recovery],Region,SumOfGW FROM ELexist_coal \
UNION SELECT ELp,vintage,[Heat Recovery],Region,SumOfGW FROM ELexist_nuclear \
UNION SELECT ELp,vintage,[Heat Recovery],Region,SumOfGW FROM ELexist_other
P2=ELexist

Q3=SELECT ELp,vintage,[Heat Recovery],Region,SumOfGW FROM ELexist_coal_nox
P3=ELnoxexist

Q4=SELECT ELp,vintage,[Heat Recovery],Region,SumOfGW FROM ELexist_coal_sox
P4=ELfgdexist

Q5=SELECT r,ophours FROM ELhydrohours
P5=ELhydhrs

Q6=SELECT KEM,Region,SumOfGW FROM IHS_hydro
P6=ELhydexist

Q7=SELECT Region,SumOfGW FROM IHS_wind
P7=ELwindexist

Q9=SELECT Region,[SumOf2012]/1000 FROM [CEIC Hydro]
P9=ELhydroCEIC

Q10=SELECT ELp,Region,Tariff FROM OnGridTariffs
P10=ELtariffmax

Q11=SELECT 't11',r,rr,[TWH 2011] FROM ELtransgrid
P11=ELtransdata

Q12=SELECT 'HVAC',r,rr,Distance from ELtransgrid Where Connect_AC OR [AC]>0 \
UNION SELECT 'UHVDC',r,rr,Distance from ELtransgrid Where Connect_DC OR [DC]>0
P12=ELtransD

Q13=SELECT Fuel,Region,Consumption FROM FuelAllocation
P13=FuelAllocation

Q14=SELECT Fuel,Time,Multiplier FROM FuelAllocationTrend
P14=FuelAllocationTrend

$offecho

$call =mdb2gms @cmd.txt
