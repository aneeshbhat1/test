/**************************************************************************************
Apex Class Name    : APTS_EFPricingCallback_Test
Version            : 1.0
Created Date       : September 26 2017
Function           : Created for code coverage on APTS_EFPricingCallback.
Modification Log   :
------------------------------------------------------------------------------
 * Developer                   Date                   Description
 * ----------------------------------------------------------------------------
 * Mitul Parmar                 09/26/2017              Original Version
*******************************************************************************/
@isTest
public class APTS_EFPricingCallback_Test{

	private static final String LINE_TYPE_PRODUCT_SERVICE = 'Product/Service';
    private static final String LINE_TYPE_OPTION = 'Option';
    private static final String LINE_STATUS_NEW = 'New';
    private static final String PRICE_TYPE_RECURRING = 'Recurring';
    private static final String CHARGE_TYPE_OVERAGE = 'Overage';
    private static final String CHARGE_TYPE_INCLUDED_UNITS = 'Included Units';
    private static final String CHARGE_TYPE_COMMIT = 'Commit';
    private static final String CHARGE_TYPE_INCLUDED = 'Included';
    private static final String LINE_STATUS_CANCELLED = 'Cancelled';

	public static testMethod void testCoursePricingLogic(){
	
		//add pricing call back entry in custom setting
		Apttus_Config2__ConfigCustomClasses__c custSetting = new Apttus_Config2__ConfigCustomClasses__c();
	    custSetting.Apttus_Config2__PricingCallbackClass__c = 'APTS_EFPricingCallback';
	    custSetting.Name = 'System Properties1';
	    insert custSetting;
	        
	    //add custom setting for config line item custom fields in PCB
	    List<Apttus_Config2__ConfigLineItemCustomFields__c> custsettinglist = new List<Apttus_Config2__ConfigLineItemCustomFields__c>();
	    Apttus_Config2__ConfigLineItemCustomFields__c custSetting1 = new Apttus_Config2__ConfigLineItemCustomFields__c();
	    custSetting1.Apttus_Config2__CustomFieldNames__c = 'Apttus_Config2__PriceListId__r.Brackets_Threshold__c,Apttus_Config2__OptionId__r.Apts_CoursePricing__c,Apttus_Config2__ConfigurationId__r.APTS_Total_Course_Weeks__c,DestinationCode__c';
	    custSetting1.Apttus_Config2__CustomFieldNames2__c = 'Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.ComparativeQuote__c,Apttus_Config2__OptionId__r.Apts_TI_Pricing__c,Apttus_Config2__PriceListId__r.Apts_BracketsThresholdTI__c,Apttus_Config2__OptionId__r.ProductSubtype__c';
        custSetting1.Name = 'System Properties2';
	    custsettinglist.add(custSetting1);
	    insert custsettinglist;

	    Test.startTest();
        //get system admin profile
        Profile SystemAdminProfile = APTS_TestDataUtility.getProfile('System Administrator');
        System.debug('***TEST CLASS : SystemAdminProfile===>'+SystemAdminProfile);
    
        //insert User
        User testUser = APTS_TestDataUtility.createUser(SystemAdminProfile.ID);
        System.debug('***TEST CLASS : testUser===>'+testUser);
    
        System.runAs(testUser) {

        	//Get Standard Price Book Id    
            Id stdPriceBookId = Test.getStandardPricebookId();
            system.debug('*******stdPricebookId====>' + stdPriceBookId);

        	//create price list
            Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c(Name = 'APTPS TST PriceList 1', Apttus_Config2__Active__c = true, Brackets_Threshold__c = 8, Apts_BracketsThresholdTI__c = 3);
            insert priceList;
            System.debug('***TEST CLASS : priceList===>'+priceList);

            //Create Product
            list<Product2> productsList = new list<Product2>();
            Product2 product1 = new product2(Name = 'Auckland 1', ProductCode = 'NZ-AUC', Apttus_Config2__ConfigurationType__c = 'Bundle', IsActive = true, Apttus_Config2__HasOptions__c = true, Apttus_Config2__Customizable__c = true, Apttus_Config2__ProductType__c = 'Destination'); 
            productsList.add(product1);
            System.debug('***TEST CLASS : PRODUCT 1===>'+product1);
            
            Product2 product2 = new product2(Name = 'Intensive Course', ProductCode = 'NZ-AUC', Apttus_Config2__ConfigurationType__c = 'Option', IsActive = true, Apttus_Config2__ProductType__c = 'Course', Apts_CoursePricing__c = TRUE); 
            productsList.add(product2);
            System.debug('***TEST CLASS : PRODUCT 2===>'+product2);
            
            Product2 product3 = new product2(Name = 'Auckland 2', ProductCode = 'NZ-AUK', Apttus_Config2__ConfigurationType__c = 'Bundle', IsActive = true, Apttus_Config2__HasOptions__c = true, Apttus_Config2__Customizable__c = true, Apttus_Config2__ProductType__c = 'Destination'); 
            productsList.add(product3);
            System.debug('***TEST CLASS : PRODUCT 3===>'+product3);
            
            Product2 product4 = new product2(Name = 'Basic Course', ProductCode = 'NZ-AUK', Apttus_Config2__ConfigurationType__c = 'Option', IsActive = true, Apttus_Config2__ProductType__c = 'Course', Apts_CoursePricing__c = TRUE); 
            productsList.add(product4);
            System.debug('***TEST CLASS : PRODUCT 4===>'+product4);

            Product2 product5 = new product2(Name = 'Auckland 3', ProductCode = 'NZ-AUZ', Apttus_Config2__ConfigurationType__c = 'Bundle', IsActive = true, Apttus_Config2__HasOptions__c = true, Apttus_Config2__Customizable__c = true, Apttus_Config2__ProductType__c = 'Destination'); 
            productsList.add(product5);
            System.debug('***TEST CLASS : PRODUCT 5===>'+product5);
            
            Product2 product6 = new product2(Name = 'Junior Course', ProductCode = 'NZ-AUZ', Apttus_Config2__ConfigurationType__c = 'Option', IsActive = true, Apttus_Config2__ProductType__c = 'Course', Apts_CoursePricing__c = TRUE); 
            productsList.add(product6);
            System.debug('***TEST CLASS : PRODUCT 6===>'+product6);

            Product2 product7 = new product2(Name = 'Travel Insurance', ProductCode = 'NZ-TRI', Apttus_Config2__ConfigurationType__c = 'Option', IsActive = true, Apts_TI_Pricing__c = TRUE); 
            productsList.add(product7);
            System.debug('***TEST CLASS : PRODUCT 7===>'+product7);

            insert productsList;
            System.debug('***TEST CLASS : PRODUCTLIST===>'+productsList);

            //create price dimension
            list<Apttus_Config2__PriceDimension__c> priceDimensionList = new list<Apttus_Config2__PriceDimension__c>();
            Apttus_Config2__PriceDimension__c priceDimension1 = new Apttus_Config2__PriceDimension__c(name='Quantity', Apttus_Config2__Type__c = 'Standard', Apttus_Config2__ContextType__c = 'Line Item', Apttus_Config2__BusinessObject__c = 'Apttus_Config2__LineItem__c', Apttus_Config2__Datasource__c = 'Apttus_Config2__Quantity__c');
            priceDimensionList.add(priceDimension1);

            Apttus_Config2__PriceDimension__c priceDimension2 = new Apttus_Config2__PriceDimension__c(name='Destination Code', Apttus_Config2__Type__c = 'Standard', Apttus_Config2__ContextType__c = 'Line Item', Apttus_Config2__BusinessObject__c = 'Apttus_Config2__LineItem__c', Apttus_Config2__Datasource__c = 'DestinationCode__c');
            priceDimensionList.add(priceDimension2);
            insert priceDimensionList;

            //create price list items
            list<Apttus_Config2__PriceListItem__c> priceListItems = new list<Apttus_Config2__PriceListItem__c>();
            Apttus_Config2__PriceListItem__c priceListItem1 = new Apttus_Config2__PriceListItem__c(Apttus_Config2__PriceListId__c = priceList.Id, Apttus_Config2__ListPrice__c = 1000, Apttus_Config2__ProductId__c = product1.Id, Apttus_Config2__ChargeType__c = 'Standard Price');
            priceListItems.add(priceListItem1);
            System.debug('***TEST CLASS : priceListItem1===>'+priceListItem1);
            
            Apttus_Config2__PriceListItem__c priceListItem2 = new Apttus_Config2__PriceListItem__c(Apttus_Config2__PriceListId__c = priceList.Id, Apttus_Config2__ListPrice__c = 1000, Apttus_Config2__ProductId__c = product2.Id, Apttus_Config2__ChargeType__c = 'Standard Price');
            priceListItems.add(priceListItem2);
            System.debug('***TEST CLASS : priceListItem2===>'+priceListItem2);
            
            Apttus_Config2__PriceListItem__c priceListItem3 = new Apttus_Config2__PriceListItem__c(Apttus_Config2__PriceListId__c = priceList.Id, Apttus_Config2__ListPrice__c = 1000, Apttus_Config2__ProductId__c = product3.Id, Apttus_Config2__ChargeType__c = 'Standard Price');
            priceListItems.add(priceListItem3);
            System.debug('***TEST CLASS : priceListItem3===>'+priceListItem3);
            
            Apttus_Config2__PriceListItem__c priceListItem4 = new Apttus_Config2__PriceListItem__c(Apttus_Config2__PriceListId__c = priceList.Id, Apttus_Config2__ListPrice__c = 1000, Apttus_Config2__ProductId__c = product4.Id, Apttus_Config2__ChargeType__c = 'Standard Price');
            priceListItems.add(priceListItem4);
            System.debug('***TEST CLASS : priceListItem4===>'+priceListItem4);

            Apttus_Config2__PriceListItem__c priceListItem5 = new Apttus_Config2__PriceListItem__c(Apttus_Config2__PriceListId__c = priceList.Id, Apttus_Config2__ListPrice__c = 1000, Apttus_Config2__ProductId__c = product5.Id, Apttus_Config2__ChargeType__c = 'Standard Price');
            priceListItems.add(priceListItem5);
            System.debug('***TEST CLASS : priceListItem5===>'+priceListItem5);
            
            Apttus_Config2__PriceListItem__c priceListItem6 = new Apttus_Config2__PriceListItem__c(Apttus_Config2__PriceListId__c = priceList.Id, Apttus_Config2__ListPrice__c = 1000, Apttus_Config2__ProductId__c = product6.Id, Apttus_Config2__ChargeType__c = 'Standard Price');
            priceListItems.add(priceListItem6);
            System.debug('***TEST CLASS : priceListItem6===>'+priceListItem6);

            Apttus_Config2__PriceListItem__c priceListItem7 = new Apttus_Config2__PriceListItem__c(Apttus_Config2__PriceListId__c = priceList.Id, Apttus_Config2__ListPrice__c = 200, Apttus_Config2__ProductId__c = product7.Id, Apttus_Config2__ChargeType__c = 'Standard Price');
            priceListItems.add(priceListItem7);
            System.debug('***TEST CLASS : priceListItem6===>'+priceListItem7);

            insert priceListItems;
            System.debug('***TEST CLASS : priceListItems===>'+priceListItems);

            //create price matrix entrt
            list<Apttus_Config2__PriceMatrix__c> prixeMatrixList = new list<Apttus_Config2__PriceMatrix__c>();
            Apttus_Config2__PriceMatrix__c priceMatrix1 = new Apttus_Config2__PriceMatrix__c(Apttus_Config2__PriceListItemId__c = priceListItem1.Id, Apttus_Config2__Sequence__c = 1,Apttus_Config2__MatrixType__c = 'Dimension', Apttus_Config2__Dimension1Id__c = priceDimension1.Id, Apttus_Config2__Dimension1ValueType__c = 'Cumulative Range', Apttus_Config2__Dimension2Id__c = priceDimension2.Id, Apttus_Config2__Dimension2ValueType__c = 'Discrete');
            prixeMatrixList.add(priceMatrix1);

            Apttus_Config2__PriceMatrix__c priceMatrix2 = new Apttus_Config2__PriceMatrix__c(Apttus_Config2__PriceListItemId__c = priceListItem2.Id, Apttus_Config2__Sequence__c = 1,Apttus_Config2__MatrixType__c = 'Dimension', Apttus_Config2__Dimension1Id__c = priceDimension1.Id, Apttus_Config2__Dimension1ValueType__c = 'Cumulative Range', Apttus_Config2__Dimension2Id__c = priceDimension2.Id, Apttus_Config2__Dimension2ValueType__c = 'Discrete');
            prixeMatrixList.add(priceMatrix2);

            Apttus_Config2__PriceMatrix__c priceMatrix3 = new Apttus_Config2__PriceMatrix__c(Apttus_Config2__PriceListItemId__c = priceListItem3.Id, Apttus_Config2__Sequence__c = 1,Apttus_Config2__MatrixType__c = 'Dimension', Apttus_Config2__Dimension1Id__c = priceDimension1.Id, Apttus_Config2__Dimension1ValueType__c = 'Cumulative Range', Apttus_Config2__Dimension2Id__c = priceDimension2.Id, Apttus_Config2__Dimension2ValueType__c = 'Discrete');
            prixeMatrixList.add(priceMatrix3);

            Apttus_Config2__PriceMatrix__c priceMatrix4 = new Apttus_Config2__PriceMatrix__c(Apttus_Config2__PriceListItemId__c = priceListItem4.Id, Apttus_Config2__Sequence__c = 1,Apttus_Config2__MatrixType__c = 'Dimension', Apttus_Config2__Dimension1Id__c = priceDimension1.Id, Apttus_Config2__Dimension1ValueType__c = 'Cumulative Range', Apttus_Config2__Dimension2Id__c = priceDimension2.Id, Apttus_Config2__Dimension2ValueType__c = 'Discrete');
            prixeMatrixList.add(priceMatrix4);

            Apttus_Config2__PriceMatrix__c priceMatrix5 = new Apttus_Config2__PriceMatrix__c(Apttus_Config2__PriceListItemId__c = priceListItem5.Id, Apttus_Config2__Sequence__c = 1,Apttus_Config2__MatrixType__c = 'Dimension', Apttus_Config2__Dimension1Id__c = priceDimension1.Id, Apttus_Config2__Dimension1ValueType__c = 'Cumulative Range', Apttus_Config2__Dimension2Id__c = priceDimension2.Id, Apttus_Config2__Dimension2ValueType__c = 'Discrete');
            prixeMatrixList.add(priceMatrix5);

            Apttus_Config2__PriceMatrix__c priceMatrix6 = new Apttus_Config2__PriceMatrix__c(Apttus_Config2__PriceListItemId__c = priceListItem6.Id, Apttus_Config2__Sequence__c = 1,Apttus_Config2__MatrixType__c = 'Dimension', Apttus_Config2__Dimension1Id__c = priceDimension1.Id, Apttus_Config2__Dimension1ValueType__c = 'Cumulative Range', Apttus_Config2__Dimension2Id__c = priceDimension2.Id, Apttus_Config2__Dimension2ValueType__c = 'Discrete');
            prixeMatrixList.add(priceMatrix6);

            Apttus_Config2__PriceMatrix__c priceMatrix7 = new Apttus_Config2__PriceMatrix__c(Apttus_Config2__PriceListItemId__c = priceListItem7.Id, Apttus_Config2__Sequence__c = 1,Apttus_Config2__MatrixType__c = 'Dimension', Apttus_Config2__Dimension1Id__c = priceDimension1.Id, Apttus_Config2__Dimension1ValueType__c = 'Cumulative Range', Apttus_Config2__Dimension2Id__c = priceDimension2.Id, Apttus_Config2__Dimension2ValueType__c = 'Discrete');
            prixeMatrixList.add(priceMatrix7);

            insert prixeMatrixList;

            list<Apttus_Config2__PriceMatrixEntry__c> prixeMatrixEntryList = new list<Apttus_Config2__PriceMatrixEntry__c>();
            Apttus_Config2__PriceMatrixEntry__c priceMatrixEntry11 = new Apttus_Config2__PriceMatrixEntry__c(Apttus_Config2__PriceMatrixId__c = priceMatrix1.Id, Apttus_Config2__Sequence__c = 1, Apttus_Config2__PriceOverride__c = 495.00, Apttus_Config2__AdjustmentAmount__c = 495.00, Apttus_Config2__AdjustmentType__c = 'List Price Override', Apttus_Config2__Dimension1Value__c = '8', Apttus_Config2__Dimension2Value__c = 'NZ-AUC');
            prixeMatrixEntryList.add(priceMatrixEntry11);

            Apttus_Config2__PriceMatrixEntry__c priceMatrixEntry12 = new Apttus_Config2__PriceMatrixEntry__c(Apttus_Config2__PriceMatrixId__c = priceMatrix1.Id, Apttus_Config2__Sequence__c = 2, Apttus_Config2__PriceOverride__c = 295.00, Apttus_Config2__AdjustmentAmount__c = 295.00, Apttus_Config2__AdjustmentType__c = 'List Price Override', Apttus_Config2__Dimension1Value__c = '99', Apttus_Config2__Dimension2Value__c = 'NZ-AUC');
            prixeMatrixEntryList.add(priceMatrixEntry12);

            Apttus_Config2__PriceMatrixEntry__c priceMatrixEntry21 = new Apttus_Config2__PriceMatrixEntry__c(Apttus_Config2__PriceMatrixId__c = priceMatrix2.Id, Apttus_Config2__Sequence__c = 1, Apttus_Config2__PriceOverride__c = 595.00, Apttus_Config2__AdjustmentAmount__c = 595.00, Apttus_Config2__AdjustmentType__c = 'List Price Override', Apttus_Config2__Dimension1Value__c = '8', Apttus_Config2__Dimension2Value__c = 'NZ-AUC');
            prixeMatrixEntryList.add(priceMatrixEntry21);

            Apttus_Config2__PriceMatrixEntry__c priceMatrixEntry22 = new Apttus_Config2__PriceMatrixEntry__c(Apttus_Config2__PriceMatrixId__c = priceMatrix2.Id, Apttus_Config2__Sequence__c = 2, Apttus_Config2__PriceOverride__c = 395.00, Apttus_Config2__AdjustmentAmount__c = 395.00, Apttus_Config2__AdjustmentType__c = 'List Price Override', Apttus_Config2__Dimension1Value__c = '99', Apttus_Config2__Dimension2Value__c = 'NZ-AUC');
            prixeMatrixEntryList.add(priceMatrixEntry22);

            Apttus_Config2__PriceMatrixEntry__c priceMatrixEntry31 = new Apttus_Config2__PriceMatrixEntry__c(Apttus_Config2__PriceMatrixId__c = priceMatrix3.Id, Apttus_Config2__Sequence__c = 1, Apttus_Config2__PriceOverride__c = 295.00, Apttus_Config2__AdjustmentAmount__c = 295.00, Apttus_Config2__AdjustmentType__c = 'List Price Override', Apttus_Config2__Dimension1Value__c = '8', Apttus_Config2__Dimension2Value__c = 'NZ-AUK');
            prixeMatrixEntryList.add(priceMatrixEntry31);

            Apttus_Config2__PriceMatrixEntry__c priceMatrixEntry32 = new Apttus_Config2__PriceMatrixEntry__c(Apttus_Config2__PriceMatrixId__c = priceMatrix3.Id, Apttus_Config2__Sequence__c = 2, Apttus_Config2__PriceOverride__c = 195.00, Apttus_Config2__AdjustmentAmount__c = 195.00, Apttus_Config2__AdjustmentType__c = 'List Price Override', Apttus_Config2__Dimension1Value__c = '99', Apttus_Config2__Dimension2Value__c = 'NZ-AUK');
            prixeMatrixEntryList.add(priceMatrixEntry32);

            Apttus_Config2__PriceMatrixEntry__c priceMatrixEntry41 = new Apttus_Config2__PriceMatrixEntry__c(Apttus_Config2__PriceMatrixId__c = priceMatrix4.Id, Apttus_Config2__Sequence__c = 1, Apttus_Config2__PriceOverride__c = 295.00, Apttus_Config2__AdjustmentAmount__c = 295.00, Apttus_Config2__AdjustmentType__c = 'List Price Override', Apttus_Config2__Dimension1Value__c = '8', Apttus_Config2__Dimension2Value__c = 'NZ-AUK');
            prixeMatrixEntryList.add(priceMatrixEntry41);

            Apttus_Config2__PriceMatrixEntry__c priceMatrixEntry42 = new Apttus_Config2__PriceMatrixEntry__c(Apttus_Config2__PriceMatrixId__c = priceMatrix4.Id, Apttus_Config2__Sequence__c = 2, Apttus_Config2__PriceOverride__c = 95.00, Apttus_Config2__AdjustmentAmount__c = 95.00, Apttus_Config2__AdjustmentType__c = 'List Price Override', Apttus_Config2__Dimension1Value__c = '99', Apttus_Config2__Dimension2Value__c = 'NZ-AUK');
            prixeMatrixEntryList.add(priceMatrixEntry42);

            Apttus_Config2__PriceMatrixEntry__c priceMatrixEntry51 = new Apttus_Config2__PriceMatrixEntry__c(Apttus_Config2__PriceMatrixId__c = priceMatrix5.Id, Apttus_Config2__Sequence__c = 1, Apttus_Config2__PriceOverride__c = 295.00, Apttus_Config2__AdjustmentAmount__c = 295.00, Apttus_Config2__AdjustmentType__c = 'List Price Override', Apttus_Config2__Dimension1Value__c = '8', Apttus_Config2__Dimension2Value__c = 'NZ-AUK');
            prixeMatrixEntryList.add(priceMatrixEntry51);

            Apttus_Config2__PriceMatrixEntry__c priceMatrixEntry52 = new Apttus_Config2__PriceMatrixEntry__c(Apttus_Config2__PriceMatrixId__c = priceMatrix5.Id, Apttus_Config2__Sequence__c = 2, Apttus_Config2__PriceOverride__c = 195.00, Apttus_Config2__AdjustmentAmount__c = 195.00, Apttus_Config2__AdjustmentType__c = 'List Price Override', Apttus_Config2__Dimension1Value__c = '99', Apttus_Config2__Dimension2Value__c = 'NZ-AUK');
            prixeMatrixEntryList.add(priceMatrixEntry52);

            Apttus_Config2__PriceMatrixEntry__c priceMatrixEntry61 = new Apttus_Config2__PriceMatrixEntry__c(Apttus_Config2__PriceMatrixId__c = priceMatrix6.Id, Apttus_Config2__Sequence__c = 1, Apttus_Config2__PriceOverride__c = 295.00, Apttus_Config2__AdjustmentAmount__c = 295.00, Apttus_Config2__AdjustmentType__c = 'List Price Override', Apttus_Config2__Dimension1Value__c = '8', Apttus_Config2__Dimension2Value__c = 'NZ-AUZ');
            prixeMatrixEntryList.add(priceMatrixEntry61);

            Apttus_Config2__PriceMatrixEntry__c priceMatrixEntry62 = new Apttus_Config2__PriceMatrixEntry__c(Apttus_Config2__PriceMatrixId__c = priceMatrix6.Id, Apttus_Config2__Sequence__c = 2, Apttus_Config2__PriceOverride__c = 95.00, Apttus_Config2__AdjustmentAmount__c = 95.00, Apttus_Config2__AdjustmentType__c = 'List Price Override', Apttus_Config2__Dimension1Value__c = '99', Apttus_Config2__Dimension2Value__c = 'NZ-AUZ');
            prixeMatrixEntryList.add(priceMatrixEntry62);

            Apttus_Config2__PriceMatrixEntry__c priceMatrixEntry71 = new Apttus_Config2__PriceMatrixEntry__c(Apttus_Config2__PriceMatrixId__c = priceMatrix7.Id, Apttus_Config2__Sequence__c = 1, Apttus_Config2__PriceOverride__c = 195.00, Apttus_Config2__AdjustmentAmount__c = 195.00, Apttus_Config2__AdjustmentType__c = 'List Price Override', Apttus_Config2__Dimension1Value__c = '8', Apttus_Config2__Dimension2Value__c = 'NZ-TRI');
            prixeMatrixEntryList.add(priceMatrixEntry71);

            Apttus_Config2__PriceMatrixEntry__c priceMatrixEntry72 = new Apttus_Config2__PriceMatrixEntry__c(Apttus_Config2__PriceMatrixId__c = priceMatrix7.Id, Apttus_Config2__Sequence__c = 2, Apttus_Config2__PriceOverride__c = 85.00, Apttus_Config2__AdjustmentAmount__c = 85.00, Apttus_Config2__AdjustmentType__c = 'List Price Override', Apttus_Config2__Dimension1Value__c = '99', Apttus_Config2__Dimension2Value__c = 'NZ-TRI');
            prixeMatrixEntryList.add(priceMatrixEntry72);
            insert prixeMatrixEntryList;

            String CustomerRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
            Account testAcc = APTS_TestDataUtility.createAccount(CustomerRecTypeId);
            //testAcc.CurrencyIsoCode = 'EUR';
            insert testAcc;
            System.debug('***TEST CLASS : testAcc===>'+testAcc);

            //create opportunity
            Opportunity oppty = APTS_TestDataUtility.createOpportunities(testAcc.Id, testUser);
            oppty.Pricebook2ID = stdPricebookId;
            insert oppty;
            System.debug('***TEST CLASS : oppty===>'+oppty);

            //insert Proposal     
            Apttus_Proposal__Proposal__c TestProp = APTS_TestDataUtility.createProposal('TestProposal', oppty.Id, 'EUR', testAcc.Id,'Proposal',priceList.id);
            TestProp.Apttus_Proposal__Primary__c=true;
            TestProp.Apttus_Proposal__Approval_Stage__c='None';
            insert TestProp;
            System.debug('***TEST CLASS : TestProp===>'+TestProp);

            //create product configuration
            Apttus_Config2__ProductConfiguration__c configuration = new Apttus_Config2__ProductConfiguration__c(Name = 'APTpS TST Configuration 1', Apttus_Config2__AccountId__c = testAcc.Id, Apttus_Config2__PriceListId__c = priceList.Id, Apttus_QPConfig__Proposald__c = TestProp.Id, Apttus_Config2__Status__c = LINE_STATUS_NEW, Apttus_Config2__VersionNumber__c = 1, Apttus_Config2__EffectivePriceListId__c = priceList.Id);
            configuration.Apttus_Config2__BusinessObjectType__c ='Proposal';
            insert configuration;
            System.debug('***TEST CLASS : configuration===>'+configuration);

            
            //create line items
            list<Apttus_Config2__LineItem__c> lineItemsList = new list<Apttus_Config2__LineItem__c>();
            
            Apttus_Config2__LineItem__c lineItem1 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c = configuration.Id, 
                Apttus_Config2__LineType__c = LINE_TYPE_PRODUCT_SERVICE, Apttus_Config2__LineStatus__c = LINE_STATUS_NEW, Apttus_Config2__ProductId__c = product1.Id, 
                Apttus_Config2__BasePrice__c = 1000, Apttus_Config2__PriceListItemId__c = priceListItem1.Id, Apttus_Config2__SellingTerm__c = 1,
                Apttus_Config2__Description__c = 'Users - Full Access', Apttus_Config2__PriceListId__c = priceList.Id,
                Apttus_Config2__ChargeType__c = 'Standard Price', Apttus_Config2__Quantity__c = 1, Apttus_Config2__ItemSequence__c = 1, Apttus_Config2__LineNumber__c = 1, 
                Apttus_Config2__PrimaryLineNumber__c = 1);
            lineItemsList.add(lineItem1);
            System.debug('***TEST CLASS : lineItem1===>'+lineItem1);
            
            Apttus_Config2__LineItem__c lineItem2 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c = configuration.Id, 
                Apttus_Config2__LineType__c = LINE_TYPE_PRODUCT_SERVICE, Apttus_Config2__ParentBundleNumber__c = 1, Apttus_Config2__LineStatus__c = LINE_STATUS_NEW, 
                Apttus_Config2__ProductId__c = product1.Id, Apttus_Config2__BasePrice__c = 1000,  Apttus_Config2__PriceListItemId__c = priceListItem2.Id,
                Apttus_Config2__Description__c = 'Users - Dashboard Only Access', Apttus_Config2__PriceListId__c = priceList.Id,
                Apttus_Config2__ChargeType__c = 'Standard Price', Apttus_Config2__OptionId__c = product2.Id, Apttus_Config2__SellingTerm__c = 1,
                Apttus_Config2__Quantity__c = 10, Apttus_Config2__ItemSequence__c = 1, Apttus_Config2__LineNumber__c = 1, Apttus_Config2__PrimaryLineNumber__c = 2, 
                Apttus_Config2__PriceType__c = PRICE_TYPE_RECURRING);
            lineItemsList.add(lineItem2);
            System.debug('***TEST CLASS : lineItem2===>'+lineItem2);
            
