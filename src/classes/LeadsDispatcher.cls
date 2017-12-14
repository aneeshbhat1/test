/**************************************************************************************
Apex Class Name    : LeadsDispatcher
Version            : 1.0
Created Date       : May 29 2017
Function           :
Modification Log   :
------------------------------------------------------------------------------
 * Developer                   Date                   Description
 * ----------------------------------------------------------------------------
 * Suresh S                  05/29/2017              Original Version
*******************************************************************************/
public class LeadsDispatcher {

    public static void run() {
        // Check to see if the trigger has been disabled. If it has, return
       /*** if (handler.IsTriggerDisabled())
            return;
        ***/
        // Before trigger logic
        system.debug('&&&&&&&&&&&&&&&&');
        try {
            if (Trigger.IsBefore) {
                if (Trigger.IsInsert) {
                    Leads.onBeforeInsert(trigger.new);
                }

                if (Trigger.IsUpdate) {
                    Leads.onBeforeUpdate(trigger.old, trigger.new);
                }
                if (Trigger.IsDelete) {
                    Leads.onBeforeDelete(trigger.oldMap);
                }
            }
        } catch (Exception e){}

        // After trigger logic
        if (Trigger.IsAfter) {

            if (Trigger.IsInsert) {
                Leads.onAfterInsert(Trigger.new);
            }

            if (Trigger.IsUpdate) {
                system.debug('###################');
                Leads.onAfterUpdate(trigger.newMap, trigger.oldMap);
            }

            if (trigger.IsDelete) {
                Leads.onAfterDelete(trigger.oldMap);
            }

            if (trigger.isUndelete) {
                Leads.onAfterUndelete(trigger.oldMap);
            }
        }
    }
}