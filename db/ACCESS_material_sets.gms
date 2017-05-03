$onecho > cmd.txt
I=db\SetsParameters.accdb
X=db\material_sets.gdx

Q1=select [KEM Abbreviation] from [All Materials]
s1=allmaterials

Q2=select [KEM Abbreviation] from [All Materials] WHERE [Fuel Y/N]
s2=f

Q3=select [KEM Abbreviation] from [All Materials] WHERE [Upstream Fuel Y/N]
s3=fup

Q4=select [KEM Abbreviation] from [All Materials] WHERE [Coal Y/N]
s4=COf

Q5=select [KEM Abbreviation] from [All Materials] WHERE [Electricity Y/N]
s5=ELf

Q6=select rw FROM [COal Processing]
S6=rw

Q7=select mm FROM [COal Mining Method]
S7=mm

Q8=select [Sulfur Content] from Sulfur
s8=sulf

Q9=select cv from [Coal Calorific Value]
s9=cv

Q10=select cv from [Coal Calorific Value] where [Met Coal T/F]
s10=cv_met

Q11=select PU from [Coal Producers]
s11=ss

Q12=select TVE from [Coal Producers]
s12=TVE

Q13=select Local from [Coal Producers]
s13=Local

Q14=select SOE from [Coal Producers]
s14=SOE

Q15=select Allss from [Coal Producers]
s15=Allss

Q16=SELECT [KEM Abbreviation],[Energy per MWH] FROM [All Materials] WHERE [Fuel Y/N] AND [Energy per MWH]>0
P16=FuelperMWH

Q17=SELECT CV,[Calorific Value (kcal/kg)] FROM [Coal Calorific Value]
P17=COcvSCE

Q18=select [KEM Abbreviation],[Operating Cost] from [Emission Control Technologies]
P18=EMfgcomcst

Q19=select [KEM Abbreviation],[Capital Cost] from [Emission Control Technologies]
P19=EMfgccapex

$offecho

$call =mdb2gms @cmd.txt
