$onecho > cmd.txt
I=db\coal_tables.accdb
X=db\coaltrans.gdx
Q1=SELECT 'rail',r,rr,distance From RegionConnect \
UNION SELECT 'rail',rr,r,distance From RegionConnect \
UNION SELECT 'port',Region,'East',East FROM PortConnect \
UNION SELECT 'port',Region,'North',North FROM PortConnect \
UNION SELECT 'port',Region,'Sichuan',Sichuan FROM PortConnect \
UNION SELECT 'port',Region,'Central',Central FROM PortConnect \
UNION SELECT 'port',Region,'South',South FROM PortConnect \
UNION SELECT 'port',Region,'EastCBR',EastCBR FROM PortConnect \
UNION SELECT 'port',Region,'NorthEast',NorthEast FROM PortConnect
p1=COtransD

Q3=SELECT 'rail',r,rr,capacity FROM RegionConnect \
UNION SELECT 'rail',rr,r,capacity FROM RegionConnect \
UNION SELECT 'port',port,port,cap_port_2011 FROM Regions
p3=COtransexist

Q6=   SELECT 'coal',Sector,'t11',[GB],[2011] FROM [IHSDemandSCE] \
UNION SELECT 'met','Metallurgical','t11',GB,[2011] FROM [MetCoalConsumption],nodes WHERE [Province]=r and [rdem] \
UNION SELECT 'coal',Sector,'t12',GB,[2012] FROM [IHSDemandSCE] \
UNION SELECT 'met','Metallurgical','t12',GB,[2012] FROM [MetCoalConsumption],nodes WHERE [Province]=r and [rdem] \
UNION SELECT 'coal',Sector,'t13',GB,[2013] FROM [IHSDemandSCE] \
UNION SELECT 'met','Metallurgical','t13',GB,[2013] FROM [MetCoalConsumption],nodes WHERE [Province]=r and [rdem] \
UNION SELECT 'coal',Sector,'t14',GB,[2014] FROM [IHSDemandSCE] \
UNION SELECT 'met','Metallurgical','t14',GB,[2014] FROM [MetCoalConsumption],nodes WHERE [Province]=r and [rdem] \
UNION SELECT 'coal',Sector,'t15',GB,[2015] FROM [IHSDemandSCE] \
UNION SELECT 'met','Metallurgical','t15',GB,[2015] FROM [MetCoalConsumption],nodes WHERE [Province]=r and [rdem] \
UNION SELECT 'coal',Sector,'t16',GB,[2016] FROM [IHSDemandSCE] \
UNION SELECT 'met','Metallurgical','t16',GB,[2016] FROM [MetCoalConsumption],nodes WHERE [Province]=r and [rdem] \
UNION SELECT 'coal',Sector,'t17',GB,[2017] FROM [IHSDemandSCE] \
UNION SELECT 'met','Metallurgical','t17',GB,[2017] FROM [MetCoalConsumption],nodes WHERE [Province]=r and [rdem] \
UNION SELECT 'coal',Sector,'t18',GB,[2018] FROM [IHSDemandSCE] \
UNION SELECT 'met','Metallurgical','t18',GB,[2018] FROM [MetCoalConsumption],nodes WHERE [Province]=r and [rdem] \
UNION SELECT 'coal',Sector,'t19',GB,[2019] FROM [IHSDemandSCE] \
UNION SELECT 'met','Metallurgical','t19',GB,[2019] FROM [MetCoalConsumption],nodes WHERE [Province]=r and [rdem] \
UNION SELECT 'coal',Sector,'t20',GB,[2020] FROM [IHSDemandSCE] \
UNION SELECT 'met','Metallurgical','t20',GB,[2020] FROM [MetCoalConsumption],nodes WHERE [Province]=r and [rdem] \
UNION SELECT 'coal',Sector,'t21',GB,[2021] FROM [IHSDemandSCE] \
UNION SELECT 'met','Metallurgical','t21',GB,[2021] FROM [MetCoalConsumption],nodes WHERE [Province]=r and [rdem] \
UNION SELECT 'coal',Sector,'t22',GB,[2022] FROM [IHSDemandSCE] \
UNION SELECT 'met','Metallurgical','t22',GB,[2022] FROM [MetCoalConsumption],nodes WHERE [Province]=r and [rdem] \
UNION SELECT 'coal',Sector,'t23',GB,[2023] FROM [IHSDemandSCE] \
UNION SELECT 'met','Metallurgical','t23',GB,[2023] FROM [MetCoalConsumption],nodes WHERE [Province]=r and [rdem] \
UNION SELECT 'coal',Sector,'t24',GB,[2024] FROM [IHSDemandSCE] \
UNION SELECT 'met','Metallurgical','t24',GB,[2024] FROM [MetCoalConsumption],nodes WHERE [Province]=r and [rdem] \
UNION SELECT 'coal',Sector,'t25',GB,[2025] FROM [IHSDemandSCE] \
UNION SELECT 'met','Metallurgical','t25',GB,[2025] FROM [MetCoalConsumption],nodes WHERE [Province]=r and [rdem] \
UNION SELECT 'coal',Sector,'t26',GB,[2026] FROM [IHSDemandSCE] \
UNION SELECT 'met','Metallurgical','t26',GB,[2026] FROM [MetCoalConsumption],nodes WHERE [Province]=r and [rdem] \
UNION SELECT 'coal',Sector,'t27',GB,[2027] FROM [IHSDemandSCE] \
UNION SELECT 'met','Metallurgical','t27',GB,[2027] FROM [MetCoalConsumption],nodes WHERE [Province]=r and [rdem] \
UNION SELECT 'coal',Sector,'t28',GB,[2028] FROM [IHSDemandSCE] \
UNION SELECT 'met','Metallurgical','t28',GB,[2028] FROM [MetCoalConsumption],nodes WHERE [Province]=r and [rdem] \
UNION SELECT 'coal',Sector,'t29',GB,[2029] FROM [IHSDemandSCE] \
UNION SELECT 'met','Metallurgical','t29',GB,[2029] FROM [MetCoalConsumption],nodes WHERE [Province]=r and [rdem] \
UNION SELECT 'coal',Sector,'t30',GB,[2030] FROM [IHSDemandSCE] \
UNION SELECT 'met','Metallurgical','t30',GB,[2030] FROM [MetCoalConsumption],nodes WHERE [Province]=r and [rdem] \
UNION SELECT 'coal',Sector,'t31',GB,[2031] FROM [IHSDemandSCE] \
UNION SELECT 'met','Metallurgical','t31',GB,[2031] FROM [MetCoalConsumption],nodes WHERE [Province]=r and [rdem] \
UNION SELECT 'coal',Sector,'t32',GB,[2032] FROM [IHSDemandSCE] \
UNION SELECT 'met','Metallurgical','t32',GB,[2032] FROM [MetCoalConsumption],nodes WHERE [Province]=r and [rdem] \
UNION SELECT 'coal',Sector,'t33',GB,[2033] FROM [IHSDemandSCE] \
UNION SELECT 'met','Metallurgical','t33',GB,[2033] FROM [MetCoalConsumption],nodes WHERE [Province]=r and [rdem] \
UNION SELECT 'coal',Sector,'t34',GB,[2034] FROM [IHSDemandSCE] \
UNION SELECT 'met','Metallurgical','t34',GB,[2034] FROM [MetCoalConsumption],nodes WHERE [Province]=r and [rdem] \
UNION SELECT 'coal',Sector,'t35',GB,[2035] FROM [IHSDemandSCE] \
UNION SELECT 'met','Metallurgical','t35',GB,[2035] FROM [MetCoalConsumption],nodes WHERE [Province]=r and [rdem]
p6=OTHERCOconsumpProv