            Apttus_Config2__LineItem__c lineItem3 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c = configuration.Id, 
                Apttus_Config2__LineType__c = LINE_TYPE_PRODUCT_SERVICE, Apttus_Config2__ParentBundleNumber__c = 1, Apttus_Config2__LineStatus__c = LINE_STATUS_NEW, 
                Apttus_Config2__ProductId__c = product3.Id, Apttus_Config2__BasePrice__c = 1000,  Apttus_Config2__PriceListItemId__c = priceListItem3.Id,
                Apttus_Config2__ChargeType__c = 'Standard Price',  Apttus_Config2__PriceListId__c = priceList.Id, Apttus_Config2__SellingTerm__c = 1,
                Apttus_Config2__Quantity__c = 1, Apttus_Config2__ItemSequence__c = 1, Apttus_Config2__LineNumber__c = 1, Apttus_Config2__PrimaryLineNumber__c = 3, 
                Apttus_Config2__PriceType__c = 'One Time', Apttus_Config2__AdjustmentType__c = 'Discount Amount', Apttus_Config2__AdjustedPrice__c = 10, Apttus_Config2__NetPrice__c = 1490);
            lineItemsList.add(lineItem3);
            System.debug('***TEST CLASS : lineItem3===>'+lineItem3);

            Apttus_Config2__LineItem__c lineItem4 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c = configuration.Id, Apttus_Config2__SellingTerm__c = 1,
                Apttus_Config2__LineType__c = LINE_TYPE_PRODUCT_SERVICE, Apttus_Config2__ParentBundleNumber__c = 1, Apttus_Config2__LineStatus__c = LINE_STATUS_NEW, 
                Apttus_Config2__ProductId__c = product3.Id, Apttus_Config2__BasePrice__c = 1000,  Apttus_Config2__PriceListItemId__c = priceListItem4.Id,
                Apttus_Config2__ChargeType__c = 'Standard Price', Apttus_Config2__OptionId__c = product4.Id, Apttus_Config2__PriceListId__c = priceList.Id,
                Apttus_Config2__Quantity__c = 5, Apttus_Config2__ItemSequence__c = 1, Apttus_Config2__LineNumber__c = 1, Apttus_Config2__PrimaryLineNumber__c = 3, 
                Apttus_Config2__PriceType__c = 'One Time', Apttus_Config2__AdjustmentType__c = 'Discount Amount', Apttus_Config2__AdjustedPrice__c = 10, Apttus_Config2__NetPrice__c = 1490);
            lineItemsList.add(lineItem4);
            System.debug('***TEST CLASS : lineItem4===>'+lineItem4);
            
            insert lineItemsList;
            System.debug('***TEST CLASS : lineItemsList===>'+lineItemsList);

            APTS_EFPricingCallback pcbInstance = new APTS_EFPricingCallback();
            pcbInstance.setMode(Apttus_Config2.CustomClass.PricingMode.ADJUSTMENT);
            
            configuration.Apttus_Config2__Status__c = 'Saved';
            update configuration;

            //reprice API
            Apttus_Config2.PricingWebService.updatePriceForCart(configuration.id);

            //create product configuration
            Apttus_Config2__ProductConfiguration__c configuration2 = new Apttus_Config2__ProductConfiguration__c(Name = 'APTpS TST Configuration 2', Apttus_Config2__AccountId__c = testAcc.Id, Apttus_Config2__PriceListId__c = priceList.Id, Apttus_QPConfig__Proposald__c = TestProp.Id, Apttus_Config2__Status__c = LINE_STATUS_NEW, Apttus_Config2__VersionNumber__c = 1, Apttus_Config2__EffectivePriceListId__c = priceList.Id);
            configuration.Apttus_Config2__BusinessObjectType__c ='Proposal';
            insert configuration2;
            System.debug('***TEST CLASS : configuration===>'+configuration2);
            
            //create line items
            list<Apttus_Config2__LineItem__c> lineItemsList2 = new list<Apttus_Config2__LineItem__c>();
            
            lineItem1 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c = configuration2.Id, 
                Apttus_Config2__LineType__c = LINE_TYPE_PRODUCT_SERVICE, Apttus_Config2__LineStatus__c = LINE_STATUS_NEW, Apttus_Config2__ProductId__c = product1.Id, 
                Apttus_Config2__BasePrice__c = 1000, Apttus_Config2__PriceListItemId__c = priceListItem1.Id, Apttus_Config2__SellingTerm__c = 1,
                Apttus_Config2__Description__c = 'Users - Full Access', Apttus_Config2__PriceListId__c = priceList.Id,
                Apttus_Config2__ChargeType__c = 'Standard Price', Apttus_Config2__Quantity__c = 1, Apttus_Config2__ItemSequence__c = 1, Apttus_Config2__LineNumber__c = 1, 
                Apttus_Config2__PrimaryLineNumber__c = 1);
            lineItemsList2.add(lineItem1);
            System.debug('***TEST CLASS : lineItem1===>'+lineItem1);
            
            lineItem2 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c = configuration2.Id, 
                Apttus_Config2__LineType__c = LINE_TYPE_PRODUCT_SERVICE, Apttus_Config2__ParentBundleNumber__c = 1, Apttus_Config2__LineStatus__c = LINE_STATUS_NEW, 
                Apttus_Config2__ProductId__c = product1.Id, Apttus_Config2__BasePrice__c = 1000,  Apttus_Config2__PriceListItemId__c = priceListItem2.Id,
                Apttus_Config2__Description__c = 'Users - Dashboard Only Access', Apttus_Config2__PriceListId__c = priceList.Id,
                Apttus_Config2__ChargeType__c = 'Standard Price', Apttus_Config2__OptionId__c = product2.Id, Apttus_Config2__SellingTerm__c = 1,
                Apttus_Config2__Quantity__c = 10, Apttus_Config2__ItemSequence__c = 1, Apttus_Config2__LineNumber__c = 1, Apttus_Config2__PrimaryLineNumber__c = 2, 
                Apttus_Config2__PriceType__c = PRICE_TYPE_RECURRING);
            lineItemsList2.add(lineItem2);
            System.debug('***TEST CLASS : lineItem2===>'+lineItem2);
            
            lineItem3 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c = configuration2.Id, 
                Apttus_Config2__LineType__c = LINE_TYPE_PRODUCT_SERVICE, Apttus_Config2__ParentBundleNumber__c = 1, Apttus_Config2__LineStatus__c = LINE_STATUS_NEW, 
                Apttus_Config2__ProductId__c = product3.Id, Apttus_Config2__BasePrice__c = 1000,  Apttus_Config2__PriceListItemId__c = priceListItem3.Id,
                Apttus_Config2__ChargeType__c = 'Standard Price',  Apttus_Config2__PriceListId__c = priceList.Id, Apttus_Config2__SellingTerm__c = 1,
                Apttus_Config2__Quantity__c = 1, Apttus_Config2__ItemSequence__c = 1, Apttus_Config2__LineNumber__c = 1, Apttus_Config2__PrimaryLineNumber__c = 3, 
                Apttus_Config2__PriceType__c = 'One Time', Apttus_Config2__AdjustmentType__c = 'Discount Amount', Apttus_Config2__AdjustedPrice__c = 10, Apttus_Config2__NetPrice__c = 1490);
            lineItemsList2.add(lineItem3);
            System.debug('***TEST CLASS : lineItem3===>'+lineItem3);

            lineItem4 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c = configuration2.Id, Apttus_Config2__SellingTerm__c = 1,
                Apttus_Config2__LineType__c = LINE_TYPE_PRODUCT_SERVICE, Apttus_Config2__ParentBundleNumber__c = 1, Apttus_Config2__LineStatus__c = LINE_STATUS_NEW, 
                Apttus_Config2__ProductId__c = product3.Id, Apttus_Config2__BasePrice__c = 1000,  Apttus_Config2__PriceListItemId__c = priceListItem4.Id,
                Apttus_Config2__ChargeType__c = 'Standard Price', Apttus_Config2__OptionId__c = product4.Id, Apttus_Config2__PriceListId__c = priceList.Id,
                Apttus_Config2__Quantity__c = 8, Apttus_Config2__ItemSequence__c = 1, Apttus_Config2__LineNumber__c = 1, Apttus_Config2__PrimaryLineNumber__c = 3, 
                Apttus_Config2__PriceType__c = 'One Time', Apttus_Config2__AdjustmentType__c = 'Discount Amount', Apttus_Config2__AdjustedPrice__c = 10, Apttus_Config2__NetPrice__c = 1490);
            lineItemsList2.add(lineItem4);
            System.debug('***TEST CLASS : lineItem4===>'+lineItem4);

            
            
            insert lineItemsList2;
            System.debug('***TEST CLASS : lineItemsList===>'+lineItemsList2);

            pcbInstance = new APTS_EFPricingCallback();
            pcbInstance.setMode(Apttus_Config2.CustomClass.PricingMode.ADJUSTMENT);
            
            configuration2.Apttus_Config2__Status__c = 'Saved';
            update configuration2;

            //reprice API
            Apttus_Config2.PricingWebService.updatePriceForCart(configuration2.id);

            //insert Proposal     
            Apttus_Proposal__Proposal__c TestProp1 = APTS_TestDataUtility.createProposal('TestProposal', oppty.Id, 'EUR', testAcc.Id,'Proposal',priceList.id);
            TestProp1.Apttus_Proposal__Primary__c=true;
            TestProp1.Apttus_Proposal__Approval_Stage__c='None';
            TestProp1.ComparativeQuote__c = TRUE;
            insert TestProp1;
            System.debug('***TEST CLASS : TestProp1 ===>'+TestProp1);

            //create product configuration
            Apttus_Config2__ProductConfiguration__c configuration1 = new Apttus_Config2__ProductConfiguration__c(Name = 'APTpS TST Configuration 1', Apttus_Config2__AccountId__c = testAcc.Id, Apttus_Config2__PriceListId__c = priceList.Id, Apttus_QPConfig__Proposald__c = TestProp1.Id, Apttus_Config2__Status__c = LINE_STATUS_NEW, Apttus_Config2__VersionNumber__c = 1, Apttus_Config2__EffectivePriceListId__c = priceList.Id);
            configuration1.Apttus_Config2__BusinessObjectType__c ='Proposal';
            insert configuration1;
            System.debug('***TEST CLASS : configuration1===>'+configuration1);
            
            //create line items
            lineItemsList = new list<Apttus_Config2__LineItem__c>();
            
            lineItem1 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c = configuration1.Id, 
                Apttus_Config2__LineType__c = LINE_TYPE_PRODUCT_SERVICE, Apttus_Config2__LineStatus__c = LINE_STATUS_NEW, Apttus_Config2__ProductId__c = product1.Id, 
                Apttus_Config2__BasePrice__c = 1000, Apttus_Config2__PriceListItemId__c = priceListItem1.Id, Apttus_Config2__SellingTerm__c = 1,
                Apttus_Config2__Description__c = 'Users - Full Access', Apttus_Config2__PriceListId__c = priceList.Id,
                Apttus_Config2__ChargeType__c = 'Standard Price', Apttus_Config2__Quantity__c = 1, Apttus_Config2__ItemSequence__c = 1, Apttus_Config2__LineNumber__c = 1, 
                Apttus_Config2__PrimaryLineNumber__c = 1);
            lineItemsList.add(lineItem1);
            System.debug('***TEST CLASS : lineItem1===>'+lineItem1);
            
            lineItem2 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c = configuration1.Id, 
                Apttus_Config2__LineType__c = LINE_TYPE_PRODUCT_SERVICE, Apttus_Config2__ParentBundleNumber__c = 1, Apttus_Config2__LineStatus__c = LINE_STATUS_NEW, 
                Apttus_Config2__ProductId__c = product1.Id, Apttus_Config2__BasePrice__c = 1000,  Apttus_Config2__PriceListItemId__c = priceListItem2.Id,
                Apttus_Config2__Description__c = 'Users - Dashboard Only Access', Apttus_Config2__PriceListId__c = priceList.Id,
                Apttus_Config2__ChargeType__c = 'Standard Price', Apttus_Config2__OptionId__c = product2.Id, Apttus_Config2__SellingTerm__c = 1,
                Apttus_Config2__Quantity__c = 10, Apttus_Config2__ItemSequence__c = 1, Apttus_Config2__LineNumber__c = 1, Apttus_Config2__PrimaryLineNumber__c = 2, 
                Apttus_Config2__PriceType__c = PRICE_TYPE_RECURRING);
            lineItemsList.add(lineItem2);
            System.debug('***TEST CLASS : lineItem2===>'+lineItem2);
            
            lineItem3 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c = configuration1.Id, 
                Apttus_Config2__LineType__c = LINE_TYPE_PRODUCT_SERVICE, Apttus_Config2__ParentBundleNumber__c = 1, Apttus_Config2__LineStatus__c = LINE_STATUS_NEW, 
                Apttus_Config2__ProductId__c = product3.Id, Apttus_Config2__BasePrice__c = 1000,  Apttus_Config2__PriceListItemId__c = priceListItem3.Id,
                Apttus_Config2__ChargeType__c = 'Standard Price',  Apttus_Config2__PriceListId__c = priceList.Id, Apttus_Config2__SellingTerm__c = 1,
                Apttus_Config2__Quantity__c = 1, Apttus_Config2__ItemSequence__c = 1, Apttus_Config2__LineNumber__c = 1, Apttus_Config2__PrimaryLineNumber__c = 3, 
                Apttus_Config2__PriceType__c = 'One Time', Apttus_Config2__AdjustmentType__c = 'Discount Amount', Apttus_Config2__AdjustedPrice__c = 10, Apttus_Config2__NetPrice__c = 1490);
            lineItemsList.add(lineItem3);
            System.debug('***TEST CLASS : lineItem3===>'+lineItem3);

            lineItem4 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c = configuration1.Id, Apttus_Config2__SellingTerm__c = 1,
                Apttus_Config2__LineType__c = LINE_TYPE_PRODUCT_SERVICE, Apttus_Config2__ParentBundleNumber__c = 1, Apttus_Config2__LineStatus__c = LINE_STATUS_NEW, 
                Apttus_Config2__ProductId__c = product3.Id, Apttus_Config2__BasePrice__c = 1000,  Apttus_Config2__PriceListItemId__c = priceListItem4.Id,
                Apttus_Config2__ChargeType__c = 'Standard Price', Apttus_Config2__OptionId__c = product4.Id, Apttus_Config2__PriceListId__c = priceList.Id,
                Apttus_Config2__Quantity__c = 5, Apttus_Config2__ItemSequence__c = 1, Apttus_Config2__LineNumber__c = 1, Apttus_Config2__PrimaryLineNumber__c = 3, 
                Apttus_Config2__PriceType__c = 'One Time', Apttus_Config2__AdjustmentType__c = 'Discount Amount', Apttus_Config2__AdjustedPrice__c = 10, Apttus_Config2__NetPrice__c = 1490);
            lineItemsList.add(lineItem4);
            System.debug('***TEST CLASS : lineItem4===>'+lineItem4);

            Apttus_Config2__LineItem__c lineItem5 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c = configuration1.Id, Apttus_Config2__SellingTerm__c = 1,
                Apttus_Config2__LineType__c = LINE_TYPE_PRODUCT_SERVICE, Apttus_Config2__ParentBundleNumber__c = 1, Apttus_Config2__LineStatus__c = LINE_STATUS_NEW, 
                Apttus_Config2__ProductId__c = product7.Id, Apttus_Config2__BasePrice__c = 800,  Apttus_Config2__PriceListItemId__c = priceListItem7.Id,
                Apttus_Config2__ChargeType__c = 'Standard Price', Apttus_Config2__OptionId__c = product7.Id, Apttus_Config2__PriceListId__c = priceList.Id,
                Apttus_Config2__Quantity__c = 8, Apttus_Config2__ItemSequence__c = 1, Apttus_Config2__LineNumber__c = 1, Apttus_Config2__PrimaryLineNumber__c = 3, 
                Apttus_Config2__PriceType__c = 'One Time', Apttus_Config2__AdjustmentType__c = 'Discount Amount', Apttus_Config2__AdjustedPrice__c = 10, Apttus_Config2__NetPrice__c = 1490);
            lineItemsList.add(lineItem5);
            System.debug('***TEST CLASS : lineItem5===>'+lineItem5);
            
            insert lineItemsList;
            System.debug('***TEST CLASS : lineItemsList===>'+lineItemsList);

            configuration1.Apttus_Config2__Status__c = 'Saved';
            update configuration1;

            //reprice API
            Apttus_Config2.PricingWebService.updatePriceForCart(configuration1.id);

            //create product configuration
            Apttus_Config2__ProductConfiguration__c configuration3 = new Apttus_Config2__ProductConfiguration__c(Name = 'APTpS TST Configuration 1', Apttus_Config2__AccountId__c = testAcc.Id, Apttus_Config2__PriceListId__c = priceList.Id, Apttus_QPConfig__Proposald__c = TestProp1.Id, Apttus_Config2__Status__c = LINE_STATUS_NEW, Apttus_Config2__VersionNumber__c = 1, Apttus_Config2__EffectivePriceListId__c = priceList.Id);
            configuration3.Apttus_Config2__BusinessObjectType__c ='Proposal';
            insert configuration3;
            System.debug('***TEST CLASS : configuration1===>'+configuration1);
            
            //create line items
            lineItemsList = new list<Apttus_Config2__LineItem__c>();
            
            lineItem1 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c = configuration3.Id, 
                Apttus_Config2__LineType__c = LINE_TYPE_PRODUCT_SERVICE, Apttus_Config2__LineStatus__c = LINE_STATUS_NEW, Apttus_Config2__ProductId__c = product1.Id, 
                Apttus_Config2__BasePrice__c = 1000, Apttus_Config2__PriceListItemId__c = priceListItem1.Id, Apttus_Config2__SellingTerm__c = 1,
                Apttus_Config2__Description__c = 'Users - Full Access', Apttus_Config2__PriceListId__c = priceList.Id,
                Apttus_Config2__ChargeType__c = 'Standard Price', Apttus_Config2__Quantity__c = 1, Apttus_Config2__ItemSequence__c = 1, Apttus_Config2__LineNumber__c = 1, 
                Apttus_Config2__PrimaryLineNumber__c = 1);
            lineItemsList.add(lineItem1);
            System.debug('***TEST CLASS : lineItem1===>'+lineItem1);
            
            lineItem2 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c = configuration3.Id, 
                Apttus_Config2__LineType__c = LINE_TYPE_PRODUCT_SERVICE, Apttus_Config2__ParentBundleNumber__c = 1, Apttus_Config2__LineStatus__c = LINE_STATUS_NEW, 
                Apttus_Config2__ProductId__c = product1.Id, Apttus_Config2__BasePrice__c = 1000,  Apttus_Config2__PriceListItemId__c = priceListItem2.Id,
                Apttus_Config2__Description__c = 'Users - Dashboard Only Access', Apttus_Config2__PriceListId__c = priceList.Id,
                Apttus_Config2__ChargeType__c = 'Standard Price', Apttus_Config2__OptionId__c = product2.Id, Apttus_Config2__SellingTerm__c = 1,
                Apttus_Config2__Quantity__c = 10, Apttus_Config2__ItemSequence__c = 1, Apttus_Config2__LineNumber__c = 1, Apttus_Config2__PrimaryLineNumber__c = 2, 
                Apttus_Config2__PriceType__c = PRICE_TYPE_RECURRING);
            lineItemsList.add(lineItem2);
            System.debug('***TEST CLASS : lineItem2===>'+lineItem2);
            
            lineItem3 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c = configuration3.Id, 
                Apttus_Config2__LineType__c = LINE_TYPE_PRODUCT_SERVICE, Apttus_Config2__ParentBundleNumber__c = 1, Apttus_Config2__LineStatus__c = LINE_STATUS_NEW, 
                Apttus_Config2__ProductId__c = product3.Id, Apttus_Config2__BasePrice__c = 1000,  Apttus_Config2__PriceListItemId__c = priceListItem3.Id,
                Apttus_Config2__ChargeType__c = 'Standard Price',  Apttus_Config2__PriceListId__c = priceList.Id, Apttus_Config2__SellingTerm__c = 1,
                Apttus_Config2__Quantity__c = 1, Apttus_Config2__ItemSequence__c = 1, Apttus_Config2__LineNumber__c = 1, Apttus_Config2__PrimaryLineNumber__c = 3, 
                Apttus_Config2__PriceType__c = 'One Time', Apttus_Config2__AdjustmentType__c = 'Discount Amount', Apttus_Config2__AdjustedPrice__c = 10, Apttus_Config2__NetPrice__c = 1490);
            lineItemsList.add(lineItem3);
            System.debug('***TEST CLASS : lineItem3===>'+lineItem3);

            lineItem4 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c = configuration3.Id, Apttus_Config2__SellingTerm__c = 1,
                Apttus_Config2__LineType__c = LINE_TYPE_PRODUCT_SERVICE, Apttus_Config2__ParentBundleNumber__c = 1, Apttus_Config2__LineStatus__c = LINE_STATUS_NEW, 
                Apttus_Config2__ProductId__c = product3.Id, Apttus_Config2__BasePrice__c = 1000,  Apttus_Config2__PriceListItemId__c = priceListItem4.Id,
                Apttus_Config2__ChargeType__c = 'Standard Price', Apttus_Config2__OptionId__c = product4.Id, Apttus_Config2__PriceListId__c = priceList.Id,
                Apttus_Config2__Quantity__c = 5, Apttus_Config2__ItemSequence__c = 1, Apttus_Config2__LineNumber__c = 1, Apttus_Config2__PrimaryLineNumber__c = 3, 
                Apttus_Config2__PriceType__c = 'One Time', Apttus_Config2__AdjustmentType__c = 'Discount Amount', Apttus_Config2__AdjustedPrice__c = 10, Apttus_Config2__NetPrice__c = 1490);
            lineItemsList.add(lineItem4);
            System.debug('***TEST CLASS : lineItem4===>'+lineItem4);

            lineItem5 = new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c = configuration3.Id, Apttus_Config2__SellingTerm__c = 1,
                Apttus_Config2__LineType__c = LINE_TYPE_PRODUCT_SERVICE, Apttus_Config2__ParentBundleNumber__c = 1, Apttus_Config2__LineStatus__c = LINE_STATUS_NEW, 
                Apttus_Config2__ProductId__c = product7.Id, Apttus_Config2__BasePrice__c = 800,  Apttus_Config2__PriceListItemId__c = priceListItem7.Id,
                Apttus_Config2__ChargeType__c = 'Standard Price', Apttus_Config2__OptionId__c = product7.Id, Apttus_Config2__PriceListId__c = priceList.Id,
                Apttus_Config2__Quantity__c = 3, Apttus_Config2__ItemSequence__c = 1, Apttus_Config2__LineNumber__c = 1, Apttus_Config2__PrimaryLineNumber__c = 3, 
                Apttus_Config2__PriceType__c = 'One Time', Apttus_Config2__AdjustmentType__c = 'Discount Amount', Apttus_Config2__AdjustedPrice__c = 10, Apttus_Config2__NetPrice__c = 1490);
            lineItemsList.add(lineItem5);
            System.debug('***TEST CLASS : lineItem5===>'+lineItem5);
            
            insert lineItemsList;
            System.debug('***TEST CLASS : lineItemsList===>'+lineItemsList);

            configuration3.Apttus_Config2__Status__c = 'Saved';
            update configuration3;

            //reprice API
            Apttus_Config2.PricingWebService.updatePriceForCart(configuration3.id);
            pcbInstance.finish();
        }

        Test.stopTest();
	}

}