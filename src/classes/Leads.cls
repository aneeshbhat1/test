/**************************************************************************************
Apex Class Name    : Leads
Version            : 1.0
Created Date       : May 29 2017
Function           :
Modification Log   :
------------------------------------------------------------------------------
 * Developer                   Date                   Description
 * ----------------------------------------------------------------------------
 * Suresh S                  05/29/2017              Original Version
*******************************************************************************/
public class Leads {
     
    public static void onBeforeInsert(List<SObject> newItems) {
        LeadsHelper.updateHadAddressFilledOnCreation(newItems);
    }

    public static void onBeforeUpdate(List<Lead> oldLeadList,List<Lead> newLeadList) 
    {
      LeadsHelper.leadOwnerchangelogic(oldLeadList,newLeadList);
    }

    public static void onBeforeDelete(Map<Id, SObject> oldItems) {
    }

    public static void onAfterInsert(List<Lead>newItems) {

        LeadsHelper.createShareOnInsert(newItems);


    }

    public static void onAfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        LeadsHelper.processRanking((List<Lead>)newItems.values());
       
        //LeadsHelper.OnLeadUpdate2((List<Lead>)newItems.values());
        //leadsHelper.OnLeadUpdate((List<Lead>)newItems.values());

        //Check
        //List<ID> opportunityIDList =leadsHelper.createOppportunityAndTaskTransfer((List<Lead>)newItems.values());
       // system.debug('opportunityIDList List Size for Task:'+opportunityIDList.size());
        //TasksHelper.convertActivitiesToTask(opportunityIDList);
        //LeadsHelper.transferNotesToOpponLeadConversion((List<Lead>)newItems.values());
        LeadsHelper.createShareOnUpdateTypes((List<Lead>)newItems.values(),(List<Lead>)oldItems.values());
        
    }
    public static void onAfterDelete(Map<Id, SObject> oldItems) {
    }

    public static void onAfterUndelete(Map<Id, SObject> oldItems) {
    }
}