Q7=SELECT TariffCode,'rate1',Rate1 FROM Railrates \
UNION SELECT TariffCode,'rate2',Rate2 FROM Railrates
p7=Railrates

Q8= SELECT 'port',r,rr,ship_rate FROM ship_rates \
UNION SELECT 'port',rr,r,ship_rate FROM ship_rates
p8=COtransomcst

Q9=SELECT 'rail',r,rr,capex FROM RegionConnect \
UNION SELECT 'rail',rr,r,capex FROM RegionConnect
p9=COtranscapex

Q10= SELECT 'coal','t11',GB,[2011] FROM [SteamCoalConsumption],nodes WHERE [Province]=r AND [rdem] \
UNION SELECT 'coal','t12',GB,[2012] FROM [SteamCoalConsumption],nodes WHERE [Province]=r AND [rdem] \
UNION SELECT 'coal','t13',GB,[2013] FROM [SteamCoalConsumption],nodes WHERE [Province]=r \
UNION SELECT 'coal','t14',GB,[2014] FROM [SteamCoalConsumption],nodes WHERE [Province]=r AND [rdem] \
UNION SELECT 'coal','t15',GB,[2015] FROM [SteamCoalConsumption],nodes WHERE [Province]=r AND [rdem] \
UNION SELECT 'coal','t16',GB,[2016] FROM [SteamCoalConsumption],nodes WHERE [Province]=r AND [rdem] \
UNION SELECT 'met','t11',GB,[2011] FROM [MetCoalConsumption],nodes WHERE [Province]=r AND [rdem] \
UNION SELECT 'met','t12',GB,[2012] FROM [MetCoalConsumption],nodes WHERE [Province]=r AND [rdem] \
UNION SELECT 'met','t13',GB,[2013] FROM [MetCoalConsumption],nodes WHERE [Province]=r AND [rdem] \
UNION SELECT 'met','t14',GB,[2014] FROM [MetCoalConsumption],nodes WHERE [Province]=r AND [rdem] \
UNION SELECT 'met','t15',GB,[2015] FROM [MetCoalConsumption],nodes WHERE [Province]=r AND [rdem]
p10=OTHERCOconsumpProv_weight



Q11=SELECT time,r,rimp,exports FROM coal_exports
p11=COfexpmax

$offecho

$call =mdb2gms @cmd.txt

