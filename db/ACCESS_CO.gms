$onecho > cmd.txt
I=db\coal_tables.accdb
X=db\coalprod.gdx

Q1 =  SELECT CoalType2,MiningMethod,PU,'washed','t11',Region,[Washing yield of washed coal (%)] FROM CoalRegions,[Volumealongprocessingchain2011] WHERE [PU]=[Production unit] \
UNION SELECT CoalType2,MiningMethod,PU,'washed','t15',Region,[Washing yield of washed coal (%)] FROM CoalRegions,[Volumealongprocessingchain2015] WHERE [PU]=[Production unit] \
UNION SELECT CoalType2,MiningMethod,PU,'washed','t20',Region,[Washing yield of washed coal (%)] FROM CoalRegions,[Volumealongprocessingchain2020] WHERE [PU]=[Production unit] \
UNION SELECT CoalType2,MiningMethod,PU,'washed','t25',Region,[Washing yield of washed coal (%)] FROM CoalRegions,[Volumealongprocessingchain2025] WHERE [PU]=[Production unit] \
UNION SELECT CoalType2,MiningMethod,PU,'washed','t30',Region,[Washing yield of washed coal (%)] FROM CoalRegions,[Volumealongprocessingchain2030] WHERE [PU]=[Production unit] \
UNION SELECT CoalType2,MiningMethod,PU,'washed','t35',Region,[Washing yield of washed coal (%)] FROM CoalRegions,[Volumealongprocessingchain2035] WHERE [PU]=[Production unit] \
UNION SELECT CoalType2,MiningMethod,PU,'other','t11',Region,[Washing yield of other washed products  (%)] FROM CoalRegions,[Volumealongprocessingchain2011] WHERE [PU]=[Production unit] \
UNION SELECT CoalType2,MiningMethod,PU,'other','t15',Region,[Washing yield of other washed products  (%)] FROM CoalRegions,[Volumealongprocessingchain2015] WHERE [PU]=[Production unit] \
UNION SELECT CoalType2,MiningMethod,PU,'other','t20',Region,[Washing yield of other washed products  (%)] FROM CoalRegions,[Volumealongprocessingchain2020] WHERE [PU]=[Production unit] \
UNION SELECT CoalType2,MiningMethod,PU,'other','t25',Region,[Washing yield of other washed products  (%)] FROM CoalRegions,[Volumealongprocessingchain2025] WHERE [PU]=[Production unit] \
UNION SELECT CoalType2,MiningMethod,PU,'other','t30',Region,[Washing yield of other washed products  (%)] FROM CoalRegions,[Volumealongprocessingchain2030] WHERE [PU]=[Production unit] \
UNION SELECT CoalType2,MiningMethod,PU,'other','t35',Region,[Washing yield of other washed products  (%)] FROM CoalRegions,[Volumealongprocessingchain2035] WHERE [PU]=[Production unit]
p1=COprodyield

