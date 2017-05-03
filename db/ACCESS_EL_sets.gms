$onecho > cmd.txt
I=db\SetsParameters.accdb
X=db\electricity_sets.gdx

Q1=select ELl from [Load Segments]
s1=Ell

Q2=select ELp from [Power Plant Types]
s2=ELp

Q3=select ELp from [Power Plant Types]
s3=ELpon

Q4=select ELl,Hours from [Load Segments]
P4=ELlchours

Q5=select ELt from [Transmission Technologies]
s5=ELt

Q6=select grid from Regions
s6=grid

Q7=select [Primary Demand Region],grid from Regions
s7=rgrid

$offecho

$call =mdb2gms @cmd.txt