/**************************************************************************************
Apex Class Name    : QuoteProposals
Version            : 1.0
Created Date       : Sep 14 2017
Function           :
Modification Log   :
------------------------------------------------------------------------------
 * Developer                   Date                   Description
 * ----------------------------------------------------------------------------
 * Arjun Mohan                 09/14/2017              Original Version
*******************************************************************************/

public  class QuoteProposals {
   public static void onBeforeInsert(List<SObject> newItems) {
        QuoteProposalsHelper.updateQuoteProposalFieldsBeforeInsert(newItems);
    }
    public static void onBeforeUpdate(Map<Id,Apttus_Proposal__Proposal__c> oldQuoteproposalMap,List<Apttus_Proposal__Proposal__c> newQuoteproposalList)
    {
        QuoteProposalsHelper.updateQuoteProposalFieldsBeforeUpdate(oldQuoteproposalMap,newQuoteproposalList);
    }
}