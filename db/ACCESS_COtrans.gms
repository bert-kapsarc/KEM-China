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

Q3=SELECT 'rail',r,rr,[capacity (mt/year)] FROM RegionConnect \
UNION SELECT 'rail',rr,r,[capacity (mt/year)] FROM RegionConnect \
UNION SELECT 'port',port,port,[Capacity Port (mt/year)] FROM Regions
p3=COtransexist

Q9=SELECT 'rail',r,rr,capex FROM RegionConnect \
UNION SELECT 'rail',rr,r,capex FROM RegionConnect
p9=COtranscapex

Q10=SELECT Sector,COf,r,[Coal (mt SCE)] FROM OTHERCOconsump
P10=OTHERCOconsump

Q11=SELECT time,r,rimp,exports FROM coal_exports
p11=COfexpmax

Q12=SELECT COf,tr,[Fixed Cost (RMB/ton)] FROM COtransomcst_fixed
p12=COtransomcst_fixed

Q13=SELECT COf,tr,[Variable Cost (RMB/ton-km)] FROM COtransomcst_var
p13=COtransomcst_var

Q14 SELECT time,[Surcharge (RMB/ton-km)] FROM [RailSurcharge]
P14=RailSurcharge


$offecho

$call =mdb2gms @cmd.txt

