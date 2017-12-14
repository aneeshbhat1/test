/**************************************************************************************
Apex Class Name    : DCJobs 
Version            : 1.0
Created Date       : June 22 2017
Function           :
Modification Log   :
------------------------------------------------------------------------------
 * Developer                   Date                   Description
 * ----------------------------------------------------------------------------
 * Suresh S                  06/22/2017              Original Version
*******************************************************************************/
public class DCJobs {
     
    public static void onBeforeInsert(List<SObject> newItems) {
    }

    public static void onBeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
    }

    public static void onBeforeDelete(Map<Id, SObject> oldItems) {
    }

    public static void onAfterInsert(Map<Id, SObject> newItems) { 
    }

    public static void onAfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
              
        DCJobsHelper.handleUnaccurateDupeResults((List<dupcheck__dcJob__c>)newItems.values());
    }
    public static void onAfterDelete(Map<Id, SObject> oldItems) {    }

    public static void onAfterUndelete(Map<Id, SObject> oldItems) {    }
}