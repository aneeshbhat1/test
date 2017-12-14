/**************************************************************************************
Apex Class Name    : ProposalLineItemDispatcher
Version            : 1.0
Created Date       : September 14 2017
Function           :
Modification Log   :
------------------------------------------------------------------------------
 * Developer                   Date                   Description
 * ----------------------------------------------------------------------------
 * Arjun.Mohan                 09/14/2017              Original Version
*******************************************************************************/

public class ProposalLineItemDispatcher {
    // Before trigger logic
    public static void run() {
        if (Trigger.IsBefore) {
            if (Trigger.IsInsert) {
                ProposalLineItems.onBeforeInsert(trigger.new);
            }
        }
    }
}