/**************************************************************************************
Apex Class Name    : SeasonSupplementsHelper
Version            : 1.0
Created Date       : September 21 2017
Function           : Season Supplements helper for getting required updated supplement product
Modification Log   :
------------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------
* Mitul Parmar                 09/21/2017              Original Version
*******************************************************************************/
public class SeasonSupplementsHelper{  
    
    /*
    Description : Helper Method to select season supplement records depending on course dates and product code
    If the record size is exactly 1 than its the valid season supplement or else its bad data.
    Created by : Mitul Parmar
    Created Date : 21-Sep-2017
    */
    public static List<Season_Supplements__c> getAllValidSeasonSupplements(Date courseStartDate, Date courseEndDate, String productCode, String market) {
        
        List<Season_Supplements__c> seasonSupplementReturnList = new List<Season_Supplements__c>();
        
        try{
            if(productCode != NULL && courseStartDate != NULL && courseEndDate != NULL){
                
                //get the selected season supplement data
                List<Season_Supplements__c> seasonSupplementList = SeasonSupplementsSelector.getSeasonSupplementFromCourseDate(courseStartDate, courseEndDate, productCode, market);
                
                //for all the available season supplements
                for(Season_Supplements__c seasonSupplement : seasonSupplementList){
                    
                    Season_Supplements__c tempSeasonSupplement = new Season_Supplements__c();
                    
                    //get season supplement start date
                    if(courseStartDate <= seasonSupplement.SupplementStartDate__c){
                        tempSeasonSupplement.SupplementStartDate__c = seasonSupplement.SupplementStartDate__c;
                    }
                    else if(courseStartDate >= seasonSupplement.SupplementStartDate__c){
                        tempSeasonSupplement.SupplementStartDate__c = courseStartDate;
                    }
                    
                    //get season supplement end date
                    if(courseEndDate <= seasonSupplement.SupplementEndDate__c){
                        tempSeasonSupplement.SupplementEndDate__c = courseEndDate;
                    }
                    else if(courseEndDate >= seasonSupplement.SupplementEndDate__c){
                        tempSeasonSupplement.SupplementEndDate__c = seasonSupplement.SupplementEndDate__c;
                    }
                    
                    //add Season supplement product
                    tempSeasonSupplement.SeasonSupplementProduct__c = seasonSupplement.SeasonSupplementProduct__c;
                    
                    seasonSupplementReturnList.add(tempSeasonSupplement);
                }
            }
        }
        catch (Exception ex) {
            system.debug('Exception in SeasonSupplementsHelper getAllValidSeasonSupplements :--- ');
            ExceptionHandler.errorLogAsync(ex.getMessage(), ex.getStackTraceString(),
                                           'SeasonSupplementsHelper', 'getAllValidSeasonSupplements', NULL);
        }
        
        //if this list is more than 2 records that its a error condition which will be checked in class which is using this helper method
        return seasonSupplementReturnList;
    }
    
