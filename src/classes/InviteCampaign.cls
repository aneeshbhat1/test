public with sharing class InviteCampaign {

    @AuraEnabled
    public static String getInitialData(Id entityId) {
        String sObjectName = entityId.getSObjectType().getDescribe().getName();
        SObject objectToUpdate = Database.query('SELECT Market__c, SalesOffice__c, Product__c, Program__c,MeetingType__c,MeetingCity__c FROM ' + sObjectName + ' WHERE Id = :entityId LIMIT 1');      
        return JSON.serialize(objectToUpdate);
    }

    @AuraEnabled
    public static String getMeetingTypes() {
        Map<String, String> meetingtype = FieldUtilityClass.getPickListValues(Campaign.getSObjectType(), 'MeetingType__c');
        return JSON.serialize(meetingtype.keySet());
    }

    @AuraEnabled
    public static String getMeetingCity(Id recordId) {
        Map<String, List<String>> meetingcity = FieldUtilityClass.getFieldDependencies(Campaign.getSObjectType().getDescribe().getName(), 'Market__c', 'MeetingCity__c');
        Opportunity opp = OpportunitiesSelector.getOpportunityrecords(recordId);
        return JSON.serialize(meetingcity.get(opp.Market__c));
    }

    @AuraEnabled
    public static String getProgram(Id recordId) {      
        Map<String, String> programs = FieldUtilityClass.getPickListValues(Campaign.getSObjectType(), 'Program__c');
        return JSON.serialize(programs.keySet());
    }

    @AuraEnabled
    public static String getsalesoffice(Id recordId) {
        Map<String, List<String>> salesoffice = FieldUtilityClass.getFieldDependencies(Campaign.getSObjectType().getDescribe().getName(), 'Market__c', 'SalesOffice__c');
        Opportunity opp = OpportunitiesSelector.getOpportunityrecords(recordId);
        return JSON.serialize(salesoffice.get(opp.Market__c));
    }

    @AuraEnabled
    public static List<campaign> getcampaigns() {
        List<campaign> campaignRecords = CampaignsSelector.getCampaignRecords();
        return campaignRecords;
    }

    @AuraEnabled
    public static list<CampaignWrapper> getCampaignsWithFilter(String recordId,string salesoffice, string program, string meetingType, string meetingCity, datetime datefrom, datetime dateto) {

        String market = '';
         List<string> lstOfprogram = new List<string>();
        if(recordId != null && recordId != ''){
            Opportunity opp =  OpportunitiesSelector.getOpportunityrecords(recordId);
            market = opp.Market__c;
        }
        
    	list<string> lstOfsalesoffice = new List<string>();
        if (salesoffice != null && salesoffice != '') {
            lstOfsalesoffice = (list<string>) JSON.deserialize(salesoffice, list<string>.class);
        }
        
        if (program != null && program != '') {
           lstOfprogram = (list<string>) JSON.deserialize(program, list<string>.class);                    
        }

        list<string> lstOfmeetingType = new List<string>();
        if (meetingType != null && meetingType != '') {
            lstOfmeetingType = (list<string>) JSON.deserialize(meetingType, list<string>.class);
        }

        list<string> lstOfmeetingCity = new List<string>();
        if (meetingCity != null && meetingCity != '') {
            lstOfmeetingCity = (list<string>) JSON.deserialize(meetingCity, list<string>.class);
        }

        string query = 'select id,SalesOffice__c,Program__c,MeetingType__c,MeetingCity__c, DateFrom__c, DateTo__c, IsUP__c, MeetingSize__c,Name FROM campaign WHERE ';
        string statusValue = 'Active';

        if(market != ''){
            query += 'Market__c = :market' + ' AND ' ;
        }

        if (statusValue != null) {
            query += 'Status = :statusValue' + ' AND ' ;
        }
        
        if (lstOfsalesoffice.size() > 0) {
            query += 'SalesOffice__c in :lstOfsalesoffice' + ' AND ' ;
        }

        if (lstOfprogram.size() > 0) {
            query += 'Program__c in :lstOfprogram' + ' AND ' ;
        }

        if (lstOfmeetingType.size() > 0) {
            query += 'MeetingType__c in :lstOfmeetingType' + ' AND ';
        }

        if (lstOfmeetingCity.size() > 0) {
            query += 'MeetingCity__c in :lstOfmeetingCity' + ' AND ';
        }

        if (datefrom != null) {
            query += 'DateFrom__c >= :datefrom' + ' AND ';
        }

        if (dateto != null) {
            query += 'DateTo__c <= :dateto';
        }

        if (query.endsWith('AND ')) {
            query = query.substring(0, query.lastIndexOf(' AND '));

        }
        if (query.endsWith('WHERE ')) {
            query = query.substring(0, query.lastIndexOf(' WHERE '));
        }
        
        List<campaign> campaignRecords = new List<campaign>();
        campaignRecords = Database.query(query);
        CampaignWrapper wrapperClassInitialise = new CampaignWrapper();
        list<CampaignWrapper> lstOfWrappers = new list<CampaignWrapper>();
        
        
        Map<Id, Integer> invitedMembersCount=new Map<Id, Integer> ();
        invitedMembersCount = CampaignsSelector.getCampaignMembers(campaignRecords);

        if ((campaignRecords.size()>0 ) ) {
            for (campaign objCampaign :campaignRecords) {
                CampaignWrapper initializeWrapperClass = new CampaignWrapper();
                initializeWrapperClass.objWrapperCampaign = objCampaign;
                integer value = invitedMembersCount.get(objCampaign.id);
                initializeWrapperClass.InvitedCount = value;
                lstOfWrappers.add(initializeWrapperClass);
            }
        }
        return lstOfWrappers;   
    }
    
    @AuraEnabled
    public static list<CampaignWrapper> getInitialCampaignData(String recordId,  datetime datefrom) {



        String market = '';
        List<string> lstOfprogram = new List<string>();
        if(recordId != null && recordId != ''){
            Opportunity opp = OpportunitiesSelector.getOpportunityrecords(recordId);
            market = opp.Market__c;
            lstOfprogram.add(opp.Program__c);
        }		

        string query = 'select id,SalesOffice__c, Program__c,MeetingType__c,MeetingCity__c, DateFrom__c, DateTo__c, IsUP__c, MeetingSize__c,Name FROM campaign WHERE ';
        string statusValue = 'Active';

        if(market != ''){
            query += 'Market__c = :market' + ' AND ' ;
        }

        if (statusValue != null) {
            query += 'Status = :statusValue' + ' AND ' ;
        }
        
         if (lstOfprogram.size() > 0) {
            query += 'Program__c in :lstOfprogram' + ' AND ' ;
        }
                
        if (datefrom != null) {
            query += 'DateFrom__c >= :datefrom' + ' AND ';
        }

        if (query.endsWith('AND ')) {
            query = query.substring(0, query.lastIndexOf(' AND '));

        }
        if (query.endsWith('WHERE ')) {
            query = query.substring(0, query.lastIndexOf(' WHERE '));
        }
       
        List<campaign> campaignRecords = new List<campaign>();
        campaignRecords = Database.query(query);
        CampaignWrapper wrapperClassInitialise = new CampaignWrapper();
        list<CampaignWrapper> lstOfWrappers = new list<CampaignWrapper>();
        
       Map<Id, Integer> invitedMembersCount=new Map<Id, Integer> ();
        invitedMembersCount = CampaignsSelector.getCampaignMembers(campaignRecords);

        if ((campaignRecords.size()>0 ) ) {
            for (campaign objCampaign :campaignRecords) {
                CampaignWrapper initializeWrapperClass = new CampaignWrapper();
                initializeWrapperClass.objWrapperCampaign = objCampaign;
                integer value = invitedMembersCount.get(objCampaign.id);
                initializeWrapperClass.InvitedCount = value;
                lstOfWrappers.add(initializeWrapperClass);
            }
        }            
            return lstOfWrappers;
       
    }

    public class CampaignWrapper {
        @AuraEnabled
        public boolean isChecked = false;
        @AuraEnabled
        public campaign objWrapperCampaign = new campaign();
         @AuraEnabled
        public Integer invitedCount;
    }


    @AuraEnabled
    public static void AddCampaigns(string incomingCampaignList, Id OpportunityId) {
        try {
            System.Debug('Input Params : incomingCampaignList:'+incomingCampaignList+'  OppId:'+OpportunityId);
            List<CampaignMember> campaignMemberList = new List<CampaignMember>();
            list<campaign> lstOfSelectedCampaign = (list<campaign>) JSON.deserialize(incomingCampaignList, list<campaign>.class);
            Id recordId = Id.valueOf(OpportunityId);
            System.debug('RecordId:'+recordId);
            Opportunity opportunityRecord = OpportunitiesSelector.getOpportunityrecords(recordId);     
            System.debug('Opp Record:'+opportunityRecord);
            Account accountRecord = AccountsSelector.getAccountonOpportunity(opportunityRecord); 
            System.debug('Account Record:'+accountRecord);
            for (Campaign campaignRecord:lstOfSelectedCampaign) {
                if (accountRecord.PersonContactId != null) {
                    System.debug('Entered If personal Id:'+accountRecord.PersonContactId);
                    CampaignMember member = new CampaignMember();
                    member.ContactId = accountRecord.PersonContactId;
                    member.CampaignId = campaignRecord.Id;
                    member.status='Invited';
                    campaignMemberList.add(member);
                }
            }
            insert campaignMemberList;
        } Catch (Exception ex) {
            String errMessage = ex.getMessage();
            String trace = ex.getStackTraceString();
            String className = 'InviteCampaign';
            String methodName = 'AddCampaigns';
            Id id = '';
            ExceptionHandler.errorLog(errMessage, trace, className, methodName, id);
        }
    }

    @AuraEnabled
    public static String getMarket(Id OpportunityId) {
        Id recordId = Id.valueOf(OpportunityId);
        Opportunity opportunityRecord = OpportunitiesSelector.getOpportunityrecords(recordId);  
        string market = opportunityRecord.Market__c;
        return JSON.serialize(market);
    }


}