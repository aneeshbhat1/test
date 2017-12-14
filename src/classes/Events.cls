/**
 * Created by thejasvi.a on 10/13/2017.
 */

public with sharing class Events {
    public static void onBeforeInsert(List<Event> newItems) {
        EventsHelper.UpdateSubjectOnEvents(newItems);
    }

    public static void onBeforeUpdate(List<Event> oldEventList,List<Event> neweventList) {

    }

    public static void onBeforeDelete(Map<Id, SObject> oldItems) {
    }

    public static void onAfterInsert(List<Event>newItems) {
        List<Id> Ids = new List<Id>();
        for (event eventRecord:newItems) {
            string oppId= string.valueof(eventRecord.WhatId);
            if(oppId!=null && oppId!=''){
            if (oppId.startswith( '006')){
                Ids.add(eventRecord.WhatId);
            }
            }
        }
        TasksHelper.convertActivitiesToTask(Ids);
    }

    public static void onAfterUpdate(List<Event>newItems) {
         List<Id> Ids = new List<Id>();
        for (event eventRecord:newItems) {
            string oppId= string.valueof(eventRecord.WhatId);
            if(oppId!=null && oppId!=''){
            if (oppId.startswith( '006')){
                Ids.add(eventRecord.WhatId);
            }
            }
        }
        TasksHelper.convertActivitiesToTask(Ids);
    }
    public static void onAfterDelete(Map<Id, SObject> oldItems) {
    }

    public static void onAfterUndelete(Map<Id, SObject> oldItems) {
    }
}