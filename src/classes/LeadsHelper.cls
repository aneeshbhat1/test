/**************************************************************************************
Apex Class Name    : LeadsHelper
Version            : 1.0
Created Date       : June 22 2017
Function           :
Modification Log   :
------------------------------------------------------------------------------
 * Developer                   Date                   Description
 * ----------------------------------------------------------------------------
 * Savita                  06/22/2017              Original Version
*******************************************************************************/
public class LeadsHelper {
    public static map<string, string> leadFieldAPIAndLabelMap = new map<string, string>();
    public static map<string, string> accountFieldAPIAndLabelMap = new map<string, string>();
    public static Map<String, Schema.SObjectType> leadSchemaMap = Schema.getGlobalDescribe();
    public static map<string, string>fieldAPIAndLabelMap = new map<string, string>();
    public static map<string, string> ruleNameRuleValMap = new map<string, string>();
    public static map<string, string>ruleNameAndTritonIdMap = new map<string, string>();
    public static Map<Id,List<Task>> leadIdTasksMap = new Map<Id,List<Task>>();

    public static void createShareOnInsert(List<Lead> leadList) {
        try {
            Map<Id, String> leadMap = new Map<Id, String>();
            for (lead leadRec: leadList) {
                leadMap.put(leadRec.ID, leadRec.RecordSharingKey__c);
            }
            //get the public group details here
            Map<String, Id> publicGroupMap = publicGroupsSelector.getPublicGroups(leadMap.values());
            List<LeadShare> leadShareList = new List<LeadShare>();
            leadShareList = createLeadShareRec(leadMap, publicGroupMap);
            if (leadShareList.size() > 0) {
                insert leadShareList;
            }
        } Catch (Exception ex) {
            String errMessage = ex.getMessage();
            String trace = ex.getStackTraceString();
            String className = 'LeadsHelper';
            String methodName = 'createShareOnInsert';
            Id id = '';
            ExceptionHandler.errorLog(errMessage, trace, className, methodName, id);
        }
    }

    public static List<LeadShare> createLeadShareRec(Map<Id, String> LeadMap, Map<String, ID> publicGroupMap) {
        List<LeadShare> leadShareList = new List<LeadShare>();
        for (ID LId:LeadMap.keyset()) {

            if (publicGroupMap.containskey(LeadMap.get(LId))) {
                LeadShare shareRecord = createShareRecord(LId, publicGroupMap.get(LeadMap.get(LId)), System.Label.EditAccessLevel);
                leadShareList.add(shareRecord);
            }

        }
        return leadShareList;
    }

    public static LeadShare createShareRecord(ID recordId, ID userOrGroupId, String accessLevel) {
        LeadShare shareRecord = new LeadShare();
        shareRecord.leadid = recordId;
        shareRecord.UserOrGroupId = userOrGroupId;
        shareRecord.LeadAccessLevel = accessLevel;
        return shareRecord;
    }

    //For after update
    public static void createShareOnUpdateTypes(List<Lead> leadNewList, List<Lead> leadOldList) {
        List<String> addPublicGroupNameList = new List<String>();
        List<String> removePublicGroupNameList = new List<String>();
        List<String> allPublicGroupList = new List<String>();
        List<Id> leadIdList = new List<Id>();

        for (Integer index = 0; index < leadNewList.size(); index++) {
            leadIdList.add(leadNewList[index].id);
            if (leadNewList[index].RecordSharingKey__c != leadOldList[index].RecordSharingKey__c) {
                addPublicGroupNameList.add(leadNewList[index].RecordSharingKey__c);
                removePublicGroupNameList.add(leadOldList[index].RecordSharingKey__c);
            }
            if (leadNewList[index].OwnerId != leadOldList[index].OwnerId) {
                addPublicGroupNameList.add(leadNewList[index].RecordSharingKey__c);
            }
        }
        allPublicGroupList.addAll(addPublicGroupNameList);
        allPublicGroupList.addAll(removePublicGroupNameList);
        Map<String, ID> publicGroupMap = publicGroupsSelector.getPublicGroups(allPublicGroupList);
        //access level
        List<LeadShare> leadShareList = new List<LeadShare>();
        List<LeadShare> deleteAccess = new List<LeadShare>();
        //share table query
        List<LeadShare> leadShareIdList = [select id,userOrGroupId,LeadId from LeadShare Where leadId in :leadIdList];
        Map<String, LeadShare> leadShareIdKeyMap = new Map<String, LeadShare>();
        Map<Id, Id> groupIdMap = new Map<Id, Id>();
        String leadGroupIdCombinatinMap = '';
        for (LeadShare share : leadShareIdList) {
            leadGroupIdCombinatinMap = String.valueOf(String.valueOf(share.userOrGroupId) + String.valueOf(share.leadid));
            leadShareIdKeyMap.put(leadGroupIdCombinatinMap, share);
        }

        for (Integer index = 0; index < leadNewList.size(); index++) {
            if (leadNewList[index].RecordSharingKey__c != leadOldList[index].RecordSharingKey__c) {
                if (publicGroupMap.containsKey(leadNewList[index].RecordSharingKey__c)) {
                    //add acccess level
                    leadshareList.add(createShareRecord(leadNewList[index].id, publicGroupMap.get(leadNewList[index].RecordSharingKey__c), 'Edit'));
                }
                if (publicGroupMap.containsKey(leadOldList[index].RecordSharingKey__c)) {
                    String groupstr = String.valueOf(publicGroupMap.get(leadOldList[index].RecordSharingKey__c));
                    groupstr += leadNewList[index].id;
                    if (leadShareIdKeyMap.containsKey(groupstr)) {
                        deleteAccess.add(leadShareIdKeyMap.get(groupstr));
                    }
                }
            }
            if (leadNewList[index].OwnerId != leadOldList[index].OwnerId) {
                if (publicGroupMap.containsKey(leadNewList[index].RecordSharingKey__c)) {
                    leadshareList.add(createShareRecord(leadNewList[index].id, publicGroupMap.get(leadNewList[index].RecordSharingKey__c), 'Edit'));
                }
            }
        }
        if (deleteAccess != null && deleteAccess.size() > 0) {
            delete deleteAccess;
        }
        if (leadshareList != null && leadshareList.size() > 0) {
            insert leadShareList;
        }

    }
    //*********Lead Share code End here****************//