Q2 =  SELECT CoalType2,MiningMethod,PU,'t11',Region,[2011] FROM CoalRegions,[RawcoalvolumesbyPU] WHERE [PU]=ProductionUnit \
UNION SELECT CoalType2,MiningMethod,PU,'t12',Region,[2012] FROM CoalRegions,[RawcoalvolumesbyPU] WHERE [PU]=ProductionUnit \
UNION SELECT CoalType2,MiningMethod,PU,'t13',Region,[2013] FROM CoalRegions,[RawcoalvolumesbyPU] WHERE [PU]=ProductionUnit \
UNION SELECT CoalType2,MiningMethod,PU,'t14',Region,[2014] FROM CoalRegions,[RawcoalvolumesbyPU] WHERE [PU]=ProductionUnit \
UNION SELECT CoalType2,MiningMethod,PU,'t15',Region,[2015] FROM CoalRegions,[RawcoalvolumesbyPU] WHERE [PU]=ProductionUnit \
UNION SELECT CoalType2,MiningMethod,PU,'t16',Region,[2016] FROM CoalRegions,[RawcoalvolumesbyPU] WHERE [PU]=ProductionUnit \
UNION SELECT CoalType2,MiningMethod,PU,'t17',Region,[2017] FROM CoalRegions,[RawcoalvolumesbyPU] WHERE [PU]=ProductionUnit \
UNION SELECT CoalType2,MiningMethod,PU,'t18',Region,[2018] FROM CoalRegions,[RawcoalvolumesbyPU] WHERE [PU]=ProductionUnit \
UNION SELECT CoalType2,MiningMethod,PU,'t19',Region,[2019] FROM CoalRegions,[RawcoalvolumesbyPU] WHERE [PU]=ProductionUnit \
UNION SELECT CoalType2,MiningMethod,PU,'t20',Region,[2020] FROM CoalRegions,[RawcoalvolumesbyPU] WHERE [PU]=ProductionUnit \
UNION SELECT CoalType2,MiningMethod,PU,'t21',Region,[2021] FROM CoalRegions,[RawcoalvolumesbyPU] WHERE [PU]=ProductionUnit \
UNION SELECT CoalType2,MiningMethod,PU,'t22',Region,[2022] FROM CoalRegions,[RawcoalvolumesbyPU] WHERE [PU]=ProductionUnit \
UNION SELECT CoalType2,MiningMethod,PU,'t23',Region,[2023] FROM CoalRegions,[RawcoalvolumesbyPU] WHERE [PU]=ProductionUnit \
UNION SELECT CoalType2,MiningMethod,PU,'t24',Region,[2024] FROM CoalRegions,[RawcoalvolumesbyPU] WHERE [PU]=ProductionUnit \
UNION SELECT CoalType2,MiningMethod,PU,'t25',Region,[2025] FROM CoalRegions,[RawcoalvolumesbyPU] WHERE [PU]=ProductionUnit \
UNION SELECT CoalType2,MiningMethod,PU,'t26',Region,[2026] FROM CoalRegions,[RawcoalvolumesbyPU] WHERE [PU]=ProductionUnit \
UNION SELECT CoalType2,MiningMethod,PU,'t27',Region,[2027] FROM CoalRegions,[RawcoalvolumesbyPU] WHERE [PU]=ProductionUnit \
UNION SELECT CoalType2,MiningMethod,PU,'t28',Region,[2028] FROM CoalRegions,[RawcoalvolumesbyPU] WHERE [PU]=ProductionUnit \
UNION SELECT CoalType2,MiningMethod,PU,'t29',Region,[2029] FROM CoalRegions,[RawcoalvolumesbyPU] WHERE [PU]=ProductionUnit \
UNION SELECT CoalType2,MiningMethod,PU,'t30',Region,[2030] FROM CoalRegions,[RawcoalvolumesbyPU] WHERE [PU]=ProductionUnit \
UNION SELECT CoalType2,MiningMethod,PU,'t31',Region,[2031] FROM CoalRegions,[RawcoalvolumesbyPU] WHERE [PU]=ProductionUnit \
UNION SELECT CoalType2,MiningMethod,PU,'t32',Region,[2032] FROM CoalRegions,[RawcoalvolumesbyPU] WHERE [PU]=ProductionUnit \
UNION SELECT CoalType2,MiningMethod,PU,'t33',Region,[2033] FROM CoalRegions,[RawcoalvolumesbyPU] WHERE [PU]=ProductionUnit \
UNION SELECT CoalType2,MiningMethod,PU,'t34',Region,[2034] FROM CoalRegions,[RawcoalvolumesbyPU] WHERE [PU]=ProductionUnit \
UNION SELECT CoalType2,MiningMethod,PU,'t35',Region,[2035] FROM CoalRegions,[RawcoalvolumesbyPU] WHERE [PU]=ProductionUnit
p2=COprodIHS


