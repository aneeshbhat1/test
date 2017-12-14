/**************************************************************************************
Apex Class Name    : LineItemsHelper
Version            : 1.0
Created Date       : oct 3 2017
Function           :
Modification Log   :
------------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------
* Aditi                     10/03/2017              Original Version
*******************************************************************************/
public class LineItemsHelper {

    // In this method we are resetting the values of start date end date and quantity of perticular bundle whose course is changed
    Public static void updateStartdateEnddateOfCourserelatedArticlesIfCourseIsChanged(Map<Id, Apttus_Config2__LineItem__c> newLineItemMap, Map<Id, Apttus_Config2__LineItem__c> oldLineItemMap)
    {
        Id currentrecord;
        try
        {
            List<Apttus_Config2__LineItem__c> lineitemList=new List<Apttus_Config2__LineItem__c>();
            List<Id> configIds=new List<Id>();
            List<Decimal> lineNumberList=new List<Decimal>();
            for (Apttus_Config2__LineItem__c lineitem:oldLineItemMap.values() ) {
                currentrecord=lineitem.Id;
                if (lineitem.APTS_Product_Type__c==APTS_Constants.ProductType_COURSE) {
                    lineNumberList.add(lineitem.Apttus_Config2__LineNumber__c);
                    configIds.add(lineitem.Apttus_Config2__ConfigurationId__c);
                }
            }

            if (configIds.size()>0 && lineNumberList.size()>0) {
                lineitemList=LineItemsSelector.getLineItemsForselectedConfigId(configIds,lineNumberList);
                for (Apttus_Config2__LineItem__c lineitem:lineitemList) {
                    lineitem.Apttus_Config2__Quantity__c=1;
                    lineitem.Apttus_Config2__StartDate__c=null;
                    lineitem.Apttus_Config2__EndDate__c=null;
                }
                //Update Start date and End date of the related articles here
                SObjectUnitOfWork.executeUpdateLineItemValues(lineitemList);
            }
        }
        catch(Exception ex)
        {
            ExceptionHandler.errorLogAsync(ex.getMessage(), ex.getStackTraceString(),
                    'LineItemsHelper', 'updateStartdateEnddateOfCourserelatedArticlesIfCourseIsChanged', currentrecord);
        }





    }