    //************* Lead Convert code here *******************//
    public static void processRanking(Lead[] leads) {
        List<Lead> rankingLeads = new List<Lead>();
        List<Lead> leadRecords = new List<Lead>();
        Set<Id> leadID = new Set<id>();
        Set<Id> rankingLeadsId = new Set<id>();

        for (Lead incomingRecords : leads) {
            if (incomingRecords.IsConverted == false && incomingRecords.IsDupeProcessed__c  && incomingRecords.IsDupe__c == false && incomingRecords.ReadyForRanking__c) {
                leadRecords.add(incomingRecords);
                leadID.add(incomingRecords.ID);
            }
        }
        Map<Id, Integer> ranking = RankingHandler.calculateRank(leadRecords);
        List<Lead> leadList = LeadsSelector.getLeadOnId(leadID);
        for (Lead incomingRecords : leadList) {
            if (incomingRecords.IsConverted == false && incomingRecords.IsDupeProcessed__c  && incomingRecords.IsDupe__c == false && incomingRecords.ReadyForRanking__c) {
                String rankingvalue = string.valueof(ranking.get(incomingRecords.id));
                incomingRecords.Ranking__c = integer.valueof(rankingvalue);
                incomingRecords.ReadyForRanking__c = false;
                rankingLeads.add(incomingRecords);
                rankingLeadsId.add(incomingRecords.id);
            }
        }
        if (rankingLeads.size() > 0) {
            //try {
                SObjectUnitOfWork.ExecuteUpdateLeads(rankingLeads);
                system.debug('LeadsHelper-processRanking-Inside Convert');
                //proceed for Convertion
                List<Lead> afterRankingLeads = LeadsSelector.getLeadOnId(rankingLeadsId);
                //Get the Lead settings here.
                Map<ID,Boolean> leadSettingMap = RankingHandler.getLeadSettings(afterRankingLeads);
                //call leadsetting methid here..
                system.debug('LeadsHelper-processRanking-Inside Convert-leadSettingMap'+leadSettingMap);
                List<Database.LeadConvert> leadConverts =new List<Database.LeadConvert>();
                for(Lead leadRecord : afterRankingLeads){
                    //Integer ranking = (Integer) leadRecord.Ranking__c;
                    if (leadSettingMap !=null && leadSettingMap.containsKey(leadRecord.ID) &&
                            leadSettingMap.get(leadRecord.ID) ) {
                        Database.LeadConvert leadConversion = new database.LeadConvert();
                        leadConversion.setLeadId(leadRecord.Id);
                        leadConversion.setConvertedStatus(System.Label.LeadStageConverted);
                        leadConversion.setOpportunityName(leadRecord.FirstName + ' ' + leadRecord.LastName);
                        leadConverts.add(leadConversion);
                    }
                }
                //After
                if(!leadConverts.isEmpty()){
                    for(Integer i = 0; i <= leadConverts.size()/100 ; i++){
                        list<Database.LeadConvert> tempList = new list<Database.LeadConvert>();
                        Integer startIndex = i*100;
                        Integer endIndex = ((startIndex+100) < leadConverts.size()) ? startIndex+100: leadConverts.size();
                        for(Integer j=startIndex;j<endIndex;j++){
                            tempList.add(leadConverts[j]);
                        }
                        Database.LeadConvertResult[] leadConvertedList = Database.convertLead(tempList, false);
                        ExceptionHandler.bulkLeadError(leadConvertedList,'LeadsHelper','processRanking');
                }
                }
                
            /*} catch (Exception ex) {
                String errMessage = ex.getMessage();
                String trace = ex.getStackTraceString();
                String className = 'LeadsHelper';
                String methodName = 'processRanking';
                Id id = '';
                ExceptionHandler.errorLog(errMessage, trace, className, methodName, id);
            }*/
        }
    }



