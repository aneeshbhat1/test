/**************************************************************************************
Apex Class Name    : TaskTrigger
Version            : 1.0
Created Date       : November 29 2017
Function           :
Modification Log   :
------------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------
* Arkadiusz Celej             29/11/2017             Original Version
*******************************************************************************/
trigger TaskTrigger on Task (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    Boolean isTriggerDisabled=SFLangUtil.getTriggerSettings('Task');
    if(!isTriggerDisabled) {
        System.debug('RUN TASK DISPATCHER');
        TasksDispatcher.Run();
    }
}