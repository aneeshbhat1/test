/**************************************************************************************
Apex Class Name    : DCJobsDispatcher 
Version            : 1.0
Created Date       : June 22 2017
Function           :
Modification Log   :
------------------------------------------------------------------------------
 * Developer                   Date                   Description
 * ----------------------------------------------------------------------------
 * Suresh S                  06/22/2017              Original Version
*******************************************************************************/
public class DCJobsDispatcher {

    public static void run() {
        // Check to see if the trigger has been disabled. If it has, return
       /*** if (handler.IsTriggerDisabled())
            return;
        ***/
        // Before trigger logic
        if (Trigger.IsBefore) {
            if (Trigger.IsInsert)
                DCJobs.onBeforeInsert(trigger.new);

            if (Trigger.IsUpdate)
                DCJobs.onBeforeUpdate(trigger.newMap, trigger.oldMap);

            if (Trigger.IsDelete)
                DCJobs.onBeforeDelete(trigger.oldMap);
        }

        // After trigger logic
        if (Trigger.IsAfter) {
            if (Trigger.IsInsert)
                DCJobs.onAfterInsert(Trigger.newMap);

            if (Trigger.IsUpdate)
                DCJobs.onAfterUpdate(trigger.newMap, trigger.oldMap);

            if (trigger.IsDelete)
                DCJobs.onAfterDelete(trigger.oldMap);

            if (trigger.isUndelete)
                DCJobs.onAfterUndelete(trigger.oldMap);
        }
    }
}