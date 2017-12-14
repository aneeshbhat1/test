/**************************************************************************************
Apex Class Name    : DCJobTrigger
Version            : 1.0
Created Date       : May 29 2017
Function           :
Modification Log   :
------------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------
* Suresh S                  05/29/2017              Original Version
*******************************************************************************/
trigger DCJobTrigger on dupcheck__dcJob__c(after update,after insert,before insert,before update,after delete,before delete)
{
    Boolean isTriggerDisabled=SFLangUtil.getTriggerSettings(Label.dcJobApiName);
    if(!isTriggerDisabled) {
        DCJobsDispatcher.run();
    }
}