Q3 =  SELECT CoalType2,MiningMethod,PU,'raw','t11',Region,[Average CV of raw coal (kcal/kg, NAR)] FROM CoalRegions,[Volumealongprocessingchain2011] WHERE [PU]=[Production unit] \
UNION SELECT CoalType2,MiningMethod,PU,'washed','t11',Region,[Average CV of washed coal (kcal/kg, NAR)] FROM CoalRegions,[Volumealongprocessingchain2011] WHERE [PU]=[Production unit] \
UNION SELECT CoalType2,MiningMethod,PU,'other','t11',Region,[Average CV of other washed products (kcal/kg, NAR)] FROM CoalRegions,[Volumealongprocessingchain2011] WHERE [PU]=[Production unit] \
UNION SELECT CoalType2,MiningMethod,PU,'raw','t15',Region,[Average CV of raw coal (kcal/kg, NAR)] FROM CoalRegions,[Volumealongprocessingchain2015] WHERE [PU]=[Production unit] \
UNION SELECT CoalType2,MiningMethod,PU,'washed','t15',Region,[Average CV of washed coal (kcal/kg, NAR)] FROM CoalRegions,[Volumealongprocessingchain2015] WHERE [PU]=[Production unit] \
UNION SELECT CoalType2,MiningMethod,PU,'other','t15',Region,[Average CV of other washed products (kcal/kg, NAR)] FROM CoalRegions,[Volumealongprocessingchain2015] WHERE [PU]=[Production unit] \
UNION SELECT CoalType2,MiningMethod,PU,'raw','t20',Region,[Average CV of raw coal (kcal/kg, NAR)] FROM CoalRegions,[Volumealongprocessingchain2020] WHERE [PU]=[Production unit] \
UNION SELECT CoalType2,MiningMethod,PU,'washed','t20',Region,[Average CV of washed coal (kcal/kg, NAR)] FROM CoalRegions,[Volumealongprocessingchain2020] WHERE [PU]=[Production unit] \
UNION SELECT CoalType2,MiningMethod,PU,'other','t20',Region,[Average CV of other washed products (kcal/kg, NAR)] FROM CoalRegions,[Volumealongprocessingchain2020] WHERE [PU]=[Production unit] \
UNION SELECT CoalType2,MiningMethod,PU,'raw','t25',Region,[Average CV of raw coal (kcal/kg, NAR)] FROM CoalRegions,[Volumealongprocessingchain2025] WHERE [PU]=[Production unit] \
UNION SELECT CoalType2,MiningMethod,PU,'washed','t25',Region,[Average CV of washed coal (kcal/kg, NAR)] FROM CoalRegions,[Volumealongprocessingchain2025] WHERE [PU]=[Production unit] \
UNION SELECT CoalType2,MiningMethod,PU,'other','t25',Region,[Average CV of other washed products (kcal/kg, NAR)] FROM CoalRegions,[Volumealongprocessingchain2025] WHERE [PU]=[Production unit] \
UNION SELECT CoalType2,MiningMethod,PU,'raw','t30',Region,[Average CV of raw coal (kcal/kg, NAR)] FROM CoalRegions,[Volumealongprocessingchain2030] WHERE [PU]=[Production unit] \
UNION SELECT CoalType2,MiningMethod,PU,'washed','t30',Region,[Average CV of washed coal (kcal/kg, NAR)] FROM CoalRegions,[Volumealongprocessingchain2030] WHERE [PU]=[Production unit] \
UNION SELECT CoalType2,MiningMethod,PU,'other','t30',Region,[Average CV of other washed products (kcal/kg, NAR)] FROM CoalRegions,[Volumealongprocessingchain2030] WHERE [PU]=[Production unit] \
UNION SELECT CoalType2,MiningMethod,PU,'raw','t35',Region,[Average CV of raw coal (kcal/kg, NAR)] FROM CoalRegions,[Volumealongprocessingchain2035] WHERE [PU]=[Production unit] \
UNION SELECT CoalType2,MiningMethod,PU,'washed','t35',Region,[Average CV of washed coal (kcal/kg, NAR)] FROM CoalRegions,[Volumealongprocessingchain2035] WHERE [PU]=[Production unit] \
UNION SELECT CoalType2,MiningMethod,PU,'other','t35',Region,[Average CV of other washed products (kcal/kg, NAR)] FROM CoalRegions,[Volumealongprocessingchain2035] WHERE [PU]=[Production unit]
p3=coalcv

