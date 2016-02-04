totalcost(fi,"nuclear subsidy") = gridgamma(ii,jj,"nuclear","t1",fi,"j0","k0");
totalcost("PV subsidy",fj) = gridgamma(ii,jj,"PV","t1","i0",fj,"k0");
totalcost(fi,fj) = gridsocialcost(ii,jj,fi,fj,"k0");

subsidy(fi,"nuclear subsidy") = gridgamma(ii,jj,"nuclear","t1",fi,"j0","k0");
subsidy("PV subsidy",fj) = gridgamma(ii,jj,"PV","t1","i0",fj,"k0");
subsidy(fi,fj) = capitalsubsidy(ii,jj,"t1",fi,fj,"k0");

totalsubsidy(fi,"nuclear subsidy") = gridgamma(ii,jj,"nuclear","t1",fi,"j0","k0");
totalsubsidy("PV subsidy",fj) = gridgamma(ii,jj,"PV","t1","i0",fj,"k0");
totalsubsidy(fi,fj) = gridsubsidycost(ii,jj,fi,fj,"k0");

methane(fi,"nuclear subsidy") = gridgamma(ii,jj,"nuclear","t1",fi,"j0","k0");
methane("PV subsidy",fj) = gridgamma(ii,jj,"PV","t1","i0",fj,"k0");
methane(fi,fj) = gridexcessmethane(ii,jj,'t1',fi,fj,"k0");

energy(fi,"nuclear subsidy") = gridgamma(ii,jj,"nuclear","t1",fi,"j0","k0");
energy("PV subsidy",fj) = gridgamma(ii,jj,"PV","t1","i0",fj,"k0");
energy(fi,fj) = gridenergy(ii,jj,fi,fj,"k0");

export(fi,"nuclear subsidy") = gridgamma(ii,jj,"nuclear","t1",fi,"j0","k0");
export("PV subsidy",fj) = gridgamma(ii,jj,"PV","t1","i0",fj,"k0");
export(fi,fj) = gridexportrevenue(ii,jj,fi,fj,"k0");

socialgain(fi,"nuclear subsidy") = gridgamma(ii,jj,"nuclear","t1",fi,"j0","k0");
socialgain("PV subsidy",fj) = gridgamma(ii,jj,"PV","t1","i0",fj,"k0");
socialgain(fi,fj) = gridecongain(ii,jj,fi,fj,"k0");

if(subgrid=1,
execute_unload "results.gdx"

                             totalcost, subsidy, methane, totalsubsidy, energy, export,socialgain;

$ifthen exist '.\xls\nul'
         execute 'for %F in (.\xls\*.xlsx) do (call gdxxrw i=results.gdx o=.\xls\%~nF.xlsx par=totalcost rng=totcst! rdim=1)'
         execute 'for %F in (.\xls\*.xlsx) do (call gdxxrw i=results.gdx o=.\xls\%~nF.xlsx par=subsidy rng=sub! rdim=1)'
*         execute 'for %F in (.\xls\*.xlsx) do (call gdxxrw i=results.gdx o=.\xls\%~nF.xlsx par=methane rng=methane! rdim=1)'
         execute 'for %F in (.\xls\*.xlsx) do (call gdxxrw i=results.gdx o=.\xls\%~nF.xlsx par=totalsubsidy rng=totsub! rdim=1)'
         execute 'for %F in (.\xls\*.xlsx) do (call gdxxrw i=results.gdx o=.\xls\%~nF.xlsx par=socialgain rng=socialgain! rdim=1)'
         execute 'for %F in (.\xls\*.xlsx) do (call gdxxrw i=results.gdx o=.\xls\%~nF.xlsx par=export rng=export! rdim=1)'
;

$else
         execute 'mkdir .\xls'
         execute 'call gdxxrw i=results.gdx o=.\xls\report.xlsx par=totalcost rng=totcst! rdim=1'
         execute 'call gdxxrw i=results.gdx o=.\xls\report.xlsx par=subsidy rng=sub! rdim=1'
*         execute 'call gdxxrw i=results.gdx o=.\xls\report.xlsx par=methane rng=methane! rdim=1'
         execute 'call gdxxrw i=results.gdx o=.\xls\report.xlsx par=totalsubsidy rng=totsub! rdim=1'
         execute 'call gdxxrw i=results.gdx o=.\xls\report.xlsx par=socialgain rng=socialgain! rdim=1'
         execute 'call gdxxrw i=results.gdx o=.\xls\report.xlsx par=export rng=export! rdim=1'
;
$endif
);