    public static void updateSeasonOnLineItem(Map<Id, Apttus_Config2__LineItem__c> newLineItemMap, Map<Id, Apttus_Config2__LineItem__c> oldLineItemMap) {
        set<Id> configurationIdSet = new set<Id>();
        
        for(Apttus_Config2__LineItem__c objLineItem : newLineItemMap.values()){
            if(objLineItem.APTS_Product_Type__c == 'Accommodation' && objLineItem.Apttus_Config2__StartDate__c != null && objLineItem.Apttus_Config2__StartDate__c != oldLineItemMap.get(objLineItem.Id).Apttus_Config2__StartDate__c && objLineItem.Departure_Point__c != null){
                configurationIdSet.add(objLineItem.Apttus_Config2__ConfigurationId__c);             
            }
        }
        
        if(!configurationIdSet.isEmpty()){
            map<Decimal, Apttus_Config2__LineItem__c> accommodationBundleLineItemsMap = new map<Decimal, Apttus_Config2__LineItem__c>();
            map<Decimal, string> uniqueKeyForFixedFareAndPrimaryLineMap = new map<Decimal, string>();
            map<string, list<Fixed_Fare__c>> fixedFareMap = new map<string, list<Fixed_Fare__c>>();
            list<Apttus_Config2__LineItem__c> fixedFareLineItemsToUpdateList = new list<Apttus_Config2__LineItem__c>();
            map<Decimal, Apttus_Config2__LineItem__c> fixedFareLineItemsBundleWiseMap = new map<Decimal, Apttus_Config2__LineItem__c>();
            
            for(Apttus_Config2__LineItem__c objLineItem : [select Id, FixedFareSeason__c, APTS_Product_Type__c,Apttus_Config2__LineNumber__c, Apttus_Config2__StartDate__c, Product_Code__c,Product__c, Program__c, Departure_Point__c, DestinationCode__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.Fixed_Fare_Date__c from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c in : configurationIdSet]){
                
                if(objLineItem.product_code__c == APTS_Constants.FIXEDFAREFLIGHTCODE){
                    System.debug('Fixed fare value'+objLineItem);
                    fixedFareLineItemsBundleWiseMap.put(objLineItem.Apttus_Config2__LineNumber__c, objLineItem);
                }
                
                if(objLineItem.APTS_Product_Type__c == 'Accommodation'){
                    if(!accommodationBundleLineItemsMap.isEmpty() && accommodationBundleLineItemsMap.containskey(objLineItem.Apttus_Config2__LineNumber__c)){
                        if(objLineItem.Apttus_Config2__StartDate__c < accommodationBundleLineItemsMap.get(objLineItem.Apttus_Config2__LineNumber__c).Apttus_Config2__StartDate__c){
                            accommodationBundleLineItemsMap.remove(objLineItem.Apttus_Config2__LineNumber__c);
                            accommodationBundleLineItemsMap.put(objLineItem.Apttus_Config2__LineNumber__c, objLineItem);
                        }
                    }else{
                        accommodationBundleLineItemsMap.put(objLineItem.Apttus_Config2__LineNumber__c, objLineItem);
                    }
                    
                    if(objLineItem.Product__c != null && objLineItem.Program__c != null && objLineItem.DestinationCode__c != null && objLineItem.Departure_Point__c != null){
                        uniqueKeyForFixedFareAndPrimaryLineMap.put(objLineItem.Apttus_Config2__LineNumber__c, objLineItem.Product__c + objLineItem.Program__c + objLineItem.DestinationCode__c +objLineItem.Departure_Point__c);
                    }
                }
                
                
            }
            //ILS ILSU NZ-AUC TLS
            //ILS ILSU ES-BAR TLS
            system.debug('==accommodationBundleLineItemsMap=='+accommodationBundleLineItemsMap);
            system.debug('==uniqueKeyForFixedFareAndPrimaryLineMap=='+uniqueKeyForFixedFareAndPrimaryLineMap);
            system.debug('==fixedFareLineItemsBundleWiseMap=='+fixedFareLineItemsBundleWiseMap);
            
            for(Fixed_Fare__c objFixedFare  :[select Id, Flight_Season__c, Unique_Value__c, From_Month__c, to_Month__c, From_Day__c,To_Day__c from Fixed_Fare__c where Unique_Value__c in  : uniqueKeyForFixedFareAndPrimaryLineMap.values()]){
                if(fixedFareMap.containskey(objFixedFare.Unique_Value__c)){
                    fixedFareMap.get(objFixedFare.Unique_Value__c).add(objFixedFare);
                }else{
                    fixedFareMap.put(objFixedFare.Unique_Value__c, new list<Fixed_Fare__c>{objFixedFare});
                }                
            }
            
            system.debug('==uniqueKeyForFixedFareAndPrimaryLineMap=='+uniqueKeyForFixedFareAndPrimaryLineMap);
            
            for(Apttus_Config2__LineItem__c objLineItem : accommodationBundleLineItemsMap.values()){
                string uniqueKey = objLineItem.Product__c + objLineItem.Program__c + objLineItem.DestinationCode__c +objLineItem.Departure_Point__c;
                if(uniqueKeyForFixedFareAndPrimaryLineMap.containskey(objLineItem.Apttus_Config2__LineNumber__c) && fixedFareMap.containskey(uniqueKeyForFixedFareAndPrimaryLineMap.get(objLineItem.Apttus_Config2__LineNumber__c))){
                    for(Fixed_Fare__c objFixedFare : fixedFareMap.get(uniqueKeyForFixedFareAndPrimaryLineMap.get(objLineItem.Apttus_Config2__LineNumber__c))){
                        system.debug('I am here in for'+objLineItem.Apttus_Config2__StartDate__c);
                        Date myDate = Date.newInstance(Date.Today().Year(), integer.valueof(objLineItem.Apttus_Config2__StartDate__c.month()), integer.valueof(objLineItem.Apttus_Config2__StartDate__c.day()));
                        system.debug('the problem>>>>');
                        system.debug('My date is'+myDate);
                        Date fromDate =Date.newInstance(Date.Today().Year(), integer.valueof(objFixedFare.From_Month__c),integer.valueof(objFixedFare.From_Day__c));
                        system.debug('From date is'+fromDate);
                        integer toYear = Date.Today().Year();
                        if(objFixedFare.From_Month__c > objFixedFare.To_Month__c){
                            toYear = Date.Today().Year() + 1;
                        }
                        Date toDate =Date.newInstance(toYear, integer.valueof(objFixedFare.To_Month__c),integer.valueof(objFixedFare.To_Day__c));
                        system.debug('todate is'+toDate);
                        system.debug('==condition=='+ (fromDate <= myDate && toDate >= myDate));
                        if(fromDate <= myDate && toDate >= myDate){
                            if(fixedFareLineItemsBundleWiseMap.containskey(objLineItem.Apttus_Config2__LineNumber__c) && (fixedFareLineItemsBundleWiseMap.get(objLineItem.Apttus_Config2__LineNumber__c).FixedFareSeason__c == null || fixedFareLineItemsBundleWiseMap.get(objLineItem.Apttus_Config2__LineNumber__c).FixedFareSeason__c != null && fixedFareLineItemsBundleWiseMap.get(objLineItem.Apttus_Config2__LineNumber__c).FixedFareSeason__c != objFixedFare.Flight_Season__c)){
                                fixedFareLineItemsToUpdateList.add(new Apttus_Config2__LineItem__c(Id = fixedFareLineItemsBundleWiseMap.get(objLineItem.Apttus_Config2__LineNumber__c).Id, FixedFareSeason__c = objFixedFare.Flight_Season__c, Apttus_Config2__PricingStatus__c = 'Pending'));
                            }
                        }
                    }
                }
            }
            system.debug('==fixedFareLineItemsToUpdateList=='+fixedFareLineItemsToUpdateList);
            
            if(!fixedFareLineItemsToUpdateList.isEmpty()){
                update fixedFareLineItemsToUpdateList;
            }
        }
    }
}