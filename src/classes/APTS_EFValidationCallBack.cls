/**************************************************************************************
Apex Class Name    : APTS_EFValidationCallBack
Version            : 1.0
Created Date       : September 20 2017
Function           : Adding it for validation rule.
Modification Log   : 
------------------------------------------------------------------------------
 * Developer                   Date                   Description
 * ----------------------------------------------------------------------------
 * Mitul Parmar                 09/20/2017              Original Version
*******************************************************************************/
global with sharing class APTS_EFValidationCallBack implements Apttus_Config2.CustomClass.IValidationCallback2 {

    //Added by mitul to enable validation call back
    public static final boolean VALIDATION_TRIGGER_VALUE = TRUE;
    public static list<Apttus_Config2__LineItem__c> lineItemList;

    /*
    Description : Method to override validation of entire cart
    Created by : Mitul Parmar
    Created Date : 20-Sep-2017
    */
    global Apttus_Config2.CustomClass.ValidationResult validateCart(Apttus_Config2.ProductConfiguration cart) {

        system.debug('Inside validate Cart : -- ');

        // get the PageAction to identify is user has performed Reprice or Finalize action
        Map<String, String> mapValues = Apttus_Config2.RuntimeContext.getParameters();
        String PageAction = mapValues.get('pageAction');

        //get Line items list
        //list<Apttus_Config2__LineItem__c> lineItemList = new list<Apttus_Config2__LineItem__c> ();
        lineItemList = getLineItemData(cart);

        Apttus_Config2.CustomClass.ValidationResult result = new Apttus_Config2.CustomClass.ValidationResult(true);

        //Added by Mitul Parmar for Restrict users to Override Prices
        if(VALIDATION_TRIGGER_VALUE && result.isSuccess && !checkPriceOverrideEditable(cart) && !String.isEmpty(PageAction) && PageAction == APTS_Constants.VALIDATE_CART_PAGE_ACTION_FINALIZE){
            result.isSuccess =  false;
            result.Messages.add(new ApexPages.message(ApexPages.Severity.ERROR, System.Label.APTS_Price_Override_Error_Message));
        }
        
        //Added by Mitul Parmar for Restrict to give discount than defined limit
        if(VALIDATION_TRIGGER_VALUE && result.isSuccess && !validateCartTotalDiscount(cart) && !String.isEmpty(PageAction) && PageAction == APTS_Constants.VALIDATE_CART_PAGE_ACTION_FINALIZE){
            result.isSuccess =  false;
            result.Messages.add(new ApexPages.message(ApexPages.Severity.ERROR, System.Label.APTS_Grand_Total_Discount_Error + ' '+System.Label.APTS_Grand_Total_Discount_Limit + '.'));
        }

        //Added by Mitul Parmar for Restrict to give discount than defined limit
        if(VALIDATION_TRIGGER_VALUE && result.isSuccess && !checkQuantityDestionationAccomodation(cart) && !String.isEmpty(PageAction) && PageAction == APTS_Constants.VALIDATE_CART_PAGE_ACTION_FINALIZE){
            result.isSuccess =  false;
            result.Messages.add(new ApexPages.message(ApexPages.Severity.ERROR, System.Label.APTS_Junior_Course_Accomodation_Error));
        }

        //Added by Husen Sayyed for Restrict users to add Australia Overseas Health Cover Product
        if(VALIDATION_TRIGGER_VALUE && result.isSuccess && !validateCartByDestinationandTotalCourceWeek(cart) && !String.isEmpty(PageAction) && PageAction == APTS_Constants.VALIDATE_CART_PAGE_ACTION_FINALIZE){
            result.isSuccess =  false;
            result.Messages.add(new ApexPages.message(ApexPages.Severity.ERROR, System.Label.APTS_Australia_Overseas_Health_Cover_Product));
        }  
        
        //Added by Husen Sayyed for Restrict users for Fixed Fare flights cannot be booked for certain amount of time before departures.
        if(VALIDATION_TRIGGER_VALUE && result.isSuccess && !validateCartByDestinationandStartDate(cart) && !String.isEmpty(PageAction) && PageAction == APTS_Constants.VALIDATE_CART_PAGE_ACTION_FINALIZE){
            result.isSuccess =  false;
            result.Messages.add(new ApexPages.message(ApexPages.Severity.ERROR, System.Label.APTS_Fixed_Fare_flights_cannot_be_booked));
        }

        return result;
    }

    /*
    Description : Method to override validation cart and added asset line item related to quote
    Created by : Mitul Parmar
    Created Date : 20-Sep-2017
    */
    global Apttus_Config2.CustomClass.ValidationResult validateAssetItems(Apttus_Config2.ProductConfiguration cart, List<Apttus_Config2__TempRenew__c> assetItems) {
        
        Apttus_Config2.CustomClass.ValidationResult result = new Apttus_Config2.CustomClass.ValidationResult(true);

        return result;
    }

    /*
    Description : Method to override validation cart and RampLineItems
    Created by : Mitul Parmar
    Created Date : 20-Sep-2017
    */
    global Apttus_Config2.CustomClass.ValidationResult validateRampLineItems(Apttus_Config2.ProductConfiguration cart, List<Apttus_Config2.LineItem> rampLineItems) {
        Apttus_Config2.CustomClass.ValidationResult result = new Apttus_Config2.CustomClass.ValidationResult(true);
        return result;
    }

    /*
    Description : common method to get the line item data on the cart.
    Created by : Mitul Parmar
    Created Date : 03-Oct-2017
    */
      private static List<Apttus_Config2__LineItem__c> getLineItemData(Apttus_Config2.ProductConfiguration cart){

        Apttus_Config2__ProductConfiguration__c configuration = cart.getConfigSO();
        List<Apttus_Config2__LineItem__c>  cartLineItemList = [Select Id , Apttus_Config2__IsOptional__c,Apttus_Config2__NetPrice__c,Apttus_Config2__LineType__c,Non_Discounted_Price__c,Apttus_Config2__OptionId__r.APTS_PriceOverrideAllowed__c , Apttus_Config2__AdjustmentType__c, Apttus_Config2__AttributeValueId__r.Country__c, Apttus_Config2__AdjustmentAmount__c,
                                                                APTS_Product_Type__c, Product_Subtype__c , Apttus_Config2__Quantity__c, Apttus_Config2__OptionId__r.Family , Apttus_Config2__ConfigurationId__r.APTS_Comparative_Quote__c, DestinationCode__c, Product_Code__c, APTS_Total_Course_Weeks__c, Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.ComparativeQuote__c, Apttus_Config2__ProductId__c, Apttus_Config2__Description__c, Departure_Point__c, Apttus_Config2__StartDate__c, Apttus_Config2__ProductId__r.Family, Apttus_Config2__ConfigurationId__r.APTS_Total_Count_FTEFX__c, Apttus_Config2__LineNumber__c
                                                            from Apttus_Config2__LineItem__c 
                                                            where Apttus_Config2__ConfigurationId__c = :configuration.Id ORDER BY Apttus_Config2__LineNumber__c];

        return cartLineItemList;
    }

    /*
    Description : common method to get Product list by Product Group Name.
    Created by : Husen sayyed
    Created Date : 10-Oct-2017
    */
    private static List<Apttus_Config2__ProductGroupMember__c> getProducts(Set<String> productGroupNameSet){
        List<Apttus_Config2__ProductGroupMember__c> productGroupMemberList = new List<Apttus_Config2__ProductGroupMember__c>();
        
        for(Apttus_Config2__ProductGroupMember__c productGroupMemberRecord : [select Id, Apttus_Config2__ProductId__c, Apttus_Config2__ProductGroupId__c, Apttus_Config2__ProductGroupId__r.Name from Apttus_Config2__ProductGroupMember__c where Apttus_Config2__ProductGroupId__r.Name in : productGroupNameSet]){
            productGroupMemberList.add(productGroupMemberRecord);
        } 

        return productGroupMemberList;       
    }

    /*
    Method : checkPriceOverrideEditable
    Description :Restrict users to Override Prices
    Created By : Mitul Parmar
    Created Date: 03-Oct-2017
    */
    public static boolean checkPriceOverrideEditable(Apttus_Config2.ProductConfiguration cart) {

        boolean returnFlag = TRUE;

        system.debug('Inside checkPriceOverrideEditable : '+returnFlag);
        //List<Apttus_Config2__LineItem__c>  lineItemList = getLineItemData(cart);lineItemList

        for(Apttus_Config2__LineItem__c lineItem : lineItemList){

            //for all changed line Item Status (Amended)
            if((lineItem.Apttus_Config2__AdjustmentType__c == APTS_Constants.PRODUCT_ADJUSTMENT_TYPE_PRICE_OVERRIDE 
                && !lineItem.Apttus_Config2__OptionId__r.APTS_PriceOverrideAllowed__c) 
            || (lineItem.Apttus_Config2__AdjustmentType__c == APTS_Constants.PRODUCT_ADJUSTMENT_TYPE_PRICE_OVERRIDE 
                && lineItem.Apttus_Config2__OptionId__r.APTS_PriceOverrideAllowed__c
                && lineItem.Apttus_Config2__AdjustmentAmount__c < 0)){

                returnFlag = FALSE;
            }
        }

        return returnFlag;
    }

    /*
    Method : checkPriceOverrideEditable
    Description :Restrict users to Override Prices
    Created By : Mitul Parmar
    Created Date: 03-Oct-2017
    */
    public static boolean checkQuantityDestionationAccomodation(Apttus_Config2.ProductConfiguration cart) {

        boolean returnFlag = TRUE;
        boolean initialCheckFlag = FALSE;
        system.debug('Inside checkQuantityDestionationAccomodation : '+returnFlag);
        //List<Apttus_Config2__LineItem__c>  lineItemList = getLineItemData(cart);

        //check for product family junior course && Non Comparitive Quote
        for(Apttus_Config2__LineItem__c lineItem : lineItemList){
            if(lineItem.Apttus_Config2__OptionId__r.Family == APTS_Constants.PRODUCT_FAMILY_JUNIOR_COURSES && !lineItem.Apttus_Config2__ConfigurationId__r.APTS_Comparative_Quote__c){
                initialCheckFlag = TRUE;
            }
        }

        if(initialCheckFlag){

            Map<String,Double> accomodationSubTypeQuantity = new Map<String,Double>();

            for(Apttus_Config2__LineItem__c lineItem : lineItemList){

                //system.debug('Product Country__c :--- '+lineItem.Apttus_Config2__AttributeValueId__r.Country__c);
                //system.debug('Product Type :--- '+lineItem.APTS_Product_Type__c);
                //system.debug('Product Sub Type :--- '+lineItem.Product_Subtype__c);

                //for all changed line Item Status (Amended)
                if(lineItem.Apttus_Config2__AttributeValueId__r.Country__c == APTS_Constants.PRODUCT_COUNTRY_UK_VALUE 
                    && lineItem.APTS_Product_Type__c == APTS_Constants.PRODUCT_TYPE_ACCOMODATION
                    && (lineItem.Product_Subtype__c == APTS_Constants.PRODUCT_SUB_TYPE_HOST_FAMILY || lineItem.Product_Subtype__c == APTS_Constants.PRODUCT_SUB_TYPE_HOTEL|| lineItem.Product_Subtype__c == APTS_Constants.PRODUCT_SUB_TYPE_RESIDENCE)){
                    
                    //check for host family and if it has some value show error
                    if(accomodationSubTypeQuantity.containsKey(APTS_Constants.PRODUCT_SUB_TYPE_HOST_FAMILY)){
                        Double tempQuantity = accomodationSubTypeQuantity.get(APTS_Constants.PRODUCT_SUB_TYPE_HOST_FAMILY) + lineItem.Apttus_Config2__Quantity__c;
                        accomodationSubTypeQuantity.put(APTS_Constants.PRODUCT_SUB_TYPE_HOST_FAMILY,tempQuantity);
                    }
                    else if(lineItem.Product_Subtype__c == APTS_Constants.PRODUCT_SUB_TYPE_HOST_FAMILY){
                        accomodationSubTypeQuantity.put(APTS_Constants.PRODUCT_SUB_TYPE_HOST_FAMILY,lineItem.Apttus_Config2__Quantity__c);
                    }

                    //check for hotel and if it has some value show error
                    if(accomodationSubTypeQuantity.containsKey(APTS_Constants.PRODUCT_SUB_TYPE_HOTEL)){
                        Double tempQuantity = accomodationSubTypeQuantity.get(APTS_Constants.PRODUCT_SUB_TYPE_HOTEL) + lineItem.Apttus_Config2__Quantity__c;
                        accomodationSubTypeQuantity.put(APTS_Constants.PRODUCT_SUB_TYPE_HOTEL,tempQuantity);
                    }
                    else if(lineItem.Product_Subtype__c == APTS_Constants.PRODUCT_SUB_TYPE_HOTEL){
                        accomodationSubTypeQuantity.put(APTS_Constants.PRODUCT_SUB_TYPE_HOTEL,lineItem.Apttus_Config2__Quantity__c);
                    }

                    //check for hotel and if it has some value show error
                    if(accomodationSubTypeQuantity.containsKey(APTS_Constants.PRODUCT_SUB_TYPE_RESIDENCE)){
                        Double tempQuantity = accomodationSubTypeQuantity.get(APTS_Constants.PRODUCT_SUB_TYPE_RESIDENCE) + lineItem.Apttus_Config2__Quantity__c;
                        accomodationSubTypeQuantity.put(APTS_Constants.PRODUCT_SUB_TYPE_RESIDENCE,tempQuantity);
                    }
                    else if(lineItem.Product_Subtype__c == APTS_Constants.PRODUCT_SUB_TYPE_RESIDENCE){
                        accomodationSubTypeQuantity.put(APTS_Constants.PRODUCT_SUB_TYPE_RESIDENCE,lineItem.Apttus_Config2__Quantity__c);
                    }
                }
            }

            //check for populated map and if the value of any attribute increase more than 4 than show error
            for (Double quantityValue : accomodationSubTypeQuantity.values()){
                if(quantityValue > 4){
                    returnFlag = FALSE;
                }
            }
        }

        return returnFlag;
    }

    /*
    Method : checkPriceOverrideEditable
    Description :Restrict users to Override Prices
    Created By : Mitul Parmar
    Created Date: 03-Oct-2017
    */
    public static boolean validateCartTotalDiscount(Apttus_Config2.ProductConfiguration cart) {

        boolean returnFlag = TRUE;

        system.debug('Inside validateCartTotalDiscount : '+returnFlag);

        Apttus_Config2__ProductConfiguration__c configuration = cart.getConfigSO();
                //Added to Check Quote to Compare validations
        if (!validateCompareQuoteDiscount(cart,configuration)) {
            return FALSE;
        }

        Apttus_Config2__SummaryGroup__c grandTotalSummary = [select id, Apttus_Config2__NetAdjustmentPercent__c from Apttus_Config2__SummaryGroup__c
                                                                where Apttus_Config2__ConfigurationId__c =: configuration.Id AND Apttus_Config2__LineType__c =: APTS_Constants.VALIDATE_CART_GRAND_TOTAL];

        system.debug('Apttus_Config2__NetAdjustmentPercent__c :--- '+(grandTotalSummary.Apttus_Config2__NetAdjustmentPercent__c*-1));
        system.debug('Grand Total Discount limit :--- '+System.Label.APTS_Grand_Total_Discount_Limit);
        system.debug('Grand Total Discount Error Message :--- '+System.Label.APTS_Grand_Total_Discount_Error);

        Double totalDiscountLimit = Double.valueOf(System.Label.APTS_Grand_Total_Discount_Limit);
        //check if the discount amount can be more than defined amount
        if(grandTotalSummary != NULL && grandTotalSummary.Apttus_Config2__NetAdjustmentPercent__c != NULL 
            && (grandTotalSummary.Apttus_Config2__NetAdjustmentPercent__c*-1) > 0 && (totalDiscountLimit < (grandTotalSummary.Apttus_Config2__NetAdjustmentPercent__c*-1))){            
            returnFlag = FALSE;
        }
        
        return returnFlag;
    }
    
       public static Boolean validateCompareQuoteDiscount(Apttus_Config2.ProductConfiguration cart,Apttus_Config2__ProductConfiguration__c configuration)
    {
        boolean returnFlag = TRUE;
        Map<Decimal,Decimal> bundleWiseTotal=new Map<Decimal,Decimal>();
        //Apttus_QPConfig__Proposald__c
        Apttus_Proposal__Proposal__c  Quote=[select id,name, ComparativeQuote__c
        FROM Apttus_Proposal__Proposal__c where id=:configuration.Apttus_QPConfig__Proposald__c];
        system.debug('validateCompareQuoteDiscount :--- ');
        if (Quote.ComparativeQuote__c) {
            system.debug('ComparativeQuote__c :--- ');
            Double totalDiscountLimit = Double.valueOf(System.Label.APTS_Grand_Total_Discount_Limit);
            for (Apttus_Config2__LineItem__c  lineItem : lineItemList) {
                if (!bundleWiseTotal.containsKey(lineItem.Apttus_Config2__LineNumber__c)) {
                    calculateBundleWiseTotal(lineItem.Apttus_Config2__LineNumber__c,bundleWiseTotal);
                }
                system.debug('Inside for loop for god sake '+ lineItem.Apttus_Config2__NetPrice__c);
                system.debug('Inside for loop for god sake Product Type'+ lineItem.APTS_Product_Type__c);
                system.debug('Inside for loop for god sake  Type'+ lineItem.Apttus_Config2__LineType__c);
                if (lineItem.Apttus_Config2__LineType__c==APTS_Constants.PROPOSALLINEITEM_TYPE_PRODUCTSERVICE
                        && discountAmountAllowed( bundleWiseTotal.get(lineItem.Apttus_Config2__LineNumber__c),totalDiscountLimit)  > lineItem.Apttus_Config2__NetPrice__c) {
                    returnFlag=False;
                    system.debug('^^^^^^^^^^^^^^^^^ Failed ');
                    return returnFlag;
                }
            }
            return returnFlag;

        }
        else
        {
            return returnFlag;
        }

    }

    public static Decimal discountAmountAllowed(Decimal ExtendedPrice,Double AllowedDiscount)
    {
        system.debug('Aloowed discount '+ExtendedPrice*(AllowedDiscount/100));
        return ExtendedPrice*(AllowedDiscount/100);
    }
    
     public static Map<Decimal,Decimal> calculateBundleWiseTotal(Decimal LineNumber, Map<Decimal,Decimal> bundleWiseTotal)
    {
        Decimal total;
        for (Apttus_Config2__LineItem__c  lineItem : lineItemList) {
            if (lineItem.Apttus_Config2__LineNumber__c==LineNumber &&  !lineItem.Apttus_Config2__IsOptional__c && lineItem.Apttus_Config2__LineType__c != APTS_Constants.PROPOSALLINEITEM_TYPE_PRODUCTSERVICE) {
                if (!bundleWiseTotal.containsKey(LineNumber)) {
                    bundleWiseTotal.put(LineNumber,lineItem.Non_Discounted_Price__c);
                }
                else
                {
                    bundleWiseTotal.put(LineNumber,(bundleWiseTotal.get(LineNumber)+lineItem.Non_Discounted_Price__c));
                }
            }
        }
        system.debug('LineNumber  '+LineNumber +'And its Total is'+bundleWiseTotal.get(LineNumber));
        return bundleWiseTotal;
    }

    /*
    Method : validateCartByDestinationandTotalCourceWeek
    Description : Restrict users to add Australia Overseas Health Cover Product
    Created By : Husen Sayyed
    Created Date: 10-Oct-2017
    */
    public static boolean validateCartByDestinationandTotalCourceWeek(Apttus_Config2.ProductConfiguration cart) {

        boolean returnFlag = TRUE;
        set<String> destinationCodeSet = new set<String>{'AU-BRS','AU-SYD','AU-PER'};
        map<Decimal, Apttus_Config2__LineItem__c> bundleWiseLineCourseItemsMap = new map<Decimal, Apttus_Config2__LineItem__c>();
        map<Decimal, Apttus_Config2__LineItem__c> bundleWiseLineOSHCItemsMap = new map<Decimal, Apttus_Config2__LineItem__c>();
        
        for(Apttus_Config2__LineItem__c  lineItem : lineItemList){
            if(!lineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.ComparativeQuote__c  && destinationCodeSet.contains(lineItem.DestinationCode__c) && lineItem.Apttus_Config2__ProductId__r.Family == 'Destination' && lineItem.APTS_Total_Course_Weeks__c > 12){
                if(lineItem.Product_Code__c == 'OSHC'){
                    returnFlag = true; 
                }else{
                    returnFlag = false;
                }                           
            }else if(lineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.ComparativeQuote__c && destinationCodeSet.contains(lineItem.DestinationCode__c) && lineItem.Apttus_Config2__ProductId__r.Family == 'Destination'){
                if(lineItem.APTS_Product_Type__c == 'Course' && lineItem.Apttus_Config2__Quantity__c > 12){
                    bundleWiseLineCourseItemsMap.put(lineItem.Apttus_Config2__LineNumber__c, lineItem);
                }
                if(lineItem.Product_Code__c == 'OSHC'){
                    bundleWiseLineOSHCItemsMap.put(lineItem.Apttus_Config2__LineNumber__c, lineItem);
                }
            }
        }
        system.debug('==bundleWiseLineCourseItemsMap=='+bundleWiseLineCourseItemsMap);
        system.debug('==bundleWiseLineOSHCItemsMap=='+bundleWiseLineOSHCItemsMap);
        if(!bundleWiseLineCourseItemsMap.isEmpty()){
            if(bundleWiseLineOSHCItemsMap.isEmpty()){
                returnFlag = false;
            }
            else{
                for(Decimal  lineItemNumber : bundleWiseLineCourseItemsMap.keySet()){
                    if(bundleWiseLineOSHCItemsMap.get(lineItemNumber) == null){
                        returnFlag = false; 
                    }else{
                        returnFlag = true;
                    }
                }
            }
        }
        
        return returnFlag;
    }
    
    /*
    Method : validateCartByDestinationandStartDate
    Description : Fixed Fare flights cannot be booked for certain amount of time before departures.
    Created By : Husen Sayyed
    Created Date: 10-Oct-2017
    */
    public static boolean validateCartByDestinationandStartDate(Apttus_Config2.ProductConfiguration cart) {

        boolean returnFlag = TRUE;
        Set<String> productGroupNameSet = new set<String>{'Northern Hemisphere', 'Southern Hemisphere'};
        map<Id, String> productIdGroupNameMap = new map<Id, String>();
        map<Decimal, Apttus_Config2__LineItem__c> accommodationBundleLineItemsMap = new map<Decimal, Apttus_Config2__LineItem__c>();
        
        for(Apttus_Config2__LineItem__c  lineItem : lineItemList){
            if(lineItem.Apttus_Config2__ConfigurationId__r.APTS_Total_Count_FTEFX__c > 0){
              if(lineItem.APTS_Product_Type__c == 'Accommodation'){
                if(!accommodationBundleLineItemsMap.isEmpty() && accommodationBundleLineItemsMap.containskey(lineItem.Apttus_Config2__LineNumber__c)){
                    if(lineItem.Apttus_Config2__StartDate__c < accommodationBundleLineItemsMap.get(lineItem.Apttus_Config2__LineNumber__c).Apttus_Config2__StartDate__c){
                        accommodationBundleLineItemsMap.remove(lineItem.Apttus_Config2__LineNumber__c);
                        accommodationBundleLineItemsMap.put(lineItem.Apttus_Config2__LineNumber__c, lineItem);
                    }
                }else{
                    accommodationBundleLineItemsMap.put(lineItem.Apttus_Config2__LineNumber__c, lineItem);
                }
              }
            }
        }
        
        if(!accommodationBundleLineItemsMap.isEmpty()){
            for(Apttus_Config2__ProductGroupMember__c productGroupMemberRecord : getProducts(productGroupNameSet)){
                productIdGroupNameMap.put(productGroupMemberRecord.Apttus_Config2__ProductId__c, productGroupMemberRecord.Apttus_Config2__ProductGroupId__r.Name);
            }
            system.debug('==productIdGroupNameMap=='+productIdGroupNameMap);
            system.debug('==accommodationBundleLineItemsMap=='+accommodationBundleLineItemsMap);
            if(!productIdGroupNameMap.isEmpty()){
                for(Apttus_Config2__LineItem__c  lineItem : lineItemList){
                    if(!String.isBlank(lineItem.Departure_Point__c) && productIdGroupNameMap.containsKey(lineItem.Apttus_Config2__ProductId__c) && lineItem.Product_Code__c == 'FTEFX' && accommodationBundleLineItemsMap.containsKey(lineItem.Apttus_Config2__LineNumber__c)){
                        if(productIdGroupNameMap.get(lineItem.Apttus_Config2__ProductId__c) == 'Northern Hemisphere' && accommodationBundleLineItemsMap.get(lineItem.Apttus_Config2__LineNumber__c).Apttus_Config2__StartDate__c != null && System.today().daysBetween(accommodationBundleLineItemsMap.get(lineItem.Apttus_Config2__LineNumber__c).Apttus_Config2__StartDate__c) < 21 ){
                            system.debug('==daysBetween=='+System.today().daysBetween(accommodationBundleLineItemsMap.get(lineItem.Apttus_Config2__LineNumber__c).Apttus_Config2__StartDate__c));
                            returnFlag = false; 
                        }else if(productIdGroupNameMap.get(lineItem.Apttus_Config2__ProductId__c) == 'Southern Hemisphere' && accommodationBundleLineItemsMap.get(lineItem.Apttus_Config2__LineNumber__c).Apttus_Config2__StartDate__c != null && System.today().daysBetween(accommodationBundleLineItemsMap.get(lineItem.Apttus_Config2__LineNumber__c).Apttus_Config2__StartDate__c) < 42 ){
                            returnFlag = false; 
                        }                           
                    }
                } 
            }
        }  
        
        return returnFlag;
    }
}