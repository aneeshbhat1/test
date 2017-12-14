/**
 * Created by arjun.mohan on 8/18/2017.
 */

public with sharing class EventsSelector {

    public static  List<Event> getAllActivities(List<Id> parentIds) {

        List<Event> eventList = [SELECT Id, WhoId, WhatId, Subject, OwnerId,
                Type, SalesAction__c, Program__c, EventId__c,FalseBrochureProgramCodes__c, 
                IsExpressCall__c, ProcessedforTaskcreation__c
        FROM Event where ProcessedforTaskcreation__c=false and( WhoId in:parentIds or whatId in:parentIds)];

        return eventList;

    }

    //SF-188 this method used for task to event changes
    public static Event retriveEvent(Id whoId) {
        return [select Id,whoid,WhatId,Program__c,Type,MergeReason__c from Event where WhoId = :whoId order by CreatedDate Desc limit 1];
    }
     public static List<event> getEventsOnWhoIds(List<Id> whoIds) {
        return [select Id,whoid,WhatId,Program__c,Type,MergeReason__c from event where WhoId in :whoIds];
    }
    //SF-188 capture the event reason
    public static List<Event> retriveEventsOnLead(List<Id> leadIdList) {
        return [select id,WhoId,MergeReason__c from Event Where WhoId in :leadIdList];
    }

    //this is used on dupecheck to get latest event type
    public static String eventType(Lead leadRecord) {
       system.debug('---I am here in eventquery---'+leadRecord);
       list <Event> eventRecord =  [SELECT id,Type from Event WHERE WhoId=:leadRecord.id
        ORDER BY CreatedDate DESC Limit 1];
        system.debug('-------eventRecord----'+eventRecord);
        if(eventRecord != null && !eventRecord.isempty()) {
            return eventRecord[0].Type;
        }
        return '';
    }

}