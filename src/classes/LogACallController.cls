/**
 * Created by aneesh.bhat on 04-Sep-17.
 */

public with sharing class LogACallController {
    public static Map<String,TaskSetting__mdt> TaskSettingMetadata{get;set;}
    @auraEnabled
    public static String getInitialData(Id recordId){
        try{
            if(recordId.getSobjectType() == Lead.getSObjectType()){
                Lead lead = [SELECT Id, CloseDate__c,LikelihoodToBook__c,HearAboutUs__c,Destinations__c,Duration__c,WhenYear__c,WhenMonth__c FROM Lead where Id = :recordId LIMIT 1];
                return JSON.serialize(new LogACallData(lead.Id,lead.CloseDate__c,lead.LikelihoodToBook__c,lead.HearAboutUs__c,lead.Destinations__c,lead.Duration__c,lead.WhenYear__c,lead.WhenMonth__c));
            }
            else if(recordId.getSobjectType() == Opportunity.getSObjectType()) {
                Opportunity opp = [SELECT Id, CloseDate,LikelihoodToBook__c,HearAboutUs__c,Destinations__c,Duration__c,WhenYear__c,WhenMonth__c  FROM Opportunity where Id = :recordId LIMIT 1];
                return JSON.serialize(new LogACallData(opp.Id,opp.CloseDate,opp.LikelihoodToBook__c,opp.HearAboutUs__c,opp.Destinations__c,opp.Duration__c,opp.WhenYear__c,opp.WhenMonth__c));
            }
            return null;
        }
        catch(Exception e){
            System.debug('Error in getInitialData() :'+ e.getMessage());
            return null;
        }
    }

    @AuraEnabled
    public static string getSalesActions(){
        try{
            return JSON.serialize(FieldUtilityClass.getPickListValues(Task.getSObjectType(),'SalesAction__c').keySet());
        }
        catch (Exception e){
            System.debug('Error in getSalesActions() :'+ e.getMessage());
            return null;
        }
    }

    @AuraEnabled
    public static string getSubActions(){
        try{
            return JSON.serialize(FieldUtilityClass.getPickListValues(Task.getSObjectType(),'CallNotReachedType__c').keySet());
        }
        catch (Exception e){
            System.debug('Error in getSubActions() :'+ e.getMessage());
            return null;
        }
    }

    @AuraEnabled
    public static string getLikelihoodToBookOptions(Id recordId){
        try{
            return JSON.serialize(FieldUtilityClass.getPickListValues(recordId.getSobjectType(),'LikelihoodToBook__c').keySet());
        }
        catch (Exception e){
            System.debug('Error in getLikelihoodToBookOptions() :'+ e.getMessage());
            return null;
        }
    }

    @AuraEnabled
    public static string getHearAboutUsOptions(Id recordId){
        try{
            return JSON.serialize(FieldUtilityClass.getPickListValues(recordId.getSobjectType(),'HearAboutUs__c').keySet());
        }
        catch (Exception e){
            System.debug('Error in getHearAboutUsOptions() :'+ e.getMessage());
            return null;
        }
    }

    @AuraEnabled
    public static List<string> getDestinations(Id recordId){
        try{
            String sObjectName = recordId.getSObjectType().getDescribe().getName();
            if(String.valueOf(recordId).substring(0, 3) == '00Q') {
                Lead objectToUpdate = Database.query('SELECT Program__c FROM ' + sObjectName + ' WHERE Id = :recordId LIMIT 1');
                Map<String, List<String>> dependentPicklists = FieldUtilityClass.getFieldDependencies(Lead.getSObjectType().getDescribe().getName(), 'Program__c', 'Destinations__c');
                return dependentPicklists.get(objectToUpdate.Program__c);
            }
            else if(String.valueOf(recordId).substring(0, 3) == '006'){
                Opportunity objectToUpdate = Database.query('SELECT Program__c FROM ' + sObjectName + ' WHERE Id = :recordId LIMIT 1');
                Map<String, List<String>> dependentPicklists = FieldUtilityClass.getFieldDependencies(Opportunity.getSObjectType().getDescribe().getName(), 'Program__c', 'Destinations__c');
                return dependentPicklists.get(objectToUpdate.Program__c);
            }
            return new List<String>();
        }
        catch (Exception e){
            System.debug('Error in getDestinations() :'+ e.getMessage());
            return new List<String>();
        }
    }

    @AuraEnabled
    public static List<string> getDurations(Id recordId){
        try{
            String sObjectName = recordId.getSObjectType().getDescribe().getName();
            if(String.valueOf(recordId).substring(0, 3) == '00Q') {
                Lead objectToUpdate = Database.query('SELECT Program__c FROM ' + sObjectName + ' WHERE Id = :recordId LIMIT 1');
                Map<String, List<String>> dependentPicklists = FieldUtilityClass.GetDependentOptions(Lead.getSObjectType().getDescribe().getName(), 'Program__c', 'Duration__c');
                return dependentPicklists.get(objectToUpdate.Program__c);
            }
            else if(String.valueOf(recordId).substring(0, 3) == '006'){
                Opportunity objectToUpdate = Database.query('SELECT Program__c FROM ' + sObjectName + ' WHERE Id = :recordId LIMIT 1');
                Map<String, List<String>> dependentPicklists = FieldUtilityClass.GetDependentOptions(Opportunity.getSObjectType().getDescribe().getName(), 'Program__c', 'Duration__c');
                return dependentPicklists.get(objectToUpdate.Program__c);
            }
            return new List<String>();
        }
        catch (Exception e){
            System.debug('Error in getDurations() :'+ e.getMessage());
            return new List<String>();
        }
    }

    @AuraEnabled
    public static string getCloseReasons(Id recordId){
        try{
            return JSON.serialize(FieldUtilityClass.getPickListValues(recordId.getSobjectType(),'CloseMainReason__c').keySet());
        }
        catch (Exception e){
            System.debug('Error in getCloseReasons() :'+ e.getMessage());
            return null;
        }
    }

    @AuraEnabled
    public static String getCallResults(String callAction){
        try{
            Map<String,List<String>> dependentPicklists = FieldUtilityClass.getFieldDependencies(Task.getSObjectType().getDescribe().getName(),'SalesAction__c','ResultType__c');
            return JSON.serialize(dependentPicklists.get(callAction));
        }
        catch (Exception e){
            System.debug('Error in getCallResults() :'+ e.getMessage());
            return null;
        }
    }

    @AuraEnabled
    public static List<String> getProgramsForChange(Id recordId){
        Set<String> programs = null;
        try{
            String program = '';
            if(recordId.getSobjectType() == Opportunity.getSObjectType()){
                Opportunity opportunity = [SELECT Id, Program__c FROM Opportunity WHERE Id = :recordId LIMIT 1];
                programs = FieldUtilityClass.getPickListValues(Opportunity.getSObjectType(),'Program__c').keySet();
                program = opportunity.Program__c;
            }
            else if(recordId.getSobjectType() == Lead.getSObjectType()){
                Lead lead = [SELECT Id, Program__c FROM Lead WHERE Id = :recordId LIMIT 1];
                programs = FieldUtilityClass.getPickListValues(Lead.getSObjectType(),'Program__c').keySet();
                program = lead.Program__c;
            }

            if(programs.contains(program)){
                programs.remove(program);
            }
            if(programs.contains('MULTI')){
                programs.remove('MULTI');
            }
            return new List<String>(programs);
        }
        catch (Exception e){
            System.debug('Error in getProgramsForChange() :'+ e.getMessage());
            return new List<string>();
        }
    }

    @AuraEnabled
    public static Boolean isCustomerReached(Id recordId){
        if(recordId.getSobjectType() == Lead.getSObjectType()){
            return false;
        }
        else if(recordId.getSobjectType() == Opportunity.getSObjectType()) {
            Opportunity opp = [SELECT Id,FirstContactDateTime__c FROM Opportunity WHERE Id = :recordId];
            return opp.FirstContactDateTime__c != NULL;
        }
        else{
            return false;
        }
    }

    @AuraEnabled
    public static String saveData(
            String callAction,
            String subAction,
            string comments,
            String callResult,
            DateTime actionDateTime,
            string closeReason,
            Id recordId,
            String program,
            Datetime visitDatetime,
            String likelihoodToBook,
            String hearAboutUs,
            String destination,
            String duration,
            String whenYear,
            String whenMonth,
            DateTime bookOn ){
        ApexResponse response = new ApexResponse();
        try
        {
            // Update the values selected in the UI on the Lead or Opportunity
            if(recordId.getSobjectType() == Lead.getSObjectType()){
                Lead lead = [SELECT Id,LikelihoodToBook__c, HearAboutUs__c,Destinations__c,Duration__c,CloseDate__c,WhenYear__c,WhenMonth__c FROM Lead WHERE Id = :recordId];
                lead.LikelihoodToBook__c = likelihoodToBook;
                lead.HearAboutUs__c = hearAboutUs;
                lead.Destinations__c = destination;
                lead.Duration__c = duration;
                lead.CloseDate__c = bookOn.date();
                lead.WhenYear__c = whenYear;
                lead.WhenMonth__c = whenMonth;
                update lead;
            }
            else if(recordId.getSobjectType() == Opportunity.getSObjectType()){
                Opportunity opp = [SELECT Id,LikelihoodToBook__c,HearAboutUs__c,Destinations__c,Duration__c,CloseDate,WhenYear__c,WhenMonth__c FROM Opportunity WHERE Id = :recordId];
                opp.LikelihoodToBook__c = likelihoodToBook;
                opp.HearAboutUs__c = hearAboutUs;
                opp.Destinations__c = destination;
                opp.Duration__c = duration;
                opp.CloseDate = bookOn.date();
                opp.WhenYear__c = whenYear;
                opp.WhenMonth__c = whenMonth;

                update opp;
            }

            // If a call is reached on the Lead, convert the Lead to Opportunity directly
            if(String.valueOf(recordId).substring(0, 3) == '00Q'
                    && TasksHelper.allReachedItems.contains(callAction.toUpperCase())
                    && callResult.toUpperCase() != Label.CloseOpp.toUpperCase()) {
                Database.LeadConvert leadConversion =
                        new database.LeadConvert();
                Lead leadToConvert = [SELECT Id,FirstName,LastName FROM Lead WHERE Id = :recordId];
                leadConversion.setLeadId(recordId);
                leadConversion.setConvertedStatus(System.Label.LeadStageConverted);
                leadConversion.setOpportunityName(leadToConvert.FirstName + ' ' + leadToConvert.LastName);
                Database.LeadConvertResult lcr = Database.convertLead(leadConversion);
                opportunity objOpp = new opportunity();
                if(lcr.opportunityId != null){
                    objOpp.id = lcr.opportunityId;
                    objOpp.stageName = 'Follow Up';
                    update objOpp;
                }

                Map<String,String> result = new Map<String,String>();
                result.put('Id',lcr.opportunityId);
                result.put('Type','Opportunity');
                response.Result = result;
            }

            // Create a new Task representing the Action that was just done and fill it with details
            Task task = new Task();
            task.SalesAction__c = callAction;
            task.description = comments;
            task.CallNotReachedType__c= subAction;
            task.ResultType__c = callResult;
            task.ActivityDateTime__c = Datetime.now();
            task.ActivityDate = actionDateTime.date();
            task.Program__c = program;
            task.FollowUpDate__c = actionDateTime;
            task.CloseMainReason__c = closeReason;
            task.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Call Task').getRecordTypeId();
            if(recordId.getSobjectType() == Lead.getSObjectType()&& response.Result == null) {
                task.WhoId = recordId;
            }
            else if(recordId.getSobjectType() == Opportunity.getSObjectType()){
                task.WhatId = recordId;
            }

            if(response.Result!=null && response.Result.containsKey('Id')){
                task.WhatId = response.Result.get('Id');
                TasksHelper.handleLogAnAction(response.Result.get('Id'),task,visitDatetime);
            }
            else{
                TasksHelper.handleLogAnAction(recordId,task,visitDatetime);
            }
        }
        catch(Exception ex){
             System.debug('Error >>>> :'+ ex.getMessage());
            response.ResponseCode = 'FAILURE';
            response.ErrorMessage = ex.getMessage();
            return JSON.serialize(response);
        }
        response.ResponseCode = 'SUCCESS';
        return JSON.serialize(response);
    }
}