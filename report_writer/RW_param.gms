*$INCLUDE expost_param.gms

         Sets    sector differnet sectors /EL,WA,PC,RF,CM,f,other,ALL/
*                 rN(rall)      /nation/
                 path_order/1,2/
                 path_name;
         ;

         scalar MMBTUtoTOE MMTOE per trillion BTU /2.52e-2/

*        For each sectoror only do post solve calculations for most general case
*        RW_createXLS file will automatically aggregate over each set
*        Example in WaterSubmodel:

*        Quantities calacualted across sectors

         Parameters
         netrevenue Net revenue in USD
         revenue Total revenues in USD
         expenses Total expenses (capital O&M fuel electricity) in USD

         fconsump Regional upstream fuel use by type trillion BTU million BBL and million Tonnes
         fconsumpMMBTU Regional upstream fuel use in trillion BTU

         RFfconsump Regional refining fuel use by type million Tonnes
         RFfconsumpMMBTU Regional refining fuel use in trillion BTU

         ELdemand regional demand for power

         ELgenELp Regional net electricity generation by plant in TWh
         ELgenELl Regional net electricity generatio by plant and load segment

         ELtariffELp Costs by technology
         ELcostsELp Average Tarrif paid by each technology

         ELsalesELp Regional electricity sales by plant type 


         ELtransTot Regional transmission of electrcity in TWh

         ELsuptot Regional supply of electr by each  sectoror [GWH]

         ELdemand Regional electricity demand
         ELsales Regional electricity sales

         ELcapELp EL installed capacity by ELp and region
         ELbldELp EL build by ELp and region

         ELcap installed capacity by region
         ELbldtot cumulative bld capacity by region


*        Quanitites specific to Water desal

         WAsupWAp water produced all plants by region [MMm3]
         WAsuptot total water produced by all plants [MMm3]

         WAELprod Regional electr produced by each cogen plants
         WAELprodreg Regional electr produced by all cogen plants
         WAELprodtot Total electr produced by all cogen plants

         WAcapWAp TOtal Water capacity by plant type
         WAbldWAp cumulative bld capacity by WAp and region

         WAcap Total installed capacity
         WAbldtot cumulative bld water capacity by region

         totalcrude, totalHFO, totalgcond, crudeexport, gcondexport, totalenergy,

*        Investment values

         invest

         ELpinvest
         ELtrinvest
         WApinvest
         WAtrinvest
         finvest
         PCinvest
         RFinvest
*        Quantities for electricity demand
         ELpeakdem(time,rall)


Parameters
         COexistrco available coal production apacity by mine region and coal type
         COprodrco coal produced in each minig region by coal type
         COprodrcoSCE coal produced in each mining region by coal type converted to SCE
         COprodRaw raw coal produced by mining region
         COprodPUraw raw coal produce by produciton unit
         COprodNet net coal produced raw and washed by mining region
         COprodPUnet net coal produced raw and washed by production unit
         CObldrco coal mine expansino by region and mine type
         Cotransin coal entereing node
         Cotransout coal exiting node
         COtransfrom coal exiting produciton node
         COtransimp imported coal entering node
         COtransnet balance of coal passing through a node
         Cotr coal leaving production node bytransportation mode
         Cotrriver coal transported by river
         COtrsea coal transported by sea
         COtrport coal leaving specific port
         COtranstot total coal transported between nodes by tranport mode
         CotransbldD total distance of new rails lines built
         Cotransbldton total rail capacity built
         Cotransbldport total port capacity built

;
