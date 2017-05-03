$onecho > cmd.txt
I=db\coal_tables.accdb
X=db\coalprod.gdx

Q1 =  SELECT COf,mm,PU,rw,time,rco,[Production Yield] FROM [Coal Production Yield]
p1=COprodyield

Q2 =  SELECT COf,mm,PU,time,rco,[Production (mt)] FROM [Coal Production]
p2=COprodData

Q3 =  SELECT COf,mm,PU,rw,time,rco,[Calorific Value (kcal/kg)] FROM [Coal Calorific Value]
p3=coalcv

Q4 =  SELECT COf,mm,PU,rw,time,rco,[Operating Costs (USD/mt)] FROM [Coal Production Cost]
p4=COomcst

Q5 =  SELECT COf,mm,PU,time,rco,[Washing Ratio] FROM [Coal Washing Ratio]
p5=COwashratio


Q6=SELECT 'ExtLow',Region,ExtLow FROM CBRsulfur \
UNION SELECT 'Low',Region,Low FROM CBRsulfur \
UNION SELECT 'Med',Region,Med FROM CBRsulfur \
UNION SELECT 'High',Region,High FROM CBRsulfur
p6=COsulfur

Q7 = SELECT [Sulfur Content],[Dry Weight (%)] FROM Sulfur
p7 = COsulfDW

Q8 = SELECT COf,time,rco,mt FROM [Coal Imports Max Regional]
p8 = COfimpmax

Q9 = SELECT COf,time,mt FROM [Coal Imports Max National]
p9 = COfimpmax_nat


Q13=SELECT [time],WCD_QUADS FROM [Time Periods],[World Coal Demand EIA WEPPS] WHERE year=[yr]
P13 = WCD_Quads


Q15 SELECT COf,CV,sulf,rco,[Import Price (Yuan/mt)] FROM [Coal Import Price]
P15=COimportprice

Q16 SELECT time,Multiplier FROM [Coal Price Trend]
P16=COpricetrend

Q17= SELECT Region,SumOf2015 FROM [Regional Production (CEIC)]
P17= COprodCEIC2015

Q18= SELECT Region,[Capacity Cuts (mt)] FROM [Regional Capacity Cuts]
P18= COprodcuts

Q19= SELECT Region,[Capacity (mt)] FROM [Coal Capacity]
P19= COcapacity

$offecho

$call =mdb2gms @cmd.txt
