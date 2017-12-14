/**************************************************************************************
Apex Class Name    : ContactsSelector
Version            : 1.0
Created Date       : July 16 2017
Function           :
Modification Log   :
------------------------------------------------------------------------------
 * Developer                   Date                   Description
 * ----------------------------------------------------------------------------
 * shravan.boddula                 07/12/2017              Original Version
*******************************************************************************/
public class SObjectUnitOfWork {
    public static void executeLeadMerge(Lead retainedLead, List<Lead> duplicateLeads, List<Event> modifyEventList) {
        update modifyEventList;
        update retainedLead;
        delete duplicateLeads;
    }

    //used in Lead API hnadler.
    public static Boolean executeInsertLeads(List<Lead> leads) {
        Boolean success = false;
        if (leads != null && leads.size() > 0) {
            try {
                insert leads;
                success = true;

            } catch (Exception ex) {
                success = false;
            }
        }
        return success;
    }
    //Not used
    /*public static Boolean executeInsertTasks(List<Task> insertableTasks) {
        Boolean success = false;
        if (insertableTasks != null && insertableTasks.size() > 0) {
            try {
                insert insertableTasks;
                success = true;

            } catch (Exception ex) {
                UtilityManager.Log(ex.getMessage());
                success = false;
            }
        }
        return success;
    }*/

    public static void executeUpdateEvents(List<event> updatableEvent) {

        if (updatableEvent!= null && updatableEvent.size() > 0) {
            update updatableEvent;

        }
    }
      public static void executeUpdateTasks(List<Task> updatableTasks) {

        if (updatableTasks != null && updatableTasks.size() > 0) {
            update updatableTasks;

        }
    }

    public static Boolean executeUpdateLeads(List<Lead> updatableLeads) {
        Boolean success = false;
        if (updatableLeads != null && updatableLeads.size() > 0) {
            update updatableLeads;
        }
        return success;
    }

    public static void executeUpdateAccounts(List<Account> updatableAccounts) {
        if (updatableAccounts != null && updatableAccounts.size() > 0) {
            update updatableAccounts;
        }
    }
    //Not used-after code optimization
    public static void executeInsertOpportunities(List<Opportunity> insertableOpps) {
        if (insertableOpps != null && insertableOpps.size() > 0) {
            insert insertableOpps;
        }
    }

    public static void executeUpdateOpportunities(List<Opportunity> updatablOpps) {
        if (updatablOpps != null && updatablOpps.size() > 0) {
            update updatablOpps;
        }
    }

    public static void insertNewOpportunities_optm(List<Opportunity> newOppRecords) {
        if (newOppRecords != null) {
            insert newOppRecords;
        }
    }

    public static Map<Id, Opportunity> QuriedOppRecordsMap_Optm(List<Opportunity> QuriedOppRecords) {
        Map<Id, Opportunity> insertedNewOppIdMap = new Map<Id, Opportunity>();
        For (Opportunity newOppRecords: [Select id,accountid from opportunity where id in :QuriedOppRecords]) {
            insertedNewOppIdMap.put(newOppRecords.accountid, newOppRecords);
        }

        return insertedNewOppIdMap;
    }

    public static void updateOpportunities_optm(List<Opportunity> OppRecords) {
        if (OppRecords != null && OppRecords.size() > 0) {
            update OppRecords;
        }
    }

    public static void updateTasks_optm(List<Task> updateTasks) {
        if (updateTasks != null && updateTasks.size() > 0) {
            update updateTasks;
        }
    }

    public static void createErrorLog(ErrorLog__c err) {
        insert err;
    }
    public static void createBulkErrorLog(List<ErrorLog__c> errList) {
        Database.insert(errList,false);
    }

    public static void InsertNewTasks(List<Task> newTaskList) {
        if (newTaskList != null) {
            insert newTaskList;
        }
    }

    public static void updateExsistingTasks(List<Task> oldtasklist) {
        if (oldtasklist != null) {
            update oldtasklist;
        }
    }
    
     public static void insertCampaignmemberStatus( List<CampaignMemberStatus> statusToDelete,List<CampaignMemberStatus> statusToInsert) {
        
        if (statusToInsert != null) {
            insert statusToInsert ;
        }
        if (statusToDelete != null) {
            delete statusToDelete ;
        }
  }
    
    public static void modifyEvents(List<Event> eventList) {
        if (eventList != null && eventList.size()>0) {
            update eventList;
        }
    }

    public static void saveTasks(List<Task> tasksList) {
        try
        {
            if (tasksList != null && tasksList.size() > 0) {
                system.debug('Upsert  '+tasksList);
                Database.UpsertResult [] upsertResults = Database.upsert(tasksList,false);
                Database.UpsertResult [] failedRecords=new Database.UpsertResult []{};
                for (Database.UpsertResult resultObj:upsertResults) {
                    if(!resultObj.isSuccess())
                    {

                    }
                }
                //database.upsert tasksList;
            }
        }
        catch(exception ex)
        {
            system.debug(ex);
        }

    }

    //dupe check dml commands
    public static void modifyAccount(Account accountRecord) {
        update accountRecord;
    }

    public static void modifyOpportunity(Opportunity opportunityRecord) {
        update opportunityRecord;
    }

    public static void modifyLead(Lead leadRecord) {
        update leadRecord;
    }

    public static void deleteLead(Lead leadRecord) {
        delete leadRecord;
    }
    public static Boolean executeUpdateProductAttributeValues(List<Apttus_Config2__ProductAttributeValue__c> updateAttributeValues) {
        Boolean success = false;
        if (updateAttributeValues != null && updateAttributeValues.size() > 0) {
            update updateAttributeValues;
            success=true;
        }
        return success;
    }

    public static Boolean executeUpdateLineItemValues(List<Apttus_Config2__LineItem__c> updateLineItemValues) {
        Boolean success = false;
        if (updateLineItemValues != null && updateLineItemValues.size() > 0) {
            update updateLineItemValues;
            success=true;
        }
        return success;
    }
}