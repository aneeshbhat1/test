public class LineItemsDispatcher{
  public static void run() {
    try {
            if (Trigger.isAfter) {
                if (Trigger.IsUpdate) {
                   LineItems.onAfterUpdate((map<Id, Apttus_Config2__LineItem__c>) trigger.NewMap, (map<Id, Apttus_Config2__LineItem__c>) trigger.OldMap);
                }
                if (Trigger.isDelete) {
                    LineItems.onAfterInsert((map<Id, Apttus_Config2__LineItem__c>) trigger.NewMap, (map<Id, Apttus_Config2__LineItem__c>) trigger.OldMap);
                }
            }
        } catch (Exception e){}
  }
}