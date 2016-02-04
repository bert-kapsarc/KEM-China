$include SetsandVariables_cn.gms

         parameter LDC0(rr,ELl) regional load in GW adjusted for wind capacity addtion
                   LDC1(rr,ELl) regional load in GW for each load segment in ELlchours
                   ELlcgw(rr,ELl) something;

$gdxin ..\db\LDC.gdx
$load ELlcgw
$gdxin

LDC1(rr,ELl) = ELlcgw(rr,ELl);

display LDC1




