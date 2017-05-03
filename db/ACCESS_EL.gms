$onecho > cmd.txt
I=db\ChinaPower.accdb
X=db\power.gdx

Q1=SELECT 'HVAC',r,rr,[AC (GW)] FROM [Transmission Grid] \
UNION SELECT 'UHVDC',r,rr,[DC (GW)] FROM [Transmission Grid]
P1=ELtransexist

Q2=SELECT ELp,vintage,[Heat Recovery],Region,SumOfGW FROM [Coal Power Capacity] \
UNION SELECT ELp,vintage,[Heat Recovery],Region,SumOfGW FROM [Nuclear Capacity] \
UNION SELECT ELp,vintage,[Heat Recovery],Region,SumOfGW FROM [Other Power Plant Capacity]
P2=ELexist

Q3=SELECT ELp,vintage,[Heat Recovery],Region,SumOfGW FROM [Coal SOX Control Capacity]
P3=ELnoxexist

Q4=SELECT ELp,vintage,[Heat Recovery],Region,SumOfGW FROM [Coal NOX Control Capacity]
P4=ELfgdexist

Q5=SELECT region,hours FROM [Hydro Operating Hours]
P5=ELhydhrs

Q6=SELECT Elp,Region,SumOfGW FROM [Hydro Capacity]
P6=ELhydexist

Q7=SELECT Region,SumOfGW FROM [Wind Capacity]

P7=ELwindexist

Q9=SELECT Region,[SumOf2012]/1000 FROM [CEIC Hydro]
P9=ELhydroCEIC

Q10=SELECT ELp,Region,[Tariff (RMB/MWH)] FROM [On Grid Tariffs]
P10=ELtariffmax

Q12=SELECT 'HVAC',r,rr,[Distance (KM)] from [Transmission Grid] Where Connect_AC OR [AC (GW)]>0 \
UNION SELECT 'UHVDC',r,rr,[Distance (KM)] from [Transmission Grid] Where Connect_DC OR [DC (GW)]>0
P12=ELtransD

Q13=SELECT Fuel,Region,Consumption FROM [Fuel Allocation]
P13=FuelAllocation

Q14=SELECT Fuel,Time,Multiplier FROM [Fuel Allocation Trend]
P14=FuelAllocationTrend

Q15=SELECT Fuel,[Supply Step],Region,Price FROM [Administered Fuel Prices]
P15=ELFuelPrice

Q16=SELECT Plant,Vintage,Region,Cost FROM [Plant Operating Cost (non-fuel)]
P16=ELomcst

Q17=SELECT Plant,Cost FROM [Plant Fixed Operating Cost]
P17=ELfixedomcst

Q18=SELECT Region,Plant,Cost FROM [Plant Capital Cost]
P18=Elcapital

Q19=SELECT Plant,Lifetime FROM [Plant Lifetime]
P19=ELlifetime

Q20=SELECT [Transmission Line],[Start Region],[End Region],Cost FROM [Transmission Line Capital Cost]
P20=Eltranscapital

Q21=SELECT [Transmission Line],[Start Region],[End Region],Cost FROM [Transmission Operating Cost]
P21=ELtransomcst

Q22=SELECT [Transmission Line],[Start Region],[End Region],Yield FROM [Transmission Yield]
P22=ELtransyield

Q23=SELECT Plant,Vintage,[Parasitic Load (%)] FROM [Plant Parasitic Load]
P23=ELparasitic

Q24=SELECT Plant,Vintage,[Efficiency (%)] FROM [Plant Fuel Efficiency]
P24=ELpeff

Q25=SELECT Plant,Vintage,Fuel,Region,[Heat Rate] FROM [Plant Heat Rate]
P25=ELfuelburn

Q26=SELECT Plant,Vintage,[Capacity Factor] FROM [Plant Maximum Capacity Factor]
P26=ELcapfac

Q27=select Region,Plant,[NOX ton/m3] from [Plant NOx Emissions]
P27=NOxC

Q28=select Region,Plant,[NO2 ton/m3] from [Plant NOx Emissions]
P28=NO2C

$offecho

$call =mdb2gms @cmd.txt