  /*  public static List<ID> createOppportunityAndTaskTransfer(List<Lead> leadList) {
        List<Id> leadIdList = new List<Id>();
        Map<Id,Id> leadOpportunityMap = new Map<Id,Id>();
        List<Opportunity> createUpdateOpportunityList = new List<Opportunity>();
        Map<Id,Opportunity> leadIdOpportunityMap = new Map<Id,Opportunity>();
        List<Id> accountIdList = new List<Id>();
        List<Id> opportunityIdforTaskList = new List<Id>();
        String latestTaskType = '';
        for(Lead leadRecord : leadList) {
            if (leadRecord.IsConverted && leadRecord.ConvertedOpportunityId == null) {
                leadIdList.add(leadRecord.id);
            }
            else if(leadRecord.isConverted && leadRecord.ConvertedOpportunityId != null){
                leadOpportunityMap.put(leadRecord.id,leadRecord.ConvertedOpportunityId);
                //************
            }
        }
        //this map used in updatation of opportunity
        Map<Id,Opportunity> opportunityMap = new Map<Id,Opportunity>([Select id,Program__c,StageName from Opportunity
                Where id in :leadOpportunityMap.values()]);

        //creation of opportunity and task assignment
        for(Lead leadRecord : leadList) {
            system.debug('********** task list after' + leadIdTasksMap);
            if (leadRecord.ConvertedAccountId != null) {
                accountIdList.add(leadRecord.ConvertedAccountId);
            }
            //latest task
            if (leadIdTasksMap.containsKey(leadRecord.ConvertedAccountId) != null) {
                List<Task> taskList = leadIdTasksMap.get(leadRecord.ConvertedAccountId);
                latestTaskType = taskList != null && taskList.size() > 0 ? leadIdTasksMap.get(leadRecord.ConvertedAccountId)[0].Type : '';
            }
            //opportunity is not exists
            if(opportunityMap.containsKey(leadRecord.ConvertedAccountId)){
                if(leadRecord.ConvertedOpportunityId == null || IsOpportunityExpired(opportunityMap.get(leadRecord.ConvertedAccountId))) {
                //create an opportunity
                Opportunity newOpportunity = createOpportunity(leadRecord);
                leadIdOpportunityMap.put(leadRecord.id, newOpportunity);
            }}
            //opportunity exists
            else if(leadRecord.ConvertedOpportunityId != null  &&
                    opportunityMap.containsKey(leadRecord.ConvertedOpportunityId)) {
                opportunityIdforTaskList.add(leadRecord.ConvertedOpportunityId);
                Opportunity opportunityRecord = opportunityMap.get(leadRecord.ConvertedOpportunityId);
                String oldStage = opportunityRecord.StageName;
                opportunityRecord.StageName = Label.TBC;
                //map should have the convertedopportunityid. it iterate the same lead list
                if ( DCBusinessHelper.IsQualifiedLead(leadRecord) && (opportunityRecord.StageName == Label.OppStageInactive || opportunityRecord.StageName ==Label.OppStageClosedLost ||
                        opportunityRecord.StageName == Label.OppStageClosed)) {

                    opportunityRecord.Program__c = leadRecord.Program__c;
                    createUpdateOpportunityList.add(opportunityRecord);
                }
                else if (DCBusinessHelper.IsQualifiedLead(leadRecord) &&( opportunityRecord.StageName != Label.OppStageWon && opportunityRecord.StageName != Label.OppStageBkn && latestTaskType == Label.OppStageRes)) {
                opportunityRecord.Program__c = leadRecord.Program__c;
                    opportunityRecord.StageName = oldStage;
                    createUpdateOpportunityList.add(opportunityRecord);
            }
        }

        }
      accuntTaskList(accountIdList);
        system.debug('******* Account List'+accountIdList);
        createUpdateOpportunityList.addAll(leadIdOpportunityMap.values());
        system.debug('createUpdateOpportunityList ********* before' +createUpdateOpportunityList);
        upsert createUpdateOpportunityList;
        system.debug('createUpdateOpportunityList ******* after'+createUpdateOpportunityList);
        //task assignment for newly created opportunites
        List<Task> createTaskList = new List<Task>();
        for(Lead leadRecord : leadList) {
            if(leadIdOpportunityMap.containsKey(leadRecord.id) && leadIdTasksMap.containsKey(leadRecord.ConvertedAccountId)) {
                for(Task taskRecord : leadIdTasksMap.get(leadRecord.ConvertedAccountId)) {
                    taskRecord.whatId = leadIdOpportunityMap.get(leadRecord.id).id;
                    taskRecord.whoId = null;
                    createTaskList.add(taskRecord);
                }
            }
        }
        if(createTaskList != null && createTaskList.size() > 0) {
            update createTaskList;
        }

        //These ID's are required for TASK creation.
        List<ID> opportunityIDList = new List<ID>();
        opportunityIDList.addAll(opportunityIdforTaskList);
        for(Opportunity opp:createUpdateOpportunityList){
            system.debug('******* opportunty List'+opp);
            opportunityIDList.add(opp.id);
        }
        return opportunityIDList;

    }*/
    //this is used to have account and task list
    public static void accuntTaskList(List<Id> accountIdList) {
        for(Contact contactRecord : [select Id,AccountId,(select id,type,whoId,whatId from Tasks)
        from Contact where AccountId  in :accountIdList order by createddate desc]) {
            leadIdTasksMap.put(contactRecord.AccountId,contactRecord.Tasks);
        }
        system.debug('*********** contact task list'+leadIdTasksMap);
    }
    public static opportunity createOpportunity(Lead leadrecords) {
        Opportunity newOpportunityRecords = new Opportunity();
        newOpportunityRecords.Name = leadrecords.FirstName + ' ' + leadrecords.LastName ;
        newOpportunityRecords.AccountId = leadrecords.ConvertedAccountId;
        newOpportunityRecords.Program__c = leadrecords.Program__c;
        newOpportunityRecords.Market__c = leadrecords.Market__c;
        newOpportunityRecords.Product__c = leadrecords.Product__c;
        newOpportunityRecords.SalesOffice__c = leadrecords.SalesOffice__c;
        newOpportunityRecords.StageName = Label.TBC;
        newOpportunityRecords.CloseDate = date.today();
        return newOpportunityRecords;
    }

