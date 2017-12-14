/**************************************************************************************
Apex Class Name    : Tasks
Version            : 1.0
Created Date       : Jul 06 2017
Function           :
Modification Log   :
------------------------------------------------------------------------------
 * Developer                   Date                   Description
 * ----------------------------------------------------------------------------
 * Aneesh B                    07/06/2017              Original Version
*******************************************************************************/

public with sharing class TasksDispatcher {
    public static void run() {
        // Check to see if the trigger has been disabled. If it has, return
       /*** if (handler.IsTriggerDisabled())
            return;
        ***/
        // Before trigger logic
        if (Trigger.IsBefore) {
            if (Trigger.IsInsert)
                Tasks.onBeforeInsert(trigger.new);

            if (Trigger.IsUpdate)
                Tasks.onBeforeUpdate(trigger.newMap, trigger.oldMap);

            if (Trigger.IsDelete)
                Tasks.onBeforeDelete(trigger.oldMap);
        }

        // After trigger logic
        if (Trigger.IsAfter) {
            if (Trigger.IsInsert)
                Tasks.onAfterInsert(Trigger.newMap);

            if (Trigger.IsUpdate)
                Tasks.onAfterUpdate(trigger.newMap, trigger.oldMap);

            if (trigger.IsDelete)
                Tasks.onAfterDelete(trigger.oldMap);

            if (trigger.isUndelete)
                Tasks.onAfterUndelete(trigger.oldMap);
        }
    }
}