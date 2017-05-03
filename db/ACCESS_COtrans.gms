$onecho > cmd.txt
I=db\coal_tables.accdb
X=db\coaltrans.gdx
Q1=SELECT 'rail',r,rr,[distance (km)] From [Coal Rail Network] \
UNION SELECT 'rail',rr,r,[distance (km)] From [Coal Rail Network] \
UNION SELECT 'port',r,rr,[distance (km)] From [Port Network Distances] \
UNION SELECT 'port',rr,r,[distance (km)] From [Port Network Distances]
p1=COtransD

Q3=SELECT 'rail',r,rr,[capacity (mt/year)] FROM [Coal Rail Network] \
UNION SELECT 'rail',rr,r,[capacity (mt/year)] FROM [Coal Rail Network] \
UNION SELECT 'port',port,port,[Capacity Port (mt/year)] FROM Regions
p3=COtransexist

Q9=SELECT 'rail',r,rr,[Capital Cost (RMB/ton-km)] FROM [Coal Rail Network] \
UNION SELECT 'rail',rr,r,[Capital Cost (RMB/ton-km)] FROM [Coal Rail Network]
p9=COtranscapex

Q10=SELECT Sector,COf,r,[Coal (mt SCE)] FROM [Coal Consumption]
P10=OTHERCOconsump

Q11=SELECT time,r,exports FROM [Coal Exports]
p11=COfexpmax

Q12=SELECT COf,tr,[Fixed Cost (RMB/ton)] FROM [Coal Transport Fixed Cost]
p12=COtransomcst_fixed

Q13=SELECT COf,tr,[Variable Cost (RMB/ton-km)] FROM [Coal Transport Variable Cost]
p13=COtransomcst_var

Q14 SELECT time,[Surcharge (RMB/ton-km)] FROM [Rail Surcharge]
P14=RailSurcharge


$offecho

$call =mdb2gms @cmd.txt