    //This function checks the latest Active opportunity of an person Account if it is expired(may be lost or frozen)
    private static Boolean IsOpportunityExpired(Opportunity opp) {
        boolean expired = false;
        if (opp.StageName == Label.OppStageInactive) {
            expired = true;
        }
        return expired;
    }



    public static void updateHadAddressFilledOnCreation(list<lead> leadNewList) {
        for (Integer i = 0; i < leadNewList.size(); i++) {
            if(!(leadNewList[i].street=='' ||leadNewList[i].street==null)){
                leadNewList[i].HadAddressonCreation__c=true;

            }
        }
    }

    // lead owner change logic starts here
    public static void leadOwnerchangelogic(List<Lead> oldLeads, List<Lead> newLeads) {
        Set<id> ownerIdset = new Set<id>();
        Map<id, String> userMarketmap = new Map<id, String>();
        // for (lead newLeadrecord: newLeads) {
        for (integer i = 0; i < newLeads.size(); i++) {
            if (newLeads[i].ownerid != oldLeads[i].ownerid) {
                ownerIdset.add(newLeads[i].ownerid);
            }
        }
        //Getting owner details from lead
        if (ownerIdset.size() > 0) {
            List<User> leadUserslist = LeadsSelector.getLeaduserDetails(ownerIdset);
            for (user userRecords :leadUserslist) {
                userMarketmap.put(userRecords.id, userRecords.MarketsEnabled__c);
            }
            for (integer i = 0; i < newLeads.size(); i++) {
                if (!SFLangUtil.isIntegrationUser() && userMarketmap.containskey(newLeads[i].ownerid)) {
                    //if future owner's market is blank than just throw the below error
                    if (userMarketmap.get(newLeads[i].ownerid) == null) {
                        newLeads[i].addError(Label.Lead_Owner_Change_Error + ' ' + oldLeads[i].Market__c);
                    } else if (!(userMarketmap.get(newLeads[i].ownerid).contains(oldLeads[i].market__c))) {
                        newLeads[i].addError(Label.Lead_Owner_Change_Error + ' ' + oldLeads[i].Market__c);
                    }
                }
            }
        }
    }


}