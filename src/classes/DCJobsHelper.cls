/**************************************************************************************
Apex Class Name    : DCJobsHelper
Version            : 1.0
Created Date       : July 16 2017
Function           :
Modification Log   :
------------------------------------------------------------------------------
 * Developer                   Date                   Description
 * ----------------------------------------------------------------------------
 * Suresh S                  07/16/2017              Original Version
*******************************************************************************/
public with sharing class DCJobsHelper {
    public static void handleUnaccurateDupeResults(List<dupcheck__dcJob__c> dcJobList) {
        Map<Id, List<dupcheck__dc3Duplicate__c>> jobIDDuplicateEntryMap = new Map<Id, List<dupcheck__dc3Duplicate__c>>();
        List<Id> jobidList = new List<id>();
        List<Id> leadIdList = new List<Id>();
        List<dupcheck__dc3Duplicate__c> deleteDuplicates = new List<dupcheck__dc3Duplicate__c>();

        for (dupcheck__dcJob__c job : dcJobList) {
            if (job != null || (job.dupcheck__type__c != constant.SEARCH || job.dupcheck__type__c != constant.SEARCH_DEL)
                    || (job.dupcheck__status__c != null && job.dupcheck__Ended__c != null)) {
                jobidList.add(job.id);
            }

        }
        List<dupcheck__dc3Duplicate__c> duplicateList = DcJobsSelector.selectDuplicateRecordsByDCJobID(jobidList);

        for (dupcheck__dc3Duplicate__c dc3 : duplicateList) {
            if (dc3.dupcheck__sourceObject__c.startsWithIgnoreCase('00Q') && dc3.dupcheck__MatchObject__c.startsWithIgnoreCase('00Q')) {
                List<dupcheck__dc3Duplicate__c> temp = new List<dupcheck__dc3Duplicate__c>();
                if (jobIDDuplicateEntryMap.containsKey(dc3.dupcheck__dcJob__c)) {
                    temp = jobIDDuplicateEntryMap.get(dc3.dupcheck__dcJob__c);
                }
                temp.add(dc3);
                jobIDDuplicateEntryMap.put(dc3.dupcheck__dcJob__c, temp);
                leadIdList.add(dc3.dupcheck__sourceObject__c);
                leadIdList.add(dc3.dupcheck__MatchObject__c);
            }
        }
        Map<Id, Lead> leadMap = new Map<Id, Lead>(LeadsSelector.selectLeadById (leadIdList));
        for (ID jobID : jobidList) {


            if (jobIDDuplicateEntryMap.containsKey(jobID))
                for (dupcheck__dc3Duplicate__c duplicate : jobIDDuplicateEntryMap.get(jobID)) {

                    if (!leadMap.containsKey(duplicate.dupcheck__sourceObject__c) || !leadMap.containsKey(duplicate.dupcheck__sourceObject__c)) {
                        deleteDuplicates.add(duplicate); //if Lead is already converted OR //if records are already merged in "Automerge"
                    }
                    //if its dupe with same record OR house hold dupe,then delete the dupe entry.

                    else if (duplicate.dupcheck__sourceObject__c.equalsIgnoreCase(duplicate.dupcheck__MatchObject__c)) {
                        deleteDuplicates.add(duplicate);
                    }

                }
        }


        if (deleteDuplicates.size() > 0) {
            system.debug('test record');
            delete deleteDuplicates;
        }


    }
}