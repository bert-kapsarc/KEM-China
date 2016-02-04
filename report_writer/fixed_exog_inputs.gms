execute 'call gdxxrw i=ChinaCoal.gdx o=db/CHINA_KEM_fixed set=nodes rng=prod_IHS! rdim=3'
execute 'call gdxxrw i=ChinaCoal.gdx o=db/CHINA_KEM_fixed set=nodes rng=prod_IHS! rdim=3'

execute 'call gdxxrw i=ChinaCoal.gdx o=db/CHINA_KEM_fixed par=COprodIHS rng=prod_IHS! rdim=5'
execute 'call gdxxrw i=ChinaCoal.gdx var=COexistcp.l rng=trans_cap! rdim=5'
execute 'call gdxxrw i=ChinaCoal.gdx var=COtransexistcp.l rng=trans_cap! rdim=5'


execute 'call gdxxrw i=ChinaCoal.gdx o=db/CHINA_KEM_fixed par=COomcst rng=OMcst! rdim=6'
execute 'call gdxxrw i=ChinaCoal.gdx o=db/CHINA_KEM_fixed par=coalcv rng=CV! rdim=6'
execute 'call gdxxrw i=ChinaCoal.gdx o=db/CHINA_KEM_fixed par=COprodyield rng=yields! rdim=6'

execute 'call gdxxrw i=ChinaCoal.gdx o=db/CHINA_KEM_fixed par=Cotransomcst1 rng=transOMcst_fixed! rdim=3'
execute 'call gdxxrw i=ChinaCoal.gdx o=db/CHINA_KEM_fixed par=Cotransomcst2 rng=transOMcst_var! rdim=5'
execute 'call gdxxrw i=ChinaCoal.gdx o=db/CHINA_KEM_fixed par=COfexpmax rng=export! rdim=3'
execute 'call gdxxrw i=ChinaCoal.gdx o=db/CHINA_KEM_fixed par=COfimpmax rng=import_cap! rdim=2'


execute 'call gdxxrw i=ChinaCoal.gdx o=db/CHINA_KEM_fixed par=COtransbldcap rng=trans_planned! rdim=4'
execute 'call gdxxrw i=ChinaCoal.gdx o=db/CHINA_KEM_fixed par=COtranscapex rng=trans_capex! rdim=3'
