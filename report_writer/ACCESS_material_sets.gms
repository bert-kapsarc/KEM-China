$onecho > cmd.txt
I=db\sets.accdb
X=db\material_sets.gdx

Q1=select [KEM Abbreviation] from [All Materials]
s1=allmaterials

Q2=select [KEM Abbreviation] from [All Materials] WHERE [Fuels Y/N]
s2=f

Q3=select [KEM Abbreviation] from [All Materials] WHERE [Upstream Fuels Y/N]
s3=fup

Q4=select [KEM Abbreviation] from [All Materials] WHERE [Coal Y/N]
s4=COf

$offecho

$call =mdb2gms @cmd.txt