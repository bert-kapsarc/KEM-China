$ONTEXT
KEM CHINA an integrated MCP module of China's energy sectors.
The current version includes representation of both the coal and pwoer sectors.
Each sector minimizes total system costs, subject to various price and
envrionmental regulations imposed by the government.

MODEL PARAMETERIZATION
The model is parameterized using input data stored in an ACCESS database. All
relevant databse files are stored in the /db sub diretory.
Queries used to pull this data into the model are defined in the $INCDLUDE
statements listed below with the prefix ACCESS_. These only need to be run
if the input data is modified. The results of these querries are stored in
relevant gdx files that are called by each submodel file.

MODEL EQUATIONS
Each submodel file is included below the database queries including all the
variables, equations and relevant parameters.
SetsandVariables defines the dimensions used in all variables of the model.
Scalars and parameters store some scalars and parameters used.
coalsubmodel and coaltranssubmodel describe the coal suppliers.
powersumodel defines the power suppliers.
In the current version the demands for power, and coal (excluding the power
sector) are exogenously defined.

MODEL DECLERATION
The $INCLUDE statement create_models defines the models that can be solved


options to use when running this filel
idir =model_files;db;integration_files;report_writer; gdx=test
$OFFTEXT


*$INCLUDE ACCESS_sets.gms
*$INCLUDE ACCESS_CO.gms
*$INCLUDE ACCESS_COtrans.gms
*$INCLUDE ACCESS_EL.gms
$INCLUDE Macros.gms
$INCLUDE SetsandVariables.gms
$INCLUDE ScalarsandParameters.gms
$INCLUDE RW_param.gms

set  run_model(built_models) defines what built model will be run. Is a subset of buil_models which represents the model instances that hav been developed. Options are Coal and or Power
     run_mode(lp_mcp) Tell the model to solve in lp or mcp mode. can only select one of these options.;
*        select model(s) to run -  Coal, Power
         run_model('Coal')=yes;
*         run_model('Power')=yes;
*         run_model('Refining')=yes;
*        select model to run in LP or MCP mode (select one only!)
         run_mode('LP')=yes;

set      model_input /predefined, savepoint/
         run_with_inputs(model_input);

         run_with_inputs('predefined')=yes;





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


         ELwindtot=sum((ELpw,v,r),ELexistcp.l(ELpw,v,"t12",r))+1e-3;
         ELdeficitmax = 0e3;

$INCLUDE scenarios.gms
*$INCLUDE on_grid_tariffs.gms
*$INCLUDE short_run.gms
*COprodStats(COf,mm,ss,"t12",rco)  = COprodStats(COf,mm,ss,"t15",rco);
*$INCLUDE new_stock.gms


         option savepoint=1;
         option MCP=PATH;
         option NLP=pathnlp;
         option LP=cbc;
         PowerMCP.optfile=1;

*         execute_loadpoint "LongRunWind2020.gdx" ELwindtarget, Elwindop ;
*         ELfitv.fx(Elpw,trun,r) =
*                 (ELwindtarget.m(trun)*ELwindtarget.l(trun))/
*                 sum((v,rr,ELl),ELwindop.l(ELpw,v,ELl,trun,rr));

         t(trun) = yes;

          file info / '%emp.info%' /;
          putclose info / 'modeltype mcp';
IF( run_model('Coal'),


    If(run_mode('LP'),
*         Solve CoalLP using LP minimizing COobjvalue;



         CoalLP.optfile=1;

         solve CoalLP using emp minimizing COobjvalue;

   elseif run_mode('MCP'),
         Solve CoalMCP using MCP;
   );

elseif run_model('Power'),
   If(run_mode('LP'),
         Solve PowerLP using NLP minimizing ELobjvalue;

   elseif run_mode('MCP'),
         Solve PowerMCP using MCP;
   );

elseif run_model('Coal') and run_model('Power') ,
   If(run_mode('LP'),
         Solve IntegratedLP using LP minimizing objvalue;

   elseif run_mode('MCP'),
         execute_loadpoint "IntegratedMCP_p.gdx" ;
         Solve IntegratedMCP using MCP;
$INCLUDE obj_values.gms
   );

);

$INCLUDE RW_EL.gms
$INCLUDE RW_CO.gms

