/**
 * Created by savita.b on 8/23/2017.
 */

public with sharing class MetaDataSelector {

  public static Map<String,TaskSetting__mdt> getTaskSettingMetada() {

        Map<String,TaskSetting__mdt> taskSettingsMap = new  Map<String,TaskSetting__mdt>();

        for(TaskSetting__mdt taskSetting :[Select CanCloseManually__c, CanCreateManually__c,
                CreateCallType__c,ForClosedCallTypes__c,IsActive__c,RuleForTask__c,
                IsCallType__c,IsTaskPerCustomer__c,Name__c,RuleForActivity__c,
                No__c,RULE__c,TaskGroup__c,Type__c,UpdateCallType__c,TaskSubject__c,RecordTypeLabel__c
        from TaskSetting__mdt])
        {
            taskSettingsMap.put(taskSetting.Name__c, taskSetting);
        }


        return taskSettingsMap;
    }

}