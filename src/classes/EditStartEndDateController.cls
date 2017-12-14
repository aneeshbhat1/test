/**************************************************************************************
Apex Class Name    : EditStartEndDateController
Version            : 1.0
Created Date       : October 20 2017
Function           :
Modification Log   :
------------------------------------------------------------------------------
 * Developer                   Date                   Description
 * ----------------------------------------------------------------------------
 * Arjun.Mohan                 10/1/2017              Original Version
*******************************************************************************/

//Class is global as we are using this class as we have remoting method in this class
global class EditStartEndDateController {
    public list<BundleWrapper> bundleWrapperList { get; set; }
    public Id currentRecordId { get; set; }
    public String selectedSite { get; set; }
    public Id currentLineItemId;
    public static String configId2 { get; set; }
    public String flowName;
    public static String configRequestId { get; set; }
    public static String cartStatus{ get; set; }
    public static String cartFlow{ get; set; }
    public static String backCartUrl{ get; set; }
    public static pageReference pr;
    public static Apttus_Config2__LineItem__c currentLineItem;
    public static String currentLineItemJSON { get; set; }
    public static List<Apttus_Config2__LineItem__c> configLineItemList { get; set; }
    public static String configLineItemListJSON { get; set; }
    public static String startdateJSONString { get; set; }
    Public static List<Start_Dates__c> startDateList { get; set; }


    //This Constructor will get line items for all the selected bundles where start date is enabled
    public EditStartEndDateController() {

        System.debug('####################################  in constructor' );
        currentRecordId = ApexPages.CurrentPage().getparameters().get('id');
        this.bundleWrapperList = new list<BundleWrapper>();
        configLineItemList = new List<Apttus_Config2__LineItem__c>();
        prepareBundleWrapper();

        configId2 = ApexPages.currentPage().getParameters().get('id');
        configRequestId = ApexPages.currentPage().getParameters().get('configRequestId');
        cartStatus = ApexPages.currentPage().getParameters().get('cartStatus');
        cartFlow = ApexPages.currentPage().getParameters().get('flow');
        backCartUrl = Site.getPathPrefix() + '/apex/Apttus_Config2__Cart?id=' + configId2 + '&configRequestId=' + configRequestId;
        if(cartStatus != NULL){
            backCartUrl = backCartUrl +'&cartStatus=' + cartStatus;
        }
        if(cartFlow != NULL){
            backCartUrl = backCartUrl + '&flow=' +cartFlow;
        }
    }


    public PageReference prepareBundleWrapper() {
        if (currentRecordId != null) {
            configLineItemList = getLineItem();
            for (Apttus_Config2__LineItem__c lineItem : configLineItemList) {
                this.bundleWrapperList.add(new BundleWrapper(false, lineItem));
            }
        }
        return null;
    }

    //This Method will get available start dates for selected destination in startdate page
    public static void GetAvailableStartDates(String courseCode, String destination, Boolean isBeginner, String programCode) {
        startDateList = StartDateHelper.getAvailableStartDates(courseCode, destination, isBeginner, true, programCode);
        startdateJSONString = JSON.serialize(startDateList);
    }



    //Please revisit this method
    //This method will get the profile access for the user if he is system admin then he can get to see th previous start dates
    public static Boolean getUserProfileForAccess() {
        List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id = :userinfo.getProfileId() LIMIT 1];
        String MyProflieName = PROFILE[0].Name;
        Boolean canAccess = false;
        List<ProfileNamesForAdminAccess__mdt> adminmetdaDataList = StartDatesSelector.getProfilesForAdminAccess('Start_Dates__c');
        for (ProfileNamesForAdminAccess__mdt metaDataRecord : adminmetdaDataList) {
            string[] profiles = SFLangUtil.splitString(metaDataRecord.Profiles__c, ',');
            for (String profilename : profiles) {
                if (profilename == MyProflieName) {
                    canAccess = true;
                }
            }
        }
        return canAccess;
    }

    //Get the line items for selected config
    public list<Apttus_Config2__LineItem__c> getLineItem() {
        String query = 'SELECT ';
        for (Schema.FieldSetMember f : SObjectType.Apttus_Config2__LineItem__c.FieldSets.EditStartEndDateFieldSet.getFields()) {
            query += f.getFieldPath() + ', ';
        }

        query += 'Id,Product_Subtype__c,Name,' +
                'Beginner__c,Apttus_Config2__ProductId__r.Name,Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Market__c,Apttus_Config2__LineType__c,APTS_EnableStartDateEndDate__c,Program__c,   Apttus_Config2__Uom__c,Apttus_Config2__EndDate__c,  APTS_QunatityModifiable__c,Apttus_Config2__StartDate__c,Apttus_Config2__OptionId__c,Apttus_Config2__Quantity__c,DestinationCode__c,Apttus_Config2__ProductId__r.APTS_Destination_Location__c, Apttus_Config2__LineNumber__c' +
                '  FROM Apttus_Config2__LineItem__c WHERE Apttus_Config2__ConfigurationId__c =: ' + 'currentRecordId' + '' +
                ' and APTS_EnableStartDateEndDate__c = TRUE   ORDER BY Apttus_Config2__LineNumber__c,Product_Code__c' ;
        System.debug('#################################### ' + query);
        configLineItemList = Database.query(query);
        configLineItemListJSON = JSON.serialize(configLineItemList);
        return configLineItemList;

    }

    public List<SelectOption> getSitesOptions() {
        List<SelectOption> sitesOptions = new List<SelectOption>();
        sitesOptions.add(new SelectOption('', '-None-'));

        return sitesOptions;
    }

    //Get the selected item from check box in start date page
    public list<Apttus_Config2__LineItem__c> getSelectedLineItemsList {
        get {
            list<Apttus_Config2__LineItem__c> selectedLineItemsList = new list<Apttus_Config2__LineItem__c>();
            try {

                if (!this.bundleWrapperList.isEmpty()) {
                    for (BundleWrapper wrap : this.bundleWrapperList) {
                        if (wrap.selectedBundle) {
                            currentLineItem = wrap.lineItem;
                            currentLineItemJSON = JSON.serialize(currentLineItem);
                            this.currentLineItemId = wrap.lineItem.Id;
                            selectedLineItemsList.add(wrap.lineItem);
                            break;
                        }
                    }
                }
            } catch (Exception ex) {
                system.debug('Error Is #####################:-' + ex.getStackTraceString());
            }

            return selectedLineItemsList;
        }
        set;
    }

