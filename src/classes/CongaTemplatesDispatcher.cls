/**
 * Created by thejasvi.a on 9/20/2017.
 */

public with sharing class CongaTemplatesDispatcher {
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
                    CongaTemplates.onBeforeInsert(trigger.new);
                }

                if (Trigger.IsUpdate) {
                    CongaTemplates.onBeforeUpdate(trigger.old, trigger.new);
                }
                if (Trigger.IsDelete) {
                    CongaTemplates.onBeforeDelete(trigger.oldMap);
                }
            }
        } catch (Exception e){}

        // After trigger logic
        if (Trigger.IsAfter) {

            if (Trigger.IsInsert) {
                CongaTemplates.onAfterInsert(Trigger.new);
            }

            if (Trigger.IsUpdate) {
                system.debug('###################');
                CongaTemplates.onAfterUpdate(trigger.newMap, trigger.oldMap);
            }

            if (trigger.IsDelete) {
                CongaTemplates.onAfterDelete(trigger.oldMap);
            }

            if (trigger.isUndelete) {
                CongaTemplates.onAfterUndelete(trigger.oldMap);
            }
        }
    }
}