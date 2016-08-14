$ONTEXT
THis is KEM CHINA and integrated MCP module of China's energy sectors.
The current version includes representation of both the coal and pwoer sectors.
Each sector minimizes total system costs, subject to various price and
envrionmental regulations imposed by the government.

MODEL PARAMETERIZATION
The model is parameterized using input data stored in and ACCESS database. All
relevant databse files are stored in the /db sub diretory.
Queries used to pull this data into the model are defined in the $INCDLUDE
statements listed below with the prefix ACCESS_. These only need to be run
when the database is modified. The results of these querries are stored in gdx
relevant gdx files that are called in the submodel files described below .

MODEL EQUATIONS
The $INCLUDE statements appearing below database queries define the model
variables, equations and relevant parameters. Macros defines functions used to
calaculte the depreciation period and interest rate for annualizing capital
investments. This model is run annually, with deprectiaion defined in years.
SetsandVariables defines the dimensions used in all variables of the model.
Scalars and parameters store some scalars and parameters used.
coalsubmodel and coaltranssubmodel describe the coal suppliers.
powersumodel defines the power suppliers.
In the current version the demands for power, and coal (excluding the power
sector) are exogenously defined.

MODEL DECLERATION
The $INCLUDE statement create_models defines the models that will can solved

$OFFTEXT


*$INCLUDE ACCESS_sets.gms
*$INCLUDE ACCESS_CO.gms
*$INCLUDE ACCESS_COtrans.gms
*$INCLUDE ACCESS_EL.gms
$INCLUDE Macros.gms
$INCLUDE SetsandVariables.gms
$INCLUDE ScalarsandParameters.gms
$INCLUDE RW_param.gms
$INCLUDE coalsubmodel.gms
$INCLUDE coaltranssubmodel.gms
$INCLUDE powersubmodel.gms
$INCLUDE emissionsubmodel.gms

$INCLUDE create_models.gms

*!!!     Turn on demand in all regions
         rdem_on(r) = yes;

$INCLUDE imports.gms


$INCLUDE discounting.gms
         ELdiscfact(time)  = 1;


set  run_model(built_models) defines what built model will be run
     run_lp_mcp(lp_mcp) tells the model to solve the lp and or the mcp versions of a built model;

         run_model('Coal')=yes;
         run_lp_mcp("LP")=yes;
         run_lp_mcp("MCP")=yes;

         ELwindtot=sum((ELpw,v,r),ELexistcp.l(ELpw,v,"t12",r))+1e-3;
         ELdeficitmax = 0e3;

         ELctariff(ELc,v) = no;
         ELcELp(ELp,v,ELp,v)= no;

$INCLUDE scenarios.gms
*$INCLUDE on_grid_tariffs.gms
*$INCLUDE short_run.gms
*COprodStats(COf,mm,ss,"t12",rco)  = COprodStats(COf,mm,ss,"t15",rco);
*$INCLUDE new_stock.gms


         option savepoint=2;
         option MCP=PATH;
         option LP=cbc;
         PowerMCP.optfile=1;

*         execute_loadpoint "LongRunWind2020.gdx" ELwindtarget, Elwindop ;
*         ELfitv.fx(Elpw,trun,r) =
*                 (ELwindtarget.m(trun)*ELwindtarget.l(trun))/
*                 sum((v,rr,ELl),ELwindop.l(ELpw,v,ELl,trun,rr));

         execute_loadpoint "LongRun.gdx" ;


         t(trun) = yes;


IF( run_model('Coal'),
         ELCOconsump.fx(Elpcoal,v,gtyp,cv,sulf,sox,nox,trun,rr)$(
                 ELpfgc(ELpcoal,cv,sulf,sox,nox))=0;
         DEMsulflim.fx(trun,rr)=0;

   IF(run_lp_mcp('MCP'),
         Solve CoalMCP using MCP;
   )
   If(run_lp_mcp('LP'),
         Solve CoalLP using LP minimizing COobjvalue;
   );


);
If( run_model('Power'),
   IF(run_lp_mcp('MCP'),
         Solve PowerMCP using MCP;
   )
   If(run_lp_mcp('LP'),
         Solve PowerLP using LP minimizing ELobjvalue;
   );
);

If( run_model('Integrated'),
   IF(run_lp_mcp('MCP'),
         Solve IntegratedMCP using MCP;
   )
   If(run_lp_mcp('LP'),
         Solve IntegratedLP using LP minimizing objvalue;
   );
);

$INCLUDE RW_EL.gms
$INCLUDE RW_CO.gms

