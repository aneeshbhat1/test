public class LineItems{
    public static void onAfterUpdate(Map<Id, Apttus_Config2__LineItem__c> newLineItemMap, Map<Id, Apttus_Config2__LineItem__c> oldLineItemMap){
       lineitemshelper.updateSeasonOnLineItem(newLineItemMap, oldLineItemMap);
    }

    public static void onAfterInsert(Map<Id, Apttus_Config2__LineItem__c> newLineItemMap, Map<Id, Apttus_Config2__LineItem__c> oldLineItemMap){
        lineitemshelper.updateStartdateEnddateOfCourserelatedArticlesIfCourseIsChanged(newLineItemMap, oldLineItemMap);
    }
}