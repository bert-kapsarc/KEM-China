$onecho > cmd.txt
I=db\SetsParameters.accdb
X=db\setsandparameters.gdx

Q2=select Region from Regions
s2=rco

Q3=select Region,GB from nodes
s3=regions

Q4=select GB from nodes
s4=GB

Q5=select province from nodes
s5=province

Q6=select Region,[Demand Zone] from Regions
s6=rco_r_dem

Q7=select port_sea from Regions
s7=rport_sea

Q8=select port_river from Regions
s8=rport_riv

Q9=select port from Regions
s9=rport

Q10=select import from Regions
s10=rimp

Q11=select [Primary Demand Region] from Regions
s11=r


Q13=select Region from Regions  \
UNION select GB from nodes
s13=Rall

Q18=select Importer from Regions
s18=rco_importer

Q19=select Exporter from Regions
s19=rco_exporter

Q20=select Industrial from Regions
s20=r_industry

Q21=select time from [Time Periods]
s21=time

Q22=select [KEM Abbreviation] from Sectors
s22=sectors


Q25=SELECT Region, Latitude FROM Regions
p25=latitude

Q26=SELECT Region, Longitude FROM Regions
p26=longitude

$offecho

*execute "mdb2gms @cmd.txt"

$call =mdb2gms @cmd.txt

