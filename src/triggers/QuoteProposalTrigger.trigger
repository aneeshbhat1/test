/**************************************************************************************
Apex Class Name    : QuoteProposalTrigger
Version            : 1.0
Created Date       : September 14 2017
Function           :
Modification Log   :
------------------------------------------------------------------------------
 * Developer                   Date                   Description
 * ----------------------------------------------------------------------------
 * Arjun.Mohan                 09/14/2017              Original Version
*******************************************************************************/

trigger QuoteProposalTrigger on Apttus_Proposal__Proposal__c (before insert,before update,after update,after insert,after delete ,before delete,after undelete ) {
   // Boolean isTriggerDisabled=SFLangUtil.getTriggerSettings(Label.LeadApiName);
    //if(!isTriggerDisabled)
    //{
        QuoteProposalDispatcher.run();
    //}
}