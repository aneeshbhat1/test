/**************************************************************************************
Apex Class Name    : Opportunities
Version            : 1.0
Created Date       : May 29 2017
Function           :
Modification Log   :
------------------------------------------------------------------------------
 * Developer                   Date                   Description
 * ----------------------------------------------------------------------------
 * Suresh S                  05/29/2017              Original Version
*******************************************************************************/
public class Opportunities {
    
 
    /*
        Checks to see if the trigger has been disabled either by custom setting or by running code
    */
    /***
    public Boolean IsTriggerDisabled()
    {
       
        return false;
    }
 ***/
    public static void onBeforeInsert(List<Opportunity> newItems) {
        OpportunitiesHelper.setDefaultLetterAndLabel(newItems);
    }
 
    public static void onBeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        OpportunitiesHelper.setDefaultLetterAndLabel(newItems.values());
    }
 
    public static void onBeforeDelete(Map<Id, SObject> oldItems) {}
 
    public static void onAfterInsert(Map<Id, SObject> newItems) {
        OpportunitiesHelper.createShareOnInsert((List<Opportunity>)newItems.values());
    }
 
    public static void onAfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
       OpportunitiesHelper.createShareOnUpdateTypes((List<Opportunity>)newItems.values(),(List<Opportunity>)oldItems.values());
       //OpportunitiesHelper.updateMarketCodeOnAccount((List<Opportunity>)newItems.values(),(List<Opportunity>)oldItems.values());
    }
 
    public static void onAfterDelete(Map<Id, SObject> oldItems) {}
 
    public static void onAfterUndelete(Map<Id, SObject> oldItems) {}
}