/**************************************************************************************
Apex Class Name    : APTS_EFPricingCallback
Version            : 1.0
Created Date       : September 14 2017
Function           : Created for adding complexing pricing functionality for Matrix based pricing.
Modification Log   :
------------------------------------------------------------------------------
 * Developer                   Date                   Description
 * ----------------------------------------------------------------------------
 * Mitul Parmar                 09/14/2017              Original Version
*******************************************************************************/
global with sharing class APTS_EFPricingCallback implements Apttus_Config2.CustomClass.IPricingCallback3{
    
    //private static Double priceListThreshold = 0;
    private static Double bracketThresholdTI = 0;
    private static Double currentThreshHold = 0;
    private Apttus_Config2.ProductConfiguration cart = null;
    private List<Apttus_Config2.LineItem> cartLineitems = null;
    private Apttus_Config2.LineItem finalBundle = null;
    private static List<Apttus_Config2.LineItem> optionProductList = new List<Apttus_Config2.LineItem>();
    private static Set<Id> priceListItemIdSet = new Set<Id>();
    private static Map<Id,List<Apttus_Config2__PriceMatrixEntry__c>> lineItemPriceMatrixMap = new Map<Id,List<Apttus_Config2__PriceMatrixEntry__c>>();
    private static Map<Double,Apttus_Config2.LineItem> bundleMap = new Map<Double,Apttus_Config2.LineItem>();
    private static boolean comparitiveQuoteFlag = FALSE;

    private static Map<String,Double> courseLanguageQuantityMap = new Map<String,Double>();
    private static Map<Id,Double> courseQuantityMap = new Map<Id,Double>();
    /*
    Description : Method to override set mode of PCB
    Created by : Mitul Parmar
    Created Date : 14-Sep-2017
    */
    global void setMode(Apttus_Config2.CustomClass.PricingMode mode) {
        
    }
    
    /*
    Description : Method to override start of PCB
    Created by : Mitul Parmar
    Created Date : 14-Sep-2017
    */
    global void start(Apttus_Config2.ProductConfiguration cart) {

        this.cart = cart;
        this.cartLineitems = cart.getLineItems();

        optionProductList = new List<Apttus_Config2.LineItem>();
        bundleMap = new Map<Double,Apttus_Config2.LineItem>();
        courseLanguageQuantityMap = new Map<String,Double>();
        courseQuantityMap = new  Map<Id,Double>();
        //for each option product create required field to be passed to course pricing

        for(Apttus_Config2.LineItem lineItemS0 : this.cartLineitems) {

            Apttus_Config2__LineItem__c lineItem = lineItemS0.getLineItemSO();

            system.debug('Line Item comparitiveQuoteFlag :--- '+lineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.ComparativeQuote__c);
            system.debug('Line Item Product Type :--- '+lineItem.Apttus_Config2__PriceListItemId__c);

            comparitiveQuoteFlag = lineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.ComparativeQuote__c;

            //if the product type = course than consider it for course pricing
            if(lineItem.Apttus_Config2__OptionId__r.Apts_CoursePricing__c){
                optionProductList.add(lineItemS0);
                List<Apttus_Config2__PriceMatrixEntry__c> priceMatrixList = APTS_PriceMatrixEntrySelector.getPriceMatrixForOptions(lineItem.Apttus_Config2__PriceListItemId__c, lineItem.DestinationCode__c);
                lineItemPriceMatrixMap.put(lineItem.Id,priceMatrixList);
                currentThreshHold = lineItem.Apttus_Config2__PriceListId__r.Brackets_Threshold__c;
                
                //if its non comparitive quote than do following logic
                if(!comparitiveQuoteFlag){
                    //update map for language specific course for english
                    if(lineItem.APTS_Language__c == APTS_Constants.PRODUCT_LANGUAGE_ENGLISH){

                        if(courseLanguageQuantityMap.containsKey(APTS_Constants.PRODUCT_LANGUAGE_ENGLISH)){
                            Double tempQuantity = courseLanguageQuantityMap.get(APTS_Constants.PRODUCT_LANGUAGE_ENGLISH) + lineItem.Apttus_Config2__Quantity__c;
                            courseLanguageQuantityMap.put(APTS_Constants.PRODUCT_LANGUAGE_ENGLISH,tempQuantity);
                        }
                        else{
                            courseLanguageQuantityMap.put(APTS_Constants.PRODUCT_LANGUAGE_ENGLISH,lineItem.Apttus_Config2__Quantity__c);
                        }
                    }
                    //update map for language specific course for non english
                    else if(lineItem.APTS_Language__c != APTS_Constants.PRODUCT_LANGUAGE_NON_ENGLISH){
                        if(courseLanguageQuantityMap.containsKey(APTS_Constants.PRODUCT_LANGUAGE_NON_ENGLISH)){
                            Double tempQuantity = courseLanguageQuantityMap.get(APTS_Constants.PRODUCT_LANGUAGE_NON_ENGLISH) + lineItem.Apttus_Config2__Quantity__c;
                            courseLanguageQuantityMap.put(APTS_Constants.PRODUCT_LANGUAGE_NON_ENGLISH,tempQuantity);
                        }
                        else{
                            courseLanguageQuantityMap.put(APTS_Constants.PRODUCT_LANGUAGE_NON_ENGLISH,lineItem.Apttus_Config2__Quantity__c);
                        }
                    }
                }
                else{

                    system.debug('Comparitive quote :--- '+lineItem.Apttus_Config2__Quantity__c);
                    //there will be only 1 course for each bundle and we add the quantity
                    courseQuantityMap.put(lineItem.Apttus_Config2__ProductId__c,lineItem.Apttus_Config2__Quantity__c);
                }
            }

            //if the line item is main bundle than add it in map
            else if(lineItem.Apttus_Config2__OptionId__c == NULL){
                bundleMap.put(lineItem.Apttus_Config2__LineNumber__c,lineItemS0);
            }

            //if there is a TI product added than consider different threshold but only for comparitive quote
            else if(lineItem.Apttus_Config2__OptionId__r.Apts_TI_Pricing__c && comparitiveQuoteFlag){
                optionProductList.add(lineItemS0);
                List<Apttus_Config2__PriceMatrixEntry__c> priceMatrixList = APTS_PriceMatrixEntrySelector.getPriceMatrixForOptions(lineItem.Apttus_Config2__PriceListItemId__c, lineItem.DestinationCode__c);
                lineItemPriceMatrixMap.put(lineItem.Id,priceMatrixList);
                currentThreshHold = lineItem.Apttus_Config2__PriceListId__r.Brackets_Threshold__c;
                //priceListThreshold =  lineItem.Apttus_Config2__PriceListId__r.Brackets_Threshold__c;
                bracketThresholdTI = lineItem.Apttus_Config2__PriceListId__r.Apts_BracketsThresholdTI__c;
            }
        }
    }

    /*
    Description : Method to override before pricing line item of PCB
    Created by : Mitul Parmar
    Created Date : 14-Sep-2017
    */
    global void beforePricingLineItem(Apttus_Config2.ProductConfiguration.LineItemColl itemcoll, Apttus_Config2.LineItem lineItemS0){

        
    }
    
    /*
    Description : Method to override before pricing of PCB
    Created by : Mitul Parmar
    Created Date : 14-Sep-2017
    */
    global void beforePricing(Apttus_Config2.ProductConfiguration.LineItemColl itemColl) {
        
        for(Apttus_Config2.LineItem item : this.cartLineitems) {
            
            Apttus_Config2__LineItem__c lineItem = item.getLineItemSO();

            //if its non comparitive quote than do following logic
            if(!comparitiveQuoteFlag){
                if(lineItem.Product_Code__c == APTS_Constants.PRODUCT_CODE_ENGLISH && courseLanguageQuantityMap.containsKey(APTS_Constants.PRODUCT_LANGUAGE_ENGLISH)){
                    if(lineItem.Apttus_Config2__Quantity__c != courseLanguageQuantityMap.get(APTS_Constants.PRODUCT_LANGUAGE_ENGLISH)){
                        lineItem.Apttus_Config2__PricingStatus__c = APTS_Constants.LINE_ITEM_PRICING_STATUS_PENDING;
                        lineItem.Apttus_Config2__Quantity__c = courseLanguageQuantityMap.get(APTS_Constants.PRODUCT_LANGUAGE_ENGLISH);
                    }
                }
                else if(lineItem.Product_Code__c == APTS_Constants.PRODUCT_CODE_NON_ENGLISH && courseLanguageQuantityMap.containsKey(APTS_Constants.PRODUCT_LANGUAGE_NON_ENGLISH)){
                    if(lineItem.Apttus_Config2__Quantity__c != courseLanguageQuantityMap.get(APTS_Constants.PRODUCT_LANGUAGE_NON_ENGLISH)){
                        lineItem.Apttus_Config2__PricingStatus__c = APTS_Constants.LINE_ITEM_PRICING_STATUS_PENDING;
                        lineItem.Apttus_Config2__Quantity__c = courseLanguageQuantityMap.get(APTS_Constants.PRODUCT_LANGUAGE_NON_ENGLISH);
                    }
                }
            }
            //for comparitive quote
            else{
                 for (Apttus_Config2.LineItem courseitem : this.cartLineitems) {
                      Apttus_Config2__LineItem__c courselineItem = courseitem.getLineItemSO();
                    if (courselineItem.APTS_Product_Type__c==APTS_Constants.ProductType_COURSE 
                        && lineItem.Apttus_Config2__LineNumber__c==courselineItem.Apttus_Config2__LineNumber__c
                            && lineItem.DestinationCode__c==courselineItem.DestinationCode__c &&
                       (lineItem.Product_Code__c == APTS_Constants.PRODUCT_CODE_ENGLISH
                        || lineItem.Product_Code__c == APTS_Constants.PRODUCT_CODE_NON_ENGLISH)) {
                        lineItem.Apttus_Config2__Quantity__c =courselineItem.Apttus_Config2__Quantity__c;
                                break;
                    }
                }
                /*if(lineItem.Product_Code__c == APTS_Constants.PRODUCT_CODE_ENGLISH || lineItem.Product_Code__c == APTS_Constants.PRODUCT_CODE_NON_ENGLISH){
                    lineItem.Apttus_Config2__Quantity__c = this.courseQuantityMap.get(lineItem.Apttus_Config2__ProductId__c);
                }*/
            }
        }
    } 
    
    /*
    Description : Method to override after pricing of PCB
    Created by : Mitul Parmar
    Created Date : 14-Sep-2017
    */
    global void afterPricing(Apttus_Config2.ProductConfiguration.LineItemColl itemColl) {

    }      
  
    /*
    Description : Method to override after pricing line item of PCB
    Created by : Mitul Parmar
    Created Date : 14-Sep-2017
    */
    global void afterPricingLineItem(Apttus_Config2.ProductConfiguration.LineItemColl itemcoll, Apttus_Config2.LineItem lineItemS0){
        
        //for current line item calculate course pricing and update main bundle
        Apttus_Config2__LineItem__c lineItem = lineItemS0.getLineItemSO();

        //if more than 1 bundle added for course pricing
        if(!optionProductList.isEmpty() && optionProductList.size() > 1){
            
            //if its non comparitive quote than do course base pricing
            if(!comparitiveQuoteFlag){
                

                if(lineItem.Apttus_Config2__OptionId__r.Apts_CoursePricing__c){
                    currentThreshHold = APTS_EFPricingCallbackHelper.updateCoursePricingOnMatrix(lineItem,currentThreshHold,lineItemPriceMatrixMap);
                    system.debug('course Pricing currentThreshHold :----  '+currentThreshHold);
                    system.debug('course Pricing before update base extended :----  '+lineItem.Apttus_Config2__BaseExtendedPrice__c);
                    lineItemS0.updatePrice();

                    if(bundleMap.containsKey(lineItem.Apttus_Config2__LineNumber__c)){
                        Apttus_Config2__LineItem__c bundelLineItem = bundleMap.get(lineItem.Apttus_Config2__LineNumber__c).getLineItemSO();
                        bundelLineItem.Apttus_Config2__OptionPrice__c = lineItem.Apttus_Config2__NetPrice__c;
                        bundleMap.get(lineItem.Apttus_Config2__LineNumber__c).updatePrice();
                        system.debug('Course Pricing Bundle Price updated :-- '+lineItem.Apttus_Config2__LineNumber__c);
                    }
                    system.debug('Course Pricing after update base extended :----  '+lineItem.Apttus_Config2__BaseExtendedPrice__c);
                }
            }

            //if its comparitive quote than do pricing with other price matrix
            else{
                if(lineItem.Apttus_Config2__OptionId__r.Apts_CoursePricing__c){
                    APTS_EFPricingCallbackHelper.updatePricingForComparitive(lineItem,currentThreshHold,lineItemPriceMatrixMap);
                    system.debug('Comparitive Pricing before update base extended :----  '+lineItem.Apttus_Config2__BaseExtendedPrice__c);
                    lineItemS0.updatePrice();

                    if(bundleMap.containsKey(lineItem.Apttus_Config2__LineNumber__c)){
                        Apttus_Config2__LineItem__c bundelLineItem = bundleMap.get(lineItem.Apttus_Config2__LineNumber__c).getLineItemSO();
                        bundelLineItem.Apttus_Config2__OptionPrice__c = lineItem.Apttus_Config2__NetPrice__c;
                        bundleMap.get(lineItem.Apttus_Config2__LineNumber__c).updatePrice();
                        system.debug('Comparitive Pricing Bundle Price updated :-- '+lineItem.Apttus_Config2__LineNumber__c);
                    }
                    system.debug('Comparitive Pricing after update base extended :----  '+lineItem.Apttus_Config2__BaseExtendedPrice__c);
                }
                else if(lineItem.Apttus_Config2__OptionId__r.Apts_TI_Pricing__c){
                    APTS_EFPricingCallbackHelper.updatePricingForComparitive(lineItem,bracketThresholdTI,lineItemPriceMatrixMap);
                    system.debug('Comparitive Pricing TI before update base extended :----  '+lineItem.Apttus_Config2__BaseExtendedPrice__c);
                    lineItemS0.updatePrice();

                    if(bundleMap.containsKey(lineItem.Apttus_Config2__LineNumber__c)){
                        Apttus_Config2__LineItem__c bundelLineItem = bundleMap.get(lineItem.Apttus_Config2__LineNumber__c).getLineItemSO();
                        bundelLineItem.Apttus_Config2__OptionPrice__c = lineItem.Apttus_Config2__NetPrice__c;
                        bundleMap.get(lineItem.Apttus_Config2__LineNumber__c).updatePrice();
                        system.debug('Comparitive Pricing TI Bundle Price updated :-- '+lineItem.Apttus_Config2__LineNumber__c);
                    }
                    system.debug('Comparitive Pricing TI after update base extended :----  '+lineItem.Apttus_Config2__BaseExtendedPrice__c);
                }
            }
        }
    }   
    
    
    /*
    Description : Method to override on price item set of PCB
    Created by : Mitul Parmar
    Created Date : 14-Sep-2017
    */
    global void onPriceItemSet(Apttus_Config2__PriceListItem__c itemSO, Apttus_Config2.LineItem lineItemMO){
    }
    
    /*
    Description : Method to override finish of PCB
    Created by : Mitul Parmar
    Created Date : 14-Sep-2017
    */
    global void finish() {
    }
    
}