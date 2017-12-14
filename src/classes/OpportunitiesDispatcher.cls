/**************************************************************************************
Apex Class Name    : OpportunityTriggerDispatcher
Version            : 1.0
Created Date       : Apr 25 2017
Function           :
Modification Log   :
-----------------------------------------------------------------------------
 * Developer                   Date                   Description
 * ----------------------------------------------------------------------------
 * Suresh S                  04/25/2017              Original Version
 *************************************************************************************/
public class OpportunitiesDispatcher
{
    public static void Run()
    {
        // Check to see if the trigger has been disabled. If it has, return
       /***
        if (handler.IsTriggerDisabled())
            return;
        **/   
   
 
        // Before trigger logic
        if (Trigger.IsBefore )
        {
            if (Trigger.IsInsert)
                Opportunities.onBeforeInsert(trigger.new);
 
            if (Trigger.IsUpdate)
                Opportunities.onBeforeUpdate(trigger.newMap, trigger.oldMap);
 
            if (Trigger.IsDelete)
                Opportunities.onBeforeDelete(trigger.oldMap);
        }
         
        // After trigger logic
        if (Trigger.IsAfter)
        {
            if (Trigger.IsInsert)
                Opportunities.onAfterInsert(Trigger.newMap);
 
            if (Trigger.IsUpdate)
                Opportunities.onAfterUpdate(trigger.newMap, trigger.oldMap);
 
            if (trigger.IsDelete)
                Opportunities.onAfterDelete(trigger.oldMap);
 
            if (trigger.isUndelete)
                Opportunities.onAfterUndelete(trigger.oldMap);
        }
    }
}