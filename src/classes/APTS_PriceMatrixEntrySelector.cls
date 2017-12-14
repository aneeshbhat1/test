/**************************************************************************************
Apex Class Name    : APTS_PriceMatrixEntrySelector
Version            : 1.0
Created Date       : September 15 2017
Function           : This is created for all SOQL queries on Price Matrix OOTB object.
Modification Log   :
------------------------------------------------------------------------------
 * Developer                   Date                   Description
 * ----------------------------------------------------------------------------
 * Mitul Parmar                 09/14/2017              Original Version
*******************************************************************************/
public  class APTS_PriceMatrixEntrySelector {


    /*
    Description : Helper Method to select required field for course pricing, limit wil always be 2 since only higher and lower values will be selected
    Created by : Mitul Parmar
    Created Date : 15-Sep-2017
    */
    public static List<Apttus_Config2__PriceMatrixEntry__c> getPriceMatrixForOptions(Id priceListItemId, String destinationCode){
        return [select id, Apttus_Config2__Dimension1Value__c, Apttus_Config2__AdjustmentAmount__c 
                    from Apttus_Config2__PriceMatrixEntry__c 
                    where Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__c = :priceListItemId 
                    and Apttus_Config2__Dimension2Value__c = :destinationCode 
                    order by Apttus_Config2__Sequence__c  limit 2];
    }
}