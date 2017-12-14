/**************************************************************************************
Apex Class Name    : StartDateHelper
Version            : 1.0
Created Date       : September 20 2017
Function           :
Modification Log   :
------------------------------------------------------------------------------
 * Developer                   Date                   Description
 * ----------------------------------------------------------------------------
 * Arjun.Mohan                 09/20/2017              Original Version
*******************************************************************************/

public class StartDateHelper {


    //This Method will get list of available start dates based on coursecode,destinationcode,isbeginner,programcode
    public static List<Start_Dates__c> getAvailableStartDates(String courseCode, String destination, Boolean isBeginner, Boolean canCheckOldDates, String programCode) {
        String dateString = String.valueOf(System.today()).split(' ')[0];
        String blockpastDateCheck = (canCheckOldDates) ? '' : ' AND StartDate__c > ' + dateString;
        String IsBeginnerCheck = (isBeginner) ? ' AND Is_Beginner__c=TRUE ' : ' ';
        String selectQuery = 'select Id,Name,Course__c,Destination__c,StartDate__c,Is_Beginner__c,Is_Preferred__c from  Start_Dates__c';
        String whereclause = ' Where Course__c =\'' + courseCode + '\' AND Destination__c =\'' + destination + '\' AND Program__c =\'' + programCode + '\' ' + blockpastDateCheck + ' ' + IsBeginnerCheck;
        String Query = selectQuery + whereclause;
        System.debug('##############' + Query);
        return StartDatesSelector.getSatrtDatesForSelectedBundle(Query);
    }

    //This Method will get list of available start dates based on coursecode,destinationcode,isbeginner,programcode
    public static Apttus_Config2__LineItem__c getCurrentAttributeForCartId(Id cartId, String productType) {
        List<Apttus_Config2__LineItem__c> lineItemsList = LineItemsSelector.getLineItemsForCartId(cartId, productType);
        System.debug('lineItemsList count is ###############################' + lineItemsList.size());
        return lineItemsList[0];
    }

    //This Method will update the related articles start date end date and quantity which are specific to that destination
    public static void updateStartDateAndEndDateOfRelatedArticles(List<Apttus_Config2__LineItem__c> lineItemList, String destinationCode, Date startdate,
            Date enddate, Integer quantity) {
        Id currentRecordId;
        try {
            List<StartDateSettings__mdt> startdateSettingsList = StartDatesSelector.getStartdateSettings(destinationCode);
            String currentLineItemSubType = '';
            String currentLineItemType = '';
            for (Apttus_Config2__LineItem__c lineItemRecord : lineItemList) {
                System.debug(' %%%%%%%%%%%%%%%%%%%%%%%% SUB'+lineItemRecord.Product_Subtype__c);
                System.debug(' %%%%%%%%%%%%%%%%%%%%%%%% TYPE '+lineItemRecord.APTS_Product_Type__c);
                currentRecordId = lineItemRecord.Id;
                currentLineItemSubType = lineItemRecord.Product_Subtype__c;
                currentLineItemType = lineItemRecord.APTS_Product_Type__c;
                if (!String.isBlank(currentLineItemType)
                        && !String.isBlank(currentLineItemSubType)
                        && startdateSettingsList[0].ProductSubType__c.contains(currentLineItemSubType)
                        && startdateSettingsList[0].ProductType__c.contains(currentLineItemType)) {
                            system.debug('Start date is before updating:  '+lineItemRecord.Apttus_Config2__StartDate__c);
                    lineItemRecord.Apttus_Config2__StartDate__c = startdate.addDays(Integer.valueOf(startdateSettingsList[0].StartDateOffSet__c));
                             system.debug('Start date is After updating:  '+lineItemRecord.Apttus_Config2__StartDate__c);
                    lineItemRecord.Apttus_Config2__EndDate__c = enddate.addDays(Integer.valueOf(startdateSettingsList[0].EndDateOffSet__c));
                    lineItemRecord.Apttus_Config2__Quantity__c = (!String.isBlank(lineItemRecord.Product_Code__c) && lineItemRecord.Product_Code__c == APTS_Constants.FIXEDFAREFLIGHTCODE) ? 1 : quantity;
                                   if(lineItemRecord.Product_Code__c == APTS_Constants.FIXEDFAREFLIGHTCODE)
                              {
                                system.debug('FTEXX Start date is updated:  '+lineItemRecord.Apttus_Config2__StartDate__c);
                            }
                } else {
                    System.debug('In Else Loop hello %%%%%%%%%%%%%%%%%%%%%%%%');
                }
            }

            SObjectUnitOfWork.executeUpdateLineItemValues(lineItemList);
        } catch (Exception Ex) {
            ExceptionHandler.errorLogAsync(ex.getMessage(), ex.getStackTraceString(),
                    'StartDateHelper', 'updateStartDateAndEndDateOfRelatedArticles', currentRecordId);
        }
    }

}