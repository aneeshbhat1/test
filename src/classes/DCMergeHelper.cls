/**
 * Created by aditi.sharma on 7/25/2017.
 */
/*
Apex Class Name    : DCMergeHelper
Version            : 1.0
Created Date       : 7/25/2017
------------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------
* Aditi Sharma                7/25/2017            This class helps in implementing business scenarios on opportunities and task after account merge
*******************************************************************************/
public with sharing class DCMergeHelper {
    //************************************** DCMergePlugin Codes here ***********************************
    //This function is invoked when there is a manual merge of objects using DC (Lead to Lead or Account to Account)
    public static void OnManualMerge(String objectPrefix, Sobject masterRecord, Set < id > mergedRecordIds)
    {

        if (objectPrefix == constant.ACCOUNT_PREFIX) //001P
        {
            List<Opportunity> opps=OpportunitiesSelector.getOpportunitiesOnAccountId(masterRecord.Id);
            Account masterAccount=AccountsSelector.GetAccountOnId(masterRecord.Id);
           
           
            
            List<Opportunity> freezableOpps=OpportunityStageUpdateOnMergeAccount(masterAccount,opps);
            if (freezableOpps != null && freezableOpps.size()>0)
            {
                for (Opportunity freezableOpp : freezableOpps)
                {
                    freezableOpp.StageName='InActive';   //*********need to decide the stage here.
                }
                SObjectUnitOfWork.ExecuteUpdateOpportunities(freezableOpps);
            }
          
        }
        else if (objectPrefix ==constant.LEAD_PREFIX ) // "00Q"
        {
            list<Lead> retainedLeadList = new list<Lead>();
            Lead retainedLead=(Lead)masterRecord;
            retainedLead.ReadyForRanking__c=true;
            retainedLead.IsDupe__c=false;  //Reset the flag to "Fasle" when we do the Automerge.
            retainedLeadList.add(retainedLead);
            SObjectUnitOfWork.executeUpdateLeads(retainedLeadList);

        }

    }
    //This function decides what to be done with the opportunities when multiple person accounts are merged
  /*
Apex method Name    : OpportunityStageUpdateOnMergeAccount
Version    Method   : 7/25/2017
------------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------
* Aditi Sharma                7/25/2017            This Method updates the opportunity Stage according to the business scenarios
*******************************************************************************/
    public static List<Opportunity> OpportunityStageUpdateOnMergeAccount(Account masterAccount,List<Opportunity> mergedOpps)
    {
        List<Opportunity> freezOpportunityList = new List<Opportunity>();
        Boolean isFound = true;
        Set<String> stageNameSet = new Set<String>();

        List<Opportunity> wonOpportuntyList = opportunitiesselector.getlstOfOpportunityByCreatedDateDesc(masterAccount);

        //collect opportunity stages
        for(Opportunity opp : mergedOpps) {
            stageNameSet.add(opp.stageName);

        }
        //Won opportunity
        //please do not add any if block inside this. It has been followed as per the order
        if(stageNameSet.contains(Constant.LEADSTAGEWON)) {
            for (Opportunity opp : wonOpportuntyList) {
                if (opp.StageName == Constant.LEADSTAGEWON && isFound) {
                    isFound = false;
                    continue;
                }
                freezOpportunityList.add(opp);
            }
        }
        //Followup  opportunity
        else if(stageNameSet.contains(Constant.LEADSTAGEFOLLOWUP)) {
            list<opportunity> opportunityFollowUpList = new list<opportunity>();
            opportunityFollowUpList = opportunitiesselector.getLstOfFollowupOpportunity(mergedOpps);

            for (Opportunity opp : mergedOpps) {

                if(opportunityFollowUpList.size()>1){
                    if (opp.stageName == Constant.LEADSTAGEFOLLOWUP && opp.FollowupDateTime__c >= system.today() && isFound) {

                        isFound = false;
                        continue;
                }
                }
                else{
                    if (opp.stageName == Constant.LEADSTAGEFOLLOWUP && isFound) {

                        isFound = false;
                        continue;
                      }

                }
                freezOpportunityList.add(opp);
            }
        }
        //TBC

        else if(stageNameSet.contains(Constant.LEADSTAGETBC)) {
            mergedOpps = opportunitiesselector.getLstOpportunityOrderByCrtdDateASC(mergedOpps);
            for (Opportunity opp : mergedOpps) {
                if (opp.stageName == Constant.LEADSTAGETBC && isFound) {
                    isFound = false;
                    continue;
                }
                freezOpportunityList.add(opp);
            }
        }
        else if(stageNameSet.contains(Constant.Closed_Lost)) {
            mergedOpps = opportunitiesselector.getLstOpportunityOrderByCrtdDateASC(mergedOpps);
            for (Opportunity opp : mergedOpps) {
                if (opp.stageName == Constant.Closed_Lost && isFound) {
                    isFound = false;
                    continue;
                }
                freezOpportunityList.add(opp);
            }
        }
        else {
            //other stagename
            for (Opportunity opp : mergedOpps) {
                if (opp.FollowupDateTime__c >= system.today() && isFound) {
                    isFound = false;
                    continue;
                }
                freezOpportunityList.add(opp);
            }
        }
        return freezOpportunityList;
    }
    public static void taskMergeReasonUpdateonMergeLead(String objectPrefix, Sobject masterRecord, List < sobject > mergedRecordList){
        if (objectPrefix == Constant.LEAD_PREFIX)  // =="00Q"
        {
            List<Id> mergedIds = new List<Id>();
            Lead retainedLead = (Lead) masterRecord;
            for (sobject sObj : mergedRecordList) {
                mergedIds.add(sObj.Id);
            }
            List<event> mergedEvent = Eventsselector.GetEventsOnWhoIds(mergedIds);
            for (event mergedTask : mergedEvent ) {
                mergedTask.MergeReason__c = Constant.MERGE_REASON_MANUALLY;
            }
             SObjectUnitOfWork.executeUpdateEvents(mergedEvent);
        }
    }
}