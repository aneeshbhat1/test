/**************************************************************************************
Apex Class Name    : DcJobsSelector
Version            : 1.0
Created Date       : July 16 2017
Function           :
Modification Log   :
------------------------------------------------------------------------------
 * Developer                   Date                   Description
 * ----------------------------------------------------------------------------
 * Suresh S                  07/16/2017              Original Version
*******************************************************************************/
public with sharing class DcJobsSelector {
   public static List<dupcheck__dc3Duplicate__c> selectDuplicateRecordsByDCJobID( List<Id> jobidList) {
        return [SELECT Id,dupcheck__dcJob__c,dupcheck__sourceObject__c,dupcheck__MatchObject__c from dupcheck__dc3Duplicate__c where dupcheck__dcJob__c in :jobidList];
    }
}