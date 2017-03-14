$onecho > cmd.txt
I=db\coal_tables.accdb
X=db\coalprod.gdx

Q1 =  SELECT COf,mm,PU,rw,time,rco,[Production Yield] FROM Coprodyield
p1=COprodyield

Q2 =  SELECT COf,mm,PU,time,rco,[Production (mt)] FROM COprodIHS
p2=COprodData

Q3 =  SELECT COf,mm,PU,rw,time,rco,[Calorific Value (kcal/kg)] FROM coalcv
p3=coalcv

Q4 =  SELECT COf,mm,PU,rw,time,rco,[Operating Costs (USD/mt)] FROM COomcst
p4=COomcst

Q5 =  SELECT COf,mm,PU,time,rco,[Washing Ratio] FROM Cowashratio
p5=COwashratio


Q6=SELECT 'ExtLow',Region,ExtLow FROM CBRsulfur \
UNION SELECT 'Low',Region,Low FROM CBRsulfur \
UNION SELECT 'Med',Region,Med FROM CBRsulfur \
UNION SELECT 'High',Region,High FROM CBRsulfur
p6=COsulfur


Q9 = SELECT coal_type,year,'IMOT',tonnes FROM coal_imports \
UNION SELECT coal_type,year,'IMOT',tonnes FROM coal_imports \
UNION SELECT coal_type,year,'IMOT',tonnes FROM coal_imports
p9 = COfimpmax


Q13=SELECT [t],WCD_QUADS FROM period,[COAL_demand_EIA] WHERE year=[yr]
P13 = WCD_Quads


Q14=  SELECT 'Production','t12',[rdem],Production FROM [Coal_stats_2012],nodes WHERE [Prov]=Province \
UNION SELECT 'Other','t12',[rdem],Other FROM [Coal_stats_2012],nodes WHERE [Prov]=Province \
UNION SELECT 'Metallurgical','t12',[rdem],Metallurgical FROM [Coal_stats_2012],nodes WHERE [Prov]=Province \
UNION SELECT 'Power','t12',[rdem],Power FROM [Coal_stats_2012],nodes WHERE [Prov]=Province
P14=COstatistics

Q15 SELECT COf,CV,sulf,rco,[Import Price (Yuan/mt)] FROM [Coal Import Price]
P15=COimportprice

Q16 SELECT time,Multiplier FROM [Coal Price Trend]
P16=COpricetrend


$offecho

$call =mdb2gms @cmd.txt