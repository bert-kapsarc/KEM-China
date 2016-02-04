
*$call =gdx2access China_KEM_1.gdx
*$ontext
*execute 'call gdxxrw i=China_KEM_1.gdx var=coalimports'
* coal demand
execute 'call gdxxrw i=ChinaCoal.gdx par=EIA rng=KEMChina! rdim=2'
$ontext
execute 'call gdxxrw i=ChinaCoal.gdx par=OTHERCOconsump rng=demand_SCE! rdim=2'
*execute 'call gdxxrw i=ChinaCoal.gdx par=OTHERCOconsumpNatrng=demand_SCE! rdim=2'

execute 'call gdxxrw i=ChinaCoal.gdx par=coal_prod_SCE rng=coal_prod_SCE! rdim=2'
execute 'call gdxxrw i=ChinaCoal.gdx par=coal_imp_SCE rng=coal_imp_SCE! rdim=2'

* coal import
*execute 'call gdxxrw i=ChinaCoal.gdx var=coalimports rng=import! rdim=5'
*execute 'call gdxxrw i=ChinaCoal.gdx par=COintlprice rng=import_price! rdim=5'
*execute 'call gdxxrw i=ChinaCoal.gdx par=coalintlpriceEIA  rng=import_price_USD! rdim=5'

* coal price
execute 'call gdxxrw i=ChinaCoal.gdx par=coal_price rng=China_coal_price! rdim=2'

*marginal costs
*execute 'call gdxxrw i=ChinaCoal.gdx equ=COdem.m rng=MC_supply! rdim=4'
*execute 'call gdxxrw i=ChinaCoal.gdx equ=COprodCV.m rng=MC_prod! rdim=4'

* coal transport
*execute 'call gdxxrw i=ChinaCoal.gdx var=COtransbld.l rng=trans_bld! rdim=5'
*execute 'call gdxxrw i=ChinaCoal.gdx par=Cotranstot rng=trans_tot! rdim=4'
*execute 'call gdxxrw i=ChinaCoal.gdx par=transport rng=trans_type! rdim=2'

* coal production
*execute 'call gdxxrw i=ChinaCoal.gdx par=COprodRaw rng=coal_raw! rdim=3'
*execute 'call gdxxrw i=ChinaCoal.gdx par=COprodNet rng=coal_net! rdim=4'
*$offtext

execute 'call gdxxrw i=ChinaCoal.gdx par=costs rng=costs! rdim=1'

$offtext

