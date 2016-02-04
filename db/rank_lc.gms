

if( smax(hrs,abs(sort_lc_input(hrs)))>0,
         execute_unload "db\rank_in.gdx", sort_lc_input;

* sort symbol; permutation index will be named A also
         execute 'gdxrank db\rank_in.gdx db\rank_out.gdx';

* load the permutation index
         execute_load "db\rank_out.gdx", hrs_rank=sort_lc_input;
);
