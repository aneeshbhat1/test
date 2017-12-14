/**************************************************************************************
Apex Class Name    : PriceListSelector
Version            : 1.0
Created Date       : September 14 2017
Function           :
Modification Log   :
------------------------------------------------------------------------------
 * Developer                   Date                   Description
 * ----------------------------------------------------------------------------
 * Arjun.Mohan                 09/14/2017              Original Version
*******************************************************************************/

public class PriceListSelector {


    //This method is used to get the pricelist basedon market program and currencyt for that proposal
    public static Map<String, Apttus_Config2__PriceList__c> getPriceListForMarketProgramCurrency(List<String> uniqueKeyString) {
        Map<String, Apttus_Config2__PriceList__c> priceListMap = new Map<String, Apttus_Config2__PriceList__c>();

        if (uniqueKeyString != null && uniqueKeyString.size() > 0) {
            for (Apttus_Config2__PriceList__c priceListRecord : [
                    Select Name,Apttus_Config2__BasedOnAdjustmentAmount__c,Apttus_Config2__BasedOnAdjustmentType__c,Apttus_Config2__BasedOnPriceListId__c
                            ,Brackets_Threshold__c,Apttus_Config2__ContractNumber__c,Apttus_Config2__CostModelId__c,
                            APTS_Default__c,APTS_Default_Unique_Identifier__c,Apttus_Config2__Description__c,
                            Apttus_Config2__EffectiveDate__c,Apttus_Config2__ExpirationDate__c,Apttus_Config2__GuidePage__c,
                            Market__c,Program__c,Apttus_Config2__Type__c
                    from Apttus_Config2__PriceList__c
                    where APTS_Default_Unique_Identifier__c IN:uniqueKeyString
            ]) {
                priceListMap.put(priceListRecord.APTS_Default_Unique_Identifier__c, priceListRecord);
            }
        }
        return priceListMap;
    }

}