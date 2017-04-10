$onecho > cmd.txt
I=db\coal_tables.accdb
X=db\setsandparameters.gdx


Q2=select Region from Regions
s2=rco

Q3=select Region,GB from nodes
s3=regions

Q4=select GB from nodes
s4=GB

Q5=select province from nodes
s5=province

Q6=select Region,Region_dem from Regions
s6=rco_r_dem

Q7=select port_sea from Regions
s7=rport_sea

Q8=select port_river from Regions
s8=rport_riv

Q9=select port from Regions
s9=rport

Q10=select import from Regions
s10=rimp

Q11=select Demand from Regions
s11=r

Q12=select PU from CoalRegions
s12=ss

Q13=select Region from Regions  \
UNION select GB from nodes
s13=Rall

Q14=select TVE from CoalRegions
s14=TVE

Q15=select Local from CoalRegions
s15=Local

Q16=select SOE from CoalRegions
s16=SOE

Q17=select Allss from CoalRegions
s17=Allss

Q18=select Importer from Regions
s18=rco_importer

Q19=select Exporter from Regions
s19=rco_exporter


Q20=select Industrial from Regions
s20=r_industry

Q24=SELECT Region, Latitude FROM Regions
p24=latitude

Q25=SELECT Region, Longitude FROM Regions
p25=longitude

$offecho

*execute "mdb2gms @cmd.txt"

$call =mdb2gms @cmd.txt

