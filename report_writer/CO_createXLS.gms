
*$call =gdx2access China_KEM_1.gdx
*$ontext
*execute 'call gdxxrw i=China_KEM_1.gdx var=coalimports'
* coal demand
execute 'call gdxxrw i=ChinaCoal.gdx par=OTHERfconsump rng=demand_SCE! rdim=3'
*execute 'call gdxxrw i=ChinaCoal.gdx par=COfconsump rng=demand_ton! rdim=3'

*marginal costs
execute 'call gdxxrw i=ChinaCoal.gdx equ=COdem.m rng=MC_supply! rdim=4'
execute 'call gdxxrw i=ChinaCoal.gdx equ=COprodCV.m rng=MC_prod! rdim=4'


* coal import
execute 'call gdxxrw i=ChinaCoal.gdx var=coalimports rng=import! rdim=5'
execute 'call gdxxrw i=ChinaCoal.gdx par=Cotransimp rng=import_consump! rdim=4'
execute 'call gdxxrw i=ChinaCoal.gdx par=COintlprice rng=import_price! rdim=5'


* coal transport
execute 'call gdxxrw i=ChinaCoal.gdx var=COtransbld.l rng=trans_bld! rdim=5'


execute 'call gdxxrw i=ChinaCoal.gdx var=Cotrans.l rng=trans! rdim=8'
execute 'call gdxxrw i=ChinaCoal.gdx par=Cotransin rng=trans_in! rdim=3'
execute 'call gdxxrw i=ChinaCoal.gdx par=Cotransout rng=trans_out! rdim=3'
execute 'call gdxxrw i=ChinaCoal.gdx par=Cotransnet rng=trans_net! rdim=3'
execute 'call gdxxrw i=ChinaCoal.gdx par=Cotranstot rng=trans_tot! rdim=4'

execute 'call gdxxrw i=ChinaCoal.gdx par=transport rng=trans_type! rdim=2'

* coal production
execute 'call gdxxrw i=ChinaCoal.gdx var=coaluse.l rng=coal_by_cv! rdim=4'
execute 'call gdxxrw i=ChinaCoal.gdx par=COprodRaw rng=coal_raw! rdim=3'
execute 'call gdxxrw i=ChinaCoal.gdx par=COprodNet rng=coal_net! rdim=4'
execute 'call gdxxrw i=ChinaCoal.gdx par=COprodPUnet rng=coal_PU! rdim=6'

execute 'call gdxxrw i=ChinaCoal.gdx var=CObld.l rng=mine_bld! rdim=5'
*$offtext

execute 'call gdxxrw i=ChinaCoal.gdx par=costs rng=costs! rdim=2'


