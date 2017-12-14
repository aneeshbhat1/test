trigger LineItemTrigger on Apttus_Config2__LineItem__c (before insert,before update,after update,after insert,after delete ,before delete,after undelete ) {
 LineItemsDispatcher.run();
}