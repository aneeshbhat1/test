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

public with sharing class Tasks {
    public static void onBeforeInsert(List<SObject> newItems)
    {
        //TestDataUtil.BeforeInsertRecords((List<Lead>)newItems.values());
    }

    public static void onBeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
    }

    public static void onBeforeDelete(Map<Id, SObject> oldItems) {
    }

    public static void onAfterInsert(Map<Id, SObject> newItems) {
        System.debug('AFTER INSERT');
        TasksHelper.updateParents(newItems);
    }

    public static void onAfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        System.debug('AFTER Update');
        TasksHelper.updateParents(newItems);
    }
    public static void onAfterDelete(Map<Id, SObject> oldItems) {
    }

    public static void onAfterUndelete(Map<Id, SObject> oldItems) {
    }
}