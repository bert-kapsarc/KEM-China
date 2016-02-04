$onecho > cmd.txt
I=db\coal_tables.accdb
X=db\setsandparameters.gdx

Q1=select Region,GB,province,City,NodeType from nodes
s1=nodes

Q2=select Region from Regions
s2=rco

Q3=select Region,GB from nodes
s3=regions

Q4=select GB from nodes
s4=GB

Q5=select province from nodes
s5=province

Q6=select Region,Region_dem from Regions
s6=rco_dem

Q7=select port_sea from Regions
s7=rport_sea

Q8=select port_river from Regions
s8=rport_riv

Q9=select port from Regions
s9=rport

Q11=select Demand from Regions
s11=r

Q12=select PU from coalsup
s12=ss

Q13=select Region from Regions  \
UNION select GB from nodes
s13=Rall

Q16=SELECT City from nodes
s16=city

Q17=SELECT NodeType from nodes
s17=node_type


Q24=SELECT GB, Latitude FROM nodes
p24=latitude

Q25=SELECT GB, Longitude FROM nodes
p25=longitude

$offecho

*execute "mdb2gms @cmd.txt"

$call =mdb2gms @cmd.txt

$ontext
Q2=select Field from model_setup
s2=model_values
Q3=select Field,Value from model_setup
p3=model_setup


Q10=select rdem from nodes
s10=r


Q13=select port_N from nodes
s13=rport_sea_N

Q14=select port_E from nodes
s14=rport_sea_E

Q15=select port_S from nodes
s15=rport_sea_S


Q18=SELECT CBR FROM nodes WHERE RegionSulf=1
s18=rco_N

Q19=SELECT CBR FROM nodes WHERE RegionSulf=2
s19=rco_NE

Q20=SELECT CBR FROM nodes WHERE RegionSulf=3
s20=rco_E

Q21=SELECT CBR FROM nodes WHERE RegionSulf=4
s21=rco_SC

Q22=SELECT CBR FROM nodes WHERE RegionSulf=5
s22=rco_SW

Q23=SELECT CBR FROM nodes WHERE RegionSulf=6
s23=rco_NW


$offtext
