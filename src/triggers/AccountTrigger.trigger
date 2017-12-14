/**************************************************************************************
Apex Class Name    : AccountTrigger
Version            : 1.0
Created Date       : May 29 2017
Function           :
Modification Log   :
------------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------
* Suresh S                  05/29/2017              Original Version
*******************************************************************************/
trigger AccountTrigger on Account(before insert,before update,before delete,after update,after insert,after delete,after undelete)
{
    Boolean isTriggerDisabled=SFLangUtil.getTriggerSettings(Label.AccountApiName);
    if(!isTriggerDisabled) {
        AccountsDispatcher.Run();
    }
}