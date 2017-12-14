/**
 * Created by aneesh.bhat on 27-Oct-17.
 */

public with sharing class EventsHelper {
    public static Map<String, TaskSetting__mdt> taskSettingsMap = MetaDataSelector.getTaskSettingMetada();
    // Updates the subject on all the events
    public static void UpdateSubjectOnEvents(List<Event> events){
        for ( Event newEvent : events ) {
            UpdateSubjectOnEvent(newEvent);
        }
    }

    // Update the event subject to appropriate value
    public static void UpdateSubjectOnEvent(Event eventObj){
        if(taskSettingsMap !=null && taskSettingsMap.containsKey(eventObj.Type)){
            String eventSubject = taskSettingsMap.get(eventObj.Type).TaskSubject__c;
            eventSubject = eventSubject + eventObj.Program__c;
            eventObj.Subject = String.isBlank(eventSubject)? eventObj.Type : eventSubject;
        }
    }
}