//Get available start dates for selected destination/course/program
    public void getSelectedLineItemStartdate() {
        list<Apttus_Config2__LineItem__c> lineItemToUpdateList = new list<Apttus_Config2__LineItem__c>();

        if (!getSelectedLineItemsList.isEmpty()) {
            for (Apttus_Config2__LineItem__c lineItem : getSelectedLineItemsList) {
                System.debug('######## DEstination code selected is:'+lineItem.DestinationCode__c +'@@@@@@@@@@@@@'+lineItem.Product_Code__c+'$$$$$$$$$$$$$$'+lineItem.Program__c);
                GetAvailableStartDates(lineItem.Product_Code__c, lineItem.DestinationCode__c, lineItem.Beginner__c, lineItem.Program__c);
                break;
            }
        }
    }

    @RemoteAction
    public static boolean RepriceCart(Id CartId)
    {
        Apttus_CpqApi.CPQ.UpdatePriceRequestDO objUpdatePriceRequestDO = new Apttus_CpqApi.CPQ.UpdatePriceRequestDO();
        System.debug('CartId'+CartId);
        // add request parameters
        objUpdatePriceRequestDO.CartId = CartId;

        Apttus_CpqApi.CPQ.UpdatePriceResponseDO result = Apttus_CpqApi.CPQWebService.updatePriceForCart(objUpdatePriceRequestDO);

        boolean hasPendingItems = result.IsPricePending;
        List<Integer> pendingLineNumbers = result.PendingLineNumbers;
        List<Integer> completedLineNumbers = result.CompletedLineNumbers;
        System.debug('hasPendingItems'+hasPendingItems);
        System.debug('pendingLineNumbers'+pendingLineNumbers);
        System.debug('completedLineNumbers'+completedLineNumbers);
        return hasPendingItems;
    }
    
    @RemoteAction
    public static boolean validateCart(Id CartId)
    {
        Apttus_Config2.CPQWebService.validateCart(CartId);
        return true;
    }
    
    //Not used
    //cancel : return to cart page
    public PageReference doRedirect() {
        if (configId2 != null) {
            pr = new PageReference(Site.getPathPrefix() + '/apex/Apttus_Config2__Cart?id=' + configId2 + '&configRequestId=' + configRequestId);
            //system.debug('==configId2==' + configId2 + '==flowName==' + flowName);
            pr.setRedirect(false);
            system.debug('==pr==' + pr);
            return pr;
        }

        return pr;
    }

    //If there is a change in quantity then we calculate the start date and end date in this method
    //we have to check  unit of measurement before we calculate the start date and end date
    @RemoteAction
    global static void calculateEndDate(String configLineItemListJSON, String currentItemId, String updatedQty) {
        Id currentId = Id.valueOf(currentItemId);
        Integer newQty = Integer.valueOf(updatedQty);
         if (newQty<=0) {
            return;
        }
        String currentLineItemGroup = '';
        configLineItemList = (List<Apttus_Config2__LineItem__c>) JSON.deserialize(configLineItemListJSON, List<Apttus_Config2__LineItem__c>.Class);
        list<Apttus_Config2__LineItem__c> selectedLineItemsList = new list<Apttus_Config2__LineItem__c>();
        Date courseStartDate;
        Date courseEndDate;
        for (Apttus_Config2__LineItem__c lineItem : configLineItemList) {
            //here we get current line items destination
            currentLineItemGroup = lineItem.Apttus_Config2__ProductId__r.Name;
            if (lineItem.Id == currentId && lineItem.Apttus_Config2__StartDate__c!=null) {
                List<StartDateSettings__mdt> startdateSettingsList = StartDatesSelector.getStartdateSettings(lineItem.DestinationCode__c);
                Integer SumOffset=0;
                System.debug('!!!!!!!!!!!!!!!!!!!!!! offset has value'+startdateSettingsList.size());
                if (startdateSettingsList.size()>0) {
                 Integer startdateoffset=(startdateSettingsList[0].StartDateOffSet__c < 0)?Integer.valueOf (startdateSettingsList[0].StartDateOffSet__c*-1):Integer.valueOf(startdateSettingsList[0].StartDateOffSet__c);
                    Integer enddateoffset=(startdateSettingsList[0].EndDateOffSet__c < 0)?Integer.valueOf(startdateSettingsList[0].EndDateOffSet__c*-1):Integer.valueOf(startdateSettingsList[0].EndDateOffSet__c);
                     SumOffset=startdateoffset+enddateoffset;
                }
                System.debug('!!!!!!!!!!!!!!!!!!!!!! SumOffset Off set sum is'+SumOffset);
                lineItem.Apttus_Config2__Quantity__c = newQty;

                if (lineItem.Apttus_Config2__Uom__c !=APTS_Constants.LINEITEM_UOM_EACH) {
                    // Hour Day Month Year
                    if (lineItem.Apttus_Config2__Uom__c ==APTS_Constants.LINEITEM_UOM_WEEK  && startdateSettingsList.size() > 0) {
                        if (Integer.valueOf(lineItem.Apttus_Config2__Quantity__c) == 1) {
                            lineItem.Apttus_Config2__EndDate__c = lineItem.Apttus_Config2__StartDate__c.addDays(SumOffset+APTS_Constants.COURSEOFFSET);
                        } else {

                            lineItem.Apttus_Config2__EndDate__c = lineItem.Apttus_Config2__StartDate__c.addDays(Integer.valueOf((SumOffset+APTS_Constants.COURSEOFFSET) + (7 * (Integer.valueOf(newQty) - 1))));
                        }
                    } else if (lineItem.Apttus_Config2__Uom__c == APTS_Constants.LINEITEM_UOM_HOUR ) {
                        if (Integer.valueOf(lineItem.Apttus_Config2__Quantity__c) < 24) {
                            lineItem.Apttus_Config2__EndDate__c = courseStartDate;
                        } else {
                            Integer days = (Integer.valueOf(lineItem.Apttus_Config2__Quantity__c) / 24);
                            lineItem.Apttus_Config2__EndDate__c = courseStartDate.addDays(days);
                        }
                    } else if (lineItem.Apttus_Config2__Uom__c ==APTS_Constants.LINEITEM_UOM_MONTH ) {
                        lineItem.Apttus_Config2__EndDate__c = courseStartDate.addMonths(Integer.valueOf(lineItem.Apttus_Config2__Quantity__c));
                    } else if (lineItem.Apttus_Config2__Uom__c ==APTS_Constants.LINEITEM_UOM_DAY ) {
                        lineItem.Apttus_Config2__EndDate__c = courseStartDate.addDays(Integer.valueOf(lineItem.Apttus_Config2__Quantity__c));
                    } else if (lineItem.Apttus_Config2__Uom__c == APTS_Constants.LINEITEM_UOM_YEAR) {
                        lineItem.Apttus_Config2__EndDate__c = courseStartDate.addYears(Integer.valueOf(lineItem.Apttus_Config2__Quantity__c));
                    }

                }
                selectedLineItemsList.add(lineItem);
                break;
            } else  if (lineItem.Id == currentId && lineItem.Apttus_Config2__Uom__c ==APTS_Constants.LINEITEM_UOM_EACH){
                lineItem.Apttus_Config2__Quantity__c = newQty;
                selectedLineItemsList.add(lineItem);
                break;
            }
        }
        SObjectUnitOfWork.executeUpdateLineItemValues(selectedLineItemsList);
    }


    @RemoteAction
    global static void calculateEndDateForStartDate(String configLineItemListJSON, String currentItemId, String updatedStartDate) {
        Id currentId = Id.valueOf(currentItemId);
        Date newStartDate = Date.valueOf(updatedStartDate);
        String currentLineItemGroup = '';
        configLineItemList = (List<Apttus_Config2__LineItem__c>) JSON.deserialize(configLineItemListJSON, List<Apttus_Config2__LineItem__c>.Class);
        list<Apttus_Config2__LineItem__c> selectedLineItemsList = new list<Apttus_Config2__LineItem__c>();
        Date courseStartDate;
        Date courseEndDate;
        System.debug('&&&&&&&&&&&&&&&&&&&&&&&&&' +newStartDate);
        for (Apttus_Config2__LineItem__c lineItem : configLineItemList) {
            //here we get current line items destination
            currentLineItemGroup = lineItem.Apttus_Config2__ProductId__r.Name;
            if (lineItem.Id == currentId) {
                List<StartDateSettings__mdt> startdateSettingsList = StartDatesSelector.getStartdateSettings(lineItem.DestinationCode__c);
                for (Apttus_Config2__LineItem__c lineItemrecord : configLineItemList) {
                    if (lineItemrecord.Apttus_Config2__ProductId__r.Name == currentLineItemGroup
                            && lineItemrecord.APTS_Product_Type__c ==APTS_Constants.ProductType_COURSE
                            ) {

                        courseStartDate = lineItemrecord.Apttus_Config2__StartDate__c;
                        break;
                    }
                }
                //lineItem.Apttus_Config2__Quantity__c = newQty;

                if (lineItem.Apttus_Config2__Uom__c != APTS_Constants.LINEITEM_UOM_EACH) {
                    // Hour Day Month Year
                    if (lineItem.Apttus_Config2__Uom__c ==APTS_Constants.LINEITEM_UOM_WEEK  && startdateSettingsList.size() > 0) {
                        Integer diff= lineItem.Apttus_Config2__StartDate__c.daysBetween(newStartDate);
                        lineItem.Apttus_Config2__StartDate__c=newStartDate;
                        lineItem.Apttus_Config2__EndDate__c = lineItem.Apttus_Config2__EndDate__c.addDays(diff);

                    } else if (lineItem.Apttus_Config2__Uom__c ==APTS_Constants.LINEITEM_UOM_HOUR) {
                        if (Integer.valueOf(lineItem.Apttus_Config2__Quantity__c) < 24) {
                            lineItem.Apttus_Config2__EndDate__c = newStartDate;
                        } else {
                            Integer days = (Integer.valueOf(lineItem.Apttus_Config2__Quantity__c) / 24);
                            lineItem.Apttus_Config2__EndDate__c = newStartDate.addDays(days);
                        }
                    } else if (lineItem.Apttus_Config2__Uom__c ==APTS_Constants.LINEITEM_UOM_MONTH ) {
                        lineItem.Apttus_Config2__EndDate__c = newStartDate.addMonths(Integer.valueOf(lineItem.Apttus_Config2__Quantity__c));
                    } else if (lineItem.Apttus_Config2__Uom__c ==APTS_Constants.LINEITEM_UOM_DAY) {
                        lineItem.Apttus_Config2__EndDate__c = newStartDate.addDays(Integer.valueOf(lineItem.Apttus_Config2__Quantity__c));
                    } else if (lineItem.Apttus_Config2__Uom__c ==APTS_Constants.LINEITEM_UOM_YEAR ) {
                        lineItem.Apttus_Config2__EndDate__c = newStartDate.addYears(Integer.valueOf(lineItem.Apttus_Config2__Quantity__c));
                    }

                }
                selectedLineItemsList.add(lineItem);
                break;
            } else {
                System.debug('value is Null');
            }
        }
        SObjectUnitOfWork.executeUpdateLineItemValues(selectedLineItemsList);
    }


    //Not in use
    public static PageReference doRerefresh() {
        if (configId2 != null) {
            pr = new PageReference(Site.getPathPrefix() + '/apex/EditStartEndDate?id=' + configId2);
            pr.setRedirect(false);
            system.debug('==pr==' + pr);
            return pr;
        }
        return pr;
    }



    //Once the course start date is selected we update the start date and end date of some articles through this method
    @RemoteAction
    global static void updateStartDate(String startdate, String endDate, String quantity,
            String currentLineItemString, String configLineItemListJSON, String configId, String configReqId) {

        configLineItemList = (List<Apttus_Config2__LineItem__c>) JSON.deserialize(configLineItemListJSON, List<Apttus_Config2__LineItem__c>.Class);
        
        map<Decimal, list<Apttus_Config2__LineItem__c>> bundleWiseLineItemMap = new map<Decimal, list<Apttus_Config2__LineItem__c>>();
        
        if(!configLineItemList.isEmpty()){
            for(Apttus_Config2__LineItem__c lineItem : configLineItemList){
                if(bundleWiseLineItemMap.containsKey(lineItem.Apttus_Config2__LineNumber__c)){
                    bundleWiseLineItemMap.get(lineItem.Apttus_Config2__LineNumber__c).add(lineItem);
                }else{
                    bundleWiseLineItemMap.put(lineItem.Apttus_Config2__LineNumber__c, new list<Apttus_Config2__LineItem__c>{lineItem});
                }
            }
        }
        
        currentLineItem = (Apttus_Config2__LineItem__c) JSON.deserialize(currentLineItemString, Apttus_Config2__LineItem__c.Class);
        configId2 = configId;
        configRequestId = configReqId;
        String[] urltoNavigate = SFLangUtil.splitString(configReqId, '?') ;
        
        Set<Id> deletedLineItemIdSet = new Set<Id>();
        Apttus_Config2__LineItem__c selectedLineItem = new Apttus_Config2__LineItem__c();
        
        if (currentLineItem != null) {            
            list<Apttus_Config2__LineItem__c> selectedLineItemsList = new list<Apttus_Config2__LineItem__c>();
            for (Apttus_Config2__LineItem__c lineItem : configLineItemList) {

                if (lineItem.Id == currentLineItem.Id) {
                    lineItem.Apttus_Config2__EndDate__c = Date.valueOf(endDate);
                    lineItem.Apttus_Config2__StartDate__c = Date.valueOf(startdate);
                    lineItem.Apttus_Config2__Quantity__c = Integer.valueOf(quantity);
                    selectedLineItemsList.add(lineItem);
                    selectedLineItem = lineItem;
                    deletedLineItemIdSet = SeasonSupplementsHelper.createOptionLineItem(configId2, lineItem, bundleWiseLineItemMap);

                }
               if (lineItem.DestinationCode__c == currentLineItem.DestinationCode__c  && lineItem.Id != currentLineItem.Id && lineItem.Apttus_Config2__LineNumber__c==currentLineItem.Apttus_Config2__LineNumber__c) {
                    if(deletedLineItemIdSet == null || deletedLineItemIdSet.isEmpty()){
                        selectedLineItemsList.add(lineItem);
                    }else if(!deletedLineItemIdSet.isEmpty() && !deletedLineItemIdSet.contains(lineItem.Id)){
                        selectedLineItemsList.add(lineItem);
                    }
                }
            }
            System.debug('selectedLineItemsList from controller'+selectedLineItemsList.size());
            StartDateHelper.updateStartDateAndEndDateOfRelatedArticles(selectedLineItemsList,
                    currentLineItem.DestinationCode__c,
                    Date.valueOf(startdate),
                    Date.valueOf(endDate), Integer.valueOf(quantity));
        } else {
            System.debug('currentLineItem is: null');
        }
    }
    
     @RemoteAction
    global static String UpdateEndDateForAccommodation(String configLineItemListJSON, String currentItemId, String updatedEndDate)
    {
        Id currentId = Id.valueOf(currentItemId);
        Date newEndDate = Date.valueOf(updatedEndDate);
        configLineItemList = (List<Apttus_Config2__LineItem__c>) JSON.deserialize(configLineItemListJSON, List<Apttus_Config2__LineItem__c>.Class);
        list<Apttus_Config2__LineItem__c> selectedLineItemsList = new list<Apttus_Config2__LineItem__c>();
        for (Apttus_Config2__LineItem__c lineItem : configLineItemList) {
            //here we get current line items destination
            if (lineItem.Id == currentId
                    && lineItem.Apttus_Config2__StartDate__c !=null
                    && lineItem.APTS_Product_Type__c==APTS_Constants.PRODUCT_TYPE_ACCOMODATION) {
                lineItem.Apttus_Config2__EndDate__c=newEndDate;
                selectedLineItemsList.add(lineItem);
                //validationError=isValidDayForAccommodation(startdateSettingsList[0].ValidAccommodationDays__c,lineItem.Apttus_Config2__StartDate__c,lineItem.Apttus_Config2__EndDate__c);
                break;
            } else {
                System.debug('value is Null');
            }
        }

        if (selectedLineItemsList.size()>0) {
            SObjectUnitOfWork.executeUpdateLineItemValues(selectedLineItemsList);
            return '';
        }
        else
        {
            return '';
        }
    }


    //This class is added to manipulate the values of bundles in EDit start date and end date page
    public class BundleWrapper {
        public boolean selectedBundle { get; set; }
        public Apttus_Config2__LineItem__c lineItem { get; set; }

        public BundleWrapper(boolean selectBundle, Apttus_Config2__LineItem__c lineItem) {
            this.selectedBundle = selectBundle;
            this.lineItem = lineItem;
        }
    }
}