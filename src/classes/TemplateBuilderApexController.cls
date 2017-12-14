/**
 * Created by Aneesh on 24-11-2017.
 */

public with sharing class TemplateBuilderApexController {
    @AuraEnabled
    public static String getServerURL(){
        User user = [SELECT ServerURL__c FROM User WHERE Id = :userinfo.getUserId() LIMIT 1];
        return user.ServerURL__c;
    }
    @AuraEnabled
    public static List<SObject> getRecords(String prefix){
        if(prefix == '006'){
            return [SELECT Id,Name FROM Lead];
        }
        else if(prefix == '00Q'){
            return [SELECT Id,Name FROM Opportunity];
        }
        return new List<SObject>();
    }
}