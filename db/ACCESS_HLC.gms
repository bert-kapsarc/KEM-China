$onecho > cmd.txt
I=db\ChinaPower.accdb
X=db\load.gdx

Q1=SELECT 'Shandong',Hour,Month,Shandong FROM RegionalLoadCurves \
UNION SELECT 'South',Hour,Month,South FROM RegionalLoadCurves \
UNION SELECT 'Southwest',Hour,Month,Southwest FROM RegionalLoadCurves \
UNION SELECT 'East',Hour,Month,East FROM RegionalLoadCurves \
UNION SELECT 'CoalC',Hour,Month,CoalC FROM RegionalLoadCurves \
UNION SELECT 'North',Hour,Month,North FROM RegionalLoadCurves \
UNION SELECT 'Northeast',Hour,Month,Northeast FROM RegionalLoadCurves \
UNION SELECT 'Xinjiang',Hour,Month,Xinjiang FROM RegionalLoadCurves \
UNION SELECT 'West',Hour,Month,West FROM RegionalLoadCurves \
UNION SELECT 'Henan',Hour,Month,Henan FROM RegionalLoadCurves \
UNION SELECT 'Central',Hour,Month,Central FROM RegionalLoadCurves \
UNION SELECT 'Sichuan',Hour,Month,Sichuan FROM RegionalLoadCurves
P1=HLCmonths


Q2=   SELECT Province, Hour, '1', Jan FROM DailyWindCF \
UNION SELECT Province, Hour, '2', Feb FROM DailyWindCF \
UNION SELECT Province, Hour, '3', Mar FROM DailyWindCF \
UNION SELECT Province, Hour, '4', Apr FROM DailyWindCF \
UNION SELECT Province, Hour, '5', May FROM DailyWindCF \
UNION SELECT Province, Hour, '6', Jun FROM DailyWindCF \
UNION SELECT Province, Hour, '7', Jul FROM DailyWindCF \
UNION SELECT Province, Hour, '8', Aug FROM DailyWindCF \
UNION SELECT Province, Hour, '9', Sep FROM DailyWindCF \
UNION SELECT Province, Hour, '10', Oct FROM DailyWindCF \
UNION SELECT Province, Hour, '11', Nov FROM DailyWindCF \
UNION SELECT Province, Hour, '12', Dec FROM DailyWindCF
P2=WRCFmonths


Q3=   SELECT 'FJ', Month, Fujian FROM [Provincial Monthly Wind CF Offshore] \
UNION SELECT 'GD', Month, Guangdong FROM [Provincial Monthly Wind CF Offshore] \
UNION SELECT 'GX', Month, Guangxi FROM [Provincial Monthly Wind CF Offshore] \
UNION SELECT 'HI', Month, Hainan FROM [Provincial Monthly Wind CF Offshore] \
UNION SELECT 'HE', Month, Hebei FROM [Provincial Monthly Wind CF Offshore] \
UNION SELECT 'JS', Month, Jiangsu FROM [Provincial Monthly Wind CF Offshore] \
UNION SELECT 'LN', Month, Liaoning FROM [Provincial Monthly Wind CF Offshore] \
UNION SELECT 'SD', Month, Shandong FROM [Provincial Monthly Wind CF Offshore] \
UNION SELECT 'SH', Month, Shanghai FROM [Provincial Monthly Wind CF Offshore] \
UNION SELECT 'TJ', Month, Tianjin FROM [Provincial Monthly Wind CF Offshore] \
UNION SELECT 'ZJ', Month, Zhejiang FROM [Provincial Monthly Wind CF Offshore]
P3=WRCFmonthavgoff

Q4=   SELECT 'AH', Month, Anhui FROM [Provincial Monthly Wind CF Onshore] \
UNION SELECT 'CQ', Month, Chongqing FROM [Provincial Monthly Wind CF Onshore] \
UNION SELECT 'NME', Month, East_Inner_Mongolia FROM [Provincial Monthly Wind CF Onshore] \
UNION SELECT 'FJ', Month, Fujian FROM [Provincial Monthly Wind CF Onshore] \
UNION SELECT 'GS', Month, Gansu FROM [Provincial Monthly Wind CF Onshore] \
UNION SELECT 'GD', Month, Guangdong FROM [Provincial Monthly Wind CF Onshore] \
UNION SELECT 'GX', Month, Guangxi FROM [Provincial Monthly Wind CF Onshore] \
UNION SELECT 'GZ', Month, Guizhou FROM [Provincial Monthly Wind CF Onshore] \
UNION SELECT 'HI', Month, Hainan FROM [Provincial Monthly Wind CF Onshore] \
UNION SELECT 'HE', Month, Hebei FROM [Provincial Monthly Wind CF Onshore] \
UNION SELECT 'HL', Month, Heilongjiang FROM [Provincial Monthly Wind CF Onshore] \
UNION SELECT 'HA', Month, Henan FROM [Provincial Monthly Wind CF Onshore] \
UNION SELECT 'HB', Month, Hubei FROM [Provincial Monthly Wind CF Onshore] \
UNION SELECT 'HN', Month, Hunan FROM [Provincial Monthly Wind CF Onshore] \
UNION SELECT 'JS', Month, Jiangsu FROM [Provincial Monthly Wind CF Onshore] \
UNION SELECT 'JX', Month, Jiangxi FROM [Provincial Monthly Wind CF Onshore] \
UNION SELECT 'JN', Month, Jilin FROM [Provincial Monthly Wind CF Onshore] \
UNION SELECT 'LN', Month, Liaoning FROM [Provincial Monthly Wind CF Onshore] \
UNION SELECT 'NX', Month, Ningxia FROM [Provincial Monthly Wind CF Onshore] \
UNION SELECT 'QH', Month, Qinghai FROM [Provincial Monthly Wind CF Onshore] \
UNION SELECT 'SN', Month, Shaanxi FROM [Provincial Monthly Wind CF Onshore] \
UNION SELECT 'SD', Month, Shandong FROM [Provincial Monthly Wind CF Onshore] \
UNION SELECT 'SH', Month, Shanghai FROM [Provincial Monthly Wind CF Onshore] \
UNION SELECT 'SX', Month, Shanxi FROM [Provincial Monthly Wind CF Onshore] \
UNION SELECT 'SC', Month, Sichuan FROM [Provincial Monthly Wind CF Onshore] \
UNION SELECT 'TJ', Month, Tianjin FROM [Provincial Monthly Wind CF Onshore] \
UNION SELECT 'XZ', Month, Tibet FROM [Provincial Monthly Wind CF Onshore] \
UNION SELECT 'NM', Month, West_Inner_Mongolia FROM [Provincial Monthly Wind CF Onshore] \
UNION SELECT 'YN', Month, Yunnan FROM [Provincial Monthly Wind CF Onshore] \
UNION SELECT 'ZH', Month, Zhejiang FROM [Provincial Monthly Wind CF Onshore] \
UNION SELECT 'XJ', Month, Xinjiang FROM [Provincial Monthly Wind CF Onshore]
P4=WRCFmonthavgon

$offecho

$call =mdb2gms @cmd.txt
