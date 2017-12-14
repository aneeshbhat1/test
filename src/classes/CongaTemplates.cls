/**
 * Created by thejasvi.a on 9/20/2017.
 */

public with sharing class CongaTemplates {
    public static void onBeforeInsert(List<SObject> newItems) {

    }

    public static void onBeforeUpdate(List<SObject> oldList, List<SObject> newList) {

    }

    public static void onBeforeDelete(Map<Id, SObject> oldItems) {
    }

    public static void onAfterInsert(List<APXTConga4__Conga_Template__c>newItems) {
        CongaTemplatesHelper.createShareOnInsert(newItems);

    }

    public static void onAfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        CongaTemplatesHelper.createShareOnUpdateTypes((List<APXTConga4__Conga_Template__c>)newItems.values(),(List<APXTConga4__Conga_Template__c>)oldItems.values());

    }
    public static void onAfterDelete(Map<Id, SObject> oldItems) {
    }

    public static void onAfterUndelete(Map<Id, SObject> oldItems) {
    }
}