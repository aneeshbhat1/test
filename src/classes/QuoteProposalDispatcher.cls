/**************************************************************************************
Apex Class Name    : QuoteProposalDispatcher
Version            : 1.0
Created Date       : September 14 2017
Function           :
Modification Log   :
------------------------------------------------------------------------------
 * Developer                   Date                   Description
 * ----------------------------------------------------------------------------
 * Arjun.Mohan                 09/14/2017              Original Version
*******************************************************************************/

public with sharing class QuoteProposalDispatcher {
    // Before trigger logic
    public static void run() {
        if (Trigger.IsBefore) {
            if (Trigger.IsInsert) {
                QuoteProposals.onBeforeInsert(trigger.new);
            }
            if (Trigger.IsUpdate) {
                QuoteProposals.onBeforeUpdate((Map<Id, Apttus_Proposal__Proposal__c>) trigger.oldMap, trigger.new);
            }
        }
    }
}