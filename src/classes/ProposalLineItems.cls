/**************************************************************************************
Apex Class Name    : ProposalLineItems
Version            : 1.0
Created Date       : September 14 2017
Function           :
Modification Log   :
------------------------------------------------------------------------------
 * Developer                   Date                   Description
 * ----------------------------------------------------------------------------
 * Arjun.Mohan                 09/14/2017              Original Version
*******************************************************************************/

public  class ProposalLineItems {
    public static void onBeforeInsert(List<SObject> newItems) {
        ProposalLineItemHelper.updateProposalLineItemFieldsBeforeCreation(newItems);
    }
}