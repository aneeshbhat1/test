/**************************************************************************************
Apex Class Name    : DCMergePlugin
Version            : 1.0
Created Date       : May 29 2017
Function           :
Modification Log   :
------------------------------------------------------------------------------
 * Developer                   Date                   Description
 * ----------------------------------------------------------------------------
 * Suresh S                  05/29/2017              Original Version
*******************************************************************************/

global class DCMergePlugin implements dupcheck.dc3Plugin.InterfaceMerge {

    global void beforeMerge(String objectPrefix, Sobject masterRecord, List < sobject > mergedRecordList) {
        system.debug('DCMergePlugin-beforeMerge Started');
        DcMergeHelper.taskMergeReasonUpdateonMergeLead(objectPrefix,masterRecord,mergedRecordList);
        system.debug('DCMergePlugin-beforeMerge Ends');
        return;

    }

    global void mergeFailed(String objectPrefix, Sobject masterRecord, Set < id > mergedRecordsIds, dupcheck.dc3Exception.MergeException exceptionData) {
        return;
    }

    global void afterMerge(String objectPrefix, Sobject masterRecord, Set < id > mergedRecordIds) {
        system.debug('DCMergePlugin-afterMerge Started');
        DCMergeHelper.OnManualMerge(objectPrefix, masterRecord, mergedRecordIds);
        system.debug('DCMergePlugin-afterMerge Ends');

    }
}