    public static set<Id> createOptionLineItem(Id cartId, Apttus_Config2__LineItem__c lineItem, map<Decimal, list<Apttus_Config2__LineItem__c>> bundleWiseLineItemMap){
        set<Id> deletedLineItemIdset = new set<Id> ();
        try{
            Id productId;
            Integer lineNumber = 0;
            Id priceListId;
            List<Season_Supplements__c> seasonSupplementsList = new  List<Season_Supplements__c>();
            map<Id, Season_Supplements__c> productIdseasonSupplementRecordMap = new  map<Id, Season_Supplements__c>();  
            map<Decimal, set<Id>> bundleWiseSeasonLineItemMap = new map<Decimal, set<Id>>();
            
            system.debug('==Size of forloop #####################=='+ bundleWiseLineItemMap.get(lineItem.Apttus_Config2__LineNumber__c).size());
          
            
            if(lineItem != null && lineItem.Apttus_Config2__StartDate__c != null && lineItem.Apttus_Config2__EndDate__c != null && lineItem.Apttus_Config2__ProductId__r.APTS_Destination_Location__c != null){
                System.debug('Passing Market code is '+lineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Market__c);
                for(Season_Supplements__c seasonSupplement : SeasonSupplementsHelper.getAllValidSeasonSupplements(lineItem.Apttus_Config2__StartDate__c, lineItem.Apttus_Config2__EndDate__c, lineItem.Apttus_Config2__ProductId__r.APTS_Destination_Location__c, lineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Market__c)){
                    productIdseasonSupplementRecordMap.put(seasonSupplement.SeasonSupplementProduct__c, seasonSupplement);
                }
                productId = lineItem.Apttus_Config2__ProductId__c;
                lineNumber = Integer.valueOf(lineItem.Apttus_Config2__LineNumber__c);
                priceListId = lineItem.Apttus_Config2__PriceListId__c;
            }
            
            system.debug('==productIdseasonSupplementRecordMap=='+productIdseasonSupplementRecordMap);        
            
            if(bundleWiseLineItemMap.containskey(lineItem.Apttus_Config2__LineNumber__c)){
                list<Apttus_Config2__LineItem__c> lineItemToDeleteList = new list<Apttus_Config2__LineItem__c>();
                list<Apttus_Config2__LineItem__c> lineItemToUpdateList = new list<Apttus_Config2__LineItem__c>();
                 system.debug('==Size of forloop #####################=='+ bundleWiseLineItemMap.get(lineItem.Apttus_Config2__LineNumber__c).size());
                
                for(Apttus_Config2__LineItem__c lineItemRecord : bundleWiseLineItemMap.get(lineItem.Apttus_Config2__LineNumber__c)){
                     system.debug('==lineItemRecord.Product_Subtype__c Arjun=='+lineItemRecord.Product_Subtype__c);
                     if(lineItemRecord.Product_Subtype__c == APTS_Constants.PRODUCT_SUB_TYPE_Season_Supplements){
                         system.debug('==lineItemRecord.Product_Subtype__c=='+lineItemRecord);
                         if(bundleWiseSeasonLineItemMap.containsKey(lineItemRecord.Apttus_Config2__LineNumber__c)){
                             System.debug('Inside first if');
                            bundleWiseSeasonLineItemMap.get(lineItemRecord.Apttus_Config2__LineNumber__c).add(lineItemRecord.Apttus_Config2__OptionId__c);
                        }else{   
                            System.debug('Inside first else');
                            bundleWiseSeasonLineItemMap.put(lineItemRecord.Apttus_Config2__LineNumber__c, new set<Id>{lineItemRecord.Apttus_Config2__OptionId__c});
                        }
                         
                        if(productIdseasonSupplementRecordMap.containskey(lineItemRecord.Apttus_Config2__OptionId__c)){
                            System.debug('Inside second if');
                            Season_Supplements__c seasonSupplements = productIdseasonSupplementRecordMap.get(lineItemRecord.Apttus_Config2__OptionId__c);
                            lineItemRecord.Apttus_Config2__StartDate__c = seasonSupplements.SupplementStartDate__c;
                            lineItemRecord.Apttus_Config2__EndDate__c = seasonSupplements.SupplementEndDate__c;                     
                            Double Quantity =  (Double)seasonSupplements.SupplementStartDate__c.daysBetween(seasonSupplements.SupplementEndDate__c);                        
                            lineItemRecord.Apttus_Config2__Quantity__c = Math.round(Quantity/7);
                            lineItemToUpdateList.add(lineItemRecord);
                        }else{          
                            System.debug('Inside second else');
                            lineItemToDeleteList.add(lineItemRecord);
                            deletedLineItemIdset.add(lineItemRecord.Id);
                        }    
                     }
                }
                     if(!lineItemToUpdateList.isEmpty()){
                         System.debug('Inside third if');
                        system.debug('==lineItemToUpdateList=='+lineItemToUpdateList);
                        update lineItemToUpdateList;
                    }
                    if(!lineItemToDeleteList.isEmpty()){
                        System.debug('Inside fourth if');
                        system.debug('==lineItemToDeleteList=='+lineItemToDeleteList);
                        delete lineItemToDeleteList;
                        return deletedLineItemIdset;
                    }
                
                if(!productIdseasonSupplementRecordMap.isEmpty()){
                    
                    List<Apttus_CPQApi.CPQ.SelectedOptionDO> selectedOptDOList = new List<Apttus_CPQApi.CPQ.SelectedOptionDO>();
                    //Execute the getoptionGroups API to fetch the options with option groups
                    Apttus_CPQApi.CPQ.ProductOptionGroupSearchResultDO result = Apttus_CPQApi.CPQWebService.getOptionGroupsForPriceListProduct(priceListId,  ProductId);
                    
                    if(result.HasOptionGroups) {
                        List<Apttus_CPQApi.CPQ.ProductOptionGroupDO> prodOptGrpDOList = result.OptionGroups;
                        for(Apttus_CPQApi.CPQ.ProductOptionGroupDO prodOptGrpDO : prodOptGrpDOList) { 
                            if(prodOptGrpDO.HasOptionComponents) {
                                List<Apttus_CPQApi.CPQ.ProductOptionComponentDO> prodOptCompDOList = new List<Apttus_CPQApi.CPQ.ProductOptionComponentDO>();
                                prodOptCompDOList = prodOptGrpDO.OptionComponents; 
                                //Fetch all the option components for a particular option group.
                                system.debug('==bundleWiseSeasonLineItemMap=='+bundleWiseSeasonLineItemMap);
                                for(Apttus_CPQApi.CPQ.ProductOptionComponentDO prodOptCompDO : prodOptCompDOList){
                                    if((bundleWiseSeasonLineItemMap.isEmpty() || bundleWiseSeasonLineItemMap.get(lineItem.Apttus_Config2__LineNumber__c) != null && !bundleWiseSeasonLineItemMap.get(lineItem.Apttus_Config2__LineNumber__c).contains(prodOptCompDO.ComponentProductId)) && productIdseasonSupplementRecordMap.containskey(prodOptCompDO.ComponentProductId)){
                                        Apttus_CPQApi.CPQ.SelectedOptionDO selectedOptDO = new Apttus_CPQApi.CPQ.SelectedOptionDO();
                                        selectedOptDO.ComponentId = prodOptCompDO.ComponentId;              
                                        selectedOptDO.ComponentProductId = prodOptCompDO.ComponentProductId;
                                        Double Quantity = productIdseasonSupplementRecordMap.get(prodOptCompDO.ComponentProductId).SupplementStartDate__c.daysBetween(productIdseasonSupplementRecordMap.get(prodOptCompDO.ComponentProductId).SupplementEndDate__c);
                                        selectedOptDO.Quantity = Math.round(Quantity/7);
                                        selectedOptDO.StartDate = productIdseasonSupplementRecordMap.get(prodOptCompDO.ComponentProductId).SupplementStartDate__c;
                                        selectedOptDO.EndDate = productIdseasonSupplementRecordMap.get(prodOptCompDO.ComponentProductId).SupplementEndDate__c;
                                        selectedOptDO.Comments = 'Added by Code'; 
                                        selectedOptDOList.add(selectedOptDO);
                                    }               
                                }
                            }
                        }
                    }           
                    
                    //Invoke the addOptions API and pass the cartID, selected product line number, and the Option List retrieved from the getoptiongroups API
                    if(!selectedOptDOList.isEmpty()){
                        system.debug('==selectedOptDOList=='+selectedOptDOList);
                        Apttus_CPQApi.CPQ.AddOptionsResponseDO addOptRespDO = Apttus_CPQApi.CPQWebService.addOptions(cartId, lineNumber, selectedOptDOList);
                    }            
                }           
            }
            return deletedLineItemIdset;
        }
        catch (Exception ex) {
            system.debug('Exception in SeasonSupplementsHelper createOptionLineItem :--- ');
            ExceptionHandler.errorLogAsync(ex.getMessage(), ex.getStackTraceString(), 'SeasonSupplementsHelper', 'createOptionLineItem', NULL);
            return deletedLineItemIdset;
        }
    }      
}