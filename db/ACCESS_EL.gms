$onecho > cmd.txt
I=db\ChinaPower.accdb
X=db\power.gdx

Q1=SELECT 'HVAC',r,rr,AC FROM ELtransgrid \
UNION SELECT 'UHVDC',r,rr,DC FROM ELtransgrid
P1=ELtransexist

Q2=SELECT ELp,vintage,size,[Heat Recovery],GB,SumOfGW FROM ELexist_coal \
UNION SELECT ELp,Vintage,'large',[Heat Recovery],rdem,SumOfGW FROM ELexist_nuclear \
UNION SELECT ELp,'old','large',[Heat Recovery],rdem,SumOfGW FROM ELexist_other
P2=ELexist

Q3=SELECT ELp,vintage,size,[Heat Recovery],rdem,SumOfGW FROM ELexist_coal_nox
P3=ELnoxexist

Q4=SELECT ELp,vintage,size,[Heat Recovery],rdem,SumOfGW FROM ELexist_coal_sox
P4=ELfgdexist

Q5=SELECT r,ophours FROM ELhydrohours
P5=ELhydhrs

Q6=SELECT KEM,Region,SumOfGW FROM IHS_hydro
P6=ELhydexist

Q7=SELECT Region,SumOfGW FROM IHS_wind
P7=ELwindexist


Q8=SELECT 'lightcrude','t12',[rdem],[Crude, mmbbl] FROM FuelAllocation2012,[nodes]  Where [Prov]=Province \
UNION SELECT 'diesel','t12',[rdem],[Diesel, mt] FROM FuelAllocation2012,[nodes]  Where [Prov]=Province \
UNION SELECT 'HFO','t12',[rdem],[Fuel oil, mt] FROM FuelAllocation2012,[nodes]  Where [Prov]=Province \
UNION SELECT 'methane','t12',[rdem],[all gas, trillion btu] FROM FuelAllocation2012,[nodes]  Where [Prov]=Province \
UNION SELECT 'coal','t12',[rdem],[coal, mtce] FROM FuelAllocation2012,[nodes]  Where [Prov]=Province
P8=ELfconsumpmax

Q9=SELECT [rdem],[2012]/1000 FROM [hydro_capacity_CEIC],nodes WHERE Prov=[Province]
P9=ELhydroCEIC

Q10=SELECT ELp,Region,Tariff FROM OnGridTariffs
P10=ELtariffmax

Q11=SELECT 't11',r,rr,[TWH 2011] FROM ELtransgrid
P11=ELtransdata

Q12=SELECT 'HVAC',r,rr,Distance from ELtransgrid Where Connect_AC \
UNION SELECT 'UHVDC',r,rr,Distance from ELtransgrid Where Connect_DC
P12=ELtransD



$offecho

$call =mdb2gms @cmd.txt
