/**************************************************************************************
Apex Class Name    : LeadTrigger
Version            : 1.0
Created Date       : May 29 2017
Function           :
Modification Log   :
------------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------
* Suresh S                  05/29/2017              Original Version
*******************************************************************************/
trigger LeadTrigger on Lead (before insert,before update,before delete,after insert,after update,after delete,after undelete)
{
   Boolean isTriggerDisabled=SFLangUtil.getTriggerSettings(Label.LeadApiName);
   if(!isTriggerDisabled)
   {
      LeadsDispatcher.run();
   }

}