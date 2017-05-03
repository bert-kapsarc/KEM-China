$onecho > cmd.txt
I=db\SetsParameters.accdb
X=db\financial.gdx

Q1=SELECT [KEM Abbreviation],[Discount Rate] From [Sectors]
P1=discount_rate

$offecho

$call =mdb2gms @cmd.txt