Q4 =  SELECT CoalType2,MiningMethod,PU,'raw','t11',Region,[Minegate cost (RMB/t)] FROM CoalRegions,[Nationalraw&washedcoalcosts2011] WHERE [PU]=[Production unit] AND [Coal type]='Raw coal products' \
UNION SELECT CoalType2,MiningMethod,PU,'washed','t11',Region,[Minegate cost (RMB/t)] FROM CoalRegions,[Nationalraw&washedcoalcosts2011] WHERE [PU]=[Production unit] AND [Coal type]='Washed coal products' \
UNION SELECT CoalType2,MiningMethod,PU,'raw','t15',Region,[Minegate cost (RMB/t)] FROM CoalRegions,[Nationalraw&washedcoalcosts2015] WHERE [PU]=[Production unit] AND [Coal type]='Raw coal products' \
UNION SELECT CoalType2,MiningMethod,PU,'washed','t15',Region,[Minegate cost (RMB/t)] FROM CoalRegions,[Nationalraw&washedcoalcosts2015] WHERE [PU]=[Production unit] AND [Coal type]='Washed coal products' \
UNION SELECT CoalType2,MiningMethod,PU,'raw','t20',Region,[Minegate cost (RMB/t)] FROM CoalRegions,[Nationalraw&washedcoalcosts2020] WHERE [PU]=[Production unit] AND [Coal type]='Raw coal products' \
UNION SELECT CoalType2,MiningMethod,PU,'washed','t20',Region,[Minegate cost (RMB/t)] FROM CoalRegions,[Nationalraw&washedcoalcosts2020] WHERE [PU]=[Production unit] AND [Coal type]='Washed coal products' \
UNION SELECT CoalType2,MiningMethod,PU,'raw','t25',Region,[Minegate cost (RMB/t)] FROM CoalRegions,[Nationalraw&washedcoalcosts2025] WHERE [PU]=[Production unit] AND [Coal type]='Raw coal products' \
UNION SELECT CoalType2,MiningMethod,PU,'washed','t25',Region,[Minegate cost (RMB/t)] FROM CoalRegions,[Nationalraw&washedcoalcosts2025] WHERE [PU]=[Production unit] AND [Coal type]='Washed coal products' \
UNION SELECT CoalType2,MiningMethod,PU,'raw','t30',Region,[Minegate cost (RMB/t)] FROM CoalRegions,[Nationalraw&washedcoalcosts2030] WHERE [PU]=[Production unit] AND [Coal type]='Raw coal products' \
UNION SELECT CoalType2,MiningMethod,PU,'washed','t30',Region,[Minegate cost (RMB/t)] FROM CoalRegions,[Nationalraw&washedcoalcosts2030] WHERE [PU]=[Production unit] AND [Coal type]='Washed coal products' \
UNION SELECT CoalType2,MiningMethod,PU,'raw','t35',Region,[Minegate cost (RMB/t)] FROM CoalRegions,[Nationalraw&washedcoalcosts2035] WHERE [PU]=[Production unit] AND [Coal type]='Raw coal products' \
UNION SELECT CoalType2,MiningMethod,PU,'washed','t35',Region,[Minegate cost (RMB/t)] FROM CoalRegions,[Nationalraw&washedcoalcosts2035] WHERE [PU]=[Production unit] AND [Coal type]='Washed coal products'
p4=COomcst


Q5 =  SELECT CoalType2,MiningMethod,PU,'t11',Region,[Washing ratio (%)] FROM CoalRegions,[Volumealongprocessingchain2011] WHERE [PU]=[Production unit] \
UNION SELECT CoalType2,MiningMethod,PU,'t15',Region,[Washing ratio (%)] FROM CoalRegions,[Volumealongprocessingchain2015] WHERE [PU]=[Production unit] \
UNION SELECT CoalType2,MiningMethod,PU,'t20',Region,[Washing ratio (%)] FROM CoalRegions,[Volumealongprocessingchain2020] WHERE [PU]=[Production unit] \
UNION SELECT CoalType2,MiningMethod,PU,'t25',Region,[Washing ratio (%)] FROM CoalRegions,[Volumealongprocessingchain2025] WHERE [PU]=[Production unit] \
UNION SELECT CoalType2,MiningMethod,PU,'t30',Region,[Washing ratio (%)] FROM CoalRegions,[Volumealongprocessingchain2030] WHERE [PU]=[Production unit] \
UNION SELECT CoalType2,MiningMethod,PU,'t35',Region,[Washing ratio (%)] FROM CoalRegions,[Volumealongprocessingchain2035] WHERE [PU]=[Production unit]
p5=COwashratio



Q6=SELECT 'ExtLow','t11',Region,ExtLow FROM CBRsulfur \
UNION SELECT 'Low','t11',Region,Low FROM CBRsulfur \
UNION SELECT 'Med','t11',Region,Med FROM CBRsulfur \
UNION SELECT 'High','t11',Region,High FROM CBRsulfur
p6=COsulfur

Q9 = SELECT coal_type,year,'IMOT',tonnes FROM coal_imports \
UNION SELECT coal_type,year,'IMOT',tonnes FROM coal_imports \
UNION SELECT coal_type,year,'IMOT',tonnes FROM coal_imports
p9 = COfimpmax

Q10 = SELECT 'coal',[t],'IMOT','South',COintlprice FROM period,[Coal_dem_EIA] WHERE year=[yr]
P10 = coalintlpriceEIA

Q11 = SELECT 'coal',[t],'IMOT','South',coalintlcv FROM period,[Coal_dem_EIA] WHERE year=[yr]
P11 = coalintlcvEIA

Q12=SELECT 'coal',[t],steam FROM period,[COAL_dem_EIA] WHERE year=[yr] \
UNION SELECT 'met',[t],met FROM period,[COAL_dem_EIA] WHERE year=[yr]
P12 = COconsumpEIA


Q13=SELECT [t],WCD_QUADS FROM period,[COAL_dem_EIA] WHERE year=[yr]
P13 = WCD_Quads

Q14=  SELECT 'Production','t12',[rdem],Production FROM [Coal_stats_2012],nodes WHERE [Prov]=Province \
UNION SELECT 'Other','t12',[rdem],Other FROM [Coal_stats_2012],nodes WHERE [Prov]=Province \
UNION SELECT 'Metallurgical','t12',[rdem],Metallurgical FROM [Coal_stats_2012],nodes WHERE [Prov]=Province \
UNION SELECT 'Power','t12',[rdem],Power FROM [Coal_stats_2012],nodes WHERE [Prov]=Province
P14=COstatistics


$offecho

$call =mdb2gms @cmd.txt

$ontext
UNION SELECT 'coal','LowMed','open','ss1','t11',CBR,LowMed FROM CBRsulfur \
UNION SELECT 'coal','MedHigh','open','ss1','t11',CBR,MedHigh FROM CBRsulfur \

Q5=SELECT CoalType2,MiningMethod,PU,Region,Expansion FROM CoalRegions
p5=COexpansion


Q7=SELECT coal_type,time,Source,[port_N],north_port FROM [coal_import_price],nodes \
UNION SELECT coal_type,time,Source,[port_E],east_port FROM [coal_import_price],nodes \
UNION SELECT coal_type,time,Source,[port_S],south_port FROM [coal_import_price],nodes
P7 = coalintlprice

Q8=SELECT coal_type,time,Source,[port_N],CV_north FROM coal_import_price,[nodes] \
UNION SELECT coal_type,time,Source,[port_E],CV_east FROM coal_import_price,[nodes] \
UNION SELECT coal_type,time,Source,[port_S],CV_south FROM coal_import_price,[nodes]
P8 = coalintlcv

